local characters, slots, currentCharacterIndex = {}, 1
local camera

local offset = {
    coords = {
        x = 0.0,
        y = 2.2,
        z = 0.5
    },
    point = {
        x = 0,
        y = 0,
        z = -0.05
    }
}

RegisterNetEvent("nvx_core:multicharacter:setup", function(newChars, newSlots)
    characters = newChars
    slots = newSlots

    local cameraCoords = GetOffsetFromEntityInWorldCoords(cache.ped, offset.coords.x, offset.coords.y, offset.coords.z)
    local cameraPoint = GetOffsetFromEntityInWorldCoords(cache.ped, offset.point.x, offset.point.y, offset.point.z)
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    PointCamAtCoord(camera, cameraPoint.x, cameraPoint.y, cameraPoint.z)
    SetCamFov(camera, 50.0)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 0, true, true)

    TaskStandStill(cache.ped, -1)

    if characters[1] then
        currentCharacterIndex = 1
        exports["fivem-appearance"]:setPlayerAppearance(characters[1].skin)
    end

    DoScreenFadeIn(1000)
    Wait(1000)

    Core.UI.OpenPage("Multicharacter")
    Core.UI.SetFocus(true, true)
end)

Core.UI.OnPageReady("Multicharacter", function()
    local formatted = {}

    for _, v in pairs(characters) do
        table.insert(formatted, { name = v.name, uuid = v.uuid })
    end

    Core.UI.emit("setData", { characters = characters, slots = slots })
end)

RegisterNUICallback("multicharacter:previewCharacter", function(data, cb)
    for index, v in ipairs(characters) do
        if v.uuid == data.uuid and currentCharacterIndex ~= index then
            currentCharacterIndex = index
            exports["fivem-appearance"]:setPlayerAppearance(v.skin)
        end
    end
    cb("ok")
end)

RegisterNUICallback("multicharacter:chooseCharacter", function(data, cb)
    Core.UI.ClosePage("Multicharacter")
    Core.UI.SetFocus(false, false)

    DoScreenFadeOut(1000)
    Wait(1000)

    if camera then
        DestroyCam(camera, true)
        RenderScriptCams(false, false, 0, false, false)
        camera = nil
    end

    SwitchOutPlayer(cache.ped, 0, 1)
    while GetPlayerSwitchState() ~= 5 do
        Wait(0)
    end

    TriggerServerEvent("nvx_core:selectCharacter", data.uuid)
    cb("ok")
end)

RegisterNUICallback("multicharacter:create", function(data, cb)
    cb("ok")
end)
