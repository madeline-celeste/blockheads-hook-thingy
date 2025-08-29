#include <cstdlib>
#include <stdio.h>
#include <mutex>
#include <map>
#include <string>
#include <dlfcn.h>
#include <chrono>

#include <Foundation/Foundation.h>
#include <thread>

#import "cpp_hooks.h"
#import "hook_util.h"
#import "macros/symbol_loader.hpp"
#import "lua/lua_runner.h"

std::map<std::string, IMP>* original_implementations;

// _NOTE_
// this is to give lua enough time to set up hooks before real_main() is called,
// preventing race conditions from occuring within this timeframe.
// fixes undefined behavior, but not sure if this is the best solution available. 
#define MAIN_THROTTLE_MS 100

BOOL isFoundationReady = NO;
static std::once_flag init_flag;
extern "C" IMP objc_msg_lookup(id obj, SEL sel);
DEFINE_OVERRIDE_SYM(objc_msg_lookup);

void initSymbols() {
    LOAD_OVERRIDE_SYM(objc_msg_lookup);
    original_implementations = new std::map<std::string, IMP>();
}

#define LOG_ALL_NONINTERNAL_METHOD_CALLS false
// we do not use Objective-C methods in here because they will make objc_msg_lookup very very mad and
// result in race conditions and occasional infinite recursions and segfaults. fml

// maybe remove this? this was originally important because everything was cached here and also
// everything was hooked here, but i found it was like 10000x better to just intercept main and
// hook stuff, init lua, etc. when that's called.
// not sure if there's any point to keeping this, still? logging all msg lookups might be
// useful still though for like backtracing or something
extern "C" IMP objc_msg_lookup(id obj, SEL sel) {
    std::call_once(init_flag, initSymbols);

    if (!isFoundationReady) {
        return r_objc_msg_lookup(obj, sel);
    }

    /*std::string class_name = object_getClassName(obj);
    std::string method_name = sel_getName(sel);
    std::string full_name = class_name + " " + method_name;

    if (shouldCacheCall(class_name, method_name)) {
        ensureImplementationCached(obj, sel, full_name);
    }
    if (LOG_ALL_NONINTERNAL_METHOD_CALLS) {
        //if (!isInternalClassName(class_name)) {
            std::string output = "LOOKUP [" + full_name + "]";
            write(STDOUT_FILENO, output.c_str(), output.length());
            write(STDOUT_FILENO, "\n", 1);
        //}
    }*/

    IMP returnImp = r_objc_msg_lookup(obj, sel);
    return returnImp;
}

// _NOTE_
// here is where we intercept __libc_start_main which is like uhhhhhhhh
//
//
//
// it does things and then something something main()

typedef int (*main_fn)(int, char **, char **);
typedef int (*libc_start_main_fn)(main_fn, int, char **,
                                  void (*)(void), void (*)(void),
                                  void (*)(void), void *);

static main_fn real_main = NULL;

static int my_main(int argc, char **argv, char **envp) {
    isFoundationReady = YES;

    // i think have to do this. it gives warnings if u dont have an autorelease pool.
    // (what i mean is that like idk if this is the best wya to do this)
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    runLua();

    //
    std::this_thread::sleep_for(std::chrono::milliseconds(MAIN_THROTTLE_MS));

    [pool drain];

    // we will hijack this function that doesn't even do anything.
    // it passes GameController, so it gives us a free reference to give to lua, which contains
    // a ton of stuff that we can use from there.
    //
    // this is so incredibly convenient lmao
    HOOK_METHOD(CommandLineDelegate, loadCompleteForGameController:, hooked_loadCompleteForGameController);
    
    return real_main(argc, argv, envp);
}

extern "C" int __libc_start_main(main_fn main,
    int argc, char **ubp_av,
    void (*init)(void),
    void (*fini)(void),
    void (*rtld_fini)(void),
    void *stack_end
) {
    static libc_start_main_fn real_libc_start_main = NULL;
    if (!real_libc_start_main) {
        real_libc_start_main = (libc_start_main_fn)dlsym(RTLD_NEXT, "__libc_start_main");
        if (!real_libc_start_main) {
            NSLog(@"failed to find __libc_start_main");
            exit(1);
        }
    }

    real_main = main;
    return real_libc_start_main(my_main, argc, ubp_av, init, fini, rtld_fini, stack_end);
};