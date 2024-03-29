-- initialization
    -- ensure imports are from file instead of cache
        local function import(path)
            package.loaded[path] = nil
            local imported = require (path)
            package.loaded[path] = nil
            return imported
        end
    -- import denendencies
        local botTools = import("./AM-BotTools/botTools")
        local compTools = import("./AM-CompTools/compTools")
        local treeBot = import("./TreeBot")

    --initialize GLBL table if needed
        if GLBL == nil then
            GLBL = {}
        end
        
    --initialize SCRIPT table
    --Stores global variables for just this script
        local SCRIPT = {}

-- main program
    -- toggle this script off it it is already on
        if compTools.anotherInstanceOfThisScriptIsRunning() then
            compTools.stopOtherInstancesOfThisScript()
            log("&7[&6Bots&7] &6* &cStopping Tree Farm...")
            botTools.freezeAllMotorFunctions()
            -- silently end this script
                return 0
        end

    log("Harvesting trees")
    treeBot.harvestTrees(41,36, 4,4)
    log("Finished harvesting Trees")
    botTools.disconnectIfAfkForTenSeconds()