#include <lua.hpp>

#import <Foundation/Foundation.h>

void pushObjCObject(lua_State* L, id obj);
void registerObjCObject(lua_State* L);