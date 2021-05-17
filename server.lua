ESX, bliptable = nil, {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('gps', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('tq_gps:ac', source)
    end
end)

RegisterServerEvent('tq:gps:server:openGPS')
AddEventHandler('tq:gps:server:openGPS', function(code)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })


    table.insert(bliptable, {firstname = result[1].firstname, lastname = result[1].lastname, src = src, job = xPlayer.job.name, code = code})
end)

RegisterServerEvent('tq:gps:server:closeGPS')
AddEventHandler('tq:gps:server:closeGPS', function()
    local src = source

    for k = 1, #bliptable, 1 do
        TriggerClientEvent('tq:gps:client:removeBlip', bliptable[k].src, tonumber(src))
        TriggerClientEvent('tq:gps:client:removeBlip2', tonumber(src), bliptable[k].src)

    end

    for i = 1, #bliptable, 1 do
        if bliptable[i].src == tonumber(src) then
            table.remove(bliptable, i)
            return
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if #bliptable > 0 then
            for i = 1, #bliptable, 1 do
                local player = GetPlayerPed(bliptable[i].src)
                local coord = GetEntityCoords(player)
                local veh = GetVehiclePedIsIn(player, false)	
                local veh2 = GetEntityModel(veh)
                for k = 1, #bliptable, 1 do
                   
                    if veh2 == 353883353 then
                        thermitesprite = 15
                        thermitescale = 0.70
                    else
                        if bliptable[i].job == "ambulance" then
                            thermitesprite = 1
                            thermitescale = 0.80

                        elseif bliptable[i].job == "police" then
                            thermitescale = 0.50
                            if IsVehicleSirenOn(veh) then
                                thermitesprite = 42
                            else
                                thermitesprite = 41
                            end
                        end
                    end

                    TriggerClientEvent('tq:gps:client:getPlayerInfo', bliptable[k].src, {
                        coord = coord,
                        job = bliptable[i].job,
                        src = tonumber(bliptable[i].src),
                        text = '['..bliptable[i].code..'] - '..bliptable[i].firstname..' '..bliptable[i].lastname,
                        sprite = thermitesprite,
                        scale = thermitescale
                    })
                end
            end
        end
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    TriggerClientEvent('tq:gps:client:closed', src)

	if item == 'gps' and count < 1 then
		for k = 1, #bliptable, 1 do
            TriggerClientEvent('tq:gps:client:removeBlip', bliptable[k].src, tonumber(src))
            TriggerClientEvent('tq:gps:client:removeBlip', src, tonumber(bliptable[k].src))
        end
    
        for i = 1, #bliptable, 1 do
            if bliptable[i].src == src then
                table.remove(bliptable, i)
            end
        end
	end
end)

AddEventHandler('playerDropped', function()
    local src = source

    for k = 1, #bliptable, 1 do
        TriggerClientEvent('tq:gps:client:removeBlip', bliptable[k].src, tonumber(src))
        TriggerClientEvent('tq:gps:client:removeBlip2', tonumber(src), bliptable[k].src)

    end

    for i = 1, #bliptable, 1 do
        if bliptable[i].src == tonumber(src) then
            table.remove(bliptable, i)
            return
        end
    end
end)