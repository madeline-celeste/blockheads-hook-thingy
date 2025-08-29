#include <lua.hpp>

#import <Foundation/Foundation.h>


void pushNSString(lua_State* L, NSString* string) {
    lua_pushstring(L, [string UTF8String]);
}

void pushNSArray(lua_State* L, NSArray* array) {
    lua_createtable(L, (int)[array count], 0);

    for (NSUInteger i = 0; i < [array count]; i++) {
        id obj = [array objectAtIndex:i];

        lua_pushnumber(L, (lua_Number)(i+1));

        if ([obj isKindOfClass:[NSString class]]) {
            lua_pushstring(L, [obj UTF8String]);
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            lua_pushnumber(L, static_cast<lua_Number>([obj doubleValue]));
        } else if ([obj isKindOfClass:[NSArray class]]) {
            pushNSArray(L, obj);;
        } else {
            NSLog(@"tried push unhandled class onto stack");
            abort();
            lua_pushnil(L);
        }

        lua_settable(L, -3);
    }
}