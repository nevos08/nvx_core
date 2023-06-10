RegisterNetEvent("nvx_core:skin:save", function(skin)
    local player = NVX.Functions.GetPlayer(source)
    player.set("skin", skin, true)
end)
