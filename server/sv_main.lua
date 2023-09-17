local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("rentalpapers", function(source, item)
    TriggerClientEvent("ab-rentals:client:addkeys", source, item.info)
end)

RegisterServerEvent('ab-rentals:server:rentalpapers', function(plate, model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = {
        citizenid = Player.PlayerData.citizenid,
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        plate = plate,
        model = model,
    }
    TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items["rentalpapers"], 'add')
    Player.Functions.AddItem('rentalpapers', 1, false, info)
end)

RegisterServerEvent('ab-rentals:server:payreturn', function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local price = 0
    if model == 'seashark' then model = 'seashark3' end
    if model == 'sanchez01' then model = 'sanchez' end

    for k, v in pairs(Config.Vehicles.land) do
        if v.model == model then
            price = math.floor(v.money / 2)
            break
        end
    end

    if price == 0 then
        for k, v in pairs(Config.Vehicles.sea) do
            if v.model == model then
                price = math.floor(v.money / 2)
                break
            end
        end
    end

    if price > 0 then
        Player.Functions.AddMoney("cash", price, "rental-return")
        TriggerClientEvent('QBCore:Notify', src, "You got your 50% Refund: $" .. price, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Invalid vehicle model.", "error")
    end
end)

RegisterServerEvent('ab-rentals:server:removepapers', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Rentalpapers = Player.Functions.GetItemByName('rentalpapers')
    if Rentalpapers then
        if  Rentalpapers.info.plate == plate then
            local info = Rentalpapers.info
            TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items["rentalpapers"], 'remove')
            Player.Functions.RemoveItem('rentalpapers', 1, false, info)
        end
    end
end)

QBCore.Functions.CreateCallback('ab-rentals:server:CashCheck',function(source, cb, money)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.money.cash >= money then
        cb(true)
        Player.Functions.RemoveMoney('cash', money, "Rental Car Purchased")
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('ab-rentals:server:getDriverLicenseStatus', function(source, cb, licenseType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata.licences

    if licenseTable.driver then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('ab-rentals:server:getBoaterLicenseStatus', function(source, cb, licenseType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata.licences

    if licenseTable.boater then
        cb(true)
    else
        cb(false)
    end
end)
