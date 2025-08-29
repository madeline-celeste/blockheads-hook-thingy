#include <lua.hpp>

#import <Foundation/Foundation.h>


void pushNSArray(lua_State* L, NSArray* array);
void pushNSString(lua_State* L, NSString* string);