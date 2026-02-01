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

-- Detected inventory system
local DetectedInventory = nil

-- Framework Core object (dynamically initialized based on Config.Framework)
local Core = nil
local function GetCore()
    if Core then return Core end
    
    -- Try to get core object based on configured framework
    local frameworkConfig = Config.FrameworkTriggers[Config.Framework]
    if frameworkConfig then
        local success, coreObj = pcall(function()
            return exports[frameworkConfig.resource]:GetCoreObject()
        end)
        if success and coreObj then
            Core = coreObj
            print('[LXR-HouseRob] Framework initialized: ' .. Config.Framework)
            return Core
        end
    end
    
    -- Fallback to RSGCore if config doesn't work
    Core = RSGCore
    print('[LXR-HouseRob] Using default framework: rsg-core')
    return Core
end

-- Initialize Core on script load
Core = GetCore()

--────────────────────────────────────────────────────────────────────────────
-- INVENTORY SYSTEM COMPATIBILITY LAYER
--────────────────────────────────────────────────────────────────────────────

--- Detects the inventory system being used on the server
--- @return string|nil inventorySystem The detected inventory system
local function DetectInventorySystem()
    if DetectedInventory then return DetectedInventory end
    
    -- Check if specific inventory system is configured
    if Config.Inventory.system ~= 'auto' then
        DetectedInventory = Config.Inventory.system
        print('[LXR-HouseRob] Using configured inventory system: ' .. DetectedInventory)
        return DetectedInventory
    end
    
    -- Auto-detect inventory system by checking for running resources
    local inventoryResources = {
        'rsg-inventory',
        'lxr-inventory', 
        'qb-inventory'
    }
    
    for _, resourceName in ipairs(inventoryResources) do
        if GetResourceState(resourceName) == 'started' then
            DetectedInventory = resourceName
            print('[LXR-HouseRob] Auto-detected inventory system: ' .. DetectedInventory)
            return DetectedInventory
        end
    end
    
    -- Default to core framework functions (use framework name directly, not with -core suffix)
    local framework = Config.Framework or 'rsg-core'
    -- Strip any existing -core suffix to avoid doubling
    framework = framework:gsub('%-core$', '')
    DetectedInventory = framework .. '-core'
    print('[LXR-HouseRob] Using core framework inventory: ' .. DetectedInventory)
    return DetectedInventory
end

--- Adds an item to player's inventory using the appropriate inventory system
--- @param source number Player server ID
--- @param item string Item name
--- @param amount number Amount to add
--- @param metadata table|nil Optional item metadata
--- @return boolean success Whether item was successfully added
local function AddInventoryItem(source, item, amount, metadata)
    local Player = Core.Functions.GetPlayer(source)
    if not Player then 
        print('[LXR-HouseRob] ERROR: Player not found for source ' .. source)
        return false 
    end
    
    local inventorySystem = DetectInventorySystem()
    local success = false
    
    -- Try inventory-specific export first
    if Config.Inventory.exports[inventorySystem] then
        local status, result = pcall(function()
            return Config.Inventory.exports[inventorySystem].addItem(source, item, amount, metadata)
        end)
        
        if status then
            success = result ~= false
            if success then
                print('[LXR-HouseRob] Added item via ' .. inventorySystem .. ': ' .. item .. ' x' .. amount)
            end
        else
            print('[LXR-HouseRob] ERROR calling ' .. inventorySystem .. ' export: ' .. tostring(result))
        end
    end
    
    -- Fallback to core framework method
    if not success then
        local status, result = pcall(function()
            return Player.Functions.AddItem(item, amount, false, metadata)
        end)
        
        if status and result ~= false then
            success = true
            print('[LXR-HouseRob] Added item via core framework: ' .. item .. ' x' .. amount)
        else
            print('[LXR-HouseRob] ERROR adding item via core framework: ' .. tostring(result))
        end
    end
    
    return success
end

--- Removes an item from player's inventory using the appropriate inventory system
--- @param source number Player server ID
--- @param item string Item name
--- @param amount number Amount to remove
--- @return boolean success Whether item was successfully removed
local function RemoveInventoryItem(source, item, amount)
    local Player = Core.Functions.GetPlayer(source)
    if not Player then 
        print('[LXR-HouseRob] ERROR: Player not found for source ' .. source)
        return false 
    end
    
    local inventorySystem = DetectInventorySystem()
    local success = false
    
    -- Try inventory-specific export first
    if Config.Inventory.exports[inventorySystem] then
        local status, result = pcall(function()
            return Config.Inventory.exports[inventorySystem].removeItem(source, item, amount)
        end)
        
        if status then
            success = result ~= false
            if success then
                print('[LXR-HouseRob] Removed item via ' .. inventorySystem .. ': ' .. item .. ' x' .. amount)
            end
        else
            print('[LXR-HouseRob] ERROR calling ' .. inventorySystem .. ' export: ' .. tostring(result))
        end
    end
    
    -- Fallback to core framework method
    if not success then
        local status, result = pcall(function()
            return Player.Functions.RemoveItem(item, amount)
        end)
        
        if status and result ~= false then
            success = true
            print('[LXR-HouseRob] Removed item via core framework: ' .. item .. ' x' .. amount)
        else
            print('[LXR-HouseRob] ERROR removing item via core framework: ' .. tostring(result))
        end
    end
    
    return success
