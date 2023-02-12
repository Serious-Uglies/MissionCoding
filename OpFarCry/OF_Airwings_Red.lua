AWBeslan = AIRWING:New("AW Beslan","AW Beslan")
AWBeslan:SetAirbase(AIRBASE:FindByName("Beslan"))
AWBeslan:SetRespawnAfterDestroyed(60*15)
AWBeslan:SetTakeoffCold()
AWBeslan:__Start(2)

AWMozdok = AIRWING:New("AW Mozdok","AW Mozdok")
AWMozdok:SetAirbase(AIRBASE:FindByName("Mozdok"))
AWMozdok:SetRespawnAfterDestroyed(60*15)
AWMozdok:SetTakeoffCold()
AWMozdok:__Start(3)

AWNalchik = AIRWING:New("AW Nalchik","AW Nalchik")
AWNalchik:SetAirbase(AIRBASE:FindByName("Nalchik"))
AWNalchik:SetRespawnAfterDestroyed(60*10)
AWNalchik:SetTakeoffCold()
AWNalchik:__Start(4)

AWFARP_RF_CZ02_02 = AIRWING:New("RF_CZ02_02","AW FARP_CZ01_01")
AWFARP_RF_CZ02_02:SetAirbase(AIRBASE:FindByName("FARP_CZ01_01"))
AWFARP_RF_CZ02_02:SetRespawnAfterDestroyed(60*15)
AWFARP_RF_CZ02_02:SetTakeoffCold()
AWFARP_RF_CZ02_02:__Start(5)


-- AIRWING:SetSaveOnMissionEnd(path, filename) Remember! Save the warehouses!


-- Create a Su27 Squadron for beslan.
local beslan1st=SQUADRON:New("Su27 A2A Template", 16, "1st RU Beslan Squadron") --Ops.Squadron#SQUADRON
beslan1st:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
beslan1st:AddMissionCapability({AUFTRAG.Type.ALERT5})
beslan1st:SetFuelLowRefuel(true)
beslan1st:SetGrouping(2)

-- Create a tanker Squadron
local mozdok1st = SQUADRON:New("RU_Tanker TEMPLATE",9,"1st Mozdok Tankers")
mozdok1st:AddMissionCapability({AUFTRAG.Type.TANKER},100)
mozdok1st:SetGrouping(1)

-- Create an AWACS Squadron
local mozdok3rd = SQUADRON:New("RU_AWACS TEMPLATE",9,"3rd Mozdok Eyes RU_EWR")
mozdok3rd:AddMissionCapability({AUFTRAG.Type.AWACS},100)
mozdok3rd:SetGrouping(1)
mozdok3rd:SetFuelLowRefuel(true)

-- Create an escort squadron for Mozdok
local mozdok2nd = SQUADRON:New("Su27 A2A Template", 12, "2nd RU Mozdok Squadron")
mozdok2nd:AddMissionCapability({AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
mozdok2nd:AddMissionCapability({AUFTRAG.Type.ALERT5})
mozdok2nd:SetGrouping(2)
mozdok2nd:SetFuelLowRefuel(true)

-- Create SU25 for Nalchik
local nalchik1st = SQUADRON:New("Su25 TEMPLATE", 12, "1st Nalchik Squadron")
nalchik1st:AddMissionCapability({AUFTRAG.Type.SEAD, AUFTRAG.Type.BAI}, 100)
nalchik1st:SetGrouping(2)

-- Create Mi28 for FARP_CZ01_01
local farp_cz01_mi28 = SQUADRON:New("Mi28 A2G TEMPLATE", 12, "Farp CZ01 Mi28")
farp_cz01_mi28:AddMissionCapability({AUFTRAG.Type.BAI}, 100)
farp_cz01_mi28:SetGrouping(1)

-- Add Squadrons
AWBeslan:AddSquadron(beslan1st)
AWMozdok:AddSquadron(mozdok1st)  -- Tanker Wing
AWMozdok:AddSquadron(mozdok2nd)  -- Fighter Wing
AWMozdok:AddSquadron(mozdok3rd)  -- AWACS Wing
AWNalchik:AddSquadron(nalchik1st)
AWFARP_RF_CZ02_02:AddSquadron(farp_cz01_mi28)

-- Add Payloads
AWBeslan:NewPayload("Su27 A2A Template", -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
AWMozdok:NewPayload("RU_Tanker TEMPLATE",-1,{AUFTRAG.Type.TANKER},100)
AWMozdok:NewPayload("Su27 A2A Template", -1, {AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.ORBIT}, 100)
AWMozdok:NewPayload("RU_AWACS TEMPLATE",-1,{AUFTRAG.Type.AWACS},100)
AWNalchik:NewPayload("Su25 TEMPLATE_SEAD", -1 ,{AUFTRAG.Type.SEAD},100)
AWNalchik:NewPayload("Su25 TEMPLATE_A2G", -1 ,{AUFTRAG.Type.BAI},100)
AWFARP_RF_CZ02_02:NewPayload("Mi28 A2G TEMPLATE",-1,{AUFTRAG.Type.BAI},100)

local alert5=AUFTRAG:NewALERT5(AUFTRAG.Type.INTERCEPT)
alert5:SetRequiredAssets(2)
alert5:SetRepeat(99)
AWBeslan:AddMission(alert5)
alert5:SetRequiredAssets(3)
AWMozdok:AddMission(alert5)

local zoneCAP=ZONE:New("RU_CAP_W")
local mCAP=AUFTRAG:NewCAP(zoneCAP, 26000, 350) --Planes nur für AIR? -- https://wiki.hoggitworld.com/view/DCS_enum_attributes
mCAP:SetRepeat(99)
AWBeslan:AddMission(mCAP)
local zoneCAP=ZONE:New("RU_CAP_NW")
local mCAP2=AUFTRAG:NewCAP(zoneCAP, 26000, 350) --Planes nur für AIR? -- https://wiki.hoggitworld.com/view/DCS_enum_attributes
mCAP2:SetRepeat(99)
AWMozdok:AddMission(mCAP2)


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