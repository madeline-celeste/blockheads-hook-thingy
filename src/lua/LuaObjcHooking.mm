// _NOTE_
// this is where we do very evil and cursed things

#include <ffi.h>
#include <lua.hpp>
#include <vector>
#include <map>
#include <string>

#import "ObjCPushHelper.h"
#import "classes/ObjCSelector.h"
#import "classes/ObjCObject.h"

#import <Foundation/Foundation.h>

//#import "../hook_util.h"

extern std::map<std::string, IMP>* original_implementations;

ffi_type* ffiTypeForEncoding(const char* enc) {
    if (strcmp(enc, @encode(void)) == 0) {
        return &ffi_type_void;
    } else if (strcmp(enc, @encode(id)) == 0) {
        return &ffi_type_pointer;
    } else if (strcmp(enc, @encode(Class)) == 0) {
        return &ffi_type_pointer;
    } else if (strcmp(enc, @encode(SEL)) == 0) {
        return &ffi_type_pointer;
    } else if (strcmp(enc, @encode(void*)) == 0) {
        return &ffi_type_pointer;
    } else if (strcmp(enc, @encode(uint8_t)) == 0) {
        return &ffi_type_uint8; // unsigned uint8
    } else if (strcmp(enc, @encode(unsigned short)) == 0) {
        return &ffi_type_ushort;
    } else if (strcmp(enc, @encode(signed short)) == 0) {
        return &ffi_type_sshort;
    } else if (strcmp(enc, @encode(uint16_t)) == 0) {
        return &ffi_type_uint16; // unsigned uint16
    } else if (strcmp(enc, @encode(uint32_t)) == 0) {
        return &ffi_type_uint32; // unsigned uint32
    } else if (strcmp(enc, @encode(uint64_t)) == 0) {
        return &ffi_type_uint64; // unsigned uint64
    } else if (strcmp(enc, @encode(int8_t)) == 0) {
        return &ffi_type_sint8; // unsigned sint8
    } else if (strcmp(enc, @encode(int16_t)) == 0) {
        return &ffi_type_sint16; // unsigned sint16
    } else if (strcmp(enc, @encode(int32_t)) == 0) {
        return &ffi_type_sint32; // unsigned sint32
    } else if (strcmp(enc, @encode(int64_t)) == 0) {
        return &ffi_type_sint64; // unsigned sint64
    } else if (strcmp(enc, @encode(float)) == 0) {
        return &ffi_type_float;
    } else if (strcmp(enc, @encode(double)) == 0) {
        return &ffi_type_double;
    } else if (strcmp(enc, @encode(long double)) == 0) {
        return &ffi_type_longdouble;
    } else if (strcmp(enc, @encode(unsigned char)) == 0) {
        return &ffi_type_uchar;
    } else if (strcmp(enc, @encode(signed char)) == 0) {
        return &ffi_type_schar;
    }

    @throw [
        NSException exceptionWithName:@"FFIEncodingFail"
        reason:@"Unhandled encoding!"
        userInfo:NULL
    ];
}

struct LuaHook {
    lua_State* L;
    int luaFuncRef;

    std::vector<ffi_type*> arg_types;
    ffi_cif call_interface;
    ffi_closure* closure;
    ffi_type* return_type;
    IMP previous_implementation;
};

