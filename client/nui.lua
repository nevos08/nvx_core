RegisterNUICallback("ready", function(data, cb)
    cb("ok")

    -- Send Locales to NUI
    while not Shared.Locales do
        Wait(100)
    end

    SendNUIMessage({ eventName = "setLocales", locales = Shared.Locales.NUI })
end)
