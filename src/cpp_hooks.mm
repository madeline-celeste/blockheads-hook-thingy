#import "hook_util.h"
#import "lua/classes/GameController.h"
#import "lua/lua_runner.h"
#import "lua/classes/ObjCObject.h"
#import "cpp_hooks.h"

#import <Foundation/Foundation.h>

extern lua_State* L;
id RefGameController = nullptr;

// triggers right before "World load complete.", giving us a pointer to the gameController
void hooked_loadCompleteForGameController(id self, SEL _cmd, id gameController) {
    NSLog(@"[Hook] intercepted gameController! %@", gameController);
    RefGameController = gameController;

    enqueueLuaTask([gameController](lua_State* L) {
        //pushGameController(L, gameController);
        pushObjCObject(L, gameController);
        lua_setglobal(L, "GameController");
    });
}