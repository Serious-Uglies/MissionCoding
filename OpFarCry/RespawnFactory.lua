local RF_Version = "V0.4"

-----------------------------------------------------------------------------------
-- What's this?
-- 
-- The respawn factory script provides a game mechanic to simulate one or more 
-- factories that create a new unit for each unit destroyed in a given zone. 
--
-- This is done by adding a control zone which observes the death of units.
-- When a unit died, the inital position of the unit together with the unit type
-- is added to a queue. The groups from the queue are created one after another
-- in the configured spawn zones of the factories. The schedule for the creation 
-- is configureable.
--
-- If more than one factory is available per zone, the spawn is done randomly at
-- one of the available factories. If the static for the factory is destroyed, 
-- it cannot create new groups.
-----------------------------------------------------------------------------------
-- The Respawn Factory script was created 2022 by Skyfire
-- It depends on Moose being available.
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Usage
-----------------------------------------------------------------------------------

-- !! Currently only ground units with a single unit per group are supported !!

-- Register Factory zone handling with name e.g. FAC_NAME
-- registerFactory("FAC_NAME")
-- "FAC_NAME_ObserveZone" is the expected name of the zone to support with troops
-- Each Static with the name prefix FAC_NAME is used as factory (eg. FAC_NAME_01)
-- Each Static must have a zone with the postfix _Respawn_Zone which servers as place where
-- the new groups are created

-- Example 1
-- A simple config for config RF01:
-- 
-- registerFactory("RF01")
--
-- This needs:
--   * One Zone named "RF01_Observe_Zone"
--   * One Static named "RF01"
--   * One Zone named "RF01_RZ"

-- Example 
-- A simple config for config RF02 with three static factories:
--   * One Zone named "RF02_Observe_Zone"
--   * One Static named "RF02_01"  (can be anything after the prefix RF02 - caution: the unit name is essential)
--   * One Zone named "RF02_01_RZ"
--   * One Static named "RF02_02"  (can be anything after the prefix RF02)
--   * One Zone named "RF02_02_RZ"
--   * One Static named "RF02_03"  (can be anything after the prefix RF02)
--   * One Zone named "RF02_03_RZ"

-----------------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------------

local maxRespawn = 1000
local observeZonePostfix = "_Observe_Zone"
local respawnZonePostfix = "_RZ"
local sceneryIDPostfix = "_ID"
local respawnInterval = 611 -- seconds - slightly off time to avoid conflict with other scheduled tasks
local respawnPropability = 80  -- probability in which a vehicle is rebuild
local redInfantryVehicleTemplate = "TEMPLATE_RED_INF_SCOUT_BRDM"

-----------------------------------------------------------------------------------
-- Helper
-----------------------------------------------------------------------------------
local defaultMsgShowTime = 10

--UglyPrintOnScreen = true

local function UglyPrintDebug(_msg, _duration)
  local printOnScreen = UglyPrintOnScreen or false
  local completeMsg = "RespawnFactory: " .. _msg
  local showHowLong = _duration or defaultMsgShowTime

  if printOnScreen then
    trigger.action.outText(completeMsg, 30, false)
  end

  env.info( completeMsg )

end

-----------------------------------------------------------------------------------
UglyPrintDebug("Loading RespawnFactory Script - " .. RF_Version)
-----------------------------------------------------------------------------------
-- Some internal structures

local groupSpawnMap = {}  -- map of new spawned group name to original template
local killedGroups = {}
local killedGroupsCount = 0
local nextRespawn = 1
local factoryRegistration = {}

-----------------------------------------------------------------------------------
-- Actual Code

-- Check for Moose
if ENUMS == nil then
  UglyPrintOnScreen = true
  UglyPrintDebug("Moose is missing - cannot live without it! Respawn Factory script is not loaded!", 600)
  return
end

-----------------------------------------------------------------------------------
-- Get random alive factory for factory prefix
-----------------------------------------------------------------------------------

local function getRandomFactoryZone(_facPref)
  UglyPrintDebug("getRandomFactoryZone...")

