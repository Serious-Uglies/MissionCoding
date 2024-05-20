-------------------------
-- Setup autolaser

env.info("Loading Autolase")
local afacSet = SET_GROUP:New():FilterPrefixes({"AFAC", "JTAC", "afac", "jtac","Jtac","JTac","Afac"}):FilterCoalitions("blue"):FilterStart()
--local Pilotset = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive(true):FilterStart()
local autolaser = AUTOLASE:New(afacSet, coalition.side.BLUE, "AFAC")
autolaser:SetNotifyPilots(true) -- defaults to true, also shown if debug == true
autolaser:SetPilotMenu(true)
autolaser:DisableSmokeMenu()
autolaser:SetMaxLasingTargets(1)
autolaser:SetLaserCodes( { 1556, 1557, 1566, 1567, 1576, 1577, 1586, 1587, 1656, 1657, 1666, 1667, 1676, 1677, 1686, 1687} ) -- set self.LaserCodes


function autolaser:OnAfterLasing(From, Event, To, LaserSpot)
  local _lasingUnit       = LaserSpot.lasingunit
  local _lasedTarget      = LaserSpot.lasedunit
  local _lasedCoordinate  = LaserSpot.coordinate
  env.info(string.format("%s is lasing %s", _lasingUnit:GetName(), _lasedTarget:GetName()))
  
  lasedTargets[_lasingUnit:GetName()] = MARKER:New(_lasedTarget:GetCoordinate(),
          _lasedTarget:GetTypeName() .. " Coordinates\n" .. _lasedTarget:GetCoordinate():ToStringLLDDM() .. "\n" ..
            _lasedTarget:GetCoordinate():ToStringLLDMS() .. "\n" .. _lasedTarget:GetCoordinate():ToStringMGRS()):ReadOnly()
          :ToAll()

end

function autolaser:OnAfterLaserTimeout(From, Event, To, UnitName, RecceName)
  local _lasingUnit     = RecceName
  lasedTargets[_lasingUnit]:Remove()
end

function autolaser:OnAfterRecceKIA(From, Event, To, RecceName)
    local _lasingUnit     = RecceName
    lasedTargets[_lasingUnit]:Remove()
end

-----------------------------------------------
-- Overwrite Hercules Cargo with our own stuff

--CTLD_HERCULES.Types["SkyfireTest"] = {['name'] = "SkyfireTestUnit", ['container'] = true}

-----------------------------------------------
-- Configure our CTLS settings

-- Instantiate and start a CTLD for the blue side, using helicopter groups named "Helicargo" and alias "Lufttransportbrigade I"
my_ctld = CTLD:New(coalition.side.BLUE,{"HeliCargo"},"CTLD_Blue")

--my_ctld.useprefix = true
my_ctld.useprefix = false -- (DO NOT SWITCH THIS OFF UNLESS YOU KNOW WHAT YOU ARE DOING!) Adjust **before** starting CTLD. If set to false, *all* choppers of the coalition side will be enabled for CTLD.
my_ctld.CrateDistance = 50 -- List and Load crates in this radius only.
my_ctld.dropcratesanywhere = true -- Option to allow crates to be dropped anywhere.
my_ctld.maximumHoverHeight = 15 -- Hover max this high to load.
my_ctld.minimumHoverHeight = 4 -- Hover min this low to load.
my_ctld.forcehoverload = false -- Crates (not: troops) can **only** be loaded while hovering.
my_ctld.hoverautoloading = true -- Crates in CrateDistance in a LOAD zone will be loaded automatically if space allows.
my_ctld.smokedistance = 2000 -- Smoke or flares can be request for zones this far away (in meters).
my_ctld.movetroopstowpzone = true -- Troops and vehicles will move to the nearest MOVE zone...
my_ctld.movetroopsdistance = 5000 -- .. but only if this far away (in meters)
my_ctld.smokedistance = 2000 -- Only smoke or flare zones if requesting player unit is this far away (in meters)
my_ctld.suppressmessages = false -- Set to true if you want to script your own messages.
my_ctld.repairtime = 300 -- Number of seconds it takes to repair a unit.
my_ctld.cratecountry = country.id.GERMANY -- ID of crates. Will default to country.id.RUSSIA for RED coalition setups.
my_ctld.allowcratepickupagain = true  -- allow re-pickup crates that were dropped.
my_ctld.enableslingload = false -- allow cargos to be slingloaded - might not work for all cargo types
my_ctld.pilotmustopendoors = false -- force opening of doors
my_ctld.SmokeColor = SMOKECOLOR.Red -- color to use when dropping smoke from heli 
my_ctld.FlareColor = FLARECOLOR.Red -- color to use when flaring from heli
my_ctld.basetype = "container_cargo" -- default shape of the cargo container
my_ctld.usesubcats = true -- use sub-category names for crates, adds an extra menu layer in "Get Crates", useful if you have > 10 crate types.


