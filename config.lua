Config = {}

Config.Debug                =   false                           -- Debug Modus aktivieren / deaktivieren
Config.Locale               =   'de'                            -- Sprache einstellen (Set Default Language)

Config.DisableBlips         =   false                           -- Wenn 'true' werden gar keine Blips angezeigt
Config.Account              =   'money'                         -- Account des Spielers von dem das Geld abgebucht werden soll (zB. bank)
Config.Reciever             =   'society_mechanic'              -- Auf welches (Fraktions-) Konto soll die Rechnung gehen? - Leer lassen damit es ins nichts geht
Config.Blipname             =   'Waschanlage'                   -- Falls der Blip angezeigt werden soll, wie soll er heißen?

Config.Stations = {
    Davis = {

        Automatic = true,

        EnterPoint = {
            Coords = vector3(44.4224, -1392.0129, 28.9824)
        },

        -- Wenn Automatic = false sind diese Coords egal
        FinishPoint = {
            Coords = vector3(1.3219, -1391.9501, 28.8823)
        },

        Price = 50,

        ActivateWhitelist = false,

        Whitelist = {
            "police",
            "ambulance"
        },
        
        Blip = true,
    },

    Grove = {

        Automatic = false,

        EnterPoint = {
            Coords = vector3(175.1991, -1736.7749, 28.8790)
        },

        -- Wenn Automatic = false sind diese Coords egal
        FinishPoint = {
            Coords = vector3(0,0,0)
        },

        Price = 50,

        ActivateWhitelist = false,

        Whitelist = {},
        
        Blip = true,
    },
}