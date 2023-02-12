

-- #region OPTIONS
local useEnemyAir = true
-- #endregion

local function OnAfterCapturedCZ1()
--  trigger.action.outText("On After Captured CombatZone-1", 30)
end

local function OnEnterAttackedDoCZ1()
--  trigger.action.outText("On Enter Attack CombatZone-1", 30)
end

local function OnAfterAttackedDoCZ1()
  --trigger.action.outText("On After Attack CombatZone-1", 30)
end

local function OnEnterGuardedDoCZ1()
--  trigger.action.outText("On Enter Guarded CombatZone-1", 30)
end


local sectorConfig = {
  ["RF_CZ01_Observe_Zone"] = 
    {
      name = "Sector South", 
      airwing = AWFARP_RF_CZ02_02, 
      opszones = {"CombatZone-1", "CombatZone-2", "CombatZone-3"}, 
      factoryPrefix = "RF_CZ01",
      sectorHQ = "Ru_Sector1_HQ"
    }, -- easy
  ["RF_CZ02_Observe_Zone"] = 
    {
      name = "Sector North", 
      airwing =  AWNalchik, 
      opszones = {"CombatZone-4", "CombatZone-5", "CombatZone-6", "CombatZone-7", "CombatZone-8"}, 
      factoryPrefix = "RF_CZ02",
      sectorHQ = "Ru_Sector2_HQ"
    }, -- easy
    ["Test Sector - Offline"] = 
    {
      name = "Test Sector", 
      airwing =  nil, 
      opszones = {}, 
      factoryPrefix = "TestZone",
      sectorHQ = "TestHQ_NotPresent"
    }, -- easy
}

local zoneConfigs = {
  ["CombatZone-1"] = { OnAfterCapturedDo =  OnAfterCapturedCZ1,
                       OnEnterAttackedDo = OnEnterAttackedDoCZ1, 
                       OnAfterAttackedDo = OnAfterAttackedDoCZ1, 
                       OnEnterGuardedDo = OnEnterGuardedDoCZ1 }, -- easy
  ["CombatZone-2"] = {}, -- easy
  ["CombatZone-3"] = {}, -- medium
  ["CombatZone-4"] = {}, -- medium
  ["CombatZone-5"] = {}, -- medium
  ["CombatZone-6"] = {}, -- medium
  ["CombatZone-7"] = {}, -- medium
  ["CombatZone-8"] = {}, -- medium
}

local function initZone(_name)
  local theZone = ZONE:New(_name)
  local theOpsZone = OPSZONE:New(theZone, coalition.side.NEUTRAL)
  theOpsZone:SetDrawZone(true)
  theOpsZone:__Start(2)

  zoneConfigs[_name]["OpsZone"] = theOpsZone
  zoneConfigs[_name]["OpsZone"]:SetObjectCategories({Object.Category.UNIT}) -- Ensure, that no leftover statics will count as part of eg. red coalition 


  -- wenn diese Methoden drin sind, werden die Zonen nicht richtig gezeichnet.
  function theOpsZone:OnAfterCaptured(From, Event, To, Coalition)
    if Coalition == coalition.side.BLUE then
      local m = MESSAGE:New("We captured " .. theOpsZone:GetName() .. "! Well done! ", 15, "Blue Chief"):ToAll()
    else
      local m = MESSAGE:New("We lost " .. theOpsZone:GetName() .. "! Capture it back! ", 15, "Blue Chief"):ToAll()
    end

    if zoneConfigs[_name]["OnAfterCapturedDo"] then
      zoneConfigs[_name]["OnAfterCapturedDo"]()
    end

  end

  function theOpsZone:OnEnterAttacked(From, Event, To)
--    local m = MESSAGE:New(theOpsZone:GetName() .. " OnEnterAttacked! ", 15, "Blue Chief"):ToAll()

    if Coalition == coalition.side.BLUE then
      local m = MESSAGE:New("Zone " .. theOpsZone:GetName() .. " is under attack! Fight back to regain control! ", 15, "Blue Chief"):ToAll()
    end

    if zoneConfigs[_name]["OnEnterAttackedDo"] then
      zoneConfigs[_name]["OnEnterAttackedDo"]()
    end

  end

  function theOpsZone:OnAfterAttacked(From, Event, To, AttackerCoalition)