/*
trampoline thing i think. like it boings into lua or something i think thats why they called trampoline

idfk

todo:lua needs to be able to call the original function
*/
void objc_ffi_lua_invoke(ffi_cif *cif, void *ret, void **args, void *user_data) {    
    LuaHook* hook = (LuaHook*)user_data;
    lua_State* L = hook->L;

    id self = *static_cast<id*>(args[0]);
    SEL _cmd = *static_cast<SEL*>(args[1]);

    Method meth = class_getInstanceMethod([self class], _cmd); // waltuh
    const char* encoding = method_getTypeEncoding(meth);
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:encoding];
    NSUInteger numArgs = [sig numberOfArguments];

    lua_rawgeti(L, LUA_REGISTRYINDEX, hook->luaFuncRef);

    pushObjCObject(L, self);
    pushObjCSelector(L, _cmd);

    // start past self and _cmd
    for (NSUInteger i = 2; i < numArgs; i++) {
        const char* argType = [sig getArgumentTypeAtIndex:i];

        if (strcmp(argType, @encode(id)) == 0) {
            NSLog(@"userdata");
            id v = *reinterpret_cast<id*>(args[i]);

            if ([v isKindOfClass:[NSString class]]) {
                pushNSString(L, (NSString*)v);
            } else {
                pushObjCObject(L, v);
            }

        } else if (strcmp(argType, @encode(int)) == 0) {
            int v = *reinterpret_cast<int*>(args[i]);
            lua_pushnumber(L, static_cast<lua_Integer>(v));
        } else if (strcmp(argType, @encode(long int)) == 0) {
            long int v = *reinterpret_cast<long int*>(args[i]);
            lua_pushnumber(L, static_cast<lua_Integer>(v));
        } else if (strcmp(argType, @encode(unsigned int)) == 0) {
            unsigned int v = *reinterpret_cast<unsigned int*>(args[i]);
            lua_pushinteger(L, static_cast<lua_Integer>(v));
        } else if (strcmp(argType, @encode(double)) == 0) {
            double v = *reinterpret_cast<double*>(args[i]);
            lua_pushnumber(L, static_cast<lua_Number>(v));
        } else {
            luaL_error(L, "Unsupported arg type: %s", argType);
        }
    }
    
    //NSLog(@"%lu", numArgs);

    if (lua_pcall(L, numArgs, 1, 0) != LUA_OK) {
        NSLog(@"Lua hook error: %s", lua_tostring(L, -1));
        lua_pop(L, 1);
        memset(ret, 0, hook->return_type->size);
        return; // this may segfault depending on the function. don't know if objc can
                // handle void returns when not explicitly allowed. either way something might
                // get very broken, don't really think there's much of a better way to do this.
                // could call the original implementation but eh idc much about stability rn.
    }

    switch (hook->return_type->type) {
        case FFI_TYPE_POINTER: {
            NSLog(@"point");
            if (lua_islightuserdata(L, -1)) {
                void* obj = lua_touserdata(L, -1);
                *static_cast<void**>(ret) = obj;
            } else if (lua_isstring(L, -1)) {
                NSString* str = [NSString stringWithUTF8String:lua_tostring(L, -1)];
                *static_cast<void**>(ret) = str;
            } else if (lua_isuserdata(L, -1)) { // TODO: untested
                if (luaL_testudata(L, -1, "ObjCObject")) {
                    id obj = *static_cast<id*>(luaL_testudata(L, -1, "ObjCObject"));
                    *static_cast<void**>(ret) = obj;
                } else if (luaL_testudata(L, -1, "ObjCSelector")) { // untested
                    // this might not be portable i think (from my basic understandings at least)
                    // some platforms define objc_selector as const while others
                    // don't is what it seems
                    // idk if there will be any issues in the case that it isnt const though
                    // pointers are hard and evil

                    // i guess it's probably fine if we're casting to const and then
                    // unconsting it(..?)
                    SEL sel = *static_cast<SEL*>(luaL_testudata(L, -1, "ObjCSelector"));
                    *static_cast<void**>(ret) = const_cast<void*>(reinterpret_cast<const void*>(sel));
                } else {
                    @throw [
                        NSException exceptionWithName:@"UnhandledUData"
                        reason:@"unhandled userdata returned from lua hooked function"
                        userInfo:NULL
                    ];
                }
            } else {
                *static_cast<void**>(ret) = nil;
            }
            break;
        }
        case FFI_TYPE_UINT8: {
            if (lua_isboolean(L, -1)) {
                *static_cast<uint8_t*>(ret) = static_cast<uint8_t>(lua_toboolean(L, -1));
            } else {
                *static_cast<uint8_t*>(ret) = static_cast<uint8_t>(lua_tonumber(L, -1));
            }
            break;
        }
        case FFI_TYPE_SINT32: {
            NSLog(@"sint32!!");
            *static_cast<uint32_t*>(ret) = static_cast<uint32_t>(lua_tointeger(L, -1));
            break;
        }
        case FFI_TYPE_DOUBLE: {
            NSLog(@"doub!!");
            *static_cast<double*>(ret) = static_cast<double>(lua_tonumber(L, -1));
            break;
        }
        case FFI_TYPE_FLOAT: {
            NSLog(@"float!!");
            *static_cast<float*>(ret) = static_cast<double>(lua_tonumber(L, -1));
            break;
        }
        case FFI_TYPE_VOID: {
            memset(ret, 0, hook->return_type->size);
            break;
        }
        default: {
            memset(ret, 0, hook->return_type->size);
            NSLog(@"WARNING: default!!");
            break;
        }
    }

    lua_pop(L, 1);
}

int lua_hook_objc(lua_State* L) { 
    const char* class_name = luaL_checkstring(L, 1);
    const char* sel_name = luaL_checkstring(L, 2);
    int funcRef = luaL_ref(L, LUA_REGISTRYINDEX);

    Class cls = objc_getClass(class_name);
    if (!cls) {
        return luaL_error(L, "Class not found.");
    }

    SEL sel = sel_registerName(sel_name);
    Method meth = class_getInstanceMethod(cls, sel);
    if (!meth) {
        return luaL_error(L, "Method '%s' not found.");
    }

    std::string full_name = std::string(class_name) + " " + sel_name;

    const char* encoding = method_getTypeEncoding(meth);
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:encoding];

    LuaHook* hook = new LuaHook{};

    ffi_cif call_interface;
    hook->arg_types.push_back(&ffi_type_pointer); // self
    hook->arg_types.push_back(&ffi_type_pointer); // _cmd
    for (NSUInteger i = 2; i < [sig numberOfArguments]; i++) {
        const char* arg_encoding = [sig getArgumentTypeAtIndex:i];
        hook->arg_types.push_back(ffiTypeForEncoding(arg_encoding));
    }

    ffi_type* return_type = ffiTypeForEncoding([sig methodReturnType]);

    //NSLog(@"arg count: %u", static_cast<unsigned>(hook->arg_types.size()));

    if (ffi_prep_cif(
        &call_interface,
        FFI_DEFAULT_ABI,
        static_cast<unsigned>(hook->arg_types.size()),
        return_type,
        hook->arg_types.data()
    ) != FFI_OK) {
        return luaL_error(L, "ffi_prep_cif failed");
    }


    ffi_closure* closure;
    IMP imp;

    closure = (ffi_closure*)ffi_closure_alloc(sizeof(ffi_closure), reinterpret_cast<void**>(&imp));

    hook->L = L;
    hook->luaFuncRef = funcRef;
    hook->call_interface = call_interface;
    hook->closure = closure;
    hook->return_type = return_type;

    if (ffi_prep_closure_loc(
        closure,
        &(hook->call_interface),
        &objc_ffi_lua_invoke,
        hook,
        (void*)imp
    ) != FFI_OK) {
        return luaL_error(L, "ffi_prep_closure_loc failed");
    }

    hook->previous_implementation = class_replaceMethod(cls, sel, imp, encoding);

    NSLog(@"[Hooked %s]", full_name.c_str());

    lua_pushboolean(L, YES);
    return 1;
}