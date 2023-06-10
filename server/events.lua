AddEventHandler("playerConnecting", function(_, _, deferrals)
    deferrals.defer()
    deferrals.update(Locales.deferrals["loadingAccount"])

    local playerId = source
    local license = NVX.Functions.GetPlayerLicense(playerId)
    local account = Core.Functions.GetPlayerAccount(license)

    if not account then
        -- Create a new account for the user
        deferrals.update(Locales.deferrals["creatingAccount"])
        Wait(3000)

        account = Core.Functions.CreateAccount(license)
    end

    if Config.Whitelist.Enabled then
        if account.whitelisted == 0 then
            return deferrals.done(Locales["notWhitelisted"])
        end
    end

    deferrals.done()
end)

AddEventHandler("playerDropped", function()
    local player = NVX.Functions.GetPlayer(source)
    if player then
        player.save()
    end
end)

RegisterNetEvent("nvx_core:playerJoined", function()
    local playerId = source
    local license = NVX.Functions.GetPlayerLicense(playerId)
    local account = Core.Functions.GetPlayerAccount(license)

    -- Add the players license to his state bag
    Player(playerId).state:set("license", license, false)
    Player(playerId).state:set("group", account.group, false)

    -- Each player will be set in his own dimension.
    -- ! ATTENTION: The id of the dimension will be his playerId
    SetPlayerRoutingBucket(playerId, playerId)

    -- Kick the player if his account does not exist (for whatever reason)
    if not account then
        return DropPlayer(playerId, Locales["errorLoadingAccount"])
    end

    local characters = Core.Functions.GetPlayerCharacters(license)
    if not characters then
        TriggerClientEvent("nvx_core:creator:setup", playerId)
        return
    end

    if Config.Multicharacter.Enabled or #characters > 1 then
        -- Setup the Multicharacter UI
        NVX.Functions.Player.SetPosition(playerId, Config.Multicharacter.Position)

        local minimalCharacters = {}

        if characters.uuid then
            table.insert(minimalCharacters,
                {
                    name = characters.details.firstName .. " " .. characters.details.lastName,
                    uuid = characters.uuid,
                    skin = characters.skin
                })
        else
            for _, v in pairs(characters) do
                table.insert(minimalCharacters,
                    { name = v.details.firstName .. " " .. v.details.lastName, uuid = v.uuid, skin = v.skin })
            end
        end

        Wait(100)
        TriggerClientEvent("nvx_core:multicharacter:setup", playerId, minimalCharacters, account.slots)
    else
        -- Play with character
        Core.Functions.SelectCharacter(playerId, characters.uuid)
    end
end)

RegisterNetEvent("nvx_core:createCharacter", function(charData, skin)
    local playerId = source
    local license = Player(playerId).state.license

    local uuid = Core.Functions.CreateCharacter(license, charData, skin)
    Core.Functions.SelectCharacter(playerId, uuid)
end)

RegisterNetEvent("nvx_core:selectCharacter", function(uuid)
    if Core.Players[tonumber(source)] ~= nil then
        print("[nvx_core] Player with id " ..
            source .. " tried to select a character although he has one selected already.")
        return
    end

    Core.Functions.SelectCharacter(source, uuid)
end)

RegisterNetEvent("nvx_core:onPlayerTick", function()
    local player = NVX.Functions.GetPlayer(source)
    player.onTick()
end)
