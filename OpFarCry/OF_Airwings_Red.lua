AWLarnaca = AIRWING:New("Warehouse Larnaca","AW Larnaca")
AWLarnaca:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Larnaca))
AWLarnaca:SetRespawnAfterDestroyed(60*1)
AWLarnaca:SetTakeoffHot()
AWLarnaca:Start()
--AWBeslan:__Start(2)

--[[
AWFARP_RF_CZ02_02 = AIRWING:New("RF_CZ02_02","AW FARP_CZ01_01")
AWFARP_RF_CZ02_02:SetAirbase(AIRBASE:FindByName("FARP_CZ01_01"))
AWFARP_RF_CZ02_02:SetRespawnAfterDestroyed(60*15)
AWFARP_RF_CZ02_02:SetTakeoffCold()
AWFARP_RF_CZ02_02:__Start(5)
]]--

-- AIRWING:SetSaveOnMissionEnd(path, filename) Remember! Save the warehouses!

-- Create a Mig21 Squadron for beslan.
local Larnaca1st=SQUADRON:New("Mig21_A2A_Template", 16, "1st Larnaca Squadron") --Ops.Squadron#SQUADRON
Larnaca1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
Larnaca1st:AddMissionCapability({AUFTRAG.Type.ALERT5})
Larnaca1st:SetFuelLowRefuel(true)
Larnaca1st:SetGrouping(2)

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

-- Add Squadrons
AWLarnaca:AddSquadron(Larnaca1st)
AWLarnaca:NewPayload("Mig21_A2A_Template",-1,{AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},65)

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
local Red_DetectionSetGroupAWACS = SET_GROUP:New():FilterCoalitions("red"):FilterActive():FilterPrefixes( { "Red_EWR" } ):FilterStart()
local RedIntelAwacs = INTEL:New(Red_DetectionSetGroupAWACS, "red", "KGB AWACS")
RedIntelAwacs:SetClusterAnalysis(true, true, true)
RedIntelAwacs:SetVerbosity(2)
RedIntelAwacs:SetForgetTime(30)
RedIntelAwacs:__Start(2)

local SetRedCombatZoneAWACS = ZONE_POLYGON:New("Red Defense Zone Small", GROUP:FindByName( "ZONE_RU_CAP_E" ))
local RedGoZoneSet = SET_ZONE:New()
RedGoZoneSet:AddZone(SetRedCombatZoneAWACS)
RedIntelAwacs:SetAcceptZones(RedGoZoneSet)

function RedIntelAwacs:OnAfterNewContact(From, Event, To, contact)
  local trgtGrp = contact.group
  trigger.action.outText("KGB AWACS: I found a " .. contact.attribute .. " called " .. contact.groupname, 30)
  local targetGroup = GROUP:FindByName(contact.groupname)
  local mIntercept = AUFTRAG:NewINTERCEPT(targetGroup)
  mIntercept:SetRepeat(99)
  AWLarnaca:AddMission(mIntercept)
end
