local function formatCharacter(character)
    if not character then
        return
    end

    character.details = json.decode(character.details) or {}
    character.skin = json.decode(character.skin) or {}

    local pos = json.decode(character.position) or Config.Default.Position
    character.position = vec3(pos.x, pos.y, pos.z)

    return character
end

---Fetches a users account from the database by their rockstar license
---@param license string
function Core.Functions.GetPlayerAccount(license)
    local res = MySQL.prepare.await("SELECT * FROM users WHERE license = ?", { license })
    return res
end

function Core.Functions.CreateAccount(license, group, slots, whitelisted)
    local exists = Core.Functions.GetPlayerAccount(license) ~= nil
    if exists then
        print("[nvx_core] Tried to create an account for a rockstar license that already exists.")
        return
    end

    if not group then
        group = Config.Default.Group
    end

    if not slots then
        slots = Config.Multicharacter.DefaultSlots
    end

    if not whitelisted then
        whitelisted = Config.Whitelist.DefaultStatus
    end

    MySQL.insert.await("INSERT INTO users (`license`, `group`, `slots`, `whitelisted`) VALUES (?, ?, ?, ?)",
        { license, group, slots, whitelisted })

    print("[nvx_core] A new account was created in the database.")

    return Core.Functions.GetPlayerAccount(license)
end

---Gets all characters of a player from the database
---@param license string
function Core.Functions.GetPlayerCharacters(license)
    local res = MySQL.prepare.await("SELECT * FROM characters WHERE license = ?", { license })

    if not res then
        return
    end

    if res.uuid then
        res = formatCharacter(res)
    else
        for k, _ in pairs(res) do
            res[k] = formatCharacter(res[k])
        end
    end

    return res
end

function Core.Functions.GenerateUUID()
    local prefix = "NVX-"
    local uuid
    local unique = false

    while not unique do
        uuid = prefix .. math.random(10000000, 99999999)
        local res = MySQL.prepare.await("SELECT COUNT(*) as count FROM characters WHERE uuid = ?", { uuid })
        if res == 0 then
            unique = true
        end
        Wait(100)
    end

    return uuid
end

function Core.Functions.CreateCharacter(license, charData, skin)
    local uuid = Core.Functions.GenerateUUID()
    local meta = Config.Default.Meta or {}

    -- Generate a unique phoneNumber for each player
    meta.phoneNumber = tonumber(Config.GeneratePhoneNumber())
    local uniquePhoneNumber = false
    while not uniquePhoneNumber do
        MySQL.query(
            "SELECT JSON_UNQUOTE(JSON_EXTRACT(meta, '$.phoneNumber')) AS phoneNumber FROM characters HAVING phoneNumber = ?",
            { meta.phoneNumber }, function(res)
                if not res[1] then
                    uniquePhoneNumber = true
                end
            end)

        Wait(100)
    end


    MySQL.insert.await(
        "INSERT INTO characters (`uuid`, `license`, `details`, `position`, `skin`, `money`, `meta`) VALUES (?, ?, ?, ?, ?, ?, ?)",
        { uuid, license, json.encode(charData), json.encode(Config.Default.Position), json.encode(skin) or nil,
            Config.Default.Money, json.encode(meta) })

    return uuid
end

function Core.Functions.GetCharacter(uuid)
    local character = MySQL.prepare.await("SELECT * FROM characters WHERE uuid = ?", { uuid })
    if not character then
        return
    end

    character = formatCharacter(character)

    return character
end

function Core.Functions.SelectCharacter(playerId, uuid)
    local license = Player(playerId).state["license"]
    local character = Core.Functions.GetCharacter(uuid)
    local player = NVXPlayer(playerId, license, character)

    lib.addPrincipal("license:" .. license, "group." .. Player(playerId).state["group"])

    Core.Players[tonumber(playerId)] = player
    player.emit("nvx_core:playerLoaded", player.getPlayerData())
end
