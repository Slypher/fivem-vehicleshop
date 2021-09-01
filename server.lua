local gVehicles = {}

MySQL.ready(function()
    gVehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicle_shop')
end)

ESX.RegisterServerCallback('fivem-vehicleshop:getVehicles', function(playerId, cb)
    cb(gVehicles)
end)

ESX.RegisterServerCallback('fivem-vehicleshop:buyVehicle', function(playerId, cb, vehicleName, plate)

    local xPlayer = ESX.GetPlayerFromId(playerId)

    for i = 1, #gVehicles do

        local vehicle = gVehicles[i]

        if vehicle.name == vehicleName then

            if vehicle.stock > 0 then

                local vehiclePrice = vehicle.price

                if vehiclePrice and xPlayer.getMoney() >= vehiclePrice then

                    xPlayer.removeMoney(vehiclePrice)

                    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {

                        ['@owner'] = xPlayer.identifier,
                        ['@plate'] = plate,
                        ['@vehicle'] = json.encode(
                            {
                                model = GetHashKey(vehicleName),
                                plate = plate
                            }
                        )
                    }, function(rowsChanged)

                        xPlayer.showNotification(('O veículo com placa ~y~%s~s~ agora pertence a ~b~você~s~'):format(plate))

                        vehicle.stock = vehicle.stock - 1

                        MySQL.Async.execute('UPDATE vehicle_shop SET stock = @stock WHERE name = @vehicleName', {
                            ['@vehicleName'] = vehicleName,
                            ['@stock'] = vehicle.stock
                        })

                        cb(true)
                    end)
                else
                    cb(false)
                end

            end

            break
        end

    end

end)

-- https://github.com/esx-framework/esx-legacy/blob/cae7d8e7fddf02658dcbe858d61b5eb8cfcffca8/%5Besx_addons%5D/esx_vehicleshop/server/main.lua#L395
ESX.RegisterServerCallback('fivem-vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)