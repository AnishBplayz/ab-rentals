local QBCore = exports['qb-core']:GetCoreObject()
local SpawnVehicle = false
local nearestSpawnpoint = nil
local nearestDistance = nil

-- Vehicle Rentals
RegisterNetEvent('ab-rentals:client:LicenseCheck', function(data)
    local license = data.LicenseType
    if license == "driver" then
        QBCore.Functions.TriggerCallback("ab-rentals:server:getDriverLicenseStatus", function(hasLicense)
            if Config.Locations.vehicle.license then
                if hasLicense  then
                    TriggerEvent('ab-rentals:client:openMenu', data)
                    MenuType = "vehicle"
                else
                    QBCore.Functions.Notify(Lang:t("error.no_driver_license"), "error", 4500)
                end
            else
                TriggerEvent('ab-rentals:client:openMenu', data)
                MenuType = "vehicle"
            end
        end)
    elseif license == "boater" then
        QBCore.Functions.TriggerCallback("ab-rentals:server:getBoaterLicenseStatus", function(hasLicense)
            if Config.Locations.boat.license then
                if hasLicense then
                    TriggerEvent('ab-rentals:client:openMenu', data)
                    MenuType = "boat"
                else
                    QBCore.Functions.Notify(Lang:t("error.no_boat_license"), "error", 4500)
                end
            else
                TriggerEvent('ab-rentals:client:openMenu', data)
                MenuType = "boat"
            end
        end)
    end
end)

RegisterNetEvent('ab-rentals:client:openMenu', function(data)
    local menu = data.MenuType
    local vehMenu = {}

    if menu == "vehicle" then
        for k=1, #Config.Vehicles.land do
            local veh = QBCore.Shared.Vehicles[Config.Vehicles.land[k].model]
            local name = veh and ('%s %s'):format(veh.brand, veh.name) or Config.Vehicles.land[k].model:sub(1,1):upper()..Config.Vehicles.land[k].model:sub(2)
            vehMenu[#vehMenu+1] = {
                title = name,
                description = "Rent Vehicle",
                icon = Config.Vehicles.land[k].icon,
                arrow = true,
                event = "ab-rentals:client:spawncar",
                image = Config.Vehicles.land[k].image,
                metadata = {
                    {label = 'Price', value = "$" .. Config.Vehicles.land[k].money}
                },
                args = {
                    model = Config.Vehicles.land[k].model,
                    money = Config.Vehicles.land[k].money,
                    menu = menu
                }
            }
        end
    elseif menu == "boat" then
        for k=1, #Config.Vehicles.sea do
            local veh = QBCore.Shared.Vehicles[Config.Vehicles.sea[k].model]
            local name = veh and ('%s %s'):format(veh.brand, veh.name) or Config.Vehicles.sea[k].model:sub(1,1):upper()..Config.Vehicles.sea[k].model:sub(2)
            vehMenu[#vehMenu+1] = {
                title = name,
                description = "Rent Vehicle",
                icon = Config.Vehicles.sea[k].icon,
                arrow = true,
                event = "ab-rentals:client:spawncar",
                image = Config.Vehicles.sea[k].image,
                metadata = {
                    {label = 'Price', value = "$" .. Config.Vehicles.sea[k].money}
                },
                args = {
                    model = Config.Vehicles.sea[k].model,
                    money = Config.Vehicles.sea[k].money,
                    menu = menu
                }
            }
        end
    end
    lib.registerContext({
        id = "rental_veh_menu",
        title = "Rental Vehicles",
        options = vehMenu
    })
    lib.showContext('rental_veh_menu')
end)