--    local m = MESSAGE:New(theOpsZone:GetName() .. " OnAfterAttacked! ", 15, "Blue Chief"):ToAll()

    if zoneConfigs[_name]["OnAfterAttackedDo"] then
      zoneConfigs[_name]["OnAfterAttackedDo"]()
    end

  end

  function theOpsZone:OnEnterGuarded(From, Event, To)
--    local m = MESSAGE:New(theOpsZone:GetName() .. " Guarded ", 15, "Blue Chief"):ToAll()

    if zoneConfigs[_name]["OnEnterGuardedDo"] then
      zoneConfigs[_name]["OnEnterGuardedDo"]()
    end

  end
end


-- Check if the sectors HQ is destroyed and that all OpsZones are currently blue
local function checkSector(_sector)
  env.info("Checking sector state for (" .. _sector .. ")")

  -- First check, if HQ is still there - if so, wait for another 10s
  local theHQ = sectorConfig[_sector]["sectorHQObj"]
  if theHQ:IsAlive() == true then
    env.info("Sector HQ is still alive...")
    TIMER:New(checkSector, _sector):Start(10)
    return
  end

  -- HQ is dead, so check that no OpsZone is not blue
  for i = 1, #sectorConfig[_sector]["opszones"] do
    local theZoneName = sectorConfig[_sector]["opszones"][i]
    env.info("Checking if OpsZone is blue: " .. theZoneName)

    if zoneConfigs[theZoneName]["OpsZone"]:IsBlue() ~= true then
      TIMER:New(checkSector, _sector):Start(10)
      return
    end
  end

  for i = 1, #sectorConfig[_sector]["opszones"] do
    local theZoneName = sectorConfig[_sector]["opszones"][i]
    env.info("Stopping OpsZone: " .. theZoneName)
    zoneConfigs[theZoneName]["OpsZone"]:__Stop(2)
  end

  local theSecZone = ZONE:New(_sector)
  theSecZone:DrawZone(-1, {0,0,1}, 1, {0,0,1}, 0.2, 1, true)
--  theSecZone:UndrawZone()

  trigger.action.outText("Hooyah!!! Sector " .. sectorConfig[_sector]["name"] .. " was liberated.", 30)
end

-- Initialize the sector from the name and by it's configuration
local function initSector(_name)
  env.info("InitSector - " .. _name)

  local theHQ = STATIC:FindByName(sectorConfig[_name]["sectorHQ"], false)

  if theHQ == nil then
    env.info("Sector " .. _name .. " seems to be finished already. Ignoring!")
    return
  end

  sectorConfig[_name]["sectorHQObj"] = theHQ

  registerFactory(sectorConfig[_name]["factoryPrefix"])

  local theSecZone = ZONE:New(_name)
--  theSecZone:DrawZone(-1, {0,0,0}, 1, {0,0,0}, 0.2, 1, true)
  theSecZone:DrawZone(-1, {1,0,0}, 1, {1,0,0}, 0.2, 1, true)

  DoPatrolsInZone(theSecZone)

  for i = 1, #sectorConfig[_name]["opszones"] do
    initZone(sectorConfig[_name]["opszones"][i])
  end

  -- Init regular check if the sector is still contested
  TIMER:New(checkSector, _name):Start(10)
end


local function doActionForSector(_inZone, _contact)
--  MESSAGE:New("DoActionForSector " .. _inZone:GetName(), 20, "Debug"):ToAll()
  env.info("DoActionForSector " .. _inZone:GetName())

--  MESSAGE:New("DoActionForSector Type " .. _inZone.ClassName, 20, "Debug"):ToAll()
  env.info("DoActionForSector Type " .. _inZone.ClassName)

  local targetGroup = GROUP:FindByName(_contact.groupname)

  if (_contact.attribute == "Ground_APC") or (_contact.attribute == "Ground_Artillery") or
    (_contact.attribute == "Ground_Truck") or (_contact.attribute == "Ground_Tank") or
    (_contact.attribute == "Ground_IFV") then
    -- Spawn Groundattack
