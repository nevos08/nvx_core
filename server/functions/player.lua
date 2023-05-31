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
