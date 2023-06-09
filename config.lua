Config = {}

Config.FuelExport = 'LegacyFuel'

Config.Locations = {
    vehicle = {
        license = true,
        pedhash = "a_m_y_business_03",
        ped = {
            vector4(110.31, -1088.50, 28.3, 334.58),
            vector4(-946.01, -2705.24, 13.0, 96.77)
        },
        spawnpoint = {
            vector4(111.4223, -1081.24, 29.192, 340.0),
            vector4(-961.82, -2699.71, 13.37, 150.0)
        },
        blips = {
            label = Lang:t("info.land_veh"),
            sprite = 56,
            colour = 50,
            scale = 0.7
        },
    },
    boat = {
        license = false,
        pedhash = "a_m_y_business_02",
        ped = {
            vector4(-1513.43, -1323.19, 1.15, 273.4),
            -- vector4(115.6, -1079.49, 29.19, 195.15)
        },
        spawnpoint = {
            vector4(-1556.75, -1308.09, 1, 110.39),
            -- vector4(131.97, -1070.38, 29.21, 339.18)
        },
        blips = {
            label = Lang:t("info.sea_veh"),
            sprite = 410,
            colour = 42,
            scale = 0.7
        },
    }
}

Config.Vehicles = {
    land = {
        [1] = {
            model = 'bmx',
            icon = 'fas fa-bicycle',
            money = 100,
            image = 'https://cdn.discordapp.com/attachments/1101172346263445707/1116346159145959424/4596bd7f7aab3d7e1d537ea929b239e4.png',
        },
        [2] = {
            model = 'tribike',
            icon = 'fas fa-bicycle',
            money = 150,
            image = 'https://media.discordapp.net/attachments/1101172346263445707/1116345826185330829/581b41af5bda1a54851f6cdd5cf17e1b.png',
        },
        [3] = {
            model = 'futo',
            icon = 'fas fa-car',
            money = 450,
            image = 'https://cdn.discordapp.com/attachments/996342018127175751/1085004964348305468/image.png'
        },
        [4] = {
            model = 'bison',
            icon = 'fas fa-truck-pickup',
            money = 750,
            image = 'https://media.discordapp.net/attachments/1101172346263445707/1116345826525061190/05a0dd1613162ba9bad31b3bb5e87d78.png',
        },
        [5] = {
            model = 'sanchez',
            icon = 'fas fa-motorcycle',
            money = 450,
            image = 'https://media.discordapp.net/attachments/1101172346263445707/1116345826948677683/e33eb1aaa4195a614fc52e4acad57c9f.png',
        },
        [6] = {
            model = 'intruder',
            icon = 'fas fa-car',
            money = 1000,
            image = 'https://media.discordapp.net/attachments/1101172346263445707/1116345827355533363/5abe4ed2eb395e0bb4c81cf17a255200.png'
        },
        [7] = {
            model = 'superd',
            icon = 'fas fa-car',
            money = 3000,
            image = 'https://media.discordapp.net/attachments/1101172346263445707/1116345827682680892/9697b1925c8c4ff99bf72aee9bf685b9.png', -- Image of the vehicle 
        },
    },
    sea = {
        [1] = {
            model = 'seashark3',
            icon = 'fas fa-anchor',
            money = 5000,
            image = 'https://cdn.discordapp.com/attachments/996342018127175751/1085061655139987507/image.png'
        },
        [1] = {
            model = 'dinghy3',
            icon = 'fas fa-anchor',
            money = 3500,
            image = 'https://cdn.discordapp.com/attachments/996342018127175751/1085062044476256326/image.png'
        },
        [2] = {
            model = 'longfin',
            icon = 'fas fa-anchor',
            money = 5000,
            image = 'https://cdn.discordapp.com/attachments/996342018127175751/1085062458798002186/image.png'
        },
    }
}