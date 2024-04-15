
---------------------------------------
-- Airbases

local AWIncirlik = AIRWING:New("Warehouse Incirlik","Airwing Incirlik")
AWIncirlik:SetMarker(false)
AWIncirlik:SetAirbase(AIRBASE:FindByName(AIRBASE.Syria.Incirlik))
AWIncirlik:SetRespawnAfterDestroyed(300)
AWIncirlik:SetTakeoffHot()
AWIncirlik:__Start(2)

---------------------------------------
-- Awacs

local AWACS_E_One = SQUADRON:New("TEMPLATE_AWACS_ONE",2,"Awacs East")
AWACS_E_One:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.AWACS},100)
AWACS_E_One:SetFuelLowRefuel(true)
AWACS_E_One:SetFuelLowThreshold(0.2)
AWACS_E_One:SetTurnoverTime(10,20)
AWACS_E_One:SetTakeoffHot()
AWIncirlik:AddSquadron(AWACS_E_One)
AWIncirlik:NewPayload("TEMPLATE_AWACS_ONE",-1,{AUFTRAG.Type.ORBIT, AUFTRAG.Type.AWACS},100)


---------------------------------------
-- Tanker

local TANKER_E_BOOM = SQUADRON:New("TEMPLATE_TANKER_BOOM",10,"Tanker Boom")
TANKER_E_BOOM:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.TANKER},100)
TANKER_E_BOOM:SetFuelLowRefuel(true)
TANKER_E_BOOM:SetFuelLowThreshold(0.2)
TANKER_E_BOOM:SetTurnoverTime(10,20)
TANKER_E_BOOM:SetTakeoffHot()
TANKER_E_BOOM:SetRadio(341.0)
AWIncirlik:AddSquadron(TANKER_E_BOOM)
AWIncirlik:NewPayload("TEMPLATE_TANKER_BOOM",-1,{AUFTRAG.Type.ORBIT, AUFTRAG.Type.TANKER},100)

local TANKER_E_BASKET = SQUADRON:New("TEMPLATE_TANKER_BASKET",10,"Tanker Basket")
TANKER_E_BASKET:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.TANKER},100)
TANKER_E_BASKET:SetFuelLowRefuel(true)
TANKER_E_BASKET:SetFuelLowThreshold(0.2)
TANKER_E_BASKET:SetTurnoverTime(10,20)
TANKER_E_BASKET:SetTakeoffHot()
TANKER_E_BASKET:SetRadio(331.0)
AWIncirlik:AddSquadron(TANKER_E_BASKET)
AWIncirlik:NewPayload("TEMPLATE_TANKER_BASKET",-1,{AUFTRAG.Type.ORBIT, AUFTRAG.Type.TANKER},100)

---------------------------------------
-- Squadrons

local INCIRLIC_ESCORT = SQUADRON:New("TEMPLATE_AWACS_ESCORT",10,"Escorts Awacs East")
INCIRLIC_ESCORT:AddMissionCapability({AUFTRAG.Type.ESCORT})
INCIRLIC_ESCORT:SetFuelLowRefuel(true)
INCIRLIC_ESCORT:SetFuelLowThreshold(0.3)
INCIRLIC_ESCORT:SetTurnoverTime(10,20)
INCIRLIC_ESCORT:SetTakeoffHot()
INCIRLIC_ESCORT:SetRadio(255)
AWIncirlik:AddSquadron(INCIRLIC_ESCORT)
AWIncirlik:NewPayload("TEMPLATE_AWACS_ESCORT",-1,{AUFTRAG.Type.ESCORT},100)


local INCIRLIK_CAP = SQUADRON:New("TEMPLATE_INCIRLIK_CAP",10,"Incirlik CAP")
INCIRLIK_CAP:AddMissionCapability({AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},80)
INCIRLIK_CAP:SetFuelLowRefuel(true)
INCIRLIK_CAP:SetFuelLowThreshold(0.3)
INCIRLIK_CAP:SetTurnoverTime(10,20)
INCIRLIK_CAP:SetTakeoffHot()
INCIRLIK_CAP:SetRadio(255)
AWIncirlik:AddSquadron(INCIRLIK_CAP)
AWIncirlik:NewPayload("TEMPLATE_INCIRLIK_CAP",-1,{AUFTRAG.Type.ALERT5,AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.INTERCEPT},100)


---------------------------------------------------------------------
-- Special Missions
-- staggered setup of AI planes to give scheduler time to catch up with spawning


function startIncirlicCAP()
    -- AWACS mission. Orbit at 30000 ft, 300 KIAS, heading 145 for 20 NM.
    local zoneCAP=ZONE:New("CAP_INCIRLIK_NORTH")
    local zoneCAPOrbit=ZONE:New("CAP_INCIRLIK_NORTH_ORBIT")
    
    local capTask = AUFTRAG:NewCAP(zoneCAP, 25000, 300, zoneCAPOrbit:GetCoordinate(), 90, 25)
    capTask:SetRequiredAssets(2, 2)
    capTask:SetRepeat(99)
    -- Assign mission to pilot.
    AWIncirlik:AddMission(capTask)
end

