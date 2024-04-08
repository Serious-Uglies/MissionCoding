AWLarnaca = AIRWING:New("Warehouse Larnaca","AW Larnaca")
AWLarnaca:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Larnaca))
AWLarnaca:SetRespawnAfterDestroyed(60*1)
AWLarnaca:SetTakeoffHot()
AWLarnaca:Start()

AWPaphos = AIRWING:New("Warehouse Paphos","AW Paphos")
AWPaphos:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Paphos))
AWPaphos:SetRespawnAfterDestroyed(60*1)
AWPaphos:SetTakeoffHot()
AWPaphos:Start()


-- Create a Mig21 Squadron for Larnaca.
local Larnaca1st=SQUADRON:New("Mig21_A2A_Template", 16, "1st Larnaca Squadron") --Ops.Squadron#SQUADRON
Larnaca1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
Larnaca1st:AddMissionCapability({AUFTRAG.Type.ALERT5})
Larnaca1st:SetFuelLowRefuel(true)
Larnaca1st:SetGrouping(2)


-- Create a Mig23 Squadron for Paphos.
local Paphos1st=SQUADRON:New("Mig23_A2A_Template", 16, "1st Paphos Squadron") --Ops.Squadron#SQUADRON
Paphos1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
Paphos1st:AddMissionCapability({AUFTRAG.Type.ALERT5})
Paphos1st:SetFuelLowRefuel(true)
Paphos1st:SetGrouping(2)


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

AWPaphos:AddSquadron(Paphos1st)
AWPaphos:NewPayload("Mig23_A2A_Template",-1,{AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},65)



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
  local mIntercept = AUFTRAG:NewINTERCEPT(targetGroup)
  mIntercept:SetRepeat(99)
  AWLarnaca:AddMission(mIntercept)
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