--    MESSAGE:New("GroundTarget is found in " .. _inZone:GetName() .. "\n Starting Tankattack", 20, "Debug"):ToAll()
    env.info("GroundTarget is found in " .. _inZone:GetName() .. "\n Starting Tankattack")

    local SetGroupsGround = SET_GROUP:New():FilterCoalitions("red"):FilterZones({_inZone}):FilterPrefixes("QRF")
      :FilterCategoryGround():FilterActive():FilterOnce() -- Todo: Nur lebende enthalten? Laut Applevangelist ja; Active notwendig?

--    MESSAGE:New("We have " .. SetGroupsGround:Count() .. " groups available as QRF."):ToAll()
    env.info("We have " .. SetGroupsGround:Count() .. " groups available as QRF.")

    local groupForTasking = SetGroupsGround:GetRandom()

    local useGroundTroops = false
    if math.random(1,100) > 75 then
      useGroundTroops = true
    end

    if groupForTasking ~= nil and useGroundTroops == true then
      env.info("GroundTarget is found in " .. _inZone:GetName() .. "\nStarting Tankattack")
      --    MESSAGE:New("Attacking group is: " .. groupForTasking:GetName(), 20, "Debug"):ToAll()
      env.info("Attacking group is: " .. groupForTasking:GetName())
      groupForTasking = respawnAtCurrentPosition(groupForTasking)
      --    MESSAGE:New("Attacking group changed to: " .. groupForTasking:GetName(), 20, "Debug"):ToAll()
      env.info("Attacking group changed to: " .. groupForTasking:GetName())

      local mission = AUFTRAG:NewARMORATTACK(GROUP:FindByName(_contact.groupname), UTILS.KmphToKnots(30), "Vee")
      local armygroup = ARMYGROUP:New(groupForTasking:GetName())
      armygroup:SetDefaultFormation(ENUMS.Formation.Vehicle.OffRoad)
--      armygroup:AddWeaponRange(0, UTILS.KiloMetersToNM(2))
      armygroup:AddMission(mission)
    elseif (true) then -- Hier abfragen ob CAS aktiviert werden soll fuer rot.
      local mission = AUFTRAG:NewBAI(targetGroup, nil)
      mission:SetRepeatOnFailure(6)
      sectorConfig[_inZone:GetName()]["airwing"]:AddMission(mission)
--      MESSAGE:New("Added mission to airwing"):ToAll()
      env.info("GroundTarget is found in " .. _inZone:GetName() .. "\nStarting CAS-ATTACK")
    end

  elseif (_contact.attribute == "Ground_EWR") or (_contact.attribute == "Ground_SAM") or
    (_contact.attribute == "Ground_AAA") then -- Spawn SEAD
    if useEnemyAir and zoneConfigs[_inZone:GetName()]["airwing"] ~= nil then
      -- Regel: Man kann nun schauen, dass man SEAD aus bestimmten Arealen holt, sollten entsprechende Bedingungen da sein.
      local mission = AUFTRAG:NewSEAD(GROUP:FindByName(_contact.groupname), 5000)
      mission:SetRepeatOnFailure(6)
      -- local zone = ZONE_GROUP:New("SEAD Zone", targetGroup, 500)
      -- local mission = AUFTRAG:NewCAS(zone)
      sectorConfig[_inZone:GetName()]["airwing"]:AddMission(mission)
--      MESSAGE:New("Added mission to airwing"):ToAll()

    end
  elseif (_contact.attribute == "Air_Fighter") or (_contact.attribute == "Air_AttackHelo") or
    (_contact.attribute == "Air_TransportHelo") then
    -- Figher anfordern beim nächsten Airfield

  end
end



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
local SetCombatZones = SET_ZONE:New():FilterPrefixes("RF_CZ"):FilterOnce()
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



-- Initialize combat zones from config
for secItName, secItConfig in pairs( sectorConfig ) do
  initSector(secItName)
end


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
