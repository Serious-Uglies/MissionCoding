-----------------------------
-- Larnaca

AWLarnaca = AIRWING:New("Warehouse Larnaca","AW Larnaca")
AWLarnaca:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Larnaca))
AWLarnaca:SetRespawnAfterDestroyed(60*5)
AWLarnaca:SetTakeoffHot()
AWLarnaca:Start()

-- Create a Mig21 Squadron for Larnaca.
local Larnaca1st=SQUADRON:New("Mig21_A2A_Template", 16, "1st Larnaca Squadron") --Ops.Squadron#SQUADRON
Larnaca1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
Larnaca1st:SetFuelLowRefuel(true)
Larnaca1st:SetGrouping(2)

-- Create a Mig21 Squadron for Larnaca.
local Larnaca2nd=SQUADRON:New("C101CC_A2G_Template", 16, "2ndt Larnaca Squadron") --Ops.Squadron#SQUADRON
Larnaca2nd:AddMissionCapability({AUFTRAG.Type.BAI}, 100)
Larnaca2nd:SetFuelLowRefuel(true)
Larnaca2nd:SetGrouping(2)


-- Add Squadrons
AWLarnaca:AddSquadron(Larnaca1st)
AWLarnaca:AddSquadron(Larnaca2nd)
AWLarnaca:NewPayload("Mig21_A2A_Template",-1,{AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},65)
AWLarnaca:NewPayload("C101CC_A2G_Template",-1,{AUFTRAG.Type.BAI},65)


-----------------------------
-- Paphos

AWPaphos = AIRWING:New("Warehouse Paphos","AW Paphos")
AWPaphos:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Paphos))
AWPaphos:SetRespawnAfterDestroyed(60*5)
AWPaphos:SetTakeoffHot()
AWPaphos:Start()

-- Create a Mig29 Squadron for Paphos.
local Paphos1st=SQUADRON:New("Mig29_A2A_Template", 16, "1st Paphos Squadron") --Ops.Squadron#SQUADRON
Paphos1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
Paphos1st:SetFuelLowRefuel(true)
Paphos1st:SetGrouping(2)

AWPaphos:AddSquadron(Paphos1st)
AWPaphos:NewPayload("Mig29_A2A_Template",-1,{AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},65)


-----------------------------
-- Gazipasa

AWGazipasa = AIRWING:New("Warehouse Gazipasa","AW Gazipasa")
AWGazipasa:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Gazipasa))
AWGazipasa:SetRespawnAfterDestroyed(60*5)
AWGazipasa:SetTakeoffHot()
AWGazipasa:Start()

-- Create a Mig29 Squadron for Gazipasa.
local Gazipasa1st=SQUADRON:New("Mig29_CAP_GAZIPASA", 24, "1st Gazipasa Squadron") --Ops.Squadron#SQUADRON
Gazipasa1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
Gazipasa1st:SetFuelLowRefuel(true)
Gazipasa1st:SetGrouping(2)

AWGazipasa:AddSquadron(Gazipasa1st)
AWGazipasa:NewPayload("Mig29_CAP_GAZIPASA",-1,{AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},65)


local AWACS_GAZIPASA = SQUADRON:New("AWACS_GAZIPASA",16,"Awacs Gazipasa")
AWACS_GAZIPASA:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.AWACS},100)
AWACS_GAZIPASA:SetFuelLowRefuel(true)
AWACS_GAZIPASA:SetFuelLowThreshold(0.2)
AWACS_GAZIPASA:SetTurnoverTime(10,20)
AWACS_GAZIPASA:SetTakeoffHot()
AWGazipasa:AddSquadron(AWACS_GAZIPASA)
AWGazipasa:NewPayload("AWACS_GAZIPASA",-1,{AUFTRAG.Type.ORBIT, AUFTRAG.Type.AWACS},100)


-----------------------------

function startGazipasaAWACS()
  -- AWACS mission. Orbit at 30000 ft, 300 KIAS, heading 145 for 20 NM.
  local zoneRedAwacsOrbit=ZONE:New("RED_AWACS_ORBIT")
  local redAwacsOrbitTask = AUFTRAG:NewORBIT(zoneRedAwacsOrbit:GetCoordinate(), 30000, 300, 145, 20)
--  redAwacsOrbitTask:SetRequiredEscorts(2, 2, AUFTRAG.Type.ESCORT, "Planes", 40)
  redAwacsOrbitTask:SetRepeat(99)
  -- Assign mission to pilot.
  AWGazipasa:AddMission(redAwacsOrbitTask)

--  TIMER:New(startGazipasaCAP):Start(180)
end

