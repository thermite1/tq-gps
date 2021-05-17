ESX, gps, blips = nil, false, {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('tq_gps:ac')
AddEventHandler('tq_gps:ac', function()
  gpsacilsin(true)
end)

RegisterNetEvent('tq_gps:client:bool')
AddEventHandler('tq_gps:client:bool', function(bool)
  gps = bool
end)

RegisterNUICallback('gpskatil', function(data, cb)
  if not gps then
    gps = true
    TriggerServerEvent('tq:gps:server:openGPS', data.channel)
    -- TriggerEvent('vlad-policeAlert:client:setgpsName', "["..data.channel.."]")
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'GPS\'iniz açıldı!', length = 5000})
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz zaten açık!', length = 5000})
  end 
end)

RegisterNUICallback('gpsayril', function(data, cb)
  if gps then
    gps = false
    TriggerServerEvent('tq:gps:server:closeGPS')
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'GPS\'iniz kapatıldı!', length = 5000})
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz zaten kapalı!', length = 5000})
  end
end)

RegisterNUICallback('escape', function(data, cb)
  SetNuiFocus(false, false)
  gpsMenu = false
  cb('ok')
end)

function gpsacilsin(enable)
  if enable then
    SetNuiFocus(enable, enable)
    SendNUIMessage({
      type = "open",
    })
    gpsMenu = enable
  end
end

RegisterNetEvent('tq:gps:client:getPlayerInfo')
AddEventHandler('tq:gps:client:getPlayerInfo', function(bliptable)
    if GetPlayerServerId(PlayerId()) ~= bliptable.src then
        if DoesBlipExist(blips[bliptable.src]) then
            SetBlipCoords(blips[bliptable.src], bliptable.coord.x, bliptable.coord.y, bliptable.coord.z)
            SetBlipSprite(blips[bliptable.src], bliptable.sprite)
            SetBlipScale(blips[bliptable.src], bliptable.scale)
            SetBlipAsShortRange(blips[bliptable.src], true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(bliptable.text)
            EndTextCommandSetBlipName(blips[bliptable.src])
            if bliptable.job == 'ambulance' then
              SetBlipColour(blips[bliptable.src], 49)
            end
        else
            blips[bliptable.src] = AddBlipForCoord(bliptable.coord.x, bliptable.coord.y, bliptable.coord.z)
            SetBlipSprite(blips[bliptable.src], bliptable.sprite)
            SetBlipScale(blips[bliptable.src], bliptable.scale)
            SetBlipAsShortRange(blips[bliptable.src], true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(bliptable.text)
            EndTextCommandSetBlipName(blips[bliptable.src])
            SetBlipColour(blips[bliptable.src], bliptable.color)
            if bliptable.job == 'ambulance' then
              SetBlipColour(blips[bliptable.src], 49)
            end
        end
    end
end)

RegisterNetEvent('tq:gps:client:removeBlip')
AddEventHandler('tq:gps:client:removeBlip', function(src)
    local blip = blips[src]
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
        blips[src] = nil
    end
end)

RegisterNetEvent('tq:gps:client:removeBlip2')
AddEventHandler('tq:gps:client:removeBlip2', function(src)
    local blip = blips[src]
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
        blips[src] = nil
    end
end)

RegisterNetEvent('tq:gps:client:forceCloseAllRemoveBlip')
AddEventHandler('tq:gps:client:forceCloseAllRemoveBlip', function()
    gps = false
    for k, v in pairs(blips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
        Citizen.Wait(0)
    end
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz kapatıldı!', length = 5000})
end)