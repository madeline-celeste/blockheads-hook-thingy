#include <cstddef>
#import <lua.hpp>
#include <objc/objc.h>
#import <Foundation/Foundation.h>

static int ObjCDebug_getIvarsForClass(lua_State* L) {
    const char* class_name = luaL_checkstring(L, 1);
    Class cls = objc_getClass(class_name);

    unsigned int count = 0;
    Ivar* ivars = class_copyIvarList(cls, &count);

    lua_createtable(L, count, 0);

    for (unsigned int i = 0; i < count; i++) {
        Ivar iv = ivars[i];
        
        lua_pushnumber(L, static_cast<lua_Integer>(i));
        lua_createtable(L, 0, 2);
        {
            lua_pushstring(L, ivar_getName(iv));
            lua_setfield(L, -2, "name");

            lua_pushstring(L, ivar_getTypeEncoding(iv));
            lua_setfield(L, -2, "encoding");

            // TODO: might be not preferable
            lua_pushinteger(L, static_cast<lua_Integer>(ivar_getOffset(iv)));
            lua_setfield(L, -2, "offset");
        }
        lua_settable(L, -3);
    }
    free(ivars);

    return 1;
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
static int ObjCDebug_getClassList(lua_State* L) {
    int numClasses = objc_getClassList(NULL, 0);
    Class* classes = static_cast<Class*>(malloc(sizeof(Class) * numClasses));
    objc_getClassList(classes, numClasses);

    lua_createtable(L, 0, numClasses);
    for (int i = 0; i < numClasses; i++) {
        lua_pushnumber(L, static_cast<lua_Number>(i + 1));
        lua_pushstring(L, class_getName(classes[i]));
        lua_settable(L, -3);
    }

    return 1;
}

// this does not seem to work, i think.
// couldn't tell you why i have barely any knowledge of objc
static int ObjCDebug_getPropertiesForClass(lua_State* L) {
    const char* class_name = luaL_checkstring(L, 1);
    Class cls = objc_getClass(class_name);

    if (!cls) {
        return luaL_error(L, "Class '%s' not found", class_name);
    }

    unsigned int property_count = 0;
    objc_property_t* props = class_copyPropertyList(cls, &property_count);

    lua_createtable(L, property_count, 0);

    NSLog(@"%u", property_count);

    for (unsigned i = 0; i < property_count; i++) {
        const char* name = property_getName(props[i]);
        const char* attrs = property_getAttributes(props[i]);

        lua_pushnumber(L, i + 1); // add index to stack

        {
            lua_createtable(L, 0, 2); // add propTable to stack

            lua_pushstring(L, name ? name : "(null)"); // add name to stack
            lua_setfield(L, -2, "name"); // set field then pop

            lua_pushstring(L, attrs ? attrs : "?"); // add attribute to stack
            lua_setfield(L, -2, "attributes"); // set field and pop
        }

        lua_settable(L, -3); // sets and pops outer table
    }

    free(props);

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
    lua_pushcfunction(L, ObjCDebug_getIvarsForClass);
    lua_setfield(L, -2, "getIvarsForClass");
    lua_pushcfunction(L, ObjCDebug_getClassList);
    lua_setfield(L, -2, "getClassList");
    lua_pushcfunction(L, ObjCDebug_getPropertiesForClass);
    lua_setfield(L, -2, "getPropertiesForClass");

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pop(L, 1);
}