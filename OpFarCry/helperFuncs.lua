------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Find random point in give zone on land

function getRandomVec2OnLandInZone(_zone)
  local destVec2 = nil

  repeat
    destVec2 = _zone:GetRandomVec2()
    local checkSurfTypeCoord = COORDINATE:NewFromVec2(destVec2)
  until (checkSurfTypeCoord:IsSurfaceTypeWater() == false)

  return destVec2
end


--[[
-- Make all red units ALARMSTATE RED
local SetGroups = SET_GROUP:New():FilterCoalitions("red"):FilterOnce()

SetGroups:ForEachGroup(function(groupMakeAngry)
    env.info("Setting Group to Green: " .. groupMakeAngry:GetName())
    groupMakeAngry:OptionAlarmStateGreen()
    groupMakeAngry:OptionROEHoldFire()
  end
)
]]


