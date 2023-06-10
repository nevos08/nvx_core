if not Config.Status.Enabled then
    return
end

local function StartTicks()
    print("called")
    Citizen.CreateThread(function()
        while NVX.PlayerLoaded do
            print("triggering event")
            TriggerServerEvent("nvx_core:status:onTick")
            Wait(Config.Status.TickInterval)
        end
    end)
end

AddEventHandler("nvx_core:playerSpawned", StartTicks)
