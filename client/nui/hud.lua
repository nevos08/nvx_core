if not Config.HUD.Enabled then
    return
end

local pageReady = false
local status = {}

local function UpdateHUD()
    if not pageReady then
        return
    end

    -- Status
    local nuiData = {}
    for k, v in pairs(status) do
        local config = Config.Status.Types[k]
        if not config.showUI then
            return
        end

        table.insert(nuiData, { name = k, value = (v / config.max) * 100, color = config.color, icon = config.icon })
    end

    Core.UI.emit("hud:setStatus", { status = nuiData })
end

RegisterNetEvent("nvx_core:playerSpawned", function()
    Core.UI.OpenPage("HUD")
end)

AddStateBagChangeHandler("status", nil, function(_, _, value)
    status = value
    UpdateHUD()
end)

Core.UI.OnPageReady("HUD", function()
    pageReady = true
    Core.UI.emit("hud:setConfig", { config = { EnableStatus = Config.HUD.Status, EnableVehicle = Config.HUD.Vehicle } })
    UpdateHUD()
end)
