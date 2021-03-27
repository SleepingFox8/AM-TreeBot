-- initialization
    -- import denendencies
        local botTools = require ("AM-Tools/botTools")
        local compTools = require ("AM-Tools/compTools")

    -- prepair table for holding exported functions
        local treeBot = { _version = "0.0.0" }

    --initialize GLBL table if needed
        if GLBL == nil then
            GLBL = {}
        end
        
    --initialize SCRIPT table
    --Stores global variables for just this script
        local SCRIPT = {}

-- function declarations
    local function axeDurabilityOk()
        --function initialization
            --initialize function table
                local FUNC = {}

        FUNC.player = getPlayer()
        if FUNC.player.mainHand then
            FUNC.heldDurability = FUNC.player.mainHand.maxDmg - FUNC.player.mainHand.dmg
            if (FUNC.heldDurability < 50) then
                log("Durability too low to continue... stopping bot")
                botTools.freezeAllMotorFunctions()
                disconnect()
                -- not sure if stopAllScripts() is needed or even run after disconnect()ing
                stopAllScripts() 
            else
                return true
            end
        else
            log("Main hand is empty")
            botTools.freezeAllMotorFunctions()
            disconnect()
            stopAllScripts()
        end
    end
    
    local function grabAxeWithDura()
        botTools.summonItem("minecraft:diamond_axe",1,50)
        sleep(100)
        axeDurabilityOk()
    end

    local function setTimer(timerName, ms)
        --function initialization
            --initialize function table
                local FUNC = {}
            --store arguments in locally scoped table for scope safety
                FUNC.timerName, FUNC.ms = timerName, ms

        SCRIPT.timerStartTime[FUNC.timerName] = os.time()
        SCRIPT.timerDuration[FUNC.timerName] = ms
    end

    local function haveTime(timerName)
        --function initialization
            --initialize function table
                local FUNC = {}
            --store arguments in locally scoped table for scope safety
                FUNC.timerName = timerName

        if os.difftime(os.time(),SCRIPT.timerStartTime[FUNC.timerName]) < (SCRIPT.timerDuration[FUNC.timerName] / 1000) then
            return true
        else
            return false
        end
    end

    local function botHasNotFallen()
        --function initialization
            --initialize function table
                local FUNC = {}

        FUNC.bX, FUNC.bY, FUNC.bZ = getPlayerPos()
        if FUNC.bY < (SCRIPT.origy - 0.5) then
            log("[Bots] §6* Bot Fell Off. Logging out.")
            log("[Bots] §6* §cTREE HARVESTING...")
            botTools.freezeAllMotorFunctions()
            sleep(2000)
            log("disconnecting...")
            disconnect()
            stopAllScripts()
        else
            return true
        end
    end

    function treeBot.harvestTrees(xsize, zsize)
        --function initialization
            --initialize function table
                local FUNC = {}
            --store arguments in locally scoped table for scope safety
                FUNC.xsize, FUNC.zsize = xsize, zsize

        -- initialize variables
            SCRIPT.xInterval = 5
            SCRIPT.zInterval = 5
            SCRIPT.xsize = FUNC.xsize
            SCRIPT.zsize = FUNC.zsize
            SCRIPT.topbreaktimer = 70
            SCRIPT.lowduratrigger = 40
            SCRIPT.direction = 1
            SCRIPT.timerStartTime = {}
            SCRIPT.timerDuration = {}

        --initialize chopping variables
            log("[Bots] §6* §aTREE HARVESTING...")
            -- get original position of player
                SCRIPT.origx, SCRIPT.origy, SCRIPT.origz = getPlayerPos()
                -- remove decimal places
                    SCRIPT.origx = math.floor(SCRIPT.origx)
                    SCRIPT.origy = math.floor(SCRIPT.origy)
                    SCRIPT.origz = math.floor(SCRIPT.origz)
            -- get target postition
                FUNC.targx = SCRIPT.origx + (3 * SCRIPT.direction)
                FUNC.targz = SCRIPT.origz
            --grid positions
                FUNC.xloc = 0
                FUNC.zloc = 0

        -- main loop
            while botHasNotFallen() and (FUNC.zloc < SCRIPT.zsize) do
                --swap directions once row complete
                    SCRIPT.direction = SCRIPT.direction * -1
                --while finishing row 
                    while botHasNotFallen() and (((FUNC.xloc < SCRIPT.xsize) and (SCRIPT.direction == -1)) or ((FUNC.xloc > 0) and (SCRIPT.direction == 1))) do
                        -- harvest Tree
                            FUNC.treeHarvested = false
                            while botHasNotFallen() and FUNC.treeHarvested == false do
                                botTools.lookTowards(FUNC.targx,FUNC.targz)
                                grabAxeWithDura()
                                --travel to next tree
                                    --get player position
                                        FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                        -- remove decimal places
                                            FUNC.pX = math.floor(FUNC.pX)
                                            FUNC.pY = math.floor(FUNC.pY)
                                            FUNC.pZ = math.floor(FUNC.pZ)
                                    --if away from tree, get to tree
                                        --look straight forward to quickly break log if not obscured by leaves
                                            setTimer("lookTwordsTree",3000)
                                            while botHasNotFallen() and haveTime("lookTwordsTree") and (((FUNC.pX - FUNC.targx) > 1) or ((FUNC.pX - FUNC.targx) < -1)) or (((FUNC.pZ - FUNC.targz) > 1) or ((FUNC.pZ - FUNC.targz) < -1)) do
                                                --look twords tree
                                                    botTools.lookTowards(FUNC.targx,FUNC.targz)
                                                --break possible leaves in front of bot
                                                    attack(-1)
                                                --run forward
                                                    forward(-1)
                                                    sprint(true)
                                                sleep(100)
                                                --get player position
                                                    FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                                    -- remove decimal places
                                                        FUNC.pX = math.floor(FUNC.pX)
                                                        FUNC.pY = math.floor(FUNC.pY)
                                                        FUNC.pZ = math.floor(FUNC.pZ)
                                            end
                                            -- stop attacking
                                            attack(1)
                                        --look down to break and leaves at foot level
                                            while botHasNotFallen() and (((FUNC.pX - FUNC.targx) > 1) or ((FUNC.pX - FUNC.targx) < -1)) or (((FUNC.pZ - FUNC.targz) > 1) or ((FUNC.pZ - FUNC.targz) < -1)) do
                                                --look twords tree
                                                    botTools.lookTowards(FUNC.targx,FUNC.targz)
                                                --look down 30 degrees
                                                    FUNC.player = getPlayer()
                                                    look(FUNC.player.yaw, 30)
                                                --break possible leaves in front of bot
                                                    attack(-1)
                                                --run forward
                                                    forward(-1)
                                                    sprint(true)
                                                sleep(100)
                                                --get player position
                                                    FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                                    -- remove decimal places
                                                        FUNC.pX = math.floor(FUNC.pX)
                                                        FUNC.pY = math.floor(FUNC.pY)
                                                        FUNC.pZ = math.floor(FUNC.pZ)
                                            end
                                            -- stop attacking
                                            attack(1)
                                --harvest bottom of tree
                                    --get player position
                                        FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                        -- remove decimal places
                                            FUNC.pX = math.floor(FUNC.pX)
                                            FUNC.pY = math.floor(FUNC.pY)
                                            FUNC.pZ = math.floor(FUNC.pZ)
                                    --if next to tree
                                        if ((((FUNC.pX == FUNC.targx + 1) or (FUNC.pX == FUNC.targx - 1)) and (FUNC.pZ == FUNC.targz)) or (((FUNC.pZ == FUNC.targz + 1) or (FUNC.pZ == FUNC.targz - 1)) and (FUNC.pX == FUNC.targx))) then
                                            --stop walking
                                                forward(0)
                                            grabAxeWithDura()
                                            --detect if tree to mine based on time it takes to walk to center of tree
                                                setTimer("treeDetectionTimeout", 500)
                                            --while next to tree
                                                while botHasNotFallen() and ((((FUNC.pX == FUNC.targx + 1) or (FUNC.pX == FUNC.targx - 1)) and (FUNC.pZ == FUNC.targz)) or (((FUNC.pZ == FUNC.targz + 1) or (FUNC.pZ == FUNC.targz - 1)) and (FUNC.pX == FUNC.targx))) do
                                                    --look twords tree
                                                        botTools.lookTowards(FUNC.targx,FUNC.targz)
                                                    --break into tree
                                                        --look down 30 degrees
                                                            FUNC.player = getPlayer()
                                                            look(FUNC.player.yaw, 30)
                                                        sprint(false)
                                                        forward(-1)
                                                        --break block(s)
                                                            attack(-1)
                                                    sleep(100)
                                                    --get player position
                                                        FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                                        -- remove decimal places
                                                            FUNC.pX = math.floor(FUNC.pX)
                                                            FUNC.pY = math.floor(FUNC.pY)
                                                            FUNC.pZ = math.floor(FUNC.pZ)
                                                end
                                        end

                                
                                --get player position
                                    FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                    -- remove decimal places
                                        FUNC.pX = math.floor(FUNC.pX)
                                        FUNC.pY = math.floor(FUNC.pY)
                                        FUNC.pZ = math.floor(FUNC.pZ)
                                --if under tree
                                if ((FUNC.pX == FUNC.targx) and (FUNC.pZ == FUNC.targz)) then
                                    FUNC.timeToChop = 0
                                    if haveTime("treeDetectionTimeout") then
                                        FUNC.timeToChop = 2000
                                    else
                                        FUNC.timeToChop = 3000
                                    end
                                    --harvest top of tree
                                        --while under tree, break top section
                                            setTimer("harvestTreeTop", FUNC.timeToChop)
                                            while botHasNotFallen() and haveTime("harvestTreeTop") and ((FUNC.pX == FUNC.targx) and (FUNC.pZ == FUNC.targz)) do
                                                -- stop walking
                                                    forward(0)
                                                -- look straight up
                                                    FUNC.player = getPlayer()
                                                    look(FUNC.player.yaw,-90)
                                                -- mine the tree
                                                    attack(-1)
                                                sleep(100)
                                                --get player position
                                                    FUNC.pX, FUNC.pY, FUNC.pZ = getPlayerPos()
                                                    -- remove decimal places
                                                        FUNC.pX = math.floor(FUNC.pX)
                                                        FUNC.pY = math.floor(FUNC.pY)
                                                        FUNC.pZ = math.floor(FUNC.pZ)
                                            end
                                        --stop chopping tree
                                            attack(1) -- attack(0) doesn't work
                                    sleep(100)
                                end

                                if botHasNotFallen() and ((FUNC.pX == FUNC.targx) and (FUNC.pZ == FUNC.targz)) then
                                    --replant sappling
                                        --grab sappling
                                            botTools.summonItem("minecraft:birch_sapling",3)
                                            botTools.summonItem("minecraft:oak_sapling",3)
                                        --look straight down
                                            FUNC.player = getPlayer()
                                            look(FUNC.player.yaw,90)
                                            sleep(100)
                                        --break old sappling
                                            attack(1)
                                            sleep(100)
                                        --plant sappling
                                            use(1)
                                            --give time for right click (plant) to register
                                            sleep(100)
                                    FUNC.treeHarvested = true
                                end
                            end
                        
                        botTools.eatIfHungery()

                        --set new target
                            FUNC.targx = FUNC.targx + (SCRIPT.xInterval * (SCRIPT.direction * -1))
                            FUNC.xloc = FUNC.xloc + (SCRIPT.direction * -1)
                    end
                --set new target
                    FUNC.targx = FUNC.targx - (SCRIPT.xInterval * (SCRIPT.direction * -1))
                    FUNC.targz = FUNC.targz - SCRIPT.zInterval
                    FUNC.zloc = FUNC.zloc + 1
                -- offload Wood
                    look(25,0)
                    botTools.dropAllOfItemExcept("minecraft:oak_log")
                    botTools.dropAllOfItemExcept("minecraft:birch_log")
                    botTools.dropAllOfItemExcept("minecraft:oak_leaves")
                    botTools.dropAllOfItemExcept("minecraft:birch_leaves")
                    botTools.dropAllOfItemExcept("minecraft:stick")
                    botTools.dropAllOfItemExcept("minecraft:apple")
                    sleep(1000)
            end
            log("Finished harvesting trees")
            log("disconnecting...")
    end

return treeBot