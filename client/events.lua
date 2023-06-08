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
        if not playerData.skin then

        end

        exports["fivem-appearance"]:setPlayerAppearance(playerData.skin)

        TriggerEvent("nvx_core:playerSpawned")
        TriggerServerEvent("nvx_core:playerSpawned")

        DoScreenFadeIn(1000)
        FreezeEntityPosition(cache.ped, false)
        SetEntityInvincible(cache.ped, false)
    end)
end)
