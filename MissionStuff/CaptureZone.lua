---------------------------------------
----         Capture Zone          ----
---------------------------------------
--
--  v 0.1 05.03.2023
--  By Skyfire
-- The zone is captured, when a unit has landed there for more then the defined amount of seconds

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local updateFrequence = 1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local totalRedUnits = 0
local totalRedGroups = 0
local totalBlueUnits = 0
local totalBlueGroups = 0
local capturedRedInfoText = ""
local capturedBlueInfoText = ""
local whoWon = ""

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CaptureZoneRedName = "CaptureZone_Red"
local CaptureZoneRed = ZONE:FindByName(CaptureZoneRedName)
local CaptureZoneBlueName = "CaptureZone_Blue"
local CaptureZoneBlue = ZONE:FindByName(CaptureZoneBlueName)

local CaptureTimeNeeded = 15

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function flareVictory(_zone, _coalition)
  local explodeCoal = "blue"
  local flrColor = SMOKECOLOR.Red

  if _coalition == "blue" then
    explodeCoal = "red"
    flrColor = SMOKECOLOR.Green
  end
  
  _zone:FlareZone( flrColor, 30, math.random( 0, 90 ) )
  local playZone = ZONE:FindByName("ScoringAreaFireworks")
  playZone:FlareZone( flrColor, 30, math.random( 0, 90 ) )


  local SetGroups = SET_CLIENT:New():FilterCoalitions(explodeCoal):FilterZones({_zone}):FilterCategories("helicopter"):FilterActive():FilterOnce()
  SetGroups:ForEachClient(
    function(_client)
      _client:Explode(1000, 2)
    end  
  )

  whoWon = _coalition
end

local function CheckAndPrintLiving(_zone)
  if whoWon ~= "" then
    trigger.action.outText(whoWon .. " has won this round. Wohooooo!", 100, true)
    return
  end

  local finalText = ""

  finalText = "Ugly Scoreboard!\nCapture time needed: " .. CaptureTimeNeeded .. "s\n--------------------------------------------"

  if capturedRedInfoText ~= "" then
    finalText = finalText .. "\n" .. capturedRedInfoText .. "\n--------------------------------------------"
  end

  if capturedBlueInfoText ~= "" then
    finalText = finalText .. "\n" .. capturedBlueInfoText .. "\n--------------------------------------------"
  end


  local SetGroupsRed = SET_GROUP:New():FilterCoalitions("red"):FilterZones({_zone}):FilterCategoryGround():FilterOnce()
  local gRAlive, uRAlive = SetGroupsRed:CountAlive()
  if uRAlive == 0 then
    TIMER:New(flareVictory, _zone, "red"):Start(1, 1)
  end

  local redText = "Red Total Groups/Units: " .. totalRedGroups .. "/" .. totalRedUnits .. "\nAlive Groups: " .. gRAlive .. ", Units: " .. uRAlive
  finalText = finalText .. "\n" .. redText .. "\n--------------------------------------------"


  local SetGroupsBlue = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({_zone}):FilterCategoryGround():FilterOnce()
  local gBAlive, uBAlive = SetGroupsBlue:CountAlive()
  if uBAlive == 0 then
    TIMER:New(flareVictory, _zone, "blue"):Start(1, 1)
  end

  local blueText = "Blue Total Groups/Units: " .. totalBlueGroups .. "/" .. totalBlueUnits .. "\nAlive Groups: " .. gBAlive .. ", Units: " .. uBAlive
  finalText = finalText .. "\n" .. blueText

  trigger.action.outText(finalText, 1, true)

  TIMER:New(CheckAndPrintLiving, _zone):Start(updateFrequence)
end

local playZone = ZONE:FindByName("ScoringArea")

local InitSetRed = SET_GROUP:New():FilterCoalitions("red"):FilterZones({playZone}):FilterCategoryGround():FilterOnce()
totalRedGroups, totalRedUnits = InitSetRed:CountAlive()

local InitSetBlue = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({playZone}):FilterCategoryGround():FilterOnce()
totalBlueGroups, totalBlueUnits = InitSetBlue:CountAlive()

