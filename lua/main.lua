
function list_methods(obj)
    print("---- METHODS FOR " .. obj:call("className") .. " ----")
    print(table.concat(obj:methods(), "\n"))
    print("----               ----")
end

hook_objc("BHServer", "initWithDelegate:match:netNodeType:saveID:maxPlayers:", function(self, _cmd, delegate, match, netNodeType, saveID, maxPlayers)
    print("BHServer INIT")
    print(delegate, match, netNodeType, saveID, maxPlayers)
end)
hook_objc("BHNetNode", "initWithDelegate:match:netNodeType:", function(self, _cmd, delegate, match, netNodeType)
    print("BHNetNode INIT")
    print(delegate, match, netNodeType)
    return nil
end)


-- some stuff to mess around cuz why not
hook_objc("World", "welcomeMessage", function(self, _cmd)
    local bhServer = GameController:get("bhServer")

    return bhServer:getDebugLog()
end)
hook_objc("BHServer", "playerIsCloudWideAdminWithAlias:", function(self, _cmd)
    return true -- EVIL: make everyone have cool red names and power of doom
end)
hook_objc("ServerClient", "addFillRequest:", function(self, _cmd, fillIndex)
    print("fillIndex:", fillIndex)
    GameController:get("bhServer"):bootAllClientsDueToNoCredit()
end)
hook_objc("BHMatch", "setDelegate:", function(self, _cmd, delegate)
    print("BHMatch SETDELEGATE")
    print(delegate:className())
    abort()
end)
hook_objc("BHNetServerMatch", "isCloudMatch", function(self, _cmd)
    -- if return true, everyone will be kicked because of there being -1.0 credit lmao
    return false
end)



--repeat wait() until GameController ~= nil
--print("GameController get!")

--list_methods(GameController)
--list_methods(GameController:get("bhServer"))

function printClassesList()
    print(table.concat(ObjCDebug.getClassList(), "\n"))
end

printClassesList()