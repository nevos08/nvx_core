if not Config.Status.Enabled then
    return
end

local function StartTicks()
    Citizen.CreateThread(function()
        while NVX.PlayerLoaded do
            TriggerServerEvent("nvx_core:status:onTick")
            Wait(Config.Status.TickInterval)
        end
    end)
end

AddEventHandler("nvx_core:playerSpawned", StartTicks)