end

--────────────────────────────────────────────────────────────────────────────
-- REWARD DISTRIBUTION
--────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('lxr-houserob:server:ReceiveReward', function(data, id)

    local _source = source
    local Player = Core.Functions.GetPlayer(_source)
    local reward = data.locations[id].rewards
    local randomReward = reward[math.random(1, #reward)]
    local randomAmount = math.random(data.locations[id].rewardsAmount.min,data.locations[id].rewardsAmount.max)
    if not Player then return end

    -- Add item using compatibility layer
    local success = AddInventoryItem(_source, randomReward, randomAmount)
    
    if not success then
        print('[LXR-HouseRob] ERROR: Failed to add item to inventory for player ' .. _source)
        TriggerClientEvent('ox_lib:notify', _source, {
            type = 'error',
            title = locale('house_robbery'),
            description = 'Failed to receive item. Contact an administrator.',
        })
        return
    end

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


RegisterNetEvent('lxr-houserob:server:ReceiveSpecialReward', function(data, id)

    local _source = source
    local Player = Core.Functions.GetPlayer(_source)
    local reward = data.SpecialProp.rewards
    local randomReward = reward[math.random(1, #reward)]
    local randomAmount = math.random(data.SpecialProp.rewardsAmount.min,data.SpecialProp.rewardsAmount.max)
    if not Player then return end

    -- Add item using compatibility layer
    local success = AddInventoryItem(_source, randomReward, randomAmount)
    
    if not success then
        print('[LXR-HouseRob] ERROR: Failed to add special item to inventory for player ' .. _source)
        TriggerClientEvent('ox_lib:notify', _source, {
            type = 'error',
            title = locale('house_robbery'),
            description = 'Failed to receive special item. Contact an administrator.',
        })
        return
    end

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

RegisterNetEvent('lxr-houserob:server:RoutingBucketPed', function(ped)
    local _source = source
        SetEntityRoutingBucket(NetworkGetEntityFromNetworkId(ped), GetPlayerRoutingBucket(_source))
end)

RegisterNetEvent('lxr-houserob:server:RoutingBucket', function(toggle,data, id)
    local _source = source
    local Player = Core.Functions.GetPlayer(_source)
    local bucketId = math.random(400,760)

    if not Player then return end

    local ped = GetPlayerPed(_source)

    if toggle == "Enter" then
        SetPlayerRoutingBucket(_source, bucketId)
        
        local src = source
        local Player = Core.Functions.GetPlayer(src)
        local Playercid = Player.PlayerData.citizenid
        local discord = Core.Functions.GetIdentifier(src, 'discord') 
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

RegisterNetEvent('lxr-houserob:server:PoliceAlert', function(coords, houseName)
    local _source = source
    
    -- Send police alert webhook
    if Config.Webhooks and Config.Webhooks.Enabled then
        exports['lxr-houserob']:SendPoliceAlertWebhook(_source, coords, houseName)
    end
end)

--────────────────────────────────────────────────────────────────────────────
-- COOLDOWN MANAGEMENT
--────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('lxr-houserob:server:TriggerCooldown', function(toggle, id)
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
lib.callback.register('lxr-houserob:server:removeItem', function(source, removedItem)
    local src = source
    return RemoveInventoryItem(src, removedItem, 1)
end)

--- Checks if player has an item in their inventory
--- @param source number Player server ID
--- @param item string Item name to check
--- @return boolean hasItem Whether player has the item
lib.callback.register('lxr-houserob:server:hasItem', function(source, item)
    local Player = Core.Functions.GetPlayer(source)
    if not Player then 
        print('[LXR-HouseRob] ERROR: Player not found for source ' .. source)
        return false 
    end
    
    -- Try to get item from player's inventory
    local hasItem = Player.Functions.GetItemByName(item)
    return hasItem ~= nil
end)

--- Checks if a house is on cooldown
--- @param source number Player server ID
--- @param id number House ID to check
--- @param data table House data
--- @return boolean inCooldown Whether the house is on cooldown
lib.callback.register('lxr-houserob:server:checkCooldown', function(source, id, data)
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
lib.callback.register('lxr-houserob:server:checkLawmen', function(source, id, data)
    local players = Core.Functions.GetPlayers()
    local count = 0

    for _, playerId in pairs(players) do
        local Player = Core.Functions.GetPlayer(playerId)
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