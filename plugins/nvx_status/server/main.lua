if not Config.Status.Enabled then
    return
end

local function AddStatus(playerId, status, amount)
    local config = Config.Status.Types[status]
    if not config then
        return
    end

    local status = Player(playerId).state["status"]
    if not status then
        return
    end

    for k, v in pairs(status) do
        if v == status then
            local newValue = v + amount
            if newValue > config.max then
                newValue = config.max
            end
            status[k] = newValue
        end
    end

    Player(playerId).state:set("status", status, true)
end

local function RemoveStatus(playerId, status, amount)
    local config = Config.Status.Types[status]
    if not config then
        return
    end

    local status = Player(playerId).state["status"]
    if not status then
        return
    end

    for k, v in pairs(status) do
        if v == status then
            local newValue = v - amount
            if newValue < config.min then
                newValue = config.min
            end
            status[k] = newValue
        end
    end

    Player(playerId).state:set("status", status, true)
end

local function SetStatus(playerId, status, amount)
    local config = Config.Status.Types[status]
    if not config then
        return
    end

    local status = Player(playerId).state["status"]
    if not status then
        return
    end

    for k, v in pairs(status) do
        if v == status then
            if amount > config.max then
                amount = config.max
            elseif amount < config.min then
                amount = config.min
            end

            status[k] = amount
        end
    end

    Player(playerId).state:set("status", status, true)
end

RegisterNetEvent("nvx_core:playerLoaded", function(player)
    local status = MySQL.prepare.await("SELECT status FROM characters WHERE uuid = ?",
        { player.getUUID() })

    if not status then
        local status = {}
        for k, v in pairs(Config.Status.Types) do
            status[k] = v.default
        end

        MySQL.insert("UPDATE characters SET status = ? WHERE uuid = ?",
            { json.encode(status), player.getUUID() }, function()
                Player(player.playerId).state:set("status", status, true)
            end)

        return
    end

    status = json.decode(status)
    Player(player.playerId).state:set("status", status, true)
end)

RegisterNetEvent("nvx_core:status:onTick", function()
    print("got tick")
    local status = Player(source).state["status"]
    NVX.Shared.Table.Print(status)

    for k, v in pairs(status) do
        local statusConfig = Config.Status.Types[k]
        if not statusConfig then
            status[k] = nil
        end

        local newValue = v - statusConfig.remove
        if newValue < statusConfig.min then
            newValue = statusConfig.min
        end

        status[k] = newValue
    end

    Player(source).state:set("status", status, true)
end)

AddEventHandler("playerDropped", function()
    local uuid = Player(source).state["uuid"]
    local status = Player(source).state["status"]
    if status then
        MySQL.update("UPDATE characters SET status = ? WHERE uuid = ?", { json.encode(status), uuid })
    end
end)

exports("AddStatus", AddStatus)
exports("RemoveStatus", RemoveStatus)
exports("SetStatus", SetStatus)
