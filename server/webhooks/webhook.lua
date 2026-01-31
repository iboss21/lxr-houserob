--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    Discord Webhook System
    Copyright © 2026 LXR Development - All Rights Reserved
    
    This module handles all Discord webhook notifications for the house robbery system.
    Provides formatted embeds with player information, location data, and robbery details.
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

--────────────────────────────────────────────────────────────────────────────
-- WEBHOOK HELPER FUNCTIONS
--────────────────────────────────────────────────────────────────────────────

--- Sends a formatted webhook to Discord
--- @param webhookType string The type of webhook to send (RobberyAttempt, RobberySuccess, etc.)
--- @param embedData table Data to include in the embed
local function SendWebhook(webhookType, embedData)
    -- Check if webhooks are enabled
    if not Config.Webhooks or not Config.Webhooks.Enabled then
        return
    end
    
    -- Get webhook type configuration
    local webhookConfig = Config.Webhooks.Types[webhookType]
    if not webhookConfig or not webhookConfig.enabled then
        return
    end
    
    -- Get webhook URL
    local webhookURL = Config.Webhooks.URLs[webhookType]
    if not webhookURL or webhookURL == '' then
        print('[LXR-HouseRob] Warning: Webhook URL not configured for type: ' .. webhookType)
        return
    end
    
    -- Prepare embed
    local embed = {
        {
            ['title'] = webhookConfig.title,
            ['color'] = webhookConfig.color or Config.Webhooks.Settings.Color,
            ['fields'] = embedData.fields or {},
            ['footer'] = {
                ['text'] = Config.Webhooks.Settings.Footer,
            },
            ['timestamp'] = Config.Webhooks.Settings.Timestamp and os.date('!%Y-%m-%dT%H:%M:%S') or nil,
        }
    }
    
    -- Add description if provided
    if embedData.description then
        embed[1]['description'] = embedData.description
    end
    
    -- Add thumbnail if provided
    if embedData.thumbnail then
        embed[1]['thumbnail'] = { ['url'] = embedData.thumbnail }
    end
    
    -- Prepare webhook payload
    local payload = {
        username = Config.Webhooks.Settings.BotName,
        avatar_url = Config.Webhooks.Settings.BotAvatar,
        embeds = embed
    }
    
    -- Send webhook
    PerformHttpRequest(webhookURL, function(statusCode, response, headers)
        if statusCode ~= 204 then
            print('[LXR-HouseRob] Webhook Error: ' .. tostring(statusCode))
            if response then
                print('[LXR-HouseRob] Response: ' .. tostring(response))
            end
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

--────────────────────────────────────────────────────────────────────────────
-- WEBHOOK EVENT FUNCTIONS
--────────────────────────────────────────────────────────────────────────────

--- Sends robbery attempt notification
--- @param source number Player server ID
--- @param houseId number House ID being robbed
--- @param houseName string Name of the house
--- @param location vector3 Location coordinates
function SendRobberyAttemptWebhook(source, houseId, houseName, location)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local coords = string.format('X: %.2f, Y: %.2f, Z: %.2f', location.x, location.y, location.z)
    
    local embedData = {
        description = 'A player is attempting to rob a house!',
        fields = {
            { name = '👤 Player', value = GetPlayerName(source), inline = true },
            { name = '🆔 Citizen ID', value = Player.PlayerData.citizenid, inline = true },
            { name = '🏠 House', value = houseName .. ' (ID: ' .. houseId .. ')', inline = false },
            { name = '📍 Location', value = coords, inline = false },
            { name = '⏰ Time', value = os.date('%Y-%m-%d %H:%M:%S'), inline = false },
        }
    }
    
    SendWebhook('RobberyAttempt', embedData)
end

--- Sends successful robbery notification
--- @param source number Player server ID
--- @param houseId number House ID that was robbed
--- @param houseName string Name of the house
--- @param rewards table Array of items stolen
function SendRobberySuccessWebhook(source, houseId, houseName, rewards)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- Format rewards list
    local rewardsList = ''
    if rewards and #rewards > 0 then
        for i, reward in ipairs(rewards) do
            rewardsList = rewardsList .. '• ' .. reward.item .. ' x' .. reward.amount
            if i < #rewards then
                rewardsList = rewardsList .. '\n'
            end
        end
    else
        rewardsList = 'No items stolen'
    end
    
    local embedData = {
        description = 'A player successfully completed a house robbery!',
        fields = {
            { name = '👤 Player', value = GetPlayerName(source), inline = true },
            { name = '🆔 Citizen ID', value = Player.PlayerData.citizenid, inline = true },
            { name = '🏠 House', value = houseName .. ' (ID: ' .. houseId .. ')', inline = false },
            { name = '💰 Items Stolen', value = rewardsList, inline = false },
            { name = '⏰ Time', value = os.date('%Y-%m-%d %H:%M:%S'), inline = false },
        }
    }
    
    SendWebhook('RobberySuccess', embedData)
end

--- Sends police alert notification
--- @param source number Player server ID
--- @param location vector3 Location coordinates
--- @param houseName string Name of the house
function SendPoliceAlertWebhook(source, location, houseName)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local coords = string.format('X: %.2f, Y: %.2f, Z: %.2f', location.x, location.y, location.z)
    
    local embedData = {
        description = '🚨 ALERT: A robbery is in progress! Law enforcement has been notified.',
        fields = {
            { name = '👤 Suspect', value = GetPlayerName(source), inline = true },
            { name = '🆔 Citizen ID', value = Player.PlayerData.citizenid, inline = true },
            { name = '🏠 Location', value = houseName, inline = false },
            { name = '📍 Coordinates', value = coords, inline = false },
            { name = '⏰ Alert Time', value = os.date('%Y-%m-%d %H:%M:%S'), inline = false },
        }
    }
    
    SendWebhook('PoliceAlert', embedData)
end

--- Sends player caught/killed notification
--- @param source number Player server ID
--- @param houseId number House ID where event occurred
--- @param houseName string Name of the house
--- @param reason string Reason (caught by NPC, killed by dog, etc.)
function SendPlayerCaughtWebhook(source, houseId, houseName, reason)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local embedData = {
        description = 'A player was caught or killed during a robbery attempt!',
        fields = {
            { name = '👤 Player', value = GetPlayerName(source), inline = true },
            { name = '🆔 Citizen ID', value = Player.PlayerData.citizenid, inline = true },
            { name = '🏠 House', value = houseName .. ' (ID: ' .. houseId .. ')', inline = false },
            { name = '⚠️ Reason', value = reason, inline = false },
            { name = '⏰ Time', value = os.date('%Y-%m-%d %H:%M:%S'), inline = false },
        }
    }
    
    SendWebhook('PlayerCaught', embedData)
end

--────────────────────────────────────────────────────────────────────────────
-- EXPORTS
--────────────────────────────────────────────────────────────────────────────

-- Export functions for use in other server files
exports('SendRobberyAttemptWebhook', SendRobberyAttemptWebhook)
exports('SendRobberySuccessWebhook', SendRobberySuccessWebhook)
exports('SendPoliceAlertWebhook', SendPoliceAlertWebhook)
exports('SendPlayerCaughtWebhook', SendPlayerCaughtWebhook)
