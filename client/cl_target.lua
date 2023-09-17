local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local model = joaat(Config.Locations.vehicle.pedhash)
    lib.requestModel(model, 100)
    while not HasModelLoaded(model) do
        Wait(1000)
    end

    local coords = Config.Locations.vehicle.ped -- Assuming you want to use the first ped location

    for k, v in ipairs(coords) do -- Iterate through the ped coordinates
        local Land = CreatePed(0, model, v.x, v.y, v.z, v.w, false, false)
        TaskStartScenarioInPlace(Land, 'WORLD_HUMAN_CLIPBOARD', 1, false)
        FreezeEntityPosition(Land, true)
        SetEntityInvincible(Land, true)
        SetBlockingOfNonTemporaryEvents(Land, true)

        exports['qb-target']:AddCircleZone("rentalvehicles" .. k, vector3(v.x, v.y, v.z), 1, {
            name = "rentalvehicles" .. k,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "client",
                    event = "ab-rentals:client:LicenseCheck",
                    icon = "fas fa-car",
                    label = "Rent Vehicle",
                    LicenseType = "driver",
                    MenuType = "vehicle",
                },
                {
                    type = "client",
                    event = "ab-rentals:client:return",
                    icon = "fas fa-circle",
                    label = 'Return Vehicle',
                    canInteract = function()
                        local hasitem = QBCore.Functions.HasItem('rentalpapers')
                        if hasitem then return true end
                        return false
                    end,
                },
            },
            distance = 3
        })
    end
end)

CreateThread(function()
    local model = joaat(Config.Locations.boat.pedhash)
    lib.requestModel(model, 100)
    while not HasModelLoaded(model) do
        Wait(1000)
    end

    local coords = Config.Locations.boat.ped -- Assuming you want to use the first ped location

    for k, v in ipairs(coords) do -- Iterate through the ped coordinates
        local Land = CreatePed(0, model, v.x, v.y, v.z, v.w, false, false)
        TaskStartScenarioInPlace(Land, 'WORLD_HUMAN_CLIPBOARD', 1, false)
        FreezeEntityPosition(Land, true)
        SetEntityInvincible(Land, true)
        SetBlockingOfNonTemporaryEvents(Land, true)

        exports['qb-target']:AddCircleZone("rentalboat" .. k, vector3(v.x, v.y, v.z), 1, {
            name = "rentalboat" .. k,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "client",
                    event = "ab-rentals:client:LicenseCheck",
                    icon = "fas fa-anchor",
                    label = "Rent Boat",
                    LicenseType = "boater",
                    MenuType = "boat",
                },
                {
                    type = "client",
                    event = "ab-rentals:client:returnboat",
                    icon = "fas fa-circle",
                    label = 'Return Vehicle',
                    canInteract = function()
                        local hasitem = QBCore.Functions.HasItem('rentalpapers')
                        if hasitem then return true end
                        return false
                    end,
                },
            },
            distance = 3
        })
    end
end)
