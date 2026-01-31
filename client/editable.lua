--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    Client Editable Functions - Customizable Minigames & Police System
    Copyright © 2026 LXR Development - All Rights Reserved
    
    This file contains functions that can be customized to work with your server setup:
    - Lockpicking minigame (can be replaced with your preferred system)
    - Location search minigame (can be replaced with your preferred system)
    - Police alert system (customize to work with your law enforcement script)
    
    CUSTOMIZATION NOTES:
    - Edit these functions to integrate with your server's existing systems
    - Ensure minigame functions return true/false for success/failure
    - Modify police alert to work with your preferred law enforcement resource
]]

local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

--────────────────────────────────────────────────────────────────────────────
-- MINIGAME FUNCTIONS (Customize these to match your server)
--────────────────────────────────────────────────────────────────────────────

--- Lockpicking minigame for breaking into houses
--- @return boolean success Whether the minigame was completed successfully
function Minigame()

    local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})

    return success 
end

--- Location search minigame for finding loot
--- @return boolean success Whether the minigame was completed successfully
function LocationMinigame()
    
    local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})

    return success 
end

--────────────────────────────────────────────────────────────────────────────
-- POLICE ALERT SYSTEM (Customize to match your law enforcement script)
--────────────────────────────────────────────────────────────────────────────

--- Triggers police alert for house robbery
--- @param coords vector3 Location coordinates of the robbery
--- @param houseName string Name of the house being robbed
function TriggerPolice(coords, houseName)
    
    TriggerServerEvent('rsg-lawman:server:lawmanAlert', "House Robbery", coords)
    TriggerServerEvent('rsg-tips:server:addCriminalActivity', "A witness has reported a break & enter", nil, coords)
    
    -- Trigger webhook for police alert
    TriggerServerEvent('lxr-houserob:server:PoliceAlert', coords, houseName or "Unknown House")
end