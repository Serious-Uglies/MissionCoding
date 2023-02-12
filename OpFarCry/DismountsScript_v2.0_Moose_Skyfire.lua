---------------------------------------
----  Dismounts Script  ----
---------------------------------------
--
--  v1.0 - 5. July 2013
--  By Marc "MBot" Marbot
--  v1.5 - 6. May 2017
--  Igneous01
--  Added counts/check for remaining alive units
--  Added support for flag (When flag is 2, unit is mounted, when flag is 1, unit is dismounted, when flag is 0, units are dead)
--
--  v2.0 09.2022 
--  Skyfire
--  Adapted to moose to fit there
--  Removed flag support
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Control functions:
--
--  AddDismounts(UnitName, dm_type)
--    UnitName: string, name of group
--    dm_type: string, must be of a type defined in the table dismTypes below.
--                     each type must have a corresponding late spawn object named:
--                     dismPrefix+templatePrefix+coalition+dismTypes e.g. "TEMPLATE_RED_DISM_RFLRPG" (all uppercase!)
--                     The type of template is automatically deduced from the unit name.
--                     A blue "DISM_"+dismType -> "DISM_RFLRPG" will create an automatic dismount which requires "TEMPLATE_BLUE_DISM_RFLRPG" in the mission
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Settings
local dismPrefix = "DISM_"
local templatePrefix = "TEMPLATE_" -- TEMPLATE_RED_, TEMPLATE_BLUE_
local dismTypes = {"RIFLE", "RFLRPG", "AAA", "IGLA", "MORTAR"} 
local checkIntervall = 11  -- check the dismount state every X seconds f

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Internal data - don't change!
-- Is automatically filled with all spawn types used. Contains the SPAWN object for each type.
local spawnTypes = {}
-- Table that holds all ground units that carry mounted units
local DismountsCarrier = {}
local stopDismounts = false -- used to disable dismounts for various reasons

-- Function to add mounted units to a carrier
-- _unit (UNIT) - name of the individual vehicle unit in ME (NOT GROUP NAME)
-- dm_type (String) - type of mounted units to hold ("Rifle", "Mortar", "Manpad")
function AddDismounts(_unit, dm_type) -- Options for dm_type: "Rifle", "Mortar", "Manpad"
  for n = 1, #DismountsCarrier do
    if DismountsCarrier[n].unit == _unit then
      env.info("AddDismounts: " .. _unit:GetName() .. " is already registered.")
      return
    end
  end

  -- if no dm type registered, try to check by name
  if dm_type == nil then
    env.info("No dm_type defined")
    for dsmCount = 1, #dismTypes do
      env.info("AddDismounts - Checking type: " .. dismTypes[dsmCount])
      if string.find(_unit:GetName(), dismTypes[dsmCount]) then
        dm_type = dismTypes[dsmCount]
      end
    end
  end

  -- if dm type still not found - stop here
  if dm_type == nil then
    env.info("No dm_type type found for: " .. _unit:GetName())
    return
  end

  -- Register new spawn per type if not yet done
  local spawnName = templatePrefix .. string.upper(_unit:GetCoalitionName()) .. "_" .. dismPrefix .. dm_type
  if spawnTypes[spawnName] == nil then
    spawnTypes[spawnName] = SPAWN:New(spawnName)
  end

  DismountsCarrier[#DismountsCarrier + 1] = {
    unit = _unit, -- the unit to observe
    cargo_type = dm_type, -- the dismount type to be spawned
    cargo_group = nil, -- the spawned group
    cargo_status = "mounted", -- the state of the dismount
    cargo_coalition = string.upper(_unit:GetCoalitionName()) .. "_", -- the units coalition
    cargo_spawn = spawnTypes[spawnName], -- the spawn object
    cargo_numUnits = 0, -- the number of units originally in the group
    cargo_units = {}, -- the names of the original units
    deadUnitsIndexes = {} -- the index of dead units of the dismount
  }

end

-- Function to return the composition of the spawned group
local function GetDmGroup(_unit)
  -- local dmVec2 = {                  --Determine the x,y Vec2 position of the dismounts (10m behind of the carrier)
  --   x = carrierPos.p.x + carrierPos.x.x * -10,
  --   y = carrierPos.p.z + carrierPos.x.z * -10,
  -- }
end

local function mountDismounted(_dismCarrier)
  local lastGroup = _dismCarrier.cargo_group
  local unitCount = _dismCarrier.cargo_numUnits
  --            env.info("There have been: " .. unitCount .. " units originally in: " .. theUnit:GetName())

  _dismCarrier.deadUnitsIndexes = {}
  local deadUnitCount = 1
  local deadUnits = {}

  if lastGroup ~= nil then
    local groupSize = lastGroup:GetSize() or 0
    --              env.info("Mounting Group: " .. lastGroup:GetName() .. ", with " .. groupSize .. " units.")

    if groupSize > 0 then
      -- list of current alive units
      for i, currentUnit in pairs(lastGroup:GetUnits()) do
        deadUnits[currentUnit:GetName()] = i
        --                  env.info("Unit " .. currentUnit:GetName() .. "  with index: " .. i .. ", is alive before mounting!")
      end
    end
  else
    env.info("Mounting Group is NIL!")
  end

  -- if not initializing, kill all dead offensive
  for unitName, testIndex in pairs(_dismCarrier.cargo_units) do
    if deadUnits[unitName] == nil then
      --                env.info("Unit " .. unitName .. " was dead before, kill it!")
      _dismCarrier.deadUnitsIndexes[deadUnitCount] = testIndex
      deadUnitCount = deadUnitCount + 1
    end
  end

  _dismCarrier.cargo_status = "mounted"
  _dismCarrier.cargo_group:Destroy()
  _dismCarrier.cargo_group = nil
