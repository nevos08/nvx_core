local camera

RegisterNetEvent("nvx_core:creator:setup", function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamCoord(camera, 775.06, 983.20, 322.87)
    PointCamAtCoord(camera, 775.06, 983.20, 322.87)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 0, true, true)

    SetEntityInvincible(cache.ped, true)
    SetEntityVisible(cache.ped, false, false)

    SetTimecycleModifier("hud_def_blur")
    DoScreenFadeIn(500)
    Wait(500)

    Core.UI.OpenPage("Creator")
    SetNuiFocus(true, true)
end)

RegisterNUICallback("creator:submit", function(data, cb)
    Core.UI.ClosePage("Creator")

    DoScreenFadeOut(500)
    Wait(600)

    if camera then
        DestroyCam(camera, true)
        RenderScriptCams(false, false, 0, false, false)
        camera = nil
    end
    ClearTimecycleModifier()
    SetNuiFocus(false, false)

    if Config.Skin.Enabled then
        SetEntityVisible(cache.ped, true, false)
        exports["fivem-appearance"]:setPlayerModel("mp_m_freemode_01")
        NVX.Functions.Player.SetPosition(Config.Skin.Position)
    end

    if Config.Skin.Enabled then
        Wait(200)
        DoScreenFadeIn(500)
        FreezeEntityPosition(PlayerPedId(), false)
        exports["fivem-appearance"]:startPlayerCustomization(function(skin)
                if skin then
                    DoScreenFadeOut(500)
                    Wait(500)

                    SwitchOutPlayer(cache.ped, 0, 1)
                    while GetPlayerSwitchState() ~= 5 do
                        Wait(0)
                    end

                    TriggerServerEvent("nvx_core:createCharacter", data, skin)
                end
            end,
            {
                ped = true,
                headBlend = true,
                faceFeatures = true,
                headOverlays = true,
                components = true,
                props = true,
                allowExit = false,
                tattoos = true
            })
    else
        SwitchOutPlayer(cache.ped, 0, 1)
        while GetPlayerSwitchState() ~= 5 do
            Wait(0)
        end
        TriggerServerEvent("nvx_core:createCharacter", data)
    end

    cb("ok")
end)
