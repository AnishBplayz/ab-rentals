## Framework

This script utilizes OverExtended's ox-resources and provides a lot of utilities and functions for the end user.

The initial use for this script is for any developer/server owner using the QBCore or QBox Framework. However, over time, there may be some added functions to allow for cross platform use.

Support Provided:

- QBCore Framework ✅
- QBox Project ✅
- ESX Framework (Legacy or 1.1) ❌

# Features
- Fully Configurable
- Checks to see if player has correct amount of cash
- Checks to see if rental spot it open
- Provides rental papers for the vehicle
- Not in use 0.00 In use 0.00-0.01
- Ability to return all vehicles 
- License Checks
- Image Preview for Vehicles
- Added support for License
- 50% Refund on Return
- Using Rental Paper gives Vehiclekeys

# Dependencies 
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [qb-target](https://github.com/qbcore-framework/qb-target)

# Rental Papers Item - qb-core/shared.lua

```
["rentalpapers"]				 = {["name"] = "rentalpapers", 					["label"] = "Rental Papers", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "rentalpapers.png", 		["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false, 	["combinable"] = nil, 	["description"] = "Yea, this is my car i can prove it!"},
```
# Rental Papers Item Description - qb-inventory/html/js/app.js (Line 577)

```lua
        } else if (itemData.name == "stickynote") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p>' + itemData.info.label + '</p>');
        } else if (itemData.name == "rentalpapers") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p><strong>Name: </strong><span>'+ itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>'+ itemData.info.lastname+ '</span></p><p><strong>Plate: </strong><span>'+ itemData.info.plate + '<p><strong>Model: </strong><span>'+ itemData.info.model +'</span></p>');

```

# Add Boater License - qb-core/server/player.lua (Line 121)

```lua
    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['driver'] = true,
        ['business'] = false,
        ['weapon'] = false,
        ['boater'] = false,     -- Add this for Boat rentals License
    }
```

# To Grant the Boater License - qb-policejob/server/main.lua (Line 119)

```lua
QBCore.Commands.Add("grantlicense", Lang:t("commands.license_grant"), {{name = "id", help = Lang:t('info.player_id')}, {name = "license", help = Lang:t('info.license_type')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level >= Config.LicenseRank then
        if args[2] == "driver" or args[2] == "weapon" or args[2] == "boater" then     -- Add boater license here
            local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if not SearchedPlayer then return end
            local licenseTable = SearchedPlayer.PlayerData.metadata["licences"]
            if licenseTable[args[2]] then
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.license_already"), "error")
                return
            end
            licenseTable[args[2]] = true
            SearchedPlayer.Functions.SetMetaData("licences", licenseTable)
            TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("success.granted_license"), "success")
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.grant_license"), "success")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error_license_type"), "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.rank_license"), "error")
    end
end)

QBCore.Commands.Add("revokelicense", Lang:t("commands.license_revoke"), {{name = "id", help = Lang:t('info.player_id')}, {name = "license", help = Lang:t('info.license_type')}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level >= Config.LicenseRank then
        if args[2] == "driver" or args[2] == "weapon" or args[2] == "boater" then     -- Add boater license here
            local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if not SearchedPlayer then return end
            local licenseTable = SearchedPlayer.PlayerData.metadata["licences"]
            if not licenseTable[args[2]] then
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error_license"), "error")
                return
            end
            licenseTable[args[2]] = false
            SearchedPlayer.Functions.SetMetaData("licences", licenseTable)
            TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t("error.revoked_license"), "error")
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.revoke_license"), "success")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error_license"), "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.rank_revoke"), "error")
    end
end)
```

# Change Logs
- 1.0 - Inital release
- 1.1 - Script optimization / Locales
- 2.0 - Script Revamp and Ox Optimization
- 2.5 - Qb-Inventory and Qb-Target support

# Credits
- [Morningstar-Productions](https://github.com/Morningstar-Productions) - Edited Upon!
- [carbontheape](https://github.com/carbontheape) - Additional Types and New Locations
- [itsHyper](https://github.com/itsHyper) & elfishii - Initial Version
- [KevinGirardx](https://github.com/KevinGirardx) - Inspiration on Ox Menu
