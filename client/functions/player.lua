---Safely sets a players position by triggering a server event
---@param coords vector3 | vector4
function NVX.Functions.Player.SetPosition(coords)
    TriggerServerEvent("nvx_core:player:setPosition", coords)
end