--[[ 
my_ctld.enableLoadSave = true -- allow auto-saving and loading of files
my_ctld.saveinterval = 10 -- save every 10 minutes
my_ctld.filename = "missionsave.csv" -- example filename
my_ctld.filepath = "C:\\temp" -- example path
]]


-- update unit capabilities for testing - allow 5 crates
--[[
my_ctld:UnitCapabilities("UH-1H", true, true, 5, 12, 15)
my_ctld:UnitCapabilities("SA342L", false, false, 5, 3, 12)
my_ctld:UnitCapabilities("SA342M", false, false, 5, 3, 12)
my_ctld:UnitCapabilities("Mi-24P", true, true, 5, 8, 18)
my_ctld:UnitCapabilities("Mi-8MT", true, true, 5, 24, 15)
my_ctld:UnitCapabilities("UH-60L", true, true, 5, 12, 15)
my_ctld:UnitCapabilities("Hercules", true, true, 15, 64, 25)
]]

-- MOOSE Default
--[[
   ["UH-60L"] = {type="UH-60L", crates=true, troops=true, cratelimit = 2, trooplimit = 20, length = 16, cargoweightlimit = 3500},

    ["SA342Mistral"] = {cratelimit = 0, trooplimit = 4,  cargoweightlimit = 400},
    ["SA342L"] =       {cratelimit = 0, trooplimit = 2,  cargoweightlimit = 400},
    ["SA342M"] =       {cratelimit = 0, trooplimit = 4,  cargoweightlimit = 400},
    ["SA342Minigun"] = {cratelimit = 0, trooplimit = 2,  cargoweightlimit = 400},
    ["UH-1H"] =        {cratelimit = 1, trooplimit = 8,  cargoweightlimit = 700},
    ["Mi-8MTV2"] =     {cratelimit = 2, trooplimit = 12, cargoweightlimit = 3000},
    ["Mi-8MT"] =       {cratelimit = 2, trooplimit = 12, cargoweightlimit = 3000},
    ["Ka-50"] =        {cratelimit = 0, trooplimit = 0,  cargoweightlimit = 0},
    ["Mi-24P"] =       {cratelimit = 2, trooplimit = 8,  cargoweightlimit = 700},
    ["Mi-24V"] =       {cratelimit = 2, trooplimit = 8,  cargoweightlimit = 700},
    ["Hercules"] =     {cratelimit = 7, trooplimit = 64, cargoweightlimit = 19000}, -- 19t cargo, 64 paratroopers. 
    ["UH-60L"] =       {cratelimit = 2, trooplimit = 20, cargoweightlimit = 3500}, -- 4t cargo, 20 (unsec) seats
    ["AH-64D_BLK_II"]= {cratelimit = 0, trooplimit = 2,  cargoweightlimit = 200}, -- 2 ppl **outside** the helo]]



my_ctld:AddCTLDZone("Tawara",CTLD.CargoZoneType.SHIP,SMOKECOLOR.Blue,true,true,240,20)
my_ctld:AddCTLDZone("Invincible",CTLD.CargoZoneType.SHIP,SMOKECOLOR.Blue,true,true,240,20)