function startAWACS()
    -- AWACS mission. Orbit at 30000 ft, 300 KIAS, heading 145 for 20 NM.
    local zoneEastOrbit=ZONE:New("AWACS_EAST_ORBIT")
    local awacsOrbitTask = AUFTRAG:NewORBIT(zoneEastOrbit:GetCoordinate(), 30000, 300, 145, 20)
    awacsOrbitTask:SetRequiredEscorts(2, 2, AUFTRAG.Type.ESCORT, "Planes", 40)
    awacsOrbitTask:SetRepeat(99)
    -- Assign mission to pilot.
    AWIncirlik:AddMission(awacsOrbitTask)

    TIMER:New(startIncirlicCAP):Start(180)
end

function startTankerBasket()
    -- Basket tanker mission. Orbit at 20000 ft, 300 KIAS, heading 145 for 20 NM.
    local zoneBasketOrbit=ZONE:New("TANKER_EAST_BASKET")
    local tankerBasketOrbitTask = AUFTRAG:NewTANKER(zoneBasketOrbit:GetCoordinate(), 22000, 300, 160, 30, 1) -- 1=Basket
    tankerBasketOrbitTask:SetRequiredEscorts(2, 2, AUFTRAG.Type.ESCORT, "Planes", 40)
    tankerBasketOrbitTask:SetRepeat(99)
    tankerBasketOrbitTask:SetTACAN(63, "ARC")
    -- Assign mission to pilot.
    AWIncirlik:AddMission(tankerBasketOrbitTask)

    TIMER:New(startAWACS):Start(180)
end

-- Boom tanker mission. Orbit at 25000 ft, 300 KIAS, heading 145 for 20 NM.
local zoneBoomOrbit=ZONE:New("TANKER_EAST_BOOM")
local tankerBoomOrbitTask = AUFTRAG:NewTANKER(zoneBoomOrbit:GetCoordinate(), 27000, 300, 160, 30, 0) -- 1=boom
tankerBoomOrbitTask:SetRequiredEscorts(2, 2, AUFTRAG.Type.ESCORT, "Planes", 40)
tankerBoomOrbitTask:SetRepeat(99)
tankerBoomOrbitTask:SetTACAN(64, "TEX")
-- Assign mission to pilot.
AWIncirlik:AddMission(tankerBoomOrbitTask)

-- delayed start of basket
TIMER:New(startTankerBasket):Start(180)
















--[[
-- AWACS mission. Orbit at 30000 ft, 300 KIAS, heading 145 for 20 NM.
local zoneEastOrbit=ZONE:New("AWACS_EAST_ORBIT")
local awacsOrbitTask = AUFTRAG:NewORBIT(zoneEastOrbit:GetCoordinate(), 30000, 300, 145, 20)
awacsOrbitTask:SetRequiredEscorts(2, 2, AUFTRAG.Type.ESCORT, "Planes", 40)
awacsOrbitTask:SetRepeat(99)
-- Assign mission to pilot.
AWIncirlik:AddMission(awacsOrbitTask)

-- delayed start of boom
TIMER:New(startTankerBoom):Start(160)
]]



--[[

-- Set up AWACS called "AWACS North". It will use the AwacsAW Airwing set up above and be of the "blue" coalition. Homebase is Kutaisi.
-- The AWACS Orbit Zone is a round zone set in the mission editor named "Awacs Orbit", the FEZ is a Polygon-Zone called "Rock" we have also
-- set up in the mission editor with a late activated helo named "Rock#ZONE_POLYGON". Note this also sets the BullsEye to be referenced as "Rock".
-- The CAP station zone is called "Fremont". We will be on 255 AM.
local fezZone = ZONE_POLYGON:New("FEZ_AWACS_EAST", GROUP:FindByName( "FEZ_AWACS_EAST" ))
local testawacs = AWACS:New("AWACS East",AWIncirlik,"blue",AIRBASE.Syria.Incirlik,"AWACS_EAST_ORBIT", fezZone,"CAP_EAST_ORBIT",255,radio.modulation.AM )
-- set two escorts
testawacs:SetEscort(2)
-- Callsign will be "Focus". We'll be a Angels 30, doing 300 knots, orbit leg to 88deg with a length of 25nm.
testawacs:SetAwacsDetails(CALLSIGN.AWACS.Focus,1,30,300,88,25)
-- Set up SRS on port 5010 - change the below to your path and port
--testawacs:SetSRS("C:\\Program Files\\DCS-SimpleRadio-Standalone","female","en-GB",5010)
-- Our CAP flight will have the callsign "Ford", we want 4 AI planes, Time-On-Station is four hours, doing 300 kn IAS.
testawacs:SetAICAPDetails(CALLSIGN.Aircraft.Ford,2,4,300)
-- We're modern (default), e.g. we have EPLRS and get more fill-in information on detections
testawacs:SetModernEra()
-- And start
testawacs:__Start(5)






-- Patrol zone.
local zoneAlpha=ZONE:New("AWACS_EAST_ORBIT")
-- AWACS mission. Orbit at 15000 ft, 350 KIAS, heading 270 for 20 NM.
local auftrag=AUFTRAG:NewAWACS(zoneAlpha:GetCoordinate(), 23000, 350, 145, 20)
auftrag:SetRadio(251)       -- Set radio to 225 MHz AM.
auftrag:SetRequiredEscorts(1, 1, AUFTRAG.Type.ESCORT, "Planes", 40)
auftrag:SetRepeat(99)
-- Assign mission to pilot.
AWIncirlik:AddMission(auftrag)






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

]]