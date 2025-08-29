// _NOTE_
// this is a lua class that wraps ObjectiveC objects
//
// very yummy

#include <cstring>
#include <string>
#include <lua.hpp>

#import "ObjCSelector.h"
#import "../ObjCLuaHelper.h"

#import <Foundation/Foundation.h>

void pushObjCObject(lua_State* L, id obj) {
    id* userdata = (id*)lua_newuserdata(L,sizeof(id));
    *userdata = obj;

    luaL_getmetatable(L, "ObjCObject");
    lua_setmetatable(L, -2);
}

static int objcObject_methods(lua_State* L) {
    id obj = *(id*)luaL_checkudata(L, 1, "ObjCObject");
    Class cls = object_getClass(obj);

    unsigned int count = 0;
    Method* methods = class_copyMethodList(cls, &count);

    lua_newtable(L);

    for (unsigned int i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        const char* name = sel_getName(sel);
        
        lua_pushstring(L, name);
        lua_rawseti(L, -2, i + 1);
    }

    free(methods);
    return 1;
}

// gets an ivar!
// i dont really like this
static int objcObject_get(lua_State* L) {
    id obj = *(id*)luaL_checkudata(L, 1, "ObjCObject");
    const char* varName = luaL_checkstring(L, 2);

    Class cls = object_getClass(obj);

    Ivar ivar = class_getInstanceVariable(cls, varName);
    if (!ivar) {
        luaL_error(L, "No such variable: %s", varName);
        return 0;
    }

    const char* encoding = ivar_getTypeEncoding(ivar);

    if (strcmp(encoding, @encode(void)) == 0) {
        return 0;
    } else if (strcmp(encoding, @encode(id)) == 0) {
        id returnValue = object_getIvar(obj, ivar);
        if (returnValue) {
            if ([returnValue isKindOfClass:[NSString class]]) {
                //NSLog(@"pushing string %@", returnValue);
                lua_pushstring(L, [returnValue UTF8String]);
            } else {
                //NSLog(@"pushing class %@", returnValue);
                pushObjCObject(L, returnValue);
            }
        } else {
            lua_pushnil(L);
        }
        return 1;
    }

    return luaL_error(L, "Unsupported Ivar type: %s", encoding);
}



