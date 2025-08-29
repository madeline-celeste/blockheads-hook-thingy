#import <lua.hpp>
#import <Foundation/Foundation.h>

// TODO: make fully lua interactable i think thatm akes sense
static int DumpIvarsForClass(lua_State* L) {
    const char* class_name = luaL_checkstring(L, 1);
    Class cls = objc_getClass(class_name);

    unsigned count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    NSLog(@"Ivars for %@:", cls);
    for (unsigned i = 0; i < count; i++) {
        Ivar iv = ivars[i];
        const char *name = ivar_getName(iv);
        const char *type = ivar_getTypeEncoding(iv);
        ptrdiff_t off = ivar_getOffset(iv);
        NSLog(@"  %3u: %-30s off=0x%tx type=%s", i, name ? name : "(null)", off, type ? type : "?");
    }
    free(ivars);

    return 0;
}
static int ObjCDebug_getClassHierarchy(lua_State* L) {
    const char* class_name = luaL_checkstring(L, 1);
    Class cls = objc_getClass(class_name);

    lua_createtable(L, 0, 2); // most things have 1 superclass so this might be optimal(?)

    int class_count = 0;
    while (cls) {
        lua_pushnumber(L, static_cast<lua_Number>(class_count + 1));
        lua_pushstring(L, class_getName(cls));
        lua_settable(L, -3);

        cls = class_getSuperclass(cls);
        class_count++;
    }

    return 1;
}

int pushObjCDebug(lua_State* L) {
    lua_newuserdata(L, 0);

    luaL_getmetatable(L, "ObjCDebug");
    lua_setmetatable(L, -2);

    return 1;
}
void registerObjCDebug(lua_State*L) {
    luaL_newmetatable(L, "ObjCDebug");

    lua_pushcfunction(L, ObjCDebug_getClassHierarchy);
    lua_setfield(L, -2, "getClassHierarchy");
    lua_pushcfunction(L, DumpIvarsForClass);
    lua_setfield(L, -2, "DumpIvarsForClass");

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pop(L, 1);
}