--  _facPref = _facPref or "RF_CZ02"

  local facList = factoryRegistration[_facPref]

  local currentFacCount = #facList
  UglyPrintDebug("currentFacCount...: " .. currentFacCount)

  -- Cleanup all dead ones
  for i = currentFacCount, 1, -1 do
    UglyPrintDebug("current i ... " .. i)
    local currentObj = facList[i]["object"]

    if currentObj == nil then
      UglyPrintDebug("current i is NULL, removing! .. " .. i)
      table.remove(facList, i)
    else
      UglyPrintDebug("current ClassName ... " .. facList[i]["object"]:GetClassName())

      if facList[i]["object"]:GetClassName() == "SCENERY" then
        local oldName = facList[i]["object"]:GetName()
        local theZone = facList[i]["zone"]
        currentObj = SCENERY:FindByName(oldName, theZone:GetCoordinate(), 500)
        facList[i]["object"] = currentObj
      end

      if currentObj:IsAlive() == false then
        UglyPrintDebug("Dead, so removing: " .. currentObj:GetName())
        table.remove(facList, i)
      else
        UglyPrintDebug("Still Alive: " .. currentObj:GetName())
        UglyPrintDebug("ClassName: " .. currentObj:GetClassName())
      end
    end
  end

  currentFacCount = #facList
  UglyPrintDebug("currentFacCount...after cleanup: " .. currentFacCount)

  if currentFacCount == 0 then
    return nil
  end

  local theIndex = math.random(1, currentFacCount)
  return facList[theIndex].zone 

--  TIMER:New(getRandomFactoryZone):Start(2)
end

-- Start factory respawn test
--TIMER:New(getRandomFactoryZone):Start(10)

-----------------------------------------------------------------------------------
-- The main register function
-----------------------------------------------------------------------------------
function registerFactory(_facName)
  UglyPrintDebug("Registering Factories with prefix: " .. _facName)

  local SetFactories = SET_STATIC:New():FilterCoalitions("red"):FilterPrefixes(_facName):FilterOnce()
  local SetZones = SET_ZONE:New():FilterPrefixes(_facName .. sceneryIDPostfix):FilterOnce()

  local totalFactories = SetFactories:CountAlive() + SetZones:Count()

  if totalFactories == 0 then
    UglyPrintDebug("Cannot find any factories with name: " .. _facName)
    return
  end

  UglyPrintDebug("Found " .. totalFactories .. " factories for: " .. _facName)

  local theCount = 1
  factoryRegistration[_facName] = {}

  SetFactories:ForEachStatic(function(theFactory)
      UglyPrintDebug("Registering Factory by Static: " .. theFactory:GetName())
      local facData = {object = theFactory, zone = ZONE:FindByName(theFactory:GetName() .. respawnZonePostfix)}
      factoryRegistration[_facName][theCount] = facData
      theCount = theCount + 1
    end
  )

  SetZones:ForEachZone(function(theZone)
      UglyPrintDebug("Registering Factory by SceneryID: " .. theZone:GetName())

      local theID = string.sub (theZone:GetName(), string.len(_facName) + string.len(sceneryIDPostfix) + 2, string.len(theZone:GetName()))
      local theScenery = SCENERY:FindByName(theID, theZone:GetCoordinate(), 500)

      if theScenery == nil then
        UglyPrintDebug("ERROR Registering Factory by SceneryID: " .. theID)
      else
        local zoneName = _facName .. respawnZonePostfix .. "_" .. theID
        local facData = {object = theScenery, zone = ZONE:FindByName(zoneName)}
        factoryRegistration[_facName][theCount] = facData
        theCount = theCount + 1

        UglyPrintDebug("theID: " .. theID .. ", zoneName: " .. zoneName)
      end
    end
  )

  local SetZone = SET_ZONE:New():FilterPrefixes( _facName .. observeZonePostfix ):FilterOnce()
  local SetGroups = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterZones(SetZone):FilterOnce()

  UglyPrintDebug("SetGroups alive: " .. SetGroups:CountAlive() .. ", in zone: " .. _facName .. observeZonePostfix)

  --SetGroups:Activate(1)

  SetGroups:ForEachGroup(function(groupToStore)
      UglyPrintDebug("Adding Group: " .. groupToStore:GetName())

      -- Initial spawn at original point
      local groupCoordinate = groupToStore:GetCoordinate()
--      local newGroupSpawn = SPAWN:New(groupToStore:GetName())
--      local newGroup = newGroupSpawn:SpawnFromVec3( groupCoordinate )  
      
--      groupToStore:HandleEvent(EVENTS.Dead)

      local startValues = {}
      startValues["template"] = groupToStore
      startValues["coords"] = groupCoordinate
      startValues["facPref"] = _facName

      local storeName = nil
      if string.find(groupToStore:GetName(), "Infantry_Respawn") ~= nil then
        storeName = groupToStore:GetName()
      else
        storeName = groupToStore:GetUnit(1):GetName()
      end

      groupSpawnMap[storeName] = startValues
      UglyPrintDebug("Added Unit: " .. groupToStore:GetUnit(1):GetName() .. ", for factory: " .. _facName)
    end
  )
