NVX.Functions.Player = {}

--- Gets a players rockstar license
---@param playerId number
function NVX.Functions.Player.GetLicense(playerId)
    for _, v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'license:') then
            return string.gsub(v, 'license:', '')
        end
    end
end

---Sets a players position
---@param playerId number
---@param pos vector3 | vector4
function NVX.Functions.Player.SetPosition(playerId, pos)
    local ped = GetPlayerPed(playerId)

    SetEntityCoords(ped, pos.x, pos.y, pos.z)
    if pos.w then
        SetEntityHeading(ped, pos.w)
    end
end

function NVX.Functions.Player.Get(playerId)
    return Core.Players[playerId]
end

-- Events
RegisterNetEvent("nvx_core:player:setPosition", function(pos)
    NVX.Functions.Player.SetPosition(playerId, pos)
end)
