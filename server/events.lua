RegisterNetEvent("nvx_core:playerJoined", function()
    local playerId = source
    local license = NVX.Functions.Player.GetLicense(playerId)
end)
