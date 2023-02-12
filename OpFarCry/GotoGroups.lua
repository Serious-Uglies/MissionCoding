-----------------------
----  Goto Groups  ----
-----------------------
--
--  v 0.1 24.10.2022
--  By Skyfire
--  Script that sends groups in intervalls to a given point on the map
--  Place a zone with name "GOTO_XYZ_WHATEVER". 
--  A scheduler will collect all zones with the name "GOTO_". For each zone it will find all GROUPS 
--  with the name of each zone as prefix and send them to the center of the zones.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local zonePrefix = "GOTO_"

-- slightly off time to avoid conflict with other scheduled tasks
local gotoFrequency = 611 -- in seconds - 600s equals 10min

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Check for RouteList

if RouteList == nil then
  env.info("Route Scheduler is missing - cannot live without it! Goto Groups is not loaded!")
  trigger.action.outText("Route Scheduler is missing - cannot live without it! Goto Groups is not loaded!", 600, false)
  return
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Call this function for each zone that should be observed
function CheckGotosForZone(_zone)
  env.info("CheckGotosForZone: " .. _zone:GetName())

  local SetGroups = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterPrefixes(_zone:GetName()):FilterActive():FilterOnce()
  
  SetGroups:ForEachGroupNotInZone(_zone, function(groupToMove)
    env.info("Rerouting group: " .. groupToMove:GetName())

    if groupToMove:IsAlive() then
      local destVec2 = _zone:GetRandomVec2()
      local gotoData = {group = groupToMove, dest = destVec2}
      RouteList.pushright(theList, gotoData)
    else
      env.info("It's dead Jim: " .. groupToMove:GetName())
    end
  end
  )

  TIMER:New(CheckGotosForZone, _zone):Start(gotoFrequency)
end

-- init for all GoTo zones
local SetZones = SET_ZONE:New():FilterPrefixes(zonePrefix):FilterOnce()
SetZones:ForEachZone(function(zoneToMoveTo)
  env.info("Init Goto for zone: " .. zoneToMoveTo:GetName())
  CheckGotosForZone(zoneToMoveTo)
end
)
