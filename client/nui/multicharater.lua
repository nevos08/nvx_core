local characters, slots = {}, 1
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
    print(json.encode(characters), slots)

    local cameraCoords = GetOffsetFromEntityInWorldCoords(cache.ped, offset.coords.x, offset.coords.y, offset.coords.z)
    local cameraPoint = GetOffsetFromEntityInWorldCoords(cache.ped, offset.point.x, offset.point.y, offset.point.z)
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    PointCamAtCoord(camera, cameraPoint.x, cameraPoint.y, cameraPoint.z)
    SetCamFov(camera, 50.0)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 0, true, true)

    TaskStandStill(cache.ped, -1)

    DoScreenFadeIn(1000)
    Wait(1000)

    NVX.UI.OpenPage("Multicharacter")
    NVX.UI.SetFocus(true, true)
end)

NVX.UI.OnPageReady("Multicharacter", function()
    NVX.UI.emit("setData", { characters = characters, slots = slots })
end)
