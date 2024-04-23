-- #region OPTIONS
UseEnemyAir = true
UglyPrintOnScreen = false
DismountDistance = 10

-- #endregion

sectorConfig = {
  ["CombatSector-01"] = 
    {
      name = "Bridgehead", 
      airwing = nil,
      zonePrefix = "OpsZone-01-", -- the zone have to start with "1" and have succesive uninterrupted numbering
      opszones = {},
      factoryPrefix = "RF_CZ01",
      sectorHQ = "CombatSector_01_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-02"}
    }, -- easy
  ["CombatSector-02"] = 
    {
      name = "Corridor", 
      airwing =  AWLarnaca, 
      zonePrefix = "OpsZone-02-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_02_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-03"}
    }, -- easy
  ["CombatSector-03"] = 
    {
      name = "Gecitkale", 
      airwing =  AWLarnaca, 
      zonePrefix = "OpsZone-03-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_03_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-04", "CombatSector-05", "CombatSector-06"}
    }, -- easy
  ["CombatSector-04"] = 
    {
      name = "Famagusta", 
      airwing =  AWLarnaca, 
      zonePrefix = "OpsZone-04-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_04_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-07"}
    }, -- easy
  ["CombatSector-05"] = 
    {
      name = "Kingsfield", 
      airwing =  AWLarnaca, 
      zonePrefix = "OpsZone-05-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_05_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-08"}
    }, -- easy
  ["CombatSector-06"] = 
    {
      name = "Kyrenia", 
      airwing =  AWLarnaca, 
      zonePrefix = "OpsZone-06-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_06_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-07", "CombatSector-08"}
    }, -- easy
  ["CombatSector-07"] = 
    {
      name = "Nicosia", 
      airwing =  AWLarnaca, 
      zonePrefix = "OpsZone-07-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_07_HQ",
      state = "Sleeping",
      dependsZone = {"CombatSector-04", "CombatSector-06"},
      blocksZone = {"CombatSector-09"}
    }, -- easy
  ["CombatSector-08"] = 
    {
      name = "Larnaca", 
      airwing =  nil, 
      zonePrefix = "OpsZone-08-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_08_HQ",
      state = "Sleeping",
      dependsZone = {"CombatSector-05", "CombatSector-06"},
      blocksZone = {"CombatSector-09", "CombatSector-12", "MountOlympus"}
    }, -- easy
  ["CombatSector-09"] = 
    {
      name = "Morfou", 
      airwing =  nil, 
      zonePrefix = "OpsZone-09-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_09_HQ",
      state = "Sleeping",
      dependsZone = {"CombatSector-07", "CombatSector-08"},
      blocksZone = {"CombatSector-08", "CombatSector-10", "MountOlympus"}
    }, -- easy
  ["CombatSector-10"] = 
    {
      name = "Larnaca - West", 
      airwing =  nil, 
      zonePrefix = "OpsZone-10-",
      opszones = {}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_10_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-09", "CombatSector-11", "MountOlympus"}
    }, -- easy
  ["CombatSector-11"] =
    {
      name = "Limassol",
      airwing =  nil,
      zonePrefix = "OpsZone-11-",
      opszones = {},
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_11_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-10", "CombatSector-12", "MountOlympus"}
    }, -- easy
  ["CombatSector-12"] =
    {
      name = "Paphos", 
      airwing =  nil,
      zonePrefix = "OpsZone-12-",
      opszones = {},
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_12_HQ",
      state = "Sleeping",
      dependsZone = {},
      blocksZone = {"CombatSector-08", "CombatSector-11", "MountOlympus"}
    }, -- easy
  ["CombatSector-MountOlympus"] =
    {
      name = "Mount Olympus", 
      airwing =  nil,
      zonePrefix = "MountOlympus-",
      opszones = {},
      factoryPrefix = "RF_CZ02",
      sectorHQ = "CombatSector_MountOlympus_HQ",
      state = "Sleeping",
      dependsZone = {"CombatSector-08", "CombatSector-09", "CombatSector-10", "CombatSector-11", "CombatSector-12"},
      blocksZone = {}
    }, -- easy
}


-- init start sector
setStartSector("CombatSector-01")

SupportHandler = EVENTHANDLER:New()

function markRemoved(Event)
  if Event.text~=nil and Event.text:lower():find("ddd") then 
    env.info("markRemoved with...:" .. Event.text)

    for _name,_zone in pairs(sectorConfig) do
      env.info("Destroying HQ in sector: " .. _name)

      local vec3 = {z=Event.pos.z, x=Event.pos.x}
      local coord = COORDINATE:NewFromVec3(vec3)
          
      local theSecZone = ZONE:New(_name)

      if coord and theSecZone and theSecZone:IsCoordinateInZone(coord) then
        theSecZone:IsCoordinateInZone(coord)
        local zoneHqStatic = STATIC:FindByName(sectorConfig[_name]["sectorHQ"],false)
        if zoneHqStatic then
          env.info("Destroying HQ: " .. sectorConfig[_name]["sectorHQ"])
          zoneHqStatic:Destroy()
        else
          env.info("Cannot find HQ: " .. sectorConfig[_name]["sectorHQ"])
        end
      end
    end
  end
end

function SupportHandler:onEvent(Event)
    if Event.id == world.event.S_EVENT_MARK_REMOVED then
        -- env.info(string.format("BTI: Support got event REMOVED id %s idx %s coalition %s group %s text %s", Event.id, Event.idx, Event.coalition, Event.groupID, Event.text))
        markRemoved(Event)
    end
end

world.addEventHandler(SupportHandler)



















-- Initialize combat zones from config
--[[
for secItName, secItConfig in pairs( sectorConfig ) do
  initSector(secItName)
end
]]

--[[ 
-- Make all red units ALARMSTATE RED
local SetGroups = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterOnce()

SetGroups:ForEachGroup(function(groupMakeAngry)
    env.info("Setting Group to RED: " .. groupMakeAngry:GetName())
    groupMakeAngry:OptionAlarmStateRed()
  end
)
 ]]

 
-- We use the callback for DSCM preSave to intercept the DSMC save routine in the DISMOUNT Script to remove the mounted dismounts before saving.

--[[ 

local function removeAllDSMCStatics()
  local SetStatics = SET_STATIC:New():FilterCoalitions("red"):FilterPrefixes("DSMC_CreatedStatic"):FilterOnce()

  SetStatics:ForEachStatic(function(theStatic)
      env.info("Removing Static: " .. theStatic:GetName())
      trigger.action.outTextForCoalition(coalition.side.RED, "Removing Static: " .. theStatic:GetName(), 1)
      theStatic:Destroy()
    end
  )
end

local function doNotRemoveAllDSMCStatics()
  env.info("Keeping all DSMC Statics!")
  trigger.action.outTextForCoalition(coalition.side.RED, "Keeping all DSMC Statics!", 30)
end

-- This would create a menu for the red coalition under the main DCS "Others" menu.
local MenuCoalitionRed = MENU_COALITION:New( coalition.side.RED, "Mission Control Menus" )
local MenuCoalitionRedRemoveAllStatics = MENU_COALITION:New( coalition.side.RED, "Remove All DSMC Statics", MenuCoalitionRed )
local MenuAddNo = MENU_COALITION_COMMAND:New( coalition.side.RED, "Don't remove all DSMC statics!", MenuCoalitionRedRemoveAllStatics, doNotRemoveAllDSMCStatics )
local MenuAddYes = MENU_COALITION_COMMAND:New( coalition.side.RED, "Really remove all DSMC statics!", MenuCoalitionRedRemoveAllStatics, removeAllDSMCStatics )
 ]]
