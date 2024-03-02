---------------------------------------
----       Simple Scoreboard       ----
---------------------------------------
--
--  v 0.1 02.03.2023
--  By Skyfire
--  Simple Scoreboard script. When loading, it collects all living red and blue units. Every minute a check is performed about who is still alive.
--  The current data is printed with each check.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local updateFrequence = 5

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local totalRedUnits = 0
local totalRedGroups = 0
local totalBlueUnits = 0
local totalBlueGroups = 0

local function CheckAndPrintLiving(_zone)
  trigger.action.outText("Ugly Scoreboard!", 5, true)

  local SetGroupsRed = SET_GROUP:New():FilterCoalitions("red"):FilterZones({_zone}):FilterCategoryGround():FilterOnce()
  local gRAlive, uRAlive = SetGroupsRed:CountAlive()
  trigger.action.outText("Red Total Groups/Units: " .. totalRedGroups .. "/" .. totalRedUnits .. "\nAlive Groups: " .. gRAlive .. ", Units: " .. uRAlive, 5, false)


  local SetGroupsBlue = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({_zone}):FilterCategoryGround():FilterOnce()
  local gBAlive, uBAlive = SetGroupsBlue:CountAlive()
  trigger.action.outText("Blue Total Groups/Units: " .. totalBlueGroups .. "/" .. totalBlueUnits .. "\nAlive Groups: " .. gBAlive .. ", Units: " .. uBAlive, 5, false)

  TIMER:New(CheckAndPrintLiving, _zone):Start(updateFrequence)
end

local playZone = ZONE:FindByName("ScoringArea")

local InitSetRed = SET_GROUP:New():FilterCoalitions("red"):FilterZones({playZone}):FilterCategoryGround():FilterOnce()
totalRedGroups, totalRedUnits = InitSetRed:CountAlive()

local InitSetBlue = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({playZone}):FilterCategoryGround():FilterOnce()
totalBlueGroups, totalBlueUnits = InitSetBlue:CountAlive()

TIMER:New(CheckAndPrintLiving, playZone):Start(5)
