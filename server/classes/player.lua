function NVXPlayer(playerId, license, character)
    local self = {}

    self.playerId = playerId
    self.license = license
    self.uuid = character.uuid
    self.details = character.details
    self.position = character.position
    self.meta = character.meta

    if Config.Skin.Enabled then
        self.skin = character.skin
    end

    function self.getID()
        return self.playerId
    end

    function self.getPed()
        return GetPlayerPed(self.playerId)
    end

    function self.getLicense()
        return self.license
    end

    function self.getUUID()
        return self.uuid
    end

    function self.getName()
        return self.details.firstName .. " " .. self.details.lastName
    end

    function self.getCharacter()
        return lib.table.deepclone(character)
    end

    function self.getPosition(asVec)
        local position = GetEntityCoords(self.getPed(), true)
        local heading = GetEntityHeading(self.getPed())

        position = {
            x = NVX.Shared.Math.Round(position.x, 2),
            y = NVX.Shared.Math.Round(position.y, 2),
            z = NVX.Shared.Math.Round(position.z, 2),
            heading = NVX.Shared.Math.Round(heading, 2)
        }

        self.position = vec4(NVX.Shared.Math.Round(position.x, 2), NVX.Shared.Math.Round(position.y, 2),
            NVX.Shared.Math.Round(position.z, 2), NVX.Shared.Math.Round(heading, 2))
        return asVec and self.position or position
    end

    function self.getPlayerData()
        return { position = self.position, skin = self.skin }
    end

    -- Only use this if you know what you're doing. Can screw up things.
    function self.set(fieldName, value, save)
        self[fieldName] = value

        if save then
            self.saveField(fieldName)
        end
    end

    function self.get(fieldName)
        return self[fieldName]
    end

    function self.setMeta(key, value)
        self.meta[key] = value
    end

    function self.getMeta(key)
        return self.meta[key]
    end

    function self.emit(eventName, ...)
        TriggerClientEvent(eventName, self.playerId, ...)
    end

    function self.save()
        MySQL.prepare.await("UPDATE characters SET position = ?, skin = ? WHERE uuid = ?",
            { json.encode(self.getPosition(false)), Config.Skin.Enabled and self.skin or "{}", self.uuid })
        print("[nvx_core] Saved player with license ", self.license)
    end

    function self.saveField(fieldName)
        MySQL.prepare.await("UPDATE characters SET `" .. fieldName .. "` = ? WHERE uuid = ?",
            { self[fieldName], self.uuid })
    end

    function self.onTick()
        local pos = GetEntityCoords(self.getPed(), true)
        self.position = vec3(pos.x, pos.y, pos.z)
    end

    return self
end