-- define statics cargo
------------------------------ Troops -- 
--my_ctld:AddCratesCargo("FOB",{"Template_FOB"},CTLD_CARGO.Enum.FOB,2,500,nil)
my_ctld:AddTroopsCargo("Infantry Squad 12",     {"Template_CTLD_Blue_Inf12"},CTLD_CARGO.Enum.TROOPS,12,80)
my_ctld:AddTroopsCargo("Infantry Squad 8",      {"Template_CTLD_Blue_Inf8"},CTLD_CARGO.Enum.TROOPS,8,80)
my_ctld:AddTroopsCargo("Infantry Mortar-Team",  {"Template_CTLD_Blue_Mortar"},CTLD_CARGO.Enum.TROOPS,6,110)
my_ctld:AddTroopsCargo("Infantry JTac Widow",   {"Template_CTLD_Blue_Inf_JTac"},CTLD_CARGO.Enum.TROOPS,2,80)
my_ctld:AddTroopsCargo("Infantry Stinger Pair", {"Template_CTLD_Blue_Stinger"},CTLD_CARGO.Enum.TROOPS,2,80)

------------------------------ FOB/FARP -- 
my_ctld:AddCratesCargo("FOB",         {"Template_Blue_FOB"},CTLD_CARGO.Enum.FOB, 5, 1500, nil, "FOB")
my_ctld:AddCratesCargo("FARP",        {"Template_Blue_FARP"},CTLD_CARGO.Enum.FOB, 2, 1500, nil, "FOB")
--my_ctld:AddCratesCargo("FOB",         {"Template_Blue_FARP_SUPPORT"},CTLD_CARGO.Enum.FOB, 1, 500)