TIMER:New(CheckAndPrintLiving, playZone):Start(5)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local landedListRed = {}
local landedListBlue = {}

local function SmokeAllZones()
  CaptureZoneRed:GetCoordinate():SmokeRed()
  CaptureZoneBlue:GetCoordinate():SmokeBlue()

  local counter = 1
  while counter < 5 do
    local smokeZoneB = ZONE:FindByName("Smoke-Blue-" .. counter)
    smokeZoneB:GetCoordinate():SmokeBlue()
    local smokeZoneR = ZONE:FindByName("Smoke-Red-" .. counter)
    smokeZoneR:GetCoordinate():SmokeRed()
    counter = counter + 1
  end
  
-- Resmoke after 5 min - colored smoke only lasts that long
  TIMER:New(SmokeAllZones):Start(300)
end

TIMER:New(SmokeAllZones):Start(1)


local function prepareCaptureText(_time, _coalition, _player)

  local finalText = ""

  if _time > 0 then
    finalText = "Player [" .. _player .. "] captured the " .. _coalition .. " zone for " .. _time .. " seconds"

    if _coalition == "blue" then
      capturedBlueInfoText = capturedBlueInfoText .. "\n" .. finalText
    else
      capturedRedInfoText = capturedRedInfoText .. "\n" .. finalText
    end
  else
    if _coalition == "blue" then
      capturedBlueInfoText = "Blue Team Capture State:"
    else
      capturedRedInfoText = "Red Team Capture State:"
    end
  end
end

local function CheckZoneCapture(_zone, _coalition, _landedList)
  env.info("CheckZoneCapture: " .. _zone:GetName())

  -- Check all units from landing list. If they have not been in the zone this round, remove them. 
  for _n, _c in pairs(_landedList) do
    local unit = _n:GetClientGroupUnit()
    if unit and not unit:IsInZone(_zone) then
      _landedList[_n] = nil
    end
  end

  prepareCaptureText(0, _coalition)

  local SetGroups = SET_CLIENT:New():FilterCoalitions(_coalition):FilterZones({_zone}):FilterCategories("helicopter"):FilterActive():FilterOnce()
  SetGroups:ForEachClient(
    function(_client)
      env.info("Checking client: " .. _client:GetName())
      local IsOnGround = _client:InAir() == false

      if IsOnGround then
        env.info(_client:GetPlayerName() .. " is on ground")

        if not _landedList[_client] then
          _landedList[_client] = 1
        else
          _landedList[_client] = _landedList[_client] + 1
          env.info("Client in zone for (s): " .. _landedList[_client])

          prepareCaptureText(_landedList[_client], _coalition, _client:GetPlayerName())
        end
      else
        env.info(_client:GetPlayerName() .. " is in air")
        _landedList[_client] = nil
      end
    end  
  )

  for _n, _c in pairs(_landedList) do
    if _c >= CaptureTimeNeeded then
      env.info("Zone captured by: " .. _n:GetClientGroupUnit():GetName())
      TIMER:New(flareVictory, _zone, _coalition):Start(1, 1)
      return
    end
  end

  TIMER:New(CheckZoneCapture, _zone, _coalition, _landedList):Start(1)
end

TIMER:New(CheckZoneCapture, CaptureZoneRed, "blue", landedListBlue):Start(5)
TIMER:New(CheckZoneCapture, CaptureZoneBlue, "red", landedListRed):Start(5)

local function setCaptureTime(_newTime)
  CaptureTimeNeeded = _newTime
end

local controlGroup = GROUP:FindByName("#Debug")

local ControlMenuParent = MENU_MISSION:New( "Don't touch this!" )
MENU_MISSION_COMMAND:New("Set Capture Time to 15s", ControlMenuParent, setCaptureTime, 15)
MENU_MISSION_COMMAND:New("Set Capture Time to 30s", ControlMenuParent, setCaptureTime, 30)
MENU_MISSION_COMMAND:New("Set Capture Time to 60s", ControlMenuParent, setCaptureTime, 60)
MENU_MISSION_COMMAND:New("Set Capture Time to 120s", ControlMenuParent, setCaptureTime, 120)

