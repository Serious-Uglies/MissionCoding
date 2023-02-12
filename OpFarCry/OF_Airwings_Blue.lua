AWNavyBoys = AIRWING:New("GeorgeWashington","NavyBoys")
AWNavyBoys:SetAirbase(AIRBASE:FindByName("GeorgeWashington"))
AWNavyBoys:SetRespawnAfterDestroyed(900)
AWNavyBoys:SetTakeoffCold()
AWNavyBoys:__Start(2)


local e2Hawkers=SQUADRON:New("US_E2Hawkers", 8, "US_Hawkers") --Ops.Squadron#SQUADRON
e2Hawkers:SetCallsign(CALLSIGN.AWACS.Darkstar)
e2Hawkers:SetRadio(251.0)
e2Hawkers:SetSkill(AI.Skill.HIGH)
e2Hawkers:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.AWACS},100)
e2Hawkers:SetFuelLowRefuel(true)
e2Hawkers:SetFuelLowThreshold(0.2)
e2Hawkers:SetTurnoverTime(10,20)
AWNavyBoys:AddSquadron(e2Hawkers)
AWNavyBoys:NewPayload("US_E2Hawkers",-1,{AUFTRAG.Type.ORBIT, AUFTRAG.Type.AWACS},100)

local recoveryTankers=SQUADRON:New("RecoveryTanker", 8, "recoveryTankers") --Ops.Squadron#SQUADRON
recoveryTankers:SetCallsign(CALLSIGN.Tanker.Shell)
recoveryTankers:SetRadio(251.0)
recoveryTankers:SetSkill(AI.Skill.HIGH)
recoveryTankers:AddMissionCapability({AUFTRAG.Type.RECOVERYTANKER, AUFTRAG.Type.TANKER},100)
recoveryTankers:SetFuelLowRefuel(true)
recoveryTankers:SetFuelLowThreshold(0.2)
recoveryTankers:SetTurnoverTime(10,20)
AWNavyBoys:AddSquadron(recoveryTankers)
AWNavyBoys:NewPayload("RecoveryTanker",-1,{AUFTRAG.Type.RECOVERYTANKER, AUFTRAG.Type.TANKER},100)


local Squad_Two = SQUADRON:New("Escorts",12,"Escorts Navy")
Squad_Two:AddMissionCapability({AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT})
Squad_Two:AddMissionCapability({AUFTRAG.Type.ALERT5})
Squad_Two:SetFuelLowRefuel(true)
Squad_Two:SetFuelLowThreshold(0.3)
Squad_Two:SetTurnoverTime(10,20)
Squad_Two:SetRadio(251,radio.modulation.AM)
Squad_Two:SetGrouping(2)
--Squad_Two:SetTakeoffAir()
AWNavyBoys:AddSquadron(Squad_Two)
AWNavyBoys:NewPayload("Escorts",-1,{AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ALERT5},100)

local auftragRecoveryTanker = AUFTRAG:NewRECOVERYTANKER(UNIT:FindByName("GeorgeWashington"))
auftragRecoveryTanker:SetRepeat(99)
AWNavyBoys:AddMission(auftragRecoveryTanker)

local testawacs = AWACS:New("AWACS South",AWNavyBoys,"blue","GeorgeWashington","Awacs Orbit South",ZONE:FindByName("FEZ_ROCK"),"Fremont",252,radio.modulation.AM )
testawacs:SetEscort(1)
testawacs:SetAwacsDetails(CALLSIGN.AWACS.Focus,1,25,350,120)
--testawacs:SetSRS("C:\\DCS_DATA\\SRS","female","en-GB",5010)
testawacs:SetRejectionZone(ZONE:FindByName("Red Border"))
testawacs:SetAICAPDetails(CALLSIGN.Aircraft.Ford,2,1,300)
testawacs:SetModernEra()
testawacs:__Start(5)
testawacs.AllowMarkers = false
--testawacs.debug = false


-- Patrol zone.
local zoneAlpha=ZONE:New("Awacs Orbit Coast")
-- AWACS mission. Orbit at 15000 ft, 350 KIAS, heading 270 for 20 NM.
local auftrag=AUFTRAG:NewAWACS(zoneAlpha:GetCoordinate(), 23000, 350, 145, 20)
auftrag:SetRadio(251)       -- Set radio to 225 MHz AM.
auftrag:SetRequiredEscorts(1, 1, AUFTRAG.Type.ESCORT, "Planes", 40)
auftrag:SetRepeat(99)
-- Assign mission to pilot.
AWNavyBoys:AddMission(auftrag)




AwRotary = AIRWING:New("Kutaisi","Kutaisi FARP Supply")
AwRotary:SetAirbase(AIRBASE:FindByName("Kutaisi"))
AwRotary:SetRespawnAfterDestroyed(900)
AwRotary:SetTakeoffCold()
AwRotary:__Start(2)

local squadronTransportHelo1 = SQUADRON:New("FrpSplyHelo", 8, "FrpSplyHelo") --Ops.Squadron#SQUADRON
squadronTransportHelo1:SetSkill(AI.Skill.HIGH)
squadronTransportHelo1:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.HOVER},100)
AwRotary:AddSquadron(squadronTransportHelo1)
AwRotary:NewPayload("FrpSplyHelo",-1,{AUFTRAG.Type.ORBIT, AUFTRAG.Type.HOVER},100)

