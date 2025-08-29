#include <lua.hpp>
#include <functional>

void enqueueLuaTask(std::function<void(lua_State*)> task);
void runLua();
void stopLua();