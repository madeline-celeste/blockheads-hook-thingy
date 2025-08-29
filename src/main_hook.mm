// _NOTE_
// here is where we intercept __libc_start_main which is like uhhhhhhhh
//
//
//
// it does things and then something something main()

#include <thread>
#include <mutex>
#include <dlfcn.h>

#import "main_hook.h"
#import "hook_util.h"
#import "cpp_hooks.h"
#import "lua/lua_runner.h"

#import <Foundation/Foundation.h>


extern id RefGameController;

static main_fn real_main = NULL;

void init_hook_state() {
    isFoundationReady = YES;
}

static int my_main(int argc, char **argv, char **envp) {
    init_hook_state();

    // i think have to do this. it gives warnings if u dont have an autorelease pool.
    // (what i mean is that like idk if this is the best wya to do this)
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    runLua();

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