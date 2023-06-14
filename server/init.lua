NVX = {
    Shared = Shared,
    Functions = {
        Player = {},
        Vehicle = {}
    },
    Commands = {},
}

Core = {}
Core.Players = {}
Core.Functions = {}
Core.Commands = {}

exports("GetObject", function()
    return NVX
end)

MySQL.ready(function()
    for _, v in ipairs(Config.Resources) do
        ExecuteCommand("ensure " .. v)
    end
end)

AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        for _, v in ipairs(Config.Resources) do
            ExecuteCommand("stop " .. v)
        end
    end
end)
