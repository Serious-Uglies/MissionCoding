--[[
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

{
  ["CombatZone-1"] = { OnAfterCapturedDo =  OnAfterCapturedCZ1,
                       OnEnterAttackedDo = OnEnterAttackedDoCZ1, 
                       OnAfterAttackedDo = OnAfterAttackedDoCZ1, 
                       OnEnterGuardedDo = OnEnterGuardedDoCZ1 }, -- easy
  ["CombatZone-2"] = {}, -- easy
}
]]


--[[
sectorConfig = {
    ["CombatSector-01"] = 
      {
        name = "Bridgehead", 
        airwing = nil,
        zonePrefix = "OpsZone-01-",
        opszones = {},
        factoryPrefix = "RF_CZ01",
        sectorHQ = "CombatSector_01_HQ"
      }, -- easy
    }
]]

UseEnemyAir = true

sectorConfig = {}

function initZone(_sector, _name)
  env.info("Searching for zone: " .. _name .. ", in sector: " .. _sector)
  local theZone = ZONE:New(_name)

  if theZone == nil then
    env.info("Zone: " .. _name .. " is not available!")
    return nil
  end

  local theOpsZone = OPSZONE:New(theZone, coalition.side.NEUTRAL)
  theOpsZone:SetDrawZone(true)
  theOpsZone:__Start(2)

  --sectorConfig[_sector]["opszones"] 
  sectorConfig[_sector]["opszones"][_name] = {}
  sectorConfig[_sector]["opszones"][_name]["Name"] = _name
  sectorConfig[_sector]["opszones"][_name]["OpsZone"] = theOpsZone
  sectorConfig[_sector]["opszones"][_name]["OpsZone"]:SetObjectCategories({Object.Category.UNIT}) -- Ensure, that no leftover statics will count as part of eg. red coalition 


  -- wenn diese Methoden drin sind, werden die Zonen nicht richtig gezeichnet.
  function theOpsZone:OnAfterCaptured(From, Event, To, Coalition)
    if Coalition == coalition.side.BLUE then
      local m = MESSAGE:New("We captured " .. theOpsZone:GetName() .. "! Well done! ", 15, "Blue Chief"):ToAll()
    else
      local m = MESSAGE:New("We lost " .. theOpsZone:GetName() .. "! Capture it back! ", 15, "Blue Chief"):ToAll()
    end

    if sectorConfig[_sector]["opszones"][_name]["OnAfterCapturedDo"] then
      sectorConfig[_sector]["opszones"][_name]["OnAfterCapturedDo"]()
    end

  end

  function theOpsZone:OnEnterAttacked(From, Event, To)
--    local m = MESSAGE:New(theOpsZone:GetName() .. " OnEnterAttacked! ", 15, "Blue Chief"):ToAll()

    if Coalition == coalition.side.BLUE then
      local m = MESSAGE:New("Zone " .. theOpsZone:GetName() .. " is under attack! Fight back to regain control! ", 15, "Blue Chief"):ToAll()
    end

    if sectorConfig[_sector]["opszones"][_name]["OnEnterAttackedDo"] then
      sectorConfig[_sector]["opszones"][_name]["OnEnterAttackedDo"]()
    end

  end

  function theOpsZone:OnAfterAttacked(From, Event, To, AttackerCoalition)
--    local m = MESSAGE:New(theOpsZone:GetName() .. " OnAfterAttacked! ", 15, "Blue Chief"):ToAll()

    if sectorConfig[_sector]["opszones"][_name]["OnAfterAttackedDo"] then
      sectorConfig[_sector]["opszones"][_name]["OnAfterAttackedDo"]()
    end

  end

  function theOpsZone:OnEnterGuarded(From, Event, To)
--    local m = MESSAGE:New(theOpsZone:GetName() .. " Guarded ", 15, "Blue Chief"):ToAll()

    if sectorConfig[_sector]["opszones"][_name]["OnEnterGuardedDo"] then
      sectorConfig[_sector]["opszones"][_name]["OnEnterGuardedDo"]()
    end

  end

  return theZone
end


function setStartSector(_sector)

    initSector(_sector)
    -- paint all sleeping sectors gray
    for secItName, secItConfig in pairs( sectorConfig ) do
        if sectorConfig[secItName]["state"] == "Sleeping" then
            local theSecZone = ZONE:New(secItName)
            theSecZone:DrawZone(-1, {0.5,0.5,0.5}, 1, {0.5,0.5,0.5}, 0.2, 2, true)
        end
    end
     
end

