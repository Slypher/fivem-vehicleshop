local gVehicleCatalogPosition = vec3(-56.60, -1096.80, 26.40)

CreateThread(function()

    local blipHandler = AddBlipForCoord(gVehicleCatalogPosition)

    SetBlipSprite(blipHandler, 225)
    SetBlipDisplay(blipHandler, 4)
    SetBlipScale(blipHandler, 1.0)
    SetBlipColour(blipHandler, 3)
    SetBlipAsShortRange(blipHandler, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Premium Deluxe Motorsport')
    EndTextCommandSetBlipName(blipHandler)

    while true do

        local playerPed = PlayerPedId()

        local playerPosition = GetEntityCoords(playerPed)

        local nearMarker = false

        if #(gVehicleCatalogPosition - playerPosition) < 1.0 then

            ESX.Game.Utils.DrawText3D(gVehicleCatalogPosition, '~g~[E]~w~ Abrir loja de veículos', 0.6)

            if IsControlJustReleased(0, 38) then

                ESX.TriggerServerCallback('fivem-vehicleshop:getVehicles', function(vehicles)

                    if table.type(vehicles) ~= 'empty' then

                        SendNUIMessage(
                            {
                                type = 'SHOW_CATALOG',
                                vehicles = vehicles
                            }
                        )

                        SetNuiFocus(true, true)
                    end
                end)
            end

            nearMarker = true
        end

        if not nearMarker then
            Wait(1000)
        end

        Wait(0)
    end
end)

local function CloseCatalog()
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'CLOSE_CATALOG'})
end

RegisterNUICallback('fivem-vehicleshop:resetNuiFocus', function(data, cb)
    SetNuiFocus(false, false)
    cb({ })
end)

-- https://github.com/esx-framework/esx-legacy/blob/cae7d8e7fddf02658dcbe858d61b5eb8cfcffca8/%5Besx_addons%5D/esx_vehicleshop/client/main.lua#L224-L243
RegisterNUICallback('fivem-vehicleshop:buyVehicle', function(vehicleName, cb)

    local generatedPlate = GeneratePlate()

    ESX.TriggerServerCallback('fivem-vehicleshop:buyVehicle', function(success)

        if success then
            local playerPed = PlayerPedId()

            ESX.Game.SpawnVehicle(vehicleName, vector3(-28.6, -1085.6, 25.5), 330.0, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                SetVehicleNumberPlateText(vehicle, generatedPlate)
            end)

            CloseCatalog()
        else
            CloseCatalog()
            ESX.ShowNotification('Você não possui dinheiro suficiente para comprar o veículo')
        end

    end, vehicleName, generatedPlate)

    cb({ })
end)