static int objcObject_call(lua_State* L) {
    id obj = *(id*)luaL_checkudata(L, lua_upvalueindex(1), "ObjCObject");
    //NSLog(@"your taking too long");
    SEL sel = *(SEL*)luaL_checkudata(L, lua_upvalueindex(2), "ObjCSelector");

    //NSLog(@"we have the meats");

    Method meth = class_getInstanceMethod([obj class], sel); // segfaults
    if (!meth) {
        NSLog(@"NO FUCKING METHOD WHY");
        luaL_error(L, "No such method: %s", sel_getName(sel));
        return 0;
    }
    //NSLog(@"Good. Keep smiling.");

    const char* encoding = method_getTypeEncoding(meth);
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:encoding];
    NSUInteger numArgs = [sig numberOfArguments] - 2; // skip self&_cmd

    NSUInteger numLuaArgs = lua_gettop(L) - 1;
    if (numLuaArgs != numArgs) {
        NSLog(@"Expected %lu args, got %lu", (unsigned long)numArgs, (unsigned long) numLuaArgs);
        luaL_error(L, "Expected %lu args, got %lu", (unsigned long)numArgs, (unsigned long) numLuaArgs);
    }

    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:obj];
    [invocation setSelector:sel];

    for (NSUInteger i = 0; i < numArgs; i++) {
        const char* argType = [sig getArgumentTypeAtIndex:(i + 2)];

        if (strcmp(argType, @encode(id)) == 0) {
            if (lua_isstring(L, i + 3)) {
                NSString* str = [NSString stringWithUTF8String:lua_tostring(L, i + 3)];
                [invocation setArgument:&str atIndex:(i + 2)];
            } else if (lua_isuserdata(L, i + 3)) {
                id arg = *(id*)luaL_checkudata(L, i + 3, "ObjCObject");
                [invocation setArgument:&arg atIndex:(i + 2)];
            } else {
                id nilObj = nil;
                [invocation setArgument:&nilObj atIndex:(i + 2)];
            }
        } else if (strcmp(argType, @encode(int)) == 0) {
            int val = (int)lua_tointeger(L, i + 3);
            [invocation setArgument:&val atIndex:(i + 2)];
        } else if (strcmp(argType, @encode(double)) == 0) {
            double val = lua_tonumber(L, i + 3);
            [invocation setArgument:&val atIndex:(i + 2)];
        } else {
            return luaL_error(L, "Unsupported arg type: %s", argType);
        }
    }

    [invocation invoke];

    const char* returnType = [sig methodReturnType];
    if (strcmp(returnType, @encode(void)) == 0) {
        return 0;
    } else if (strcmp(returnType, @encode(id)) == 0) {
        id returnValue;
        [invocation getReturnValue:&returnValue];
        if (returnValue) {
            if ([returnValue isKindOfClass:[NSString class]]) {
                lua_pushstring(L, [returnValue UTF8String]);
                //NSLog(@"pushing string %@", returnValue);
            } else if ([returnValue isKindOfClass:[NSArray class]]) {
                pushNSArray(L, returnValue);
            } else {
                //NSLog(@"pushing class %@", returnValue);
                pushObjCObject(L, returnValue);
            }
        } else {
            lua_pushnil(L);
        }
        return 1;
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {
        BOOL b;
        [invocation getReturnValue:&b];
        lua_pushboolean(L, b);
        return 1;
    } else if (strcmp(returnType, @encode(int)) == 0) {
        int v;
        [invocation getReturnValue:&v];
        lua_pushinteger(L, static_cast<lua_Integer>(v));
        return 1;
    } else if (strcmp(returnType, @encode(double)) == 0) {
        double v;
        [invocation getReturnValue:&v];
        lua_pushnumber(L, static_cast<lua_Number>(v));
        return 1;
    } else if (strcmp(returnType, @encode(float)) == 0) {
        float f;
        [invocation getReturnValue:&f];
        lua_pushnumber(L, static_cast<lua_Number>(f));
        return 1;
    }

    return luaL_error(L, "Unsupported return type: %s", returnType);
}

static int objcObject__index(lua_State* L) {
    id obj = *(id*)luaL_checkudata(L, 1, "ObjCObject");
    const char* key = luaL_checkstring(L, 2);
    SEL sel = sel_registerName(key);

    NSLog(@"%s", key);

    // _NOTE_
    // NOT sure if this is a good way to do this.
    // pretty sure if there is a conflicting method name there will be
    // no way to call our function if it is done this way.
    // not really having a better idea though
    if ([obj respondsToSelector:sel]) {
        pushObjCObject(L, obj);
        pushObjCSelector(L, sel);
        lua_pushcclosure(L, objcObject_call, 2);
        return 1;
    }

    if (lua_getmetatable(L, 1)) {
        lua_pushvalue(L, 2);
        lua_rawget(L, -2);
        if (!lua_isnil(L, -1)) {
            return 1; // found somethin i guess
        }
        lua_pop(L, 1); // pop nil
    }

    return 0;
}

static int objcObject__tostring(lua_State* L) {
    id obj = *(id*)luaL_checkudata(L, 1, "ObjCObject");
    lua_pushstring(L, (std::string("ObjCObject<") + [[obj className] UTF8String] + ">").c_str());

    return 1;
}

void registerObjCObject(lua_State* L) {
    luaL_newmetatable(L, "ObjCObject");

    lua_pushcfunction(L, objcObject_methods);
    lua_setfield(L, -2, "methods");
    //lua_pushcfunction(L, objcObject_call);
    //lua_setfield(L, -2, "call");
    lua_pushcfunction(L, objcObject_get);
    lua_setfield(L, -2, "get");

    lua_pushcfunction(L, objcObject__tostring);
    lua_setfield(L, -2, "__tostring");
    lua_pushcfunction(L, objcObject__index);
    lua_setfield(L, -2, "__index");

    //lua_pushvalue(L, -1);
    //lua_setfield(L, -2, "__index");

    lua_pop(L, 1); // pop the metatable
}