#include <string>
#include <map>

#import <Foundation/Foundation.h>

extern std::map<std::string, IMP>* original_implementations;

#define HOOK_METHOD(class, selector_name, replacement_method) \
    hookMethod(#class, @selector(selector_name), reinterpret_cast<IMP>(replacement_method))

template <typename T>
T getOrigImplementation(NSString* implName) {
    auto key = std::string([implName UTF8String]);
    auto it = original_implementations->find(key);
    if (it == original_implementations->end()) {
        fprintf(stderr, "getOrigImplementation: no implementation cached for %s\n", key.c_str());
        std::abort();
        return nullptr; // or throw, depending on your design
    }
    return reinterpret_cast<T>(it->second);
}

/**
    * Replaces the implementation of an Objective-C method with a new IMP.
    * @param cls    Class to hook.
    * @param sel          Selector of the method.
    * @param newImp       The replacement implementation.
    *
    * @throws NSInvalidArgumentException if the class or method cannot be found.
*/
void hookMethod(Class cls, SEL sel, IMP newImp);

/**
    * Replaces the implementation of an Objective-C method with a new IMP, but looks up a NSString class name with `class_getInstanceMethod`.
    * @param class_name  Name of the class to hook.
    * @param sel        Selector of the method.
    * @param newImp     The replacement implementation.
    *
    * @throws NSInvalidArgumentException if the class or method cannot be found.
*/
void hookMethod(std::string class_name, SEL sel, IMP newImp);

/**
 * Returns whether the class name is some interneal stuff, such as NSString.
 * 
 * @param class_name 
 * @return BOOL 
 */
BOOL isInternalClassName(std::string class_name);

BOOL shouldCacheCall(std::string className, std::string methodName);

void ensureImplementationCached(id obj, SEL sel, std::string fullName);