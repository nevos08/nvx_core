RegisterNetEvent("nvx_core:skin:save", function(skin)
    local player = NVX.Functions.Player.Get(source)
    player.set("skin", skin, true)
end)
