---------------------------------------
----  Patrol in Zone Script  ----
---------------------------------------
--
--  v 0.1 23.10.2022
--  By Skyfire
--  Simple patrol script, that takes a zone, collects all groups that contain the string "Patrol" 
--  and assigns each 5 minutes a new waypoint to each patrol group
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local patrolPrefix = "PATROL_"

-- slightly off time to avoid conflict with other scheduled tasks
local patrolFrequency = 1813 -- in seconds - 600s equals 10min

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Check for RouteList

if RouteList == nil then
  env.info("Route Scheduler is missing - cannot live without it! Goto Groups is not loaded!")
  trigger.action.outText("Route Scheduler is missing - cannot live without it! Goto Groups is not loaded!", 600, false)
  return
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Call this function for each zone that should be observed


function DoPatrolsInZone(_zone)
  env.info("DoPatrolsInZone: " .. _zone:GetName())

  local SetGroups = SET_GROUP:New():FilterCoalitions("red"):FilterZones({_zone}):FilterCategoryGround():FilterPrefixes(patrolPrefix): FilterOnce()

  SetGroups:ForEachGroup(function(groupToMove)
    env.info("Patroling group: " .. groupToMove:GetName())

    local destVec2 = getRandomVec2OnLandInZone(_zone)
    local gotoData = {group = groupToMove, dest = destVec2}
    RouteList.pushright(theList, gotoData)

  end
  )

  -- recheck after some time, even if no patrols might be added now, as they might reappear from factories.
  TIMER:New(DoPatrolsInZone, _zone):Start(patrolFrequency)
end

