#include <mutex>
#include <queue>
#include <condition_variable>
#include <functional>
#include <thread>
#include <lua.hpp>
#include <vector>
#include <chrono>

#import "LuaObjcHooking.h"

#import "classes/ObjCSelector.h"
#import "classes/GameController.h"
#import "classes/ObjCObject.h"

#import "ObjCPushHelper.h"

#import "lib/ObjCDebug.h"

#import <Foundation/Foundation.h>

// this file is really really bad i feel and probably unstable

lua_State* L = nullptr;

std::mutex QUEUE_MUTEX;
std::condition_variable QUEUE_CONDITION_VARIABLE;
std::queue<std::function<void(lua_State*)>> TASK_QUEUE;

struct ScheduledCoroutine {
    int refToCo;
    std::chrono::steady_clock::time_point resumeTime;
};
std::mutex COROUTINE_MUTEX;
std::vector<ScheduledCoroutine> WAITING_COROUTINES;

static void resume_ready_coroutines(lua_State* L) {
    using std::chrono::steady_clock;
    steady_clock::time_point now = std::chrono::steady_clock::now();
    std::vector<ScheduledCoroutine> readyCoroutines;

    {
        std::lock_guard<std::mutex> lock(COROUTINE_MUTEX);

        auto iterator = WAITING_COROUTINES.begin();
        while (iterator != WAITING_COROUTINES.end()) {
            if (iterator->resumeTime <= now) {
                readyCoroutines.push_back(*iterator);
                iterator = WAITING_COROUTINES.erase(iterator);
            } else {
                ++iterator;
            }
        }
    }

    for (auto& coroutine : readyCoroutines) {
        lua_rawgeti(L, LUA_REGISTRYINDEX, coroutine.refToCo);
        lua_State* co = lua_tothread(L, -1);
        lua_pop(L, 1);

        // TODO: this might be bad
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

        int num_results;
        int status = lua_resume(co, NULL, 0, &num_results);
        luaL_unref(L, LUA_REGISTRYINDEX, coroutine.refToCo);

        if (status != LUA_OK && status != LUA_YIELD) {
            const char* err = lua_tostring(co, -1);
            NSLog(@"Lua error: %s", err);
        }

        [pool drain];
    }
}

static void lua_pump_once(lua_State* L) {
    while (true) {
        std::function<void(lua_State*)> task;
        {
            std::lock_guard<std::mutex> lock(QUEUE_MUTEX);
            if (TASK_QUEUE.empty()) {
                // reason why this is done here is because would be bad if
                // did it without the lock i think. could make the lock outside here but
                // idk if thats slightly worse or not.
                // concurrency is hardd.
                // ^^ actually it is cuz we call task() and that might take a little which
                // would slow some things adding to the mutex down slightly (i guess)
                break;
            }
            task = std::move(TASK_QUEUE.front());
            TASK_QUEUE.pop();
        }
        task(L);
    }

    resume_ready_coroutines(L);
}

int lua_wait(lua_State* L) {
    using std::chrono::steady_clock;
    // wait seconds
    double seconds = luaL_optnumber(L, 1, 0.03);
    steady_clock::time_point now = steady_clock::now();
    steady_clock::time_point resumeTime = now + std::chrono::milliseconds((int)(seconds*1000.0));

    lua_pushthread(L);
    int coRef = luaL_ref(L, LUA_REGISTRYINDEX);

    {
        std::lock_guard<std::mutex> lock(COROUTINE_MUTEX);
        WAITING_COROUTINES.push_back({coRef, resumeTime});
    }

    // yield the coroutine
    return lua_yield(L, 0);
}

void enqueueLuaTask(std::function<void(lua_State*)> task) {
    {
        std::lock_guard<std::mutex> lock(QUEUE_MUTEX);
        TASK_QUEUE.push(task);
    }
    QUEUE_CONDITION_VARIABLE.notify_one();
};

int lua_abort(lua_State* L) {
    NSLog(@"abort() called in lua");
    abort();
    return 0;
}

BOOL _stopLua = NO;

//#include <iostream>
void _runLuaThread() {
    L = luaL_newstate();
    luaL_openlibs(L);

    registerGameController(L);
    registerObjCObject(L);
    registerObjCSelector(L);

    // libraries
    registerObjCDebug(L);
    pushObjCDebug(L);
    lua_setglobal(L, "ObjCDebug");

    lua_register(L, "wait", lua_wait);
    lua_register(L, "hook_objc", lua_hook_objc);
    lua_register(L, "abort", lua_abort);
    lua_register(L, "stringToNSArrayObjCObject", pushLuaTableToNSArrayObjCObject);
    
    if (luaL_loadfile(L, "lua/main.lua") != LUA_OK) {
        const char* err = lua_tostring(L, -1);
        NSLog(@"Lua load error: %s", err);
        lua_pop(L, 1);
        return;
    }

    // makes a coroutine
    lua_State* co = lua_newthread(L);
    int coRef = luaL_ref(L, LUA_REGISTRYINDEX);
    // moves loaded chunk into the coroutine
    lua_xmove(L, co, 1);
    //int num_results;
    //int status = lua_resume(co, NULL, 0, &num_results);
    //if (status != LUA_OK && status != LUA_YIELD) {
    //    const char* err = lua_tostring(co, -1);
    //    std::cerr << "Lua runtime error: " << (err ? err : "(unknown)") << std::endl;
    //    lua_pop(co, 1);
    //} else {
    //    std::cout << "Lua script executed, results: " << num_results << std::endl;
    //}

    {
        std::lock_guard<std::mutex> lock(COROUTINE_MUTEX);
        WAITING_COROUTINES.push_back({coRef, std::chrono::steady_clock::now()});
    }

    //std::abort();

    while (!_stopLua) {
        {
            std::unique_lock<std::mutex> lock(QUEUE_MUTEX);
            QUEUE_CONDITION_VARIABLE.wait_for(lock, std::chrono::milliseconds(10), []() { return !TASK_QUEUE.empty(); });
        }
        lua_pump_once(L);
    }

    lua_close(L);
}

void runLua() {
    std::thread runLuaThread(_runLuaThread);
    runLuaThread.detach();
};

void stopLua() {
    _stopLua = YES;
    QUEUE_CONDITION_VARIABLE.notify_all();
}