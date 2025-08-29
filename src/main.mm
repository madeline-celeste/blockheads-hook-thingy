#include <cstdlib>
#include <stdio.h>
#include <mutex>
#include <map>
#include <string>

#include "macros/symbol_loader.hpp"
#include <Foundation/Foundation.h>

#define LOG_ALL_NONINTERNAL_METHOD_CALLS false

extern "C" IMP objc_msg_lookup(id obj, SEL sel);

DEFINE_OVERRIDE_SYM(objc_msg_lookup);

std::map<std::string, IMP>* original_implementations;

BOOL isFoundationReady = NO;
static std::once_flag init_flag;

void initSymbols() {
    LOAD_OVERRIDE_SYM(objc_msg_lookup);
    original_implementations = new std::map<std::string, IMP>();
}

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