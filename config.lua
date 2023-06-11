Config = {}
Config.Locales = "de"

Config.Default = {
    Group = "user",                            -- Only change this if you know what you're doing. This is the default permission role a user will get when his account is created in the database.
    Position = { x = 0.0, y = 0.0, z = 70.0 }, -- This is the default position the player will spawn at
    Money = 1000.52,
    Meta = {}
}

Config.Whitelist = {
    Enabled = true,
    DefaultStatus = true, -- Should the player be whitelisted automatically if his account was created? You can ignore this if the whitelist system is disabled.
}

Config.Creator = {
    Position = vec4(235.04, 216.43, 105.28, 0.0)
}

Config.Multicharacter = {
    Enabled = true, -- You can ignore the settings below if this is false
    DefaultSlots = 2,
    Position = vec4(235.04, 216.43, 105.28, 0.0)
}

Config.Skin = {
    Enabled = true, -- If this is false, skin saving, setting etc. has to be handled by yourself.
    Position = vec4(235.04, 216.43, 105.28, 0.0)
}
