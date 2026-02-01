--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    Client Main Script - House Entry & Robbery Zones
    Copyright © 2026 LXR Development - All Rights Reserved
    
    This script handles the main client-side logic for house robbery initiation:
    - Creates interaction zones at house entrances
    - Handles lockpicking minigame
    - Manages cooldown and lawmen checks
    - Triggers police alerts based on configured chances
]]

local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

CreateThread(function()

	for k,v in pairs(Config.HousesToRob) do
		exports.ox_target:addSphereZone({
            name = v.name,
            coords = vec3(v.entercoords.x, v.entercoords.y, v.entercoords.z),
            radius = 1.0,
            debug = false,
            options = {
            	label = locale('Rob_House'),
                canInteract = function()
                    return true -- Item check will be done server-side
                end,
            	onSelect = function()
                    -- Check if player has required item
                    local hasItem = lib.callback.await('lxr-houserob:server:hasItem', false, Config.BreakIn.requiredItem)
                    if not hasItem then 
                        lib.notify({
                            type = 'error',
                            title = locale('house_robbery'),
                            description = locale('need_lockpick')
                        })
                        return 
                    end
                    
            		local count = lib.callback.await('lxr-houserob:server:checkLawmen')
            		if count < Config.LawEnforcement.lawmenMinimum then 
                        lib.notify({
                            type = 'error',
                            title = locale('house_robbery'),
                            description = locale('not_enough_lawmen')
                        })
                        return 
                    end
            		local inCooldown = lib.callback.await('lxr-houserob:server:checkCooldown', false, k, v)
            		if inCooldown then 
                        lib.notify({
                            type = 'error',
                            title = locale('house_robbery'),
                            description = locale('house_on_cooldown')
                        })
                        return 
                    end
                    local playerPed = PlayerPedId()
                    local animDict = Config.Animations.HouseEnter.anim
                    local animClip = Config.Animations.HouseEnter.clip

                    RequestAnimDict(animDict)
                        while not HasAnimDictLoaded(animDict) do
                            Citizen.Wait(100)
                        end
                        SetEntityHeading(playerPed,GetEntityHeading(playerPed))
                        local entercoords = vec3(v.entercoords.x, v.entercoords.y, v.entercoords.z - 1.0)
                        SetEntityCoords(playerPed, entercoords,true,false,false,false)
                        SetEntityHeading(playerPed, v.entercoords.w)
                        TaskPlayAnim(playerPed,animDict,animClip,8.0,-8.0,-1, 1,0.0,false,false,false)

                        local success = Minigame()

                        if success then
                            ClearPedTasks(playerPed)
                            local entercoords = vec3(v.entercoords.x, v.entercoords.y, v.entercoords.z)
                            local chance = math.random(1,99)
                            if chance < Config.PoliceAlert.alertChance then
                                TriggerPolice(entercoords, v.name)
                            end
                            lib.callback.await('lxr-houserob:server:removeItem', false, Config.BreakIn.requiredItem)
                            TriggerServerEvent('lxr-houserob:server:TriggerCooldown', "activate",k)
                            EnterHouse(k, v)
                        else
                            -- Minigame failed
                            if Config.BreakIn.lockpickBreaksOnError then
                                lib.callback.await('lxr-houserob:server:removeItem', false, Config.BreakIn.requiredItem)
                            end
                        end

                    ClearPedTasks(playerPed)
            	end,
            }
            })
	end

end)