ESX = nil
local PlayerData = {}
 
Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end
end)


-- blips   
Citizen.CreateThread(function()
    if Config.blip.enabled then
        local blip = AddBlipForCoord(Config.blip.coords) 
        SetBlipSprite(blip, Config.blip.sprite)
        SetBlipScale(blip, Config.blip.scale)  
        SetBlipColour(blip, Config.blip.color)
        SetBlipDisplay(blip, Config.blip.display)  
        SetBlipAsShortRange(blip, true)   
        BeginTextCommandSetBlipName("STRING")  
        AddTextComponentString(Config.blip.text)
        EndTextCommandSetBlipName(blip)  
    end
end)
vehicles = {}

local notLoaded = true
Citizen.CreateThread(function ()
    while notLoaded do
        distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.auto[1].loc)
        if  distance <= 30 then
            -- print(notLoaded)
            for k,v in pairs(Config.auto) do
                -- print(v.name, v.loc, v.heading)
                notLoaded = false
                ESX.Game.SpawnLocalVehicle(v.name, v.loc, v.heading, function(vehicle)
                    SetVehicleOnGroundProperly(vehicle)
                    SetVehicleEngineOn(vehicle, false, false, false)
                    SetVehicleUndriveable(vehicle, true)
                    FreezeEntityPosition(vehicle, true)
                    SetEntityInvincible(vehicle, true)
                    SetVehicleLights(vehicle, 2)
                    WashDecalsFromVehicle(vehicle, 1.0)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetVehicleDoorsLocked(vehicle, 2)
                    SetVehicleNumberPlateText(vehicle, v.plate)
                    SetVehicleDoorsLocked(vehicle, 2)
                    table.insert(vehicles, vehicle)
                    
                end)
            end
        end
        Citizen.Wait(500)
    end
    while true do
        local sleep = 500
        for _, auto in pairs(Config.auto) do
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), auto.loc)
            if distance <= 2.5 then
            
                ESX.ShowFloatingHelpNotification("Drücke ~r~E ~w~um Das Auto zu Kaufen ~g~" ..auto.price.."€", auto.loc)
                if IsControlJustPressed(0, 38) then
                    SetDisplay(true)
                    autobuyname = auto.name
                    buycarprice = auto.price
                    plate = auto.plate
                    autospawn = auto.spawn
                    autospawnheading = auto.headingspawn
                  
                    SendNUIMessage({
                        type = "load"
                    })
                end
                sleep = 1
            end
            Wait(sleep)
        end
    end
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({ 
        type = "ui", 
        status = bool, 
    })
end

local vehicle = nil
RegisterNUICallback('buycar', function(data,cb)
    SetDisplay(false)
    ESX.Game.SpawnVehicle(autobuyname, autospawn, autospawnheading, function(vehicle) 
        vehicle = vehicle
        TriggerServerEvent('atimati:kaufauto', ESX.Game.GetVehicleProperties(vehicle))
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        FreezeEntityPosition(vehicle, false)
    end)
    Wait(2500)
    ESX.ShowNotification("Fahrzeug ~g~Gekauft~w~.")
   



-- for k ,v in pairs(Config.auto) do
--     print(model, v.spawn, v.headingspawn)
--      ESX.Game.SpawnVehicle(model, v.spawn, v.headingspawn, function(vehicle) 
--         vehicle = vehicle
--         TriggerServerEvent('atimati:kaufauto', ESX.Game.GetVehicleProperties(vehicle))
--         SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
--         FreezeEntityPosition(vehicle, false)
--         SetVehicleNumberPlateText(vehicle, tostring(plate))
--     end)
--         Wait(2500)
--         ESX.ShowNotification("Fahrzeug ~g~Gekauft~w~.")
--         SetDisplay(false)
--      end
end)


RegisterNUICallback('exit', function(data,cb)
    SetDisplay(false)
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        for k,v in pairs(vehicles) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
    end
end
  end)