function startGazipasaCAP()
  -- AWACS mission. Orbit at 30000 ft, 300 KIAS, heading 145 for 20 NM.
  local zoneCAP=ZONE:New("CAP_GAZIPASA")
  local zoneCAPOrbit=ZONE:New("CAP_GAZIPASA_ORBIT")
  
  local capTask = AUFTRAG:NewCAP(zoneCAP, 25000, 300, zoneCAPOrbit:GetCoordinate(), 90, 25)
  capTask:SetRequiredAssets(2, 2)
  capTask:SetRepeat(99)
  -- Assign mission to pilot.
  AWGazipasa:AddMission(capTask)

  TIMER:New(startGazipasaAWACS):Start(180)
end


startGazipasaCAP()

--[[ Create a tanker Squadron
local mozdok1st = SQUADRON:New("RU_Tanker TEMPLATE",9,"1st Mozdok Tankers")
mozdok1st:AddMissionCapability({AUFTRAG.Type.TANKER},100)
mozdok1st:SetGrouping(1)

-- Create an AWACS Squadron
local mozdok3rd = SQUADRON:New("RU_AWACS TEMPLATE",9,"3rd Mozdok Eyes RU_EWR")
mozdok3rd:AddMissionCapability({AUFTRAG.Type.AWACS},100)
mozdok3rd:SetGrouping(1)
mozdok3rd:SetFuelLowRefuel(true)

-- Create SU25 for Nalchik
local nalchik1st = SQUADRON:New("Su25 TEMPLATE", 12, "1st Nalchik Squadron")
nalchik1st:AddMissionCapability({AUFTRAG.Type.SEAD, AUFTRAG.Type.BAI}, 100)
nalchik1st:SetGrouping(2)

-- Create Mi28 for FARP_CZ01_01
local farp_cz01_mi28 = SQUADRON:New("Mi28 A2G TEMPLATE", 12, "Farp CZ01 Mi28")
farp_cz01_mi28:AddMissionCapability({AUFTRAG.Type.BAI}, 100)
farp_cz01_mi28:SetGrouping(1)
]]--


