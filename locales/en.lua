local Translations = {
    info = {
        ["land_veh"] = "Vehicle Rentals",
        ["sea_veh"] = "Boat Rentals",
        ["has_keys"] = "You already have keys",
    },
    error = {
        ["not_enough_space"] = "Parking Lot isn't Free",
        ["not_enough_money"] = "You do not have enough money!",
        ["no_vehicle"] = "No vehicle to return!",
        ["no_driver_license"] = "You do not have a driver license!",
        ["no_boat_license"] = "You do not have a boater license!"
    },
    task = {
        ["return_veh"] = "Return your rented vehicle.",
        ['veh_returned'] = 'Vehicle Returned!'
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})