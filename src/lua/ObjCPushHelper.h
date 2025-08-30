#include <lua.hpp>

#import <Foundation/Foundation.h>

int pushLuaTableToNSArrayObjCObject(lua_State* L);

void pushNSArray(lua_State* L, NSArray* array);
void pushNSString(lua_State* L, NSString* string);