#include <lua.hpp>

#import <Foundation/Foundation.h>

#import "classes/ObjCObject.h"

int pushLuaTableToNSArrayObjCObject(lua_State* L) {
    luaL_checktype(L, 1, LUA_TTABLE);

    NSMutableArray* array = [[NSMutableArray alloc] init];

    size_t len = lua_rawlen(L, 1);
    NSLog(@"%zu", len);
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, 1, i);

        if (lua_type(L, -1) == LUA_TSTRING) {
            const char* c_str = lua_tostring(L, -1);
            NSString* str = [NSString stringWithUTF8String:c_str];
            [array insertObject:str atIndex:i - 1];
        } else {
            @throw [NSException exceptionWithName:@"UnhandledArgument"
                reason:[NSString stringWithFormat:@"Unhandled argument when making NSArray from lua! (type '%s')", lua_typename(L, -1)]
                userInfo:NULL
            ];
        }
    }

    pushObjCObject(L, [array copy]);

    return 1;
}

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