RegisterNetEvent('ab-rentals:client:spawncar', function(data)
    local money = data.money
    local model = data.model
    local menu = data.menu
    local label = Lang:t("error.not_enough_space", {vehicle = menu:sub(1,1):upper()..menu:sub(2)})
    local pedCoords = GetEntityCoords(cache.ped, false)
    local nearestDistance = nil
    local nearestSpawnpoint = nil
        
    for _, spawnpoint in ipairs(Config.Locations[menu].spawnpoint) do
        local distance = #(pedCoords - vector3(spawnpoint.x, spawnpoint.y, spawnpoint.z))
        if not nearestDistance or distance < nearestDistance then
            nearestDistance = distance
            nearestSpawnpoint = spawnpoint
        end
    end

    if nearestSpawnpoint then
        if menu == "vehicle" then
            if IsAnyVehicleNearPoint(nearestSpawnpoint.x, nearestSpawnpoint.y, nearestSpawnpoint.z, 2.0) then
                QBCore.Functions.Notify(label, "error", 4500)
                return
            end
        elseif menu == "boat" then
            if IsAnyVehicleNearPoint(nearestSpawnpoint.x, nearestSpawnpoint.y, nearestSpawnpoint.z, 10.0) then 
                QBCore.Functions.Notify(label, "error", 4500)
                return
            end
        end
    end

    local alert = lib.alertDialog({
        header = 'You are about to purchase a vehicle',
        content = 'You are about to purchase a vehicle for $' .. money .. ".  \n Are you sure you want to rent this vehicle?",
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Rent',
        }
    })
    if alert == 'confirm' then
        QBCore.Functions.TriggerCallback("ab-rentals:server:CashCheck", function(money)
            if money then

                if nearestSpawnpoint then
                    if menu == "vehicle" then
                        local plate = "RT" .. tostring(math.random(1000, 9999))
                        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
                            local veh = NetToVeh(netId)
                            SetEntityHeading(veh, nearestSpawnpoint.w)
                            SetVehicleNumberPlateText(veh, plate)
                            TriggerEvent("vehiclekeys:client:SetOwner", plate)
                            SetVehicleEngineOn(veh, true, true, false)
                            SetVehicleDirtLevel(veh, 0.0)
                            exports[Config.FuelExport]:SetFuel(veh, 100)
                            SpawnVehicle = true
                        end, model, nearestSpawnpoint, true)
                    elseif menu == "boat" then
                        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
                            local veh = NetToVeh(netId)
                            SetEntityHeading(veh, nearestSpawnpoint.w)
                            local plate = GetVehicleNumberPlateText(veh)
                            -- SetVehicleNumberPlateText(veh, plate)
                            TriggerEvent("vehiclekeys:client:SetOwner", plate)
                            SetVehicleEngineOn(veh, true, true, false)
                            SetVehicleDirtLevel(veh, 0.0)
                            exports[Config.FuelExport]:SetFuel(veh, 100)
                            SpawnVehicle = true
                        end, model, nearestSpawnpoint, true)
                    end
        
                    Wait(1000)
                    local vehicle = GetVehiclePedIsIn(cache.ped, false)
                    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    vehicleLabel = GetLabelText(vehicleLabel)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    TriggerServerEvent('ab-rentals:server:rentalpapers', plate, vehicleLabel)
                else
                    QBCore.Functions.Notify("No valid spawn points found.", "error", 4500)
                end
            else
                QBCore.Functions.Notify(Lang:t("error.not_enough_money"), "error", 4500)
            end
        end, money)        
    else
        QBCore.Functions.Notify("Maybe next time..", "error", 4500)
    end
end)

RegisterNetEvent('ab-rentals:client:return', function()
    local car = GetVehiclePedIsIn(PlayerPedId(), true)
    if car ~= 0 then
        local plate = GetVehicleNumberPlateText(car)
        local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
        -- local pedCoords = GetEntityCoords(cache.ped)
        -- local carcoords = GetEntityCoords(car)
        -- local distance = #(pedCoords - carcoords)
        local HasItem = QBCore.Functions.HasItem('rentalpapers')
        if string.find(tostring(plate), "RT") then
            if SpawnVehicle then
                if HasItem then
                    QBCore.Functions.Notify(Lang:t("task.veh_returned"), 'success')
                    TriggerServerEvent('ab-rentals:server:payreturn', vehname)
                    TriggerServerEvent('ab-rentals:server:removepapers', plate)
                    QBCore.Functions.DeleteVehicle(car)
                else 
                    QBCore.Functions.Notify(Lang:t("error.no_vehicle"), "error")
                end
                SpawnVehicle = false
            end
        end
    end
end)

RegisterNetEvent('ab-rentals:client:returnboat', function()
    local car = GetVehiclePedIsIn(PlayerPedId(), true)
    if car ~= 0 then
        local plate = GetVehicleNumberPlateText(car)
        local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
        local HasItem = QBCore.Functions.HasItem('rentalpapers')
        if SpawnVehicle then
            if HasItem then
                QBCore.Functions.Notify(Lang:t("task.veh_returned"), 'success')
                TriggerServerEvent('ab-rentals:server:payreturn', vehname)
                TriggerServerEvent('ab-rentals:server:removepapers', plate)
                QBCore.Functions.DeleteVehicle(car)
            else 
                QBCore.Functions.Notify(Lang:t("error.no_vehicle"), "error")
            end
            SpawnVehicle = false
        end
    end
end)

RegisterNetEvent('ab-rentals:client:addkeys', function(data)
    local plate = data.plate
    local Haskeys = exports['cs-vehiclekeys']:HasKeys(plate)
    if Haskeys then
        QBCore.Functions.Notify(Lang:t("info.has_keys"), "inform", 3000)
    else
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
    end
end)

-- Threads
CreateThread(function()
    for _, vehicleData in pairs(Config.Locations.vehicle.ped) do
        local blip = AddBlipForCoord(vehicleData.x, vehicleData.y, vehicleData.z)
        SetBlipSprite(blip, Config.Locations.vehicle.blips.sprite)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.Locations.vehicle.blips.scale)
        SetBlipColour(blip, Config.Locations.vehicle.blips.colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Locations.vehicle.blips.label)
        EndTextCommandSetBlipName(blip)
    end

    for _, boatData in pairs(Config.Locations.boat.ped) do
        local blip = AddBlipForCoord(boatData.x, boatData.y, boatData.z)
        SetBlipSprite(blip, Config.Locations.boat.blips.sprite)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.Locations.boat.blips.scale)
        SetBlipColour(blip, Config.Locations.boat.blips.colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Locations.boat.blips.label)
        EndTextCommandSetBlipName(blip)
    end
end)
