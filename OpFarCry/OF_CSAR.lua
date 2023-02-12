my_csar = CSAR:New(coalition.side.BLUE,"Downed Pilot", "CSAR")

-- options
my_csar.limitmaxdownedpilots    = true
my_csar.suppressmessages        = false -- Show default messages
my_csar.maxdownedpilots         = 15
my_csar.FARPRescueDistance      = 1000 -- you need to be this close to a FARP or Airport for the pilot to be rescued.
my_csar.autosmoke               = true -- automatically smoke a downed pilot\'s location when a heli is near.
my_csar.autosmokedistance       = 1000 -- distance for autosmoke
my_csar.coordtype               = 1 -- Use Lat/Long DDM (0), Lat/Long DMS (1), MGRS (2), Bullseye imperial (3) or Bullseye metric (4) for coordinates.
my_csar.invisiblecrew           = false -- downed pilot spawn is visible
my_csar.useprefix               = false -- allow all helicopter to be CSAR
my_csar.allowFARPRescue         = true -- allows pilots to be rescued by landing at a FARP or Airbase. Else MASH only!
my_csar.csarOncrash             = false -- (WIP) If set to true, will generate a downed pilot when a plane crashes as well.
my_csar.pilotRuntoExtractPoint  = true -- Downed pilot will run to the rescue helicopter up to self.extractDistance in meters. 
my_csar.extractDistance         = 500 -- Distance the downed pilot will start to run to the rescue helicopter.
my_csar.loadDistance            = 25 -- configure distance for pilots to get into helicopter in meters.
my_csar.mashprefix              = {"MASH"}
my_csar.csarUsePara             = true  -- If set to true, will use the LandingAfterEjection Event instead of Ejection. Requires mycsar.enableForAI to be set to true. --shagrat
my_csar.enableForAI             = true
my_csar.rescuehoverheight       = 30
my_csar.rescuehoverdistance     = 20
my_csar.messageTime             = 20
my_csar.smokecolor              = 3 -- Color of smokemarker, 0 is green, 1 is red, 2 is white, 3 is orange and 4 is blue.
my_csar.loadDistance            = 15 -- configure distance for pilots to get into helicopter in meters.

my_csar.useSRS = false -- Use FF\'s SRS integration
--my_csar.SRSPath = STTS.DIRECTORY -- adjust your own path in your server(!)
--my_csar.SRSchannel = 127.500 -- radio channel
--my_csar.SRSModulation = radio.modulation.AM -- modulation

-- start the FSM
my_csar:__Start(5)


function my_csar:OnAfterPilotDown(from, event, to, spawnedgroup, frequency, groupname, coordinates_text)
  --MessageToAll("my_csar:OnAfterPilotDown")
  MessageToAll("Mayday Mayday Mayday, Pilot down! Contact at: " .. tostring(frequency) .. "kHz, coordinates: " .. coordinates_text)
end

--[[ 
function my_csar:OnAfterApproach(from, event, to, heliname, groupname)
  --MessageToAll("my_csar:OnAfterApproach")
--  MessageToAll("Approaching downed pilot. ".. heliname .. " request flare or smoke for assistance.")
  MESSAGE:New( "Approaching downed pilot - look out for smoke!"):ToGroup(UNIT:FindByName(heliname):GetGroup())  
end 
]]

function my_csar:OnAfterBoarded(from, event, to, heliname, groupname)
  --MessageToAll("my_csar:OnAfterBoarded")
  --MessageToAll(heliname .. " - Picked up downed pilot. Return to nearest MASH or Airfield immediately.")
  MESSAGE:New( "Picked up downed pilot. Return to nearest MASH or Airfield immediately!"):ToGroup(UNIT:FindByName(heliname):GetGroup())  
  --CsarMapMarker = {}
end

--function my_csar:OnAfterReturning(from, event, to, heliname, groupname)
  --MessageToAll("my_csar:OnAfterReturning")
    -- Stop helo.
  --self:__Stop(2)
--end

function my_csar:OnAfterRescued(from, event, to, heliunit, heliname, pilotssaved)
  --MessageToAll("my_csar:OnAfterRescued")
  MessageToAll("Downed pilot succesfully delivered to more capable hands in MASH. Thank you!")
  --MESSAGE:New( "We will take care of the patient, you are good to go!"):ToGroup(UNIT:FindByName(heliname):GetGroup())  
end


env.info("Exchanging old CSAR Groups")

local SetGroups = SET_GROUP:New():FilterCoalitions("blue"):FilterCategoryGround():FilterPrefixes("Pilot "):FilterOnce()
SetGroups:ForEachGroup(function(groupToMove)

    env.info("Exchanging CSAR Group: " .. groupToMove:GetName())
   
    local csarPos = groupToMove:GetCoordinate() -- :GetVec2()
    local freq = my_csar:_GenerateADFFrequency()

--    env.info("groupToMove:GetCoordinate():GetVec2() x: " .. csarPos.x .. "y: " .. csarPos.y)
    my_csar:_AddCsar(groupToMove:GetCoalition(), groupToMove:GetCountry(), csarPos, "Pilot " .. freq, "Pilot " .. freq, "", freq, true)

    groupToMove:Destroy()

  end
)

MessageToAll("Added CSAR Menu")

