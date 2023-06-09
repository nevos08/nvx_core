Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            exports.spawnmanager:setAutoSpawn(false)
            DoScreenFadeOut(0)
            DisplayRadar(false)

            DisableAllControlActions(0)
            DisableAllControlActions(2)

            Wait(500)
            TriggerServerEvent("nvx_core:playerJoined")
            return
        end
    end
end)

function StartPlayerTicks()
    Citizen.CreateThread(function()
        while NVX.PlayerLoaded do
            TriggerServerEvent("nvx_core:onPlayerTick")
            Wait(5000)
        end
    end)
end
