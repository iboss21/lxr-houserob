--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    Server Main Script - Robbery Management & Callbacks
    Copyright © 2026 LXR Development - All Rights Reserved
    
    This script handles server-side robbery logic:
    - Reward distribution and item management
    - Cooldown system for houses
    - Lawmen count checking
    - Routing bucket management for instanced interiors
    - Server callbacks for client validation
]]

local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

--────────────────────────────────────────────────────────────────────────────
-- GLOBAL VARIABLES
--────────────────────────────────────────────────────────────────────────────
HouseCooldown = {}
Cooldown = Config.HouseCooldowns

-- Track robbery rewards for webhook reporting
local RobberyRewards = {} -- Format: [source] = { {item = "itemname", amount = 1}, ... }

--────────────────────────────────────────────────────────────────────────────
-- REWARD DISTRIBUTION
--────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('y0-houserobbery:server:ReceiveReward', function(data, id)

    local _source = source
    local Player = RSGCore.Functions.GetPlayer(_source)
    local reward = data.locations[id].rewards
    local randomReward = reward[math.random(1, #reward)]
    local randomAmount = math.random(data.locations[id].rewardsAmount.min,data.locations[id].rewardsAmount.max)
    if not Player then return end

    Player.Functions.AddItem(randomReward,randomAmount)

    -- Track rewards for webhook
    if not RobberyRewards[_source] then
        RobberyRewards[_source] = {}
    end
    table.insert(RobberyRewards[_source], {item = randomReward, amount = randomAmount})

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

    -- Track rewards for webhook
    if not RobberyRewards[_source] then
        RobberyRewards[_source] = {}
    end
    table.insert(RobberyRewards[_source], {item = randomReward, amount = randomAmount})

    TriggerClientEvent('ox_lib:notify', _source, {
        type = 'success',
        title = locale('house_robbery'),
        description = locale('Received') .. randomReward .. ' '..randomAmount..'x',
    })
end)

--────────────────────────────────────────────────────────────────────────────
-- ROUTING BUCKET MANAGEMENT
--────────────────────────────────────────────────────────────────────────────

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

        -- Send robbery attempt webhook
        if Config.Webhooks and Config.Webhooks.Enabled then
            exports['lxr-houserob']:SendRobberyAttemptWebhook(src, id, data.name, data.entercoords)
        end

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
        
        -- Send successful robbery webhook with collected rewards
        if Config.Webhooks and Config.Webhooks.Enabled and RobberyRewards[_source] then
            exports['lxr-houserob']:SendRobberySuccessWebhook(_source, id, data.name, RobberyRewards[_source])
            RobberyRewards[_source] = nil -- Clear rewards after reporting
        end
    end
end)

--────────────────────────────────────────────────────────────────────────────
-- POLICE ALERT WEBHOOK
--────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('y0-houserobbery:server:PoliceAlert', function(coords, houseName)
    local _source = source
    
    -- Send police alert webhook
    if Config.Webhooks and Config.Webhooks.Enabled then
        exports['lxr-houserob']:SendPoliceAlertWebhook(_source, coords, houseName)
    end
end)

--────────────────────────────────────────────────────────────────────────────
-- COOLDOWN MANAGEMENT
--────────────────────────────────────────────────────────────────────────────

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

--────────────────────────────────────────────────────────────────────────────
-- SERVER CALLBACKS
--────────────────────────────────────────────────────────────────────────────

--- Removes item from player's inventory
--- @param source number Player server ID
--- @param removedItem string Item name to remove
--- @return boolean success Whether item was successfully removed
lib.callback.register('y0-houserobbery:server:removeItem', function(source, removedItem)
    local src = source
    local xPlayer = RSGCore.Functions.GetPlayer(src)
    return xPlayer.Functions.RemoveItem(removedItem,1)
end)

--- Checks if a house is on cooldown
--- @param source number Player server ID
--- @param id number House ID to check
--- @param data table House data
--- @return boolean inCooldown Whether the house is on cooldown
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

--- Checks the number of law enforcement officers online
--- @param source number Player server ID
--- @return number count Number of lawmen online
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

--────────────────────────────────────────────────────────────────────────────
-- COOLDOWN CLEANUP THREAD
--────────────────────────────────────────────────────────────────────────────

--- Automatically cleanup expired cooldowns
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