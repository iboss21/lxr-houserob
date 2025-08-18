local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

HouseCooldown = {}
Cooldown = Config.HouseCooldowns

RegisterNetEvent('y0-houserobbery:server:ReceiveReward', function(data, id)

    local _source = source
    local Player = RSGCore.Functions.GetPlayer(_source)
    local reward = data.locations[id].rewards
    local randomReward = reward[math.random(1, #reward)]
    local randomAmount = math.random(data.locations[id].rewardsAmount.min,data.locations[id].rewardsAmount.max)
    if not Player then return end

    Player.Functions.AddItem(randomReward,randomAmount)

    TriggerClientEvent('ox_lib:notify', _source, {
        type = 'success',
        title = locale('house_robbery'),
        description = locale('Received') .. randomReward .. ' '..randomAmount..'x',
    })
end)


RegisterNetEvent('y0-houserobbery:server:ReceiveSpecialReward', function(data, id)

    local _source = source
    local Player = RSGCore.Functions.GetPlayer(_source)
    local reward = data.SpecialProp.rewards
    local randomReward = reward[math.random(1, #reward)]
    local randomAmount = math.random(data.SpecialProp.rewardsAmount.min,data.SpecialProp.rewardsAmount.max)
    if not Player then return end

    Player.Functions.AddItem(randomReward,randomAmount)

    TriggerClientEvent('ox_lib:notify', _source, {
        type = 'success',
        title = locale('house_robbery'),
        description = locale('Received') .. randomReward .. ' '..randomAmount..'x',
    })
end)

RegisterNetEvent('y0-houserobbery:server:RoutingBucketPed', function(ped)
    local _source = source
        SetEntityRoutingBucket(NetworkGetEntityFromNetworkId(ped), GetPlayerRoutingBucket(_source))
end)

RegisterNetEvent('y0-houserobbery:server:RoutingBucket', function(toggle,data, id)
    local _source = source
    local Player = RSGCore.Functions.GetPlayer(_source)
    local bucketId = math.random(400,760)

    if not Player then return end

    local ped = GetPlayerPed(_source)

    if toggle == "Enter" then
        SetPlayerRoutingBucket(_source, bucketId)
        
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        local Playercid = Player.PlayerData.citizenid
        local discord = RSGCore.Functions.GetIdentifier(src, 'discord') 
        local dsc = "<@" .. discord:gsub("discord:", "") .. ">" 

        TriggerEvent(
        'rsg-log:server:CreateLog',
        'robbery',
        'House Stolen',
        'green',
        '**Player: ** ' .. Player.PlayerData.name .. '\n' ..
        '**Source: ** ' .. src .. '\n' ..
        '**Identifier: ** ' .. dsc ..'\n'..
        '**CitizenID: ** ' .. Playercid  ..'\n'..
        '**House ID: ** ' .. id  ..'\n'..
        '**House Name: ** ' .. data.name .. '\n' ..
        '**House Location: ** ' .. data.entercoords)

    elseif toggle == "Exit" then
        SetPlayerRoutingBucket(_source, 0)
    end
end)

RegisterNetEvent('y0-houserobbery:server:TriggerCooldown', function(toggle, id)
    if toggle == "activate" then
        table.insert(HouseCooldown, { cooldown = os.time() + Cooldown, id = id })
    elseif toggle == "deactivate" then
        for i, v in ipairs(HouseCooldown) do
            if v.id == id then
                table.remove(HouseCooldown, i)
                break
            end
        end
    end  
end)

lib.callback.register('y0-houserobbery:server:removeItem', function(source, removedItem)
    local src = source
    local xPlayer = RSGCore.Functions.GetPlayer(src)
    return xPlayer.Functions.RemoveItem(removedItem,1)
end)


lib.callback.register('y0-houserobbery:server:checkCooldown', function(source, id, data)
    for i, v in ipairs(HouseCooldown) do
        if v.id == id then
            if v.cooldown > os.time() then
                return true 
            else
                table.remove(HouseCooldown, i)
                return false
            end
        end
    end
    return false
end)

lib.callback.register('y0-houserobbery:server:checkLawmen', function(source, id, data)
    local players = RSGCore.Functions.GetPlayers()
    local count = 0

    for _, playerId in pairs(players) do
        local Player = RSGCore.Functions.GetPlayer(playerId)
        if Player and Player.PlayerData.job and Player.PlayerData.job.type == 'leo' then
            count = count + 1
        end
    end

    return count
end)

CreateThread(function()
    while true do
        local currentTime = os.time()
        for i = #HouseCooldown, 1, -1 do
            if HouseCooldown[i].cooldown <= currentTime then
                table.remove(HouseCooldown, i)
            end
        end
        Wait(1000) 
    end
end)