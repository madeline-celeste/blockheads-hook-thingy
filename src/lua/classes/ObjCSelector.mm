#include <lua.hpp>

#import "ObjCSelector.h"
#import "../ObjCLuaHelper.h"

#import <Foundation/Foundation.h>


int ObjCSelector__tostring(lua_State* L) {}

int pushObjCSelector(lua_State* L, SEL sel) {
    SEL* udata = (SEL*)lua_newuserdata(L, sizeof(SEL));
    *udata = sel;

    luaL_getmetatable(L, "ObjCSelector");
    lua_setmetatable(L, -2);

    return 1;
}

void registerObjCSelector(lua_State* L) {
    luaL_newmetatable(L, "ObjCSelector");

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pop(L, 1); // pop the metatable
}