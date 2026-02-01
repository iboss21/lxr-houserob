--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    Client Functions - Interior Robbery Mechanics
    Copyright © 2026 LXR Development - All Rights Reserved
    
    This script handles interior house robbery functionality:
    - House entry and exit teleportation
    - NPC and dog spawning
    - Loot location creation and interaction
    - Search minigames and prop management
    - Routing bucket handling for instanced interiors
]]

local RSGCore = exports['rsg-core']:GetCoreObject()

RobLocations = {}
NpcPeds = {}
Props = {}
IsInside = false
noise = 0
Alerted = false

SetNuiFocus(false, false)

function EnterHouse(id, data)
	local playerPed = PlayerPedId()
	local coords = data.houseInformation.exit
	local houseData = data.houseInformation

	DoScreenFadeOut(2000)
	Wait(2000)
	TriggerServerEvent('lxr-houserob:server:RoutingBucket', "Enter", data,id)
	SetEntityCoords(playerPed, coords.x, coords.y, coords.z + 0.2, 1, 0, 0, 0)
	FreezeEntityPosition(playerPed, true)
	Wait(4000)
	DoScreenFadeIn(600)
	TriggerServerEvent('y0-houseroberry:server:CreatLogs', id, data)
	exports.weathersync:setSyncEnabled(true)
	local randomCount = math.random(1,99)
	if randomCount < houseData.SpecialProp.chance then
	local specialProp = CreateObject(GetHashKey(houseData.SpecialProp.prop), houseData.SpecialProp.coords.x, houseData.SpecialProp.coords.y, houseData.SpecialProp.coords.z - 1.0, true, true, false)
	FreezeEntityPosition(specialProp, true)
	SetEntityHeading(specialProp, houseData.SpecialProp.coords.w or 0.0)
	table.insert(Props, { prop = specialProp, zone = zoneName, name = houseData.SpecialProp.prop })

	exports.ox_target:addLocalEntity(specialProp, {
		name = locale('Rob_Location')..specialProp,
		label = locale('Rob_Location'),
		distance = 2.0,
		onSelect = function()
			Wait(200)
			local success = LocationMinigame()
			if success then
				local progressBar = lib.progressCircle({
					position = 'middle',
					duration = Config.Search.searchTime,
					label = locale('searching_location'),
					useWhileDead = false,
					canCancel = false,
					disable = {
						move = true,
						mouse = true,	
					},
				})

				if progressBar then
					TriggerServerEvent('lxr-houserob:server:ReceiveSpecialReward', houseData)

					if Config.Props.deleteAfterInteraction then
						DeleteEntity(specialProp)

					end
				end
			end
		end,
	})
