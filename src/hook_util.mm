#include <memory>
#include <map>
#include <string>
#include <unordered_set>
#include <stdexcept>
#include <mutex>
#include <vector>

#import "hook_util.h"

extern std::map<std::string, IMP>* original_implementations;

std::unordered_set<std::string> hooks;
std::mutex hook_mutex;

void hookMethod(Class cls, SEL sel, IMP newImp) {
    std::lock_guard<std::mutex> lock(hook_mutex);

    if (!cls) {
        throw std::runtime_error(
            "Class not found for selector " +
            std::string(sel_getName(sel))
        );
    }
    Method m = class_getInstanceMethod(cls, sel);
    if (!m) {
        throw std::runtime_error(
            "Method " + std::string(sel_getName(sel)) +
            " not found in class " +
            std::string(class_getName(cls))
        );
    }

    std::string full_name = std::string(class_getName(cls)) + " " + sel_getName(sel);

    if (hooks.find(full_name) != hooks.end()) {
        return; // already hookedd
    }
    hooks.insert(full_name);

    method_setImplementation(m, newImp);
}

void hookMethod(std::string class_name, SEL sel, IMP newImp) {
    Class cls = objc_getClass(class_name.c_str());
    return hookMethod(cls, sel, newImp);
}


inline bool isTaggedPointer(const void *ptr) {
    return ((uintptr_t)ptr & (1ULL << 63)) != 0;
}

BOOL isInternalClassName(std::string class_name) {
    if (class_name.rfind("NS", 0) == 0 ) {
        return YES; 
    } else if (class_name.rfind("GS", 0) == 0) {
        return YES;
    } else {
        return NO;
    }
};

BOOL shouldCacheCall(std::string class_name, std::string method_name) {
    if (class_name == "Nil") {
        return NO; // skip bothering with Nil stuff
    }
    if (isInternalClassName(class_name)) {
        return NO; // wanna ignore internal spam classes or idk u know what imean
    }
    return YES;
}
void ensureImplementationCached(id obj, SEL sel, std::string full_name) {
    if (original_implementations->find(full_name) != original_implementations->end()) {
        return; // already cahceddd
    }
    
    IMP implementation = class_getMethodImplementation(object_getClass(obj), sel);
    (*original_implementations)[full_name] = implementation;
}