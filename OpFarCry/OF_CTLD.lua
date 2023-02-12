-- Instantiate and start a CTLD for the blue side, using helicopter groups named "Helicargo" and alias "Lufttransportbrigade I"
my_ctld = CTLD:New(coalition.side.BLUE,{"HeliCargo"},"CTLD_Blue")

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


-- define statics cargo
--my_ctld:AddCratesCargo("FOB",{"Template_FOB"},CTLD_CARGO.Enum.FOB,2,500,nil)
my_ctld:AddTroopsCargo("Infantry Squad 12",     {"Template_CTLD_Blue_Inf12"},CTLD_CARGO.Enum.TROOPS,12,80)
my_ctld:AddTroopsCargo("Infantry Squad 8",      {"Template_CTLD_Blue_Inf8"},CTLD_CARGO.Enum.TROOPS,8,80)
my_ctld:AddTroopsCargo("Infantry Mortar-Team",  {"Template_CTLD_Blue_Mortar"},CTLD_CARGO.Enum.TROOPS,6,110)
my_ctld:AddTroopsCargo("Infantry JTac Widow",   {"Template_CTLD_Blue_JTac"},CTLD_CARGO.Enum.TROOPS,2,80)
my_ctld:AddTroopsCargo("Infantry Stinger Pair",   {"Template_CTLD_Blue_Stinger"},CTLD_CARGO.Enum.TROOPS,2,80)

my_ctld:AddCratesCargo("FOB",         {"Template_Blue_FOB"},CTLD_CARGO.Enum.FOB, 5, 2000)
my_ctld:AddCratesCargo("JTAC HUMVEE",  {"TEMPLATE_CTLD_Blue_Jtac_HUMVEE"}, CTLD_CARGO.Enum.VEHICLE, 1, 2000)
my_ctld:AddCratesCargo("IFV M2A2",  {"TEMPLATE_CTLD_Blue_ATGM_IFV_M2A2"}, CTLD_CARGO.Enum.VEHICLE, 1, 2000)
my_ctld:AddCratesCargo("ATGM STRYKER",  {"TEMPLATE_CTLD_Blue_ATGM_Stryker"}, CTLD_CARGO.Enum.VEHICLE, 1, 2500)
my_ctld:AddCratesCargo("SUP M939",  {"TEMPLATE_CTLD_Blue_LOG_M939"}, CTLD_CARGO.Enum.VEHICLE, 1, 1500)
my_ctld:AddCratesCargo("AAA Avenger",  {"TEMPLATE_CTLD_Blue_AAA_Avenger"}, CTLD_CARGO.Enum.VEHICLE, 1, 2500)
my_ctld:AddCratesCargo("AAA Gepard",  {"TEMPLATE_CTLD_Blue_AAA_Gepard"}, CTLD_CARGO.Enum.VEHICLE, 1, 3000)
my_ctld:AddCratesCargo("AAA Vulcan",  {"TEMPLATE_CTLD_Blue_AAA_Vulcan"}, CTLD_CARGO.Enum.VEHICLE, 1, 2500)
my_ctld:AddCratesCargo("SAM NASM",  {"TEMPLATE_CTLD_Blue_SAM_NASM"}, CTLD_CARGO.Enum.VEHICLE, 4, 2500)
--my_ctld:AddCratesCargo("SAM HAWK",  {"TEMPLATE_CTLD_Blue_SAM_Hawk"}, CTLD_CARGO.Enum.VEHICLE, 6, 2500)

my_ctld:AddCratesCargo("MBT Leopard 1",  {"TEMPLATE_CTLD_Blue_MBT_LEO1"}, CTLD_CARGO.Enum.VEHICLE, 2, 3000)



--my_ctld:AddCTLDZone("FOB_Dallas",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
--my_ctld:AddCTLDZone("CTLD_Megiddo",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true,240,20)
my_ctld:AddCTLDZone("CTLD_Kutaisi",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)

function my_ctld:OnAfterCratesBuild(From,Event,To,Group,Unit,Vehicle)
  local vname = Vehicle:GetName()
  local vunit = Vehicle:GetUnit(1)
  local vunitname = vunit:GetName()
  --Get Unit Type : Wenn FOBCrate dann los
  if (string.match(vunitname, "FOB")) then
    local zone = ZONE_UNIT:New(vname,vunit,100)
    my_ctld:AddCTLDZone(vname,CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
    MessageToAll("A new FOB has been created!")
    else if (string.match(vunitname, "farp")) then
        MessageToAll("A new FARP has been created!")
        local _coordinate = vunit:GetPosition()
        local farp = SPAWNSTATIC:NewFromStatic("farp"):SpawnFromCoordinate(_coordinate,0)
        local id = math.random(1,9999)
        local supportGroup = SPAWN:NewWithAlias("Template_Blue_FARP_Support","Farp" .. id):SpawnFromCoordinate(_coordinate)
    else if (string.match(vunitname, "JTac")) then
      if (autolaser ~= nil) then
        autolaser:SetRecceLaserCode(vunitname, jtacLasercodeDefault)
      else
        env.warning("Error setting jtacLasercodeDefault, autolaser is nil")
      end
    end
  end
end
end

my_ctld:__Start(5)


env.info("Collecting old CTLD crates")
MessageToAll("Collecting old CTLD crates")

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
MessageToAll("Collecting previously dropped troops")

local SetGroups = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("Template"):FilterOnce()

SetGroups:ForEachGroup(function(theGroup)
  -- get name from group
  local _name = theGroup:GetName()
  env.info("Found old deployed group _name: " .. _name)
  MessageToAll("Found old deployed group _name: " .. _name)

  if theGroup:IsAlive() then
    env.info("Group is alive and Active _name: " .. _name)
    MessageToAll("Group is alive and Active _name: " .. _name)

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
        MessageToAll("Readded cargo: theCargo.Name: " .. theCargo.Name)
      end
    end
  end
end
)



MessageToAll("Added CTLD Menu")

