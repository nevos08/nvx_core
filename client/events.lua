RegisterNetEvent("nvx_core:playerLoaded", function(playerData)
    NVX.PlayerLoaded = true
    NVX.PlayerData = playerData

    exports["spawnmanager"]:spawnPlayer({
        x = playerData.position.x,
        y = playerData.position.y,
        z = playerData.position.z,
        model = "mp_m_freemode_01",
        skipFade = true
    }, function()
        if not playerData.skin and Config.Skin.Enabled then
            exports["fivem-appearance"]:startPlayerCustomization(function(skin)

            end, {
                ped = true,
                headBlend = true,
                faceFeatures = true,
                headOverlays = true,
                components = true,
                props = true,
                allowExit = false,
                tattoos = true
            })
        end

        exports["fivem-appearance"]:setPlayerAppearance(playerData.skin)

        TriggerEvent("nvx_core:playerSpawned")
        TriggerServerEvent("nvx_core:playerSpawned")

        DoScreenFadeIn(1000)
        while not IsScreenFadedIn() do
            Wait(10)
        end

        SwitchInPlayer(PlayerPedId())

        while IsPlayerSwitchInProgress() do
            Wait(100)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityInvincible(PlayerPedId(), false)
    end)
end)
