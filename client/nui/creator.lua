local camera

RegisterNetEvent("nvx_core:creator:setup", function()
    ShutdownLoadingScreen()

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

    NVX.UI.OpenPage("Creator")
    SetNuiFocus(true, true)
end)

RegisterNUICallback("creator:submit", function(data, cb)
    NVX.UI.ClosePage("Creator")

    DoScreenFadeOut(500)
    Wait(700)

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
        exports["fivem-appearance"]:startPlayerCustomization(function(skin)
                if skin then
                    FreezeEntityPosition(cache.ped, true)
                    DoScreenFadeOut(500)
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
        TriggerServerEvent("nvx_core:createCharacter", data)
    end

    cb("ok")
end)