-- Checks dependend sectors from current one to activate them
function activateNextSector(_sector)
  for i = 1, #sectorConfig[_sector]["blocksZone"] do
    testSector = sectorConfig[_sector]["blocksZone"][i]
    env.info("Trying to activate sector: " .. testSector)
    local allCaptured = true
    for i = 1, #sectorConfig[testSector]["dependsZone"] do
        dependZone = sectorConfig[testSector]["dependsZone"][i]
        env.info(testSector .. " depends on: " .. dependZone)
        if sectorConfig[dependZone]["state"] ~= "Captured" then
            env.info("  --> But it's not captured!")
            allCaptured = false
        end
    end

    if allCaptured then
        env.info("All good - Activating: " .. testSector)
        initSector(sectorConfig[_sector]["blocksZone"][i])
    else
        env.info("Still dependend on sth: " .. testSector)
        local theSecZone = ZONE:New(sectorConfig[_sector]["blocksZone"][i])
        theSecZone:DrawZone(-1, {1,1,0}, 1, {1,1,0}, 0.2, 2, true)
    end
  end

end


-- Check if the sectors HQ is destroyed and that all OpsZones are currently blue
function checkSector(_sector)
  env.info("Checking sector state for (" .. _sector .. ")")

  -- First check, if HQ is still there - if so, wait for another 10s
  local theHQ = sectorConfig[_sector]["sectorHQObj"]
  if theHQ ~= nil and theHQ:IsAlive() == true then
    env.info("Sector HQ is still alive...")
    TIMER:New(checkSector, _sector):Start(10)
    return
  end

  env.info("No HQ in sector: " .. _sector .. ". Checking all zones.")

  -- HQ is dead, so check that no OpsZone is not blue
  for _name,_ in pairs (sectorConfig[_sector]["opszones"]) do
    local theOpsZone = sectorConfig[_sector]["opszones"][_name]["OpsZone"]
    env.info("Checking if OpsZone is blue: " .. theOpsZone:GetName())

    if theOpsZone:IsBlue() ~= true then
      TIMER:New(checkSector, _sector):Start(10)
      return
    end
  end

--Finalize zone - everything done
  sectorConfig[_sector]["state"] = "Captured"

  -- all zones are blue
  for _name,_ in pairs (sectorConfig[_sector]["opszones"]) do
    local theOpsZone = sectorConfig[_sector]["opszones"][_name]["OpsZone"]
    env.info("Stopping OpsZone: " .. theOpsZone:GetName())
    theOpsZone:__Stop(2)
  end

  local theSecZone = ZONE:New(_sector)
  theSecZone:DrawZone(-1, {0,0,1}, 1, {0,0,1}, 0.2, 1, true)
--  theSecZone:UndrawZone()

  activateNextSector(_sector)

  trigger.action.outText("Hooyah!!! Sector " .. sectorConfig[_sector]["name"] .. " was liberated.", 30)
end

-- Initialize the sector from the name and by it's configuration
function initSector(_name)
  env.info("InitSector - " .. _name)

  local theHQ = STATIC:FindByName(sectorConfig[_name]["sectorHQ"], false)

  if theHQ == nil then
    env.info("Sector " .. _name .. " seems to be finished already. Ignoring!")
    checkSector(_name)
    return
  end

  sectorConfig[_name]["sectorHQObj"] = theHQ

  registerFactory(sectorConfig[_name]["factoryPrefix"])

  local theSecZone = ZONE:New(_name)
  theSecZone:DrawZone(-1, {1,0,0}, 1, {1,0,0}, 0.2, 1, true)

  DoPatrolsInZone(theSecZone)

  -- find zones from prefix
  lastZone = nil

  env.info("Setting up zones")
  zone_count = 1
  repeat
    if sectorConfig[_name]["zonePrefix"] ~= nil then
      searchZoneName = sectorConfig[_name]["zonePrefix"] .. tonumber(zone_count)
      env.info("Looking for " .. searchZoneName)
      lastZone = initZone(_name, searchZoneName)
      zone_count = zone_count + 1
    end
  until (lastZone == nil)

  env.info("Number of zones found: " .. tonumber(zone_count))

  sectorConfig[_name]["state"] = "Active"

  -- Init regular check if the sector is still contested
  TIMER:New(checkSector, _name):Start(10)
end

-- inZone = ZONE, _contact = INTEL contact object
function doActionForSector(_inZone, _contact)
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
      if sectorConfig[_inZone:GetName()]["airwing"] ~= nil then
        sectorConfig[_inZone:GetName()]["airwing"]:AddMission(mission)
--      MESSAGE:New("Added mission to airwing"):ToAll()
        env.info("GroundTarget is found in " .. _inZone:GetName() .. "\nStarting CAS-ATTACK")
      end
    end

  elseif (_contact.attribute == "Ground_EWR") or (_contact.attribute == "Ground_SAM") or
    (_contact.attribute == "Ground_AAA") then -- Spawn SEAD
    if UseEnemyAir and sectorConfig[_inZone:GetName()]["airwing"] ~= nil then
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

