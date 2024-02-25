ESX = nil
ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('atimati:kaufauto')
AddEventHandler('atimati:kaufauto', function (vehicleProps)

    local vehicleType = "car"
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (@owner, @plate, @vehicle, @stored, @type)',
    {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@stored']  = 1,
        ['type'] = vehicleType
    }, function ()
    end)
end)
