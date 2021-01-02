-- initialization
    -- import denendencies
        local botTools = require ("./AM-Tools/botTools")
        local compTools = require ("./AM-Tools/compTools")
        local treeBot = require("./TreeBot")

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
    treeBot.harvestTrees(41,36)
    log("Finished harvesting Trees")
    botTools.disconnectIfAfkForTenSeconds()