end

-- function to check if the dismounts carriers are moving
local function CheckMovement()

  if stopDismounts then
    return  -- stop here...and don't continue the dismount check
  end
  
  --    env.info("Dismounts CheckMovement...")
  local dsmCount = #DismountsCarrier

  for n = 1, dsmCount do
    local theUnit = DismountsCarrier[n].unit
    --      env.info("Dismounts Checking: " .. theUnit:GetName())

    if theUnit:IsAlive() == true then
      --        env.info("Unit OK: " .. theUnit:GetName())

      local velVec = theUnit:GetVelocityVec3() -- Velocity is a Vec3
      --        env.info("Unit speed: velVec.x: " .. velVec.x .. ",velVec.y: " .. velVec.y .. ",velVec.z: " .. velVec.z)

      if velVec.x < 0.01 and velVec.y < 0.01 and velVec.z < 0.01 and velVec.x > -0.01 and velVec.y > -0.01 and velVec.z >
        -0.01 then -- Check if speed is zero
        --          env.info("Unit has stopped: " .. theUnit:GetName())

        if DismountsCarrier[n].cargo_status == "mounted" then
          --            env.info("Init dismounting of: " .. theUnit:GetName())

          -- Determine the x,y Vec2 position of the dismounts (10m behind of the carrier)
          local oldPos = theUnit:GetCoordinate():GetVec2()
          local dmVec2 = {
            x = oldPos.x - 20,
            y = oldPos.y - 20
          }

          local spawnedGroup = DismountsCarrier[n].cargo_spawn:SpawnFromVec2(dmVec2)

          --            local carrierPos = theUnit:getPosition()
          --            local group = GetDmGroup(theUnit)
          DismountsCarrier[n].cargo_status = "dismounted"
          DismountsCarrier[n].cargo_group = spawnedGroup

          -- initially all are not yet dead
          DismountsCarrier[n].cargo_numUnits = spawnedGroup:GetSize()
          DismountsCarrier[n].cargo_units = {}

          for i, currentUnit in pairs(spawnedGroup:GetUnits()) do
            DismountsCarrier[n].cargo_units[currentUnit:GetName()] = i
            --              env.info("Added " .. currentUnit:GetName() .. " with index: " .. i)
          end

          -- cleanup from dead unit list
          local allCurrentUnits = spawnedGroup:GetUnits()
          for unitName, currentUnit in pairs(DismountsCarrier[n].deadUnitsIndexes) do
            --              env.info("Killing " .. unitName .. " with index: " .. currentUnit)
            allCurrentUnits[currentUnit]:Destroy()
          end

          local groupSize = spawnedGroup:GetSize() or 0
          --            env.info("Spawned Group: " .. spawnedGroup:GetName() .. ", with " .. groupSize .. " units.")
        end
      else -- Else carrier is moving
        --          env.info("Unit is moving: " .. theUnit:GetName())

        if DismountsCarrier[n].cargo_status == "dismounted" then
          --            env.info("Unit is moving again, init mounting: " .. theUnit:GetName())
          mountDismounted(DismountsCarrier[n])
        end
      end
    else
      -- if DismountsCarrier[n].cargo_status ~= "lost" then
      --   local g = Group.getByName("Dismounts_" .. DismountsCarrier[n].UnitID)
      --   if g == nil then  --If mounted group is dead as well, raise handlers/flags
      --     DismountsCarrier[n].cargo_status = "lost"
      --   end
      -- end
    end
  end
  TIMER:New(CheckMovement):Start(checkIntervall)
end

local function reinitCheckMovement()
  env.info("Reinit Dismounts checking...")
  trigger.action.outText("..", 30)
  stopDismounts = false
  CheckMovement() 
end

-- Register at DSMC save callback to cleanup all before they are unnecessarily saved 
local function onDSMCRunSave(recall)
  env.info("Running Dismounts preSaveCallback...")
  trigger.action.outText(".", 30)

  stopDismounts = true
  local dsmCount = #DismountsCarrier

  for n = 1, dsmCount do
    local theUnit = DismountsCarrier[n].unit
    if theUnit:IsAlive() == true then
      if DismountsCarrier[n].cargo_status == "dismounted" then
        mountDismounted(DismountsCarrier[n])
      end
    end
  end

  -- Reset and run normal again after 15s
  TIMER:New(reinitCheckMovement):Start(15)
  env.info("Running Dismounts preSaveCallback...done!")
end

-- Add helper for DSMC saving
if EMBD ~= nil then
  env.info("Dismounts - Added preSaveCallback to DSMC...")
  EMBD.preSaveCallback = onDSMCRunSave
else
  env.info("Dismounts - DSMC not found. Nothing to do for preSaveCallback...")
end

-- Find all dismounts in mission and automatically add them 
for dsmCount = 1, #dismTypes do
  env.info("AddDismounts - Checking type: " .. dismTypes[dsmCount])

  local DISMGroups = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterPrefixes(dismPrefix ..dismTypes[dsmCount]):FilterActive():FilterOnce()
  env.info("DISMGroups alive: " .. DISMGroups:CountAlive())

  DISMGroups:ForEachGroup(function(groupToStore)
    env.info("Adding Dismounts to Group: " .. groupToStore:GetName())

    AddDismounts(groupToStore:GetUnit(1), dismTypes[dsmCount])

    env.info("Added Dismounts to Unit: " .. groupToStore:GetUnit(1):GetName())
  end)

end

-- Go Dismounts! Go!
TIMER:New(CheckMovement):Start(checkIntervall)
env.info("Dismounts initialized!")


