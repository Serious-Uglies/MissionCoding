---------------------------------
----  Group Route Scheduler  ----
---------------------------------
--
--  v 0.1 27.10.2022
--  By Skyfire
--  Schedules routing of groups to avoid too many lags. Depends on Moose.
--  It checks in the configured routeFrequency if it must reroute some groups.
--  If the queue contains some groups, the number of groups defined by groupsPerStep is 
--  put on their way.
--
--  Currently GROUP:RouteGroundOnRoad is used
--
--  Usage: 
--  local gotoData = {group = groupToMove, dest = destVec2 (, speed(optional))}
--  RouteList.pushright(theList, gotoData)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local defaultSpeed = 40

-- slightly off time to avoid conflict with other scheduled tasks
local routeFrequency = 1.7 -- in seconds

local groupsPerStep = 1 -- how many units are moved each iteration

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Check for Moose
if ENUMS == nil then
  env.info("Moose is missing - cannot live without it! Group Route Scheduler is not loaded!")
  trigger.action.outText("Moose is missing - cannot live without it! Group Route Scheduler is not loaded!", 600, false)
  return
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Router queue structure

RouteList = {}

function RouteList.new ()
  return {first = 0, last = -1}
end

--[[
function RouteList.pushleft (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end
]]

function RouteList.pushright (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function RouteList.popleft (list)
  local first = list.first

  if first > list.last then 
    return nil
  end

  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end

--[[
function RouteList.popright (list)
  local last = list.last

  if list.first > last then
    return nil
  end

  local value = list[last]
  list[last] = nil         -- to allow garbage collection
  list.last = last - 1
  return value
end
]]

theList = RouteList.new()

local function ExecuteRerouting()
  env.info("Start ExecuteRerouting...")

  for i = 1, groupsPerStep do
    local gotoData = RouteList.popleft(theList)
    if gotoData then
      if gotoData.group ~= nil then
        env.info("Execute reroute for: " .. gotoData.group:GetName())
        local gotoSpeed = gotoData.speed or defaultSpeed
        if gotoData.group:IsAlive() ~= true and COORDINATE:NewFromVec2(gotoData.dest) == nil then -- Das passiert nicht reproduzierbar
          env.error("Rerouting Error, COORDINATE:NewFromVec2(gotoData.dest) ist nil")
        else
          gotoData.group:RouteGroundOnRoad(COORDINATE:NewFromVec2(gotoData.dest), gotoSpeed)
        end
        
      end
    else
      break
    end
  end

  env.info("End ExecuteRerouting...")
  TIMER:New(ExecuteRerouting):Start(routeFrequency)
end

TIMER:New(ExecuteRerouting):Start(routeFrequency)

