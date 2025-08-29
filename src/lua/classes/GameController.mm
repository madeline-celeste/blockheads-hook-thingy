// _NOTE_
// currently unused because not sure how to do lua inheritance from inside C/C++/ObjC++/whatever
// not sure if i even wanna have different classes for each thing or just use
// ObjCObject for everything, but i think it'd be nice maybe? dunno.

#include <lua.hpp>

#import "GameController.h"
#import "../ObjCPushHelper.h"
#import "../../../remake/include/GameController.h"

#import <Foundation/Foundation.h>

// GETTERS
// pretty sure can remove these due to ObjCSelector functionality

int lua_GameController_getWorldName(lua_State* L) {
    id* udata = (id*)luaL_checkudata(L, 1, "GameController");
    GameController* gameController = *udata;

    pushNSString(L, [gameController worldName]);
    
    return 1;
}
int lua_GameController_getPort(lua_State* L) {
    id* udata = (id*)luaL_checkudata(L, 1, "GameController");
    GameController* gameController = *udata;

    lua_pushnumber(L, static_cast<lua_Number>([[gameController port] doubleValue]));
    
    return 1;
}

// doesnt work proeprtly for some reason
int lua_GameController_getChatMessages(lua_State* L) {
    id* udata = (id*)luaL_checkudata(L, 1, "GameController");
    GameController* gameController = *udata;

    pushNSArray(L, [gameController chatMessages]);
    //NSLog(@"count %lu", [[gameController chatMessages] count]);
        
    return 1;
}

int lua_GameController_clearChat(lua_State* L) {
    id* udata = (id*)luaL_checkudata(L, 1, "GameController");
    GameController* gameController = *udata;

    [gameController clearChat];
        
    return 0;
}

int gc_test(lua_State* L) {
    id* udata = (id*)luaL_checkudata(L, 1, "GameController");
    id obj = *udata;

    NSLog(@"[Lua] GameController object: %@", obj);

    return 0;
}

#define ADD_METHOD(method_name) \
    lua_pushcfunction(L, lua_GameController_##method_name); \
    lua_setfield(L, -2, #method_name)

void registerGameController(lua_State* L) {
    luaL_newmetatable(L, "GameController");

    ADD_METHOD(getWorldName);
    ADD_METHOD(getPort);
    ADD_METHOD(getChatMessages);
    ADD_METHOD(clearChat);

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pop(L, 1); // pop the metatable
}

int pushGameController(lua_State* L, id obj) {
    id* udata = (id*)lua_newuserdata(L, sizeof(obj));
    *udata = obj;

    luaL_getmetatable(L, "GameController");
    lua_setmetatable(L, -2);

    return 1;
}