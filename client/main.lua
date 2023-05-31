Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            TriggerEvent("nvx_core:playerJoined")
            TriggerServerEvent("nvx_core:playerJoined")
            return
        end
    end
end)