end

	Wait(1000)
	for k, location in pairs(houseData.locations) do
		if location.prop and location.coords then
			local prop = CreateObject(GetHashKey(location.prop), location.coords.x, location.coords.y, location.coords.z , true, true, false)
			SetEntityRotation(prop, location.rot.x, location.rot.y, location.rot.z, 2, true)
			FreezeEntityPosition(prop, true)
			local zoneName = locale('Rob_Location')..id..'_'..k
			table.insert(Props, { prop = prop, zone = zoneName, name = location.prop })
		
			local coords = location.coords
			local zoneName = locale('Rob_Location')..id..'_'..k
		
			exports.ox_target:addLocalEntity(prop,{
 				{
				name = zoneName,
				label = locale('Rob_Location'),
				onSelect = function()
					Wait(200)
					local success = LocationMinigame()
					if success then
					local progressBar = lib.progressCircle({
					position = 'middle',
				    duration = Config.Search.searchTime,
				    label = locale('searching_location'),
				    useWhileDead = false,
    				canCancel = false,
    				disable = {
    					move = true,
    					mouse = true,	
    				},
    				})
					table.insert(RobLocations, { zone = zoneName, coords = coords, id = id })
    				if progressBar then
						TriggerServerEvent('lxr-houserob:server:ReceiveReward', houseData, k)
							if Config.Props.deleteAfterInteraction then
								for i, propData in ipairs(Props) do
									if propData.zone == zoneName  then
										DeleteObject(propData.prop)
										table.remove(Props, i)
										break
									end
								end
							end
							exports.ox_target:removeZone(zoneName)
						end
					end
				end,
			}
		})
		end
	end
	local randomChanceDog = math.random(1,99)
	if randomChanceDog < houseData.Dog.chance then
		RequestModel(houseData.Dog.model)
		while not HasModelLoaded(houseData.Dog.model) do Wait(10) end
		local dogCoords = vec3(houseData.Dog.coords.x, houseData.Dog.coords.y, houseData.Dog.coords.z)
		local npcDog = jo.entity.create(houseData.Dog.model, dogCoords, math.random(0, 360), true, 0)
		Citizen.InvokeNative(0x283978A15512B2FE, npcDog, true)
		FreezeEntityPosition(npcDog, true)
		TriggerServerEvent('lxr-houserob:server:RoutingBucketPed', PedToNet(npcDog))
		TaskCombatPed(npcDog, playerPed, 0, 16)
		SetEntityAsMissionEntity(npcDog, true, true)
		table.insert(NpcPeds, { ped = npcDog })
		Wait(500)
		FreezeEntityPosition(npcDog, false)
	end
	FreezeEntityPosition(playerPed, false)

	-- NPC spawn chance is configured per-house, not globally
	-- Check the house configuration for npcModel to determine if NPC should spawn
	local npcChance = 100 -- Default to always spawn if npcModel is defined
	if npcChance < 100 then -- This condition is now redundant but kept for compatibility

		RequestModel(houseData.npcModel)
		while not HasModelLoaded(houseData.npcModel) do Wait(10) end
		local npcSpawnLocation = houseData.npcSpawnLocation
		NpcPed = jo.entity.create(houseData.npcModel, npcSpawnLocation, math.random(0, 360), true, 0)
		TriggerServerEvent('lxr-houserob:server:RoutingBucketPed', PedToNet(NpcPed))
		FreezeEntityPosition(NpcPed, true)
		Citizen.InvokeNative(0x283978A15512B2FE, NpcPed, true)
		Citizen.InvokeNative(0x5E3BDDBCB83F3D84, NpcPed, GetHashKey(houseData.npcWeapon), houseData.ammoCount, false, true, true)
		TaskCombatPed(NpcPed, playerPed, 0, 16)
		SetEntityAsMissionEntity(NpcPed, true, true)
		table.insert(NpcPeds, { ped = NpcPed })
		Wait(500)
		FreezeEntityPosition(NpcPed, false)
	end
	IsInside = true
	ClearPedTasks(playerPed)
		CreateThread(function ()
    Wait(0)
    local ped = PlayerPedId()
    while IsInside do

		
    	Wait(300)
    	SendNUIMessage({ action = "show" })
        local crouched = GetPedCrouchMovement(ped)
        if crouched == 0 then
            noise = noise + 20
            SendNUIMessage({ action = "updateNoise", noise = noise })
            Wait(1000)
        end
        Wait(300)
        if IsPedShooting(ped) then
            noise = noise + 100
            SendNUIMessage({ action = "updateNoise", noise = noise })
            Wait(1000)
        end
        local speed = GetEntitySpeed(ped)
        if speed > 1.7 then
            noise = noise + 10
            SendNUIMessage({ action = "updateNoise", noise = noise })
            Wait(1000)
            if speed > 2.5 then
                noise = noise + 15
                SendNUIMessage({ action = "updateNoise", noise = noise })
                Wait(1000)
        	end
            if speed > 3.0 then
                noise = noise + 20
                SendNUIMessage({ action = "updateNoise", noise = noise })
                Wait(1000)
      
        	end
        else
            Wait(1000)
            if noise < 0 then
                noise = 0
            end

			noise = noise - 10
			SendNUIMessage({ action = "updateNoise", noise = noise })
            Wait(1000)
        
        end
        if IsPedDeadOrDying(playerPed) then
    		Wait(100)
    		IsInside = false
    		Alerted = false
    		noise = 0
    		DoScreenFadeOut(2000)
			Wait(2000)
			SendNUIMessage({ action = "hide" })
			SetEntityCoords(playerPed, data.entercoords.x, data.entercoords.y, data.entercoords.z + 0.5, 1, 0, 0, 0)

			Wait(4000)
			DoScreenFadeIn(800)
			TriggerServerEvent('lxr-houserob:server:RoutingBucket', "Exit",data,id)

			for i, propData in ipairs(Props) do
				if propData.zone == zoneName and DoesEntityExist(propData.prop) then
					
					DeleteEntity(propData.prop)
					table.remove(Props, i)
					break
				end
			end
					
			for k,v in pairs(RobLocations) do
				
				exports.ox_target:removeZone(RobLocations[k].zone)
				table.remove(RobLocations, k)
			end

			for k,v in pairs(NpcPeds) do
				if DoesEntityExist(NpcPeds[k].ped) then
					DeletePed(NpcPeds[k].ped)
					table.remove(NpcPeds, k)
				end
			end

			SendNUIMessage({ action = "hide" })
    	end
        if noise >= 100 then
            local lawcoords = vec3(data.entercoords.x,data.entercoords.y,data.entercoords.z)
            
            if not Alerted then
            	TriggerPolice(lawcoords)
            	Alerted = true
        	end
        end
    end
end)

	

	local exitCoords = houseData.exit
	local exitZoneName = locale('Exit_house')..id

	exports.ox_target:addSphereZone({
		name = exitZoneName,
		coords = vec3(exitCoords.x, exitCoords.y, exitCoords.z + 1.0),
		radius = 1.0,
		distance = 2.0,
		debug = false,
		options = {
			label = locale('Exit_house'),
			onSelect = function()
				IsInside = false
				exports.ox_target:removeZone(exitZoneName)
				SendNUIMessage({ action = "hide" })
				noise = 0

				DoScreenFadeOut(2000)
				Wait(2000)
				
					for i, propData in ipairs(Props) do
						if propData.zone then
							DeleteEntity(propData.prop)
							table.remove(Props, i)
							break
						end
					end
					for y, robLocation in ipairs(RobLocations) do
						if robLocation.zone then
							exports.ox_target:removeZone(robLocation.zone)
							table.remove(RobLocations, y)
						end
					end
					
					
					for k,v in pairs(NpcPeds) do
						if DoesEntityExist(NpcPeds[k].ped) then
							DeletePed(NpcPeds[k].ped)
							table.remove(NpcPeds, k)
						end
					end

				Alerted = false
				SendNUIMessage({ action = "hide" })
				SetEntityCoords(playerPed, data.entercoords.x, data.entercoords.y, data.entercoords.z + 0.5, 1, 0, 0, 0)
				TriggerServerEvent('lxr-houserob:server:RoutingBucket', "Exit", data,id)
				Wait(4000)
				SendNUIMessage({ action = "hide" })
				DoScreenFadeIn(800)
			end,
		}
	})
end


AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for k,v in pairs(NpcPeds) do
        if DoesEntityExist(NpcPeds[k].ped) then
            DeletePed(NpcPeds[k].ped)
        end
    end
    for k,v in pairs(Props) do
        if DoesEntityExist(Props[k].prop) then
            DeleteEntity(Props[k].prop)
        end
    end
 
end)