end

FactoryDeathRecorder = EVENTHANDLER:New()
FactoryDeathRecorder:HandleEvent( EVENTS.Dead ) 
function FactoryDeathRecorder:OnEventDead( _eventData )
  UglyPrintDebug("Got Dead Event from type: " .. _eventData.IniObjectCategory)
  if _eventData.IniObjectCategory ~= Object.Category.UNIT and _eventData.IniObjectCategory ~= Object.Category.STATIC then
    UglyPrintDebug("Sorry, will be ignored. Only recording Unit deaths")
    return
  end

  UglyPrintDebug("Got Dead Event from Unit: " .. _eventData.IniUnitName)

--  Event.IniObjectCategory = Object.Category.UNIT
--  			local SOpos 		= _eventData.initiator:getPosition().p
--        local coords = COORDINATE:NewFromVec3(SOpos):SmokeOrange()

  local deadName = _eventData.IniUnitName
  local deadGroup = _eventData.IniGroup
  local deadGroupName = _eventData.IniGroupName
  local spawnForInf = false

  if deadGroup ~= nil then
    UglyPrintDebug("Killed members of deadGroup: " .. deadGroup:GetName())
    UglyPrintDebug("Group has " ..deadGroup:CountAliveUnits() .. " alive units.")

    if string.find(deadGroup:GetName(), "Static") ~= nil then
      UglyPrintDebug("Group is declared as static and will not respawn.")
      return
    elseif string.find(deadGroup:GetName(), "Infantry_Respawn") ~= nil then
      if deadGroup:CountAliveUnits() == 0 then
        spawnForInf = true
        UglyPrintDebug("Group is dead and was infantry.")
        deadName = deadGroup:GetName()
      else
        UglyPrintDebug("Infantry not yet dead.") -- cancel here.
        return
      end
    end
  else
    UglyPrintDebug("Killed deadGroup: is nil")
  end

  if groupSpawnMap[deadName] == nil then
    UglyPrintDebug("No Unit with this name. Maybe a static? " .. deadName)

    -- workaround to get proper objects. ED changed the way dying object are handled. When killed, they turn
    -- into statics with a new name instead keeping the dead unit. The static name is the same + a new number at the end
    -- the unit  "Killed #001" turns into the static "Killed #001-01"
    deadName = string.sub (_eventData.IniUnitName, 0, string.len(_eventData.IniUnitName)-3)

    if groupSpawnMap[deadName] == nil then
      UglyPrintDebug("No Static either. Object not tracked " .. deadName)
      return
    end
  end

  UglyPrintDebug("Target destroyed. Good Job!!")

  local _facPrefix = groupSpawnMap[deadName]["facPref"]

  local rndFacZone = getRandomFactoryZone(_facPrefix)

  if rndFacZone == nil then
    UglyPrintDebug("Sorry, all factories from " .. _facPrefix .. " are offline!")
    return
  end

  UglyPrintDebug("Good, some factories of: " .. _facPrefix .. " is still online!")

  local origTemplate = nil
  
  if spawnForInf == true then
    origTemplate = GROUP:FindByName(redInfantryVehicleTemplate)
  else
    origTemplate = groupSpawnMap[deadName]["template"]
  end

  if origTemplate == nil then
    UglyPrintDebug("No valid template available for" .. deadName)
    return
  end

  -- store in killed groups list
  killedGroupsCount = killedGroupsCount + 1
  local respawnData = {}
  respawnData["template"] = origTemplate 
  respawnData["coords"] = groupSpawnMap[deadName]["coords"]
  respawnData["facPref"] = _facPrefix
  killedGroups[killedGroupsCount] = respawnData

  UglyPrintDebug("FactoryDeathRecorder...killedGroupsCount(" .. killedGroupsCount .."), nextRespawn(" .. nextRespawn .. ")")

  UglyPrintDebug("Prepared respawning of Group: " .. origTemplate:GetName())
end


function respawnAtCurrentPosition(_group)
  UglyPrintDebug("Respawning this at it's current position: " .. _group:GetName())

  local currentPos = _group:GetCoordinate():GetVec2()
  local nextGroupSpawn = SPAWN:New(_group:GetName())

  -- Spawn at the zone center position at the height specified in the ME of the group template!
  local spawnedGroup = nextGroupSpawn:SpawnFromVec2( currentPos )   

  -- switch respawn data to new group
  groupSpawnMap[spawnedGroup:GetUnit(1):GetName()] = groupSpawnMap[_group:GetUnit(1):GetName()]
  groupSpawnMap[_group:GetUnit(1):GetName()] = nil

  -- remove old group (sorry, we'll stay friends!)
  _group:Destroy()

  return spawnedGroup
end


local function checkRespawnFromFactory()
  UglyPrintDebug("CheckRespawnFromFactory...killedGroupsCount(" .. killedGroupsCount .."), nextRespawn(" .. nextRespawn .. ")")

  if killedGroupsCount >= nextRespawn then
    local curRespawnData = killedGroups[nextRespawn]
    nextRespawn = nextRespawn + 1

    local willRespawn = math.random(1, 100)
    UglyPrintDebug("WillRespawn: " .. willRespawn)

    if willRespawn > respawnPropability then
      UglyPrintDebug("Sorry, unlucky group - will not be respawned.")
      TIMER:New(checkRespawnFromFactory):Start(respawnInterval)
      return
    end

    local _facPrefix = curRespawnData["facPref"]
    local rndFacZone = getRandomFactoryZone(_facPrefix)

    if rndFacZone == nil then
      UglyPrintDebug("Sorry, all factories from " .. _facPrefix .. " are offline!")
      TIMER:New(checkRespawnFromFactory):Start(respawnInterval)
      return
    end
  
    UglyPrintDebug("Good, some factories of: " .. _facPrefix .. " is still online!")
    UglyPrintDebug("Spawning at: " .. rndFacZone:GetName())

    local spawnVec2 = rndFacZone:GetRandomVec2()
    local curTemplate = curRespawnData["template"]
    local nextGroupSpawn = SPAWN:New(curTemplate:GetName())

    -- Spawn at the zone center position at the height specified in the ME of the group template!
    local spawnedGroup = nextGroupSpawn:SpawnFromVec2( spawnVec2 )   

    if string.find(curTemplate:GetName(), "DISM_") ~= nil then
      AddDismounts(spawnedGroup:GetUnit(1))
      UglyPrintDebug("Adding dismount to: " .. spawnedGroup:GetUnit(1):GetName())
    end

    local startValues = {}
    startValues["template"] = curTemplate
    startValues["coords"] = curRespawnData["coords"]
    startValues["facPref"] = _facPrefix

    groupSpawnMap[spawnedGroup:GetUnit(1):GetName()] = startValues

    --function CONTROLLABLE:RouteGroundOnRoad( ToCoordinate, Speed, DelaySeconds, OffRoadFormation, WaypointFunction, WaypointFunctionArguments )
  --        spawnedGroup:RouteGroundTo(COORDINATE:NewFromVec2(_groupCoordinate:GetRandomVec2InRadius(100, 30)), 70)

    spawnedGroup:RouteGroundOnRoad(COORDINATE:NewFromVec2(curRespawnData["coords"]:GetRandomVec2InRadius(50, 20)), 70)--, 1, "Vee", respawnAtLastWP)
  
    UglyPrintDebug("Respawned " .. spawnedGroup:GetName())
    UglyPrintDebug("From template " .. curTemplate:GetName())
  else
    UglyPrintDebug("Nothing yet to respawn")
  end

  UglyPrintDebug("Starting checkRespawnFromFactory timer - " .. respawnInterval .. "s")
  TIMER:New(checkRespawnFromFactory):Start(respawnInterval)
end

-- Start factory respawn
UglyPrintDebug("Starting checkRespawnFromFactory timer - 10s")
TIMER:New(checkRespawnFromFactory):Start(10)

UglyPrintDebug("RespawnFactory loaded - " .. RF_Version)




--[[
local testScenery = {"118718475", "199917568"}
local sceneTest1 = SCENERY:FindByName("118718475")
local sceneTest2 = SCENERY:FindByName("199917568")

local function sceneAliveTest()
  env.info("sceneAliveTest...")

  if sceneTest1:IsAlive() == false then
    env.info("sceneTest1 Dead!")
  else
    env.info("sceneTest1 Alive!")
  end

  if sceneTest2:IsAlive() == false then
    env.info("sceneTest2 Dead!")
  else
    env.info("sceneTest2 Alive!")
  end

  for i = 1, #testScenery do
    local sceneTest = SCENERY:FindByName(testScenery[i])

    if sceneTest:IsAlive() == false then
      env.info("Scenery Dead: " .. testScenery[i])
    else
      env.info("Scenery Alive: " .. testScenery[i])
    end

  end

  TIMER:New(sceneAliveTest):Start(2)
end

-- Start factory respawn
TIMER:New(sceneAliveTest):Start(10)
]]



--[[

local function checkFactoryAlive()
  local myHouse = SCENERY:FindByName("514687769")
  local myNeighboursHouse = SCENERY:FindByName("514687146")

  local status = "alive!"
  if myHouse:IsAlive() == false then
    status = "dead!"
  end
  MESSAGE:New( "My House is " .. status, 15, "House Check:", true ):ToAll()

  status = "alive!"
  if myNeighboursHouse:IsAlive() == false then
    status = "dead!"
  end
  MESSAGE:New( "My Neighbours House is " .. status, 15, "House Check:" ):ToAll()

  TIMER:New(checkFactoryAlive):Start(2)
end

-- Start factory respawn
TIMER:New(checkFactoryAlive):Start(10)





Vehicle:HandleEvent( EVENTS.Dead )
function Vehicle:OnEventDead( EventData )

  self:E( { "Size ", Size = Vehicle:GetSize() } )

  -- When the last vehicle of the group is declared dead, respawn the group.
  if Vehicle:GetSize() == 1 then
    -- Respawn the vehicle in RespawnZone1.
    mist.respawnInZone('Vehicle', 'ZONEVEHICLE1', True, 300)
  end
end


local GroupSpawnMap = {}


local SpawnVec2 = ZONE:New( "Factory_Respawn-1" ):GetRandomVec2()

  -- Spawn at the zone center position at the height specified in the ME of the group template!
  SpawnAirplanes:SpawnFromVec2( SpawnVec2 )  
  

  function SetHelicopter.OnAfterDead( SetHelicopter, From, Event, To, GroupObject )
    SetHelicopter:F( { GroupObject = GroupObject:GetName() } )
    self.PickupCargo[GroupObject] = nil  -- So here I clear the PickupCargo table entry of the self object AI_CARGO_DISPATCHER.
    self.CarrierHome[GroupObject] = nil
  end



  local numTimTest = 0
  local function timerTest()
    UglyPrintDebug("Starting timerTest - " .. numTimTest)
    numTimTest = numTimTest + 1

    if numTimTest > 10 then
      return
    end

    UglyPrintDebug("Restart timerTest - " .. numTimTest)
    TIMER:New(timerTest):Start(2)
  end

  UglyPrintDebug("Init timerTest - " .. numTimTest)
  TIMER:New(timerTest):Start(2)
  
]]--