#include <lua.hpp>

#import <Foundation/Foundation.h>


// GETTERS

void registerObjCSelector(lua_State* L);

int pushObjCSelector(lua_State* L, SEL obj);