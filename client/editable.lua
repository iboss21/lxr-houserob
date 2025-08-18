local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

function Minigame()

    local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})

    return success 
end


function LocationMinigame()
    
    local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})

    return success 
end

function TriggerPolice(coords)
    
    TriggerServerEvent('rsg-lawman:server:lawmanAlert', "House Robbery", coords)
    TriggerServerEvent('rsg-tips:server:addCriminalActivity', "A witness has reported a break & enter", nil, coords)
end