// TODO: implement properly

#include <lua.hpp>

#import "../../../remake/include/MJMath.h"

#import <Foundation/Foundation.h>

int pushIntPair(lua_State* L, intpair ipair) {
    intpair* udata = (intpair*)lua_newuserdata(L, sizeof(intpair));
    *udata = ipair;

    luaL_getmetatable(L, "IntPair");
    lua_setmetatable(L, -2);

    return 1;
}

void registerIntPair(lua_State* L) {
    luaL_newmetatable(L, "IntPair");

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pop(L, 1); // pop the metatable
}