--[[ Add Payloads
AWBeslan:NewPayload("Su27 A2A Template", -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
AWMozdok:NewPayload("RU_Tanker TEMPLATE",-1,{AUFTRAG.Type.TANKER},100)
AWMozdok:NewPayload("Su27 A2A Template", -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
AWMozdok:NewPayload("RU_AWACS TEMPLATE",-1,{AUFTRAG.Type.AWACS},100)
AWNalchik:NewPayload("Su25 TEMPLATE_SEAD", -1 ,{AUFTRAG.Type.SEAD},100)
AWNalchik:NewPayload("Su25 TEMPLATE_A2G", -1 ,{AUFTRAG.Type.BAI},100)
AWFARP_RF_CZ02_02:NewPayload("Mi28 A2G TEMPLATE",-1,{AUFTRAG.Type.BAI},100)
]]--

--[[
local alert5=AUFTRAG:NewALERT5(AUFTRAG.Type.INTERCEPT)
alert5:SetRequiredAssets(2)
alert5:SetRepeat(99)
AWLarnaca:AddMission(alert5)

local zoneCAP=ZONE_POLYGON:New("Red Defense Zone Small", GROUP:FindByName( "ZONE_RU_CAP_E" ))
local mCAP=AUFTRAG:NewCAP(zoneCAP, 26000, 350) --Planes nur für AIR? -- https://wiki.hoggitworld.com/view/DCS_enum_attributes
mCAP:SetRepeat(99)
AWLarnaca:AddMission(mCAP)
]]--

--[[
-- Check if tanker-Support is available for RED
if (true) then
  local zoneTanker1 = ZONE:New("RU_Tanker_1")
  local zoneTanker2 = ZONE:New("RU_Tanker_2")
  local zoneSelector = math.random(1,2)
  local zoneActiveTanker = nil
    if (zoneSelector == 1 ) then
      zoneActiveTanker = zoneTanker1
    else
      zoneActiveTanker = zoneTanker2
    end
  local missionTanker = AUFTRAG:NewTANKER(zoneActiveTanker:GetCoordinate(), 26000, 350, 105, 30, 1)
  missionTanker:SetRepeat(99)
  missionTanker:SetRequiredEscorts(1, 1, AUFTRAG.Type.ESCORT, "Planes", 40):SetRepeat(99)
  
  AWMozdok:AddMission(missionTanker)
end

-- Check if AWACS-Support is available for RED
if (true) then
   local zoneAWACS1 = ZONE:New("RU_AWACS_1")
   local zoneAWACS2 = ZONE:New("RU_AWACS_2")
   local zoneSelector = math.random(1,2)
   local missionAWACS = nil
    if (zoneSelector == 1 ) then
      missionAWACS = AUFTRAG:NewAWACS(zoneAWACS1:GetCoordinate(), 26000, 350, 01, 25):SetRepeat(99)
      missionAWACS:SetRequiredEscorts(1, 1, AUFTRAG.Type.ESCORT, "Planes", 40)
    else
      missionAWACS = AUFTRAG:NewAWACS(zoneAWACS1:GetCoordinate(), 26000, 350, 260, 30)
      missionAWACS:SetRequiredEscorts(1, 1, AUFTRAG.Type.ESCORT, "Planes", 30):SetRepeat(99)
    end
    missionAWACS:SetRepeat(99)
    AWMozdok:AddMission(missionAWACS)
end

]]--


--[[
-- Define the INTEL
-- Set up a detection group set. "FilterStart" to include respawns.
local Red_DetectionSetGroup = SET_GROUP:New():FilterCoalitions("red"):FilterActive():FilterStart()
-- Red_DetectionSetGroup:FilterPrefixes( { "RU_Recce","RU_EWR" } )
-- Red_DetectionSetGroup:FilterStart()

-- New INTEL Type
local RedIntel = INTEL:New(Red_DetectionSetGroup, "red", "KGB")
RedIntel:SetClusterAnalysis(true, true)
RedIntel:SetForgetTime(300)
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
]]--


-- Initialize AWACS
local Red_DetectionSetGroupAWACS = SET_GROUP:New():FilterCoalitions("red"):FilterActive():FilterPrefixes( { "IADS_red_EWR" } ):FilterStart()
local RedIntelAwacsEast = INTEL:New(Red_DetectionSetGroupAWACS, "red", "KGB AWACS East")
RedIntelAwacsEast:SetClusterAnalysis(true, true, true)
RedIntelAwacsEast:SetVerbosity(2)
RedIntelAwacsEast:SetForgetTime(30)
RedIntelAwacsEast:__Start(2)

-- Initialize East Zone
local SetRedCombatZoneAWACSEast = ZONE_POLYGON:New("Red Defense Zone East", GROUP:FindByName( "ZONE_RU_CAP_E" ))
local RedGoZoneSetEast = SET_ZONE:New()
RedGoZoneSetEast:AddZone(SetRedCombatZoneAWACSEast)
RedIntelAwacsEast:SetAcceptZones(RedGoZoneSetEast)

function RedIntelAwacsEast:OnAfterNewContact(From, Event, To, contact)
  local trgtGrp = contact.group
  trigger.action.outText("KGB AWACS East: I found a " .. contact.attribute .. " called " .. contact.groupname, 30)
  local targetGroup = GROUP:FindByName(contact.groupname)

  if (contact.attribute == "Ground_APC") or (contact.attribute == "Ground_Artillery") or
    (contact.attribute == "Ground_Truck") or (contact.attribute == "Ground_Tank") or
    (contact.attribute == "Ground_IFV") then

    local mission = AUFTRAG:NewBAI(targetGroup, nil)
    mission:SetRepeatOnFailure(6)
    AWLarnaca:AddMission(mission)
  else
    local mIntercept = AUFTRAG:NewINTERCEPT(targetGroup)
    mIntercept:SetRepeat(99)
    AWLarnaca:AddMission(mIntercept)
  end
end

-- Initialize West Zone
local RedIntelAwacsWest = INTEL:New(Red_DetectionSetGroupAWACS, "red", "KGB AWACS West")
RedIntelAwacsWest:SetClusterAnalysis(true, true, true)
RedIntelAwacsWest:SetVerbosity(2)
RedIntelAwacsWest:SetForgetTime(30)
RedIntelAwacsWest:__Start(2)

local SetRedCombatZoneAWACSWest = ZONE_POLYGON:New("Red Defense Zone West", GROUP:FindByName( "ZONE_RU_CAP_W" ))
local RedGoZoneSetWest = SET_ZONE:New()
RedGoZoneSetWest:AddZone(SetRedCombatZoneAWACSWest)
RedIntelAwacsWest:SetAcceptZones(RedGoZoneSetWest)

function RedIntelAwacsWest:OnAfterNewContact(From, Event, To, contact)
  local trgtGrp = contact.group
  trigger.action.outText("KGB AWACS West: I found a " .. contact.attribute .. " called " .. contact.groupname, 30)
  local targetGroup = GROUP:FindByName(contact.groupname)
  local mIntercept = AUFTRAG:NewINTERCEPT(targetGroup)
  mIntercept:SetRepeat(99)
  AWPaphos:AddMission(mIntercept)
end



