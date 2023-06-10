Config.Status = {
    Enabled = true,
    Types = {
        ["hunger"] = {
            min = 0.0,
            max = 100.0,
            remove = 5.0, -- how much to remove on every tick
            default = 100.0
        },
        ["thirst"] = {
            min = 0.0,
            max = 100.0,
            remove = 8.0, -- how much to remove on every tick
            default = 100.0
        }
    },
    TickInterval = 30 * 1000, -- 30 seconds
}
