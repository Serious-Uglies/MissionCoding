

-- #region OPTIONS
useEnemyAir = true
UglyPrintOnScreen = false
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
      airwing =  nil, 
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
      airwing =  nil, 
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
      airwing =  nil, 
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
      airwing =  nil, 
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
      airwing =  nil, 
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
      airwing =  nil, 
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
  ["MountOlympus"] =
    {
      name = "Mount Olympus", 
      airwing =  nil,
      zonePrefix = "MountOlympus-",
      opszones = {},
      factoryPrefix = "RF_CZ02",
      sectorHQ = "MountOlympus_HQ",
      state = "Sleeping",
      dependsZone = {"CombatSector-08", "CombatSector-09", "CombatSector-10", "CombatSector-11", "CombatSector-12"},
      blocksZone = {}
    }, -- easy
}

-- Define the INTEL
-- Set up a detection group set. "FilterStart" to include respawns.
local Red_DetectionSetGroup = SET_GROUP:New():FilterCoalitions("red"):FilterActive():FilterStart()
-- Red_DetectionSetGroup:FilterPrefixes( { "RU_Recce","RU_EWR" } )
-- Red_DetectionSetGroup:FilterStart()

-- New INTEL Type
local RedIntel = INTEL:New(Red_DetectionSetGroup, "red", "KGB")
RedIntel:SetClusterAnalysis(true, true)
RedIntel:SetVerbosity(2)
RedIntel:__Start(2)
-- Restrict to Combat_Zones to avoid cluttering of contacts.
local SetCombatZones = SET_ZONE:New():FilterPrefixes("CombatSector"):FilterOnce()
RedIntel:SetAcceptZones(SetCombatZones)

-- Events to create AUFTRAG
-- Sobald eine Recce-Gruppe ein Ziel gesichtet hat, wird eine Mission erstellt.
-- possible contact.attribute:
-- Air_AttackHelo
-- Air_Fighter
-- Ground_Infantry
-- Ground_AAA
-- Ground_SAM
-- Air_TransportHelo
-- Ground_OtherGround
function RedIntel:OnAfterNewContact(From, Event, To, contact)
  local trgtGrp = contact.group
--  trigger.action.outText("KGB: I found a " .. contact.attribute .. " called " .. contact.groupname, 30)

  -- Find zone where contact happened and react
  local cpos = contact.position or contact.group:GetCoordinate() 
  local inZone = SetCombatZones:IsCoordinateInZone(cpos)

  if inZone ~= nil then
    doActionForSector(inZone, contact)  
  end
end

-- Initialize AWACS
local Red_DetectionSetGroupAWACS = SET_GROUP:New():FilterCoalitions("red"):FilterActive():FilterPrefixes( { "RU_Recce","RU_EWR" } ):FilterStart()
local RedIntelAwacs = INTEL:New(Red_DetectionSetGroupAWACS, "red", "KGB AWACS")
RedIntelAwacs:SetClusterAnalysis(true, true)
RedIntelAwacs:SetVerbosity(2)
RedIntelAwacs:__Start(2)
local SetCombatZonesAWACS = SET_ZONE:New():FilterPrefixes("FEZ"):FilterOnce()
RedIntelAwacs:SetAcceptZones(SetCombatZonesAWACS)

function RedIntelAwacs:OnAfterNewContact(From, Event, To, contact)
  local trgtGrp = contact.group
--  trigger.action.outText("KGB AWACS: I found a " .. contact.attribute .. " called " .. contact.groupname, 30)
  local targetGroup = GROUP:FindByName(contact.groupname)
  local mIntercept = AUFTRAG:NewINTERCEPT(targetGroup)
  AWMozdok:AddMission(mIntercept)
end


-- init start sector
setStartSector("CombatSector-01")

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
