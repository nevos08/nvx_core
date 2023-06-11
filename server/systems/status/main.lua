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

local function SetStatus(playerId, type, amount)
    local config = Config.Status.Types[type]
    if not config then
        return
    end

    local status = Player(playerId).state["status"]
    if not status then
        return
    end

    for k, _ in pairs(status) do
        if k == type then
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
    else
        status = json.decode(status)
        for k, v in pairs(Config.Status.Types) do
            if not status[k] then
                status[k] = v.default
            end
        end
    end

    Player(player.playerId).state:set("status", status, true)
end)

RegisterNetEvent("nvx_core:status:onTick", function()
    local status = Player(source).state["status"]

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

NVX.Commands.Add("status:fill", "owner", function(player, args)
    if not args.playerId then
        local status = Player(player.playerId).state["status"]
        for type, _ in pairs(status) do
            SetStatus(player.playerId, type, Config.Status.Types[type].max)
        end
    else
        local status = Player(args.playerId).state["status"]
        for type, _ in pairs(status) do
            SetStatus(args.playerId, type, Config.Status.Types[k].max)
        end
    end
end, {
    help = "Fill all statuses of a player.",
    suggestions = {
        {
            name = "playerId",
            type = "playerId",
            help = "The target players server id",
            optional = true
        },
    }
})

exports("AddStatus", AddStatus)
exports("RemoveStatus", RemoveStatus)
exports("SetStatus", SetStatus)