------------------------------ ATGMs -- 
my_ctld:AddCratesCargo("ATGM HUMVEE",  {"TEMPLATE_CTLD_Blue_ATGM_HUMVEE"}, CTLD_CARGO.Enum.VEHICLE, 1, 2000, nil, "IFV")
my_ctld:AddCratesCargo("ATGM STRYKER",  {"TEMPLATE_CTLD_Blue_ATGM_STRYKER"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "IFV")
my_ctld:AddCratesCargo("SPG STRYKER",  {"TEMPLATE_CTLD_Blue_SPG_STRYKER"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "IFV")

my_ctld:AddCratesCargo("JTAC HUMVEE",  {"TEMPLATE_CTLD_Blue_Jtac_HUMVEE"}, CTLD_CARGO.Enum.VEHICLE, 1, 1500, nil, "IFV")
my_ctld:AddCratesCargo("IFV M2A2",  {"TEMPLATE_CTLD_Blue_ATGM_IFV_M2A2"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "IFV")
my_ctld:AddCratesCargo("VAB T20",  {"TEMPLATE_CTLD_Blue_VAB_T20"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "IFV")

my_ctld:AddCratesCargo("MLRS M270",  {"TEMPLATE_CTLD_Blue_MLRS_M270"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "Arty")
my_ctld:AddCratesCargo("M109 Paladin",  {"TEMPLATE_CTLD_Blue_M109_PALADIN"}, CTLD_CARGO.Enum.VEHICLE, 3, 1500, nil, "Arty")

------------------------------ SAM/AAA -- 
my_ctld:AddCratesCargo("AAA Avenger",  {"TEMPLATE_CTLD_Blue_AAA_Avenger"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "AAA")
my_ctld:AddCratesCargo("AAA Vulcan",  {"TEMPLATE_CTLD_Blue_AAA_Vulcan"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "AAA")
my_ctld:AddCratesCargo("AAA Gepard",  {"TEMPLATE_CTLD_Blue_AAA_Gepard"}, CTLD_CARGO.Enum.VEHICLE, 2, 1500, nil, "AAA")

my_ctld:AddCratesCargo("SAM NASM",  {"TEMPLATE_CTLD_Blue_SAM_NASM"}, CTLD_CARGO.Enum.VEHICLE, 4, 1500, nil, "SAM")
--my_ctld:AddCratesCargo("SAM HAWK",  {"TEMPLATE_CTLD_Blue_SAM_Hawk"}, CTLD_CARGO.Enum.VEHICLE, 6, 2500)

------------------------------ MBTs -- 
my_ctld:AddCratesCargo("MBT Leopard 1",  {"TEMPLATE_CTLD_Blue_MBT_LEO1"}, CTLD_CARGO.Enum.VEHICLE, 3, 1500, nil, "MBT")

------------------------------ LOGISTIC -- 
my_ctld:AddCratesCargo("SUP M939",  {"TEMPLATE_CTLD_Blue_LOG_M939"}, CTLD_CARGO.Enum.VEHICLE, 1, 1500, nil, "LOG")


my_ctld:AddCTLDZone("CTLD_Incirlik",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
my_ctld:AddCTLDZone("CTLD_BasselAlAssad",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)

--local herccargo = CTLD_HERCULES:New("blue", "Hercules Test", my_ctld)

-- FARP Radio. First one has 130AM, next 131 and for forth
local FARPFreq = 130
local FARPName = 1 -- numbers 1..10

local FARPClearnames = {
  [1]="London",
  [2]="Dallas",
  [3]="Paris",
[4]="Moscow",
[5]="Berlin",
[6]="Rome",
[7]="Madrid",
[8]="Warsaw",
[9]="Dublin",
[10]="Perth",
}

function InitFARP(_cooordinate, _name, _unit)
  local coord = _cooordinate -- Core.Point#COORDINATE

  local FarpName = ((FARPName-1)%10)+1
  local FName = FARPClearnames[FarpName]
  
  FARPFreq = FARPFreq + 0.15
  FARPName = FARPName + 1
  local farp = SPAWNSTATIC:NewFromStatic("FARP")
  farp:InitFARP(FName, FARPFreq, 0)
  farp:InitDead(false)
  farp:SpawnFromCoordinate(_cooordinate, 0)

  if _name then
    ZONE_UNIT:New(_name, _unit, 100)
    my_ctld:AddCTLDZone(_name, CTLD.CargoZoneType.LOAD, SMOKECOLOR.Blue, true, true)
  end
end

function my_ctld:OnAfterCratesBuild(From, Event, To, Group, Unit, Vehicle)
  local vname = Vehicle:GetName()
  local vunit = Vehicle:GetUnit(1)
  local vunitname = vunit:GetName()
  MESSAGE:New("vunitname: " .. vunitname, 15):ToAll()

  --Get Unit Type : Wenn FOBCrate dann los
  if (string.match(vunitname, "FARP")) then
    local _coordinate = vunit:GetCoord()
    InitFARP(_coordinate)
    MESSAGE:New("A new FARP has been created!", 15):ToAll()
  elseif (string.match(vunitname, "FOB")) then
    local _coordinate = vunit:GetCoord()
    InitFARP(_coordinate, vname, vunit)
    MESSAGE:New("A new FOB has been created!", 15):ToAll()
  elseif (string.match(vunitname, "JTac")) then
    if (autolaser ~= nil) then
      autolaser:SetRecceLaserCode(vunitname, jtacLasercodeDefault)
    else
      env.warning("Error setting jtacLasercodeDefault, autolaser is nil")
    end
  end
end
my_ctld:__Start(5)

--------------------------------------------------
--- Collect old stuff lying around in the mission

env.info("Collecting old CTLD crates")
MESSAGE:New("Collecting old CTLD crates", 15):ToAll()

local SetStatics = SET_STATIC:New():FilterCoalitions("blue"):FilterPrefixes("-Container-"):FilterOnce()

SetStatics:ForEachStatic(function(theStatic)
  -- get name from static
  local _name,_rest = theStatic:GetName():match("(.+)-Container-(.+)")

  env.info("Found _name: " .. _name .. ", _rest: " .. _rest)

  local cargoTypes = my_ctld.Cargo_Crates
  for _id,_cargo in pairs (cargoTypes) do -- #number, #CTLD_CARGO
    if _cargo.Name == _name then
      local cgoname = _cargo.Name
      local cgotemp = _cargo.Templates
      local cgotype = _cargo.CargoType
      local cgoneed = _cargo.CratesNeeded
      local cgomass = _cargo.PerCrateMass
      local subcat = cgotype.Subcategory
      my_ctld.CrateCounter = my_ctld.CrateCounter + 1
      my_ctld.CargoCounter = my_ctld.CargoCounter + 1
      my_ctld.Spawned_Crates[my_ctld.CrateCounter] = theStatic
      local newCargo = CTLD_CARGO:New(my_ctld.CargoCounter, cgoname, cgotemp, cgotype, true, false, cgoneed, my_ctld.Spawned_Crates[my_ctld.CrateCounter], true, cgomass, nil, subcat)
      table.insert(my_ctld.Spawned_Cargo, newCargo)

      newCargo:SetWasDropped(true)
      newCargo:SetHasMoved(true)
  
      env.info("Readded cargo: _id" .. _id .. ", _cargo.Name: " .. _cargo.Name)
    end
  end
end
)


env.info("Collecting previously dropped troops")
MESSAGE:New("Collecting previously dropped troops", 15):ToAll()

local SetGroups = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("Template"):FilterOnce()

SetGroups:ForEachGroup(function(theGroup)
  -- get name from group
  local _name = theGroup:GetName()
  env.info("Found old deployed group _name: " .. _name)
  MESSAGE:New("Found old deployed group _name: " .. _name, 15):ToAll()

  if theGroup:IsAlive() then
    env.info("Group is alive and Active _name: " .. _name)
    MESSAGE:New("Group is alive and Active _name: " .. _name, 15):ToAll()

    if string.find(theGroup:GetName(), "Template_Blue_FOB") then
      local vname = theGroup:GetName()
      local vunit = theGroup:GetUnit(1)
      local _coordinate = vunit:GetCoord()
      InitFARP(_coordinate, vname, vunit)
    else
      local nameEnd = string.find(theGroup:GetName(), "-")

      if nameEnd then
        local groupType = string.sub(theGroup:GetName(), 1, nameEnd-1)
        env.info("Grouptype found: " .. groupType)
    
        local theCargo = nil
        for k,v in pairs(my_ctld.Cargo_Troops) do
          local comparison = ""
          if type(v.Templates) == "string" then comparison = v.Templates else comparison = v.Templates[1] end
          if comparison then
            env.info("comparison: " .. comparison)
          end
          if comparison == groupType then
            theCargo = v
            break
          end
        end
      
        if theCargo then
          env.info("Found theCargo: " .. theCargo.Name)
      
          local cgoname = theCargo.Name
          local cgotemp = theCargo.Templates
          local cgotype = theCargo.CargoType
          local cgoneed = theCargo.CratesNeeded
          local cgomass = theCargo.PerCrateMass
        
          my_ctld.CargoCounter = my_ctld.CargoCounter + 1
          my_ctld.TroopCounter = my_ctld.TroopCounter + 1
          my_ctld.DroppedTroops[my_ctld.TroopCounter] = theGroup
          
          local newCargo = CTLD_CARGO:New(my_ctld.CargoCounter, cgoname, cgotemp, cgotype, true, true, cgoneed, nil, nil, cgomass)
          newCargo:SetWasDropped(true)
        
          env.info("Readded cargo: theCargo.Name: " .. theCargo.Name)
          MESSAGE:New("Readded cargo: theCargo.Name: " .. theCargo.Name, 15):ToAll()
        end
      end
    end
  end
end
)


MESSAGE:New("Added CTLD Menu", 15):ToAll()

