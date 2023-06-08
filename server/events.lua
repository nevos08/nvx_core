AddEventHandler("playerConnecting", function(_, _, deferrals)
    deferrals.defer()
    deferrals.update(Locales.deferrals["loadingAccount"])

    local playerId = source
    local license = NVX.Functions.Player.GetLicense(playerId)
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
    local player = NVX.Functions.Player.Get(source)
    if player then
        player.save()
    end
end)

RegisterNetEvent("nvx_core:playerJoined", function()
    local playerId = source
    local license = NVX.Functions.Player.GetLicense(playerId)
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

        Wait(100)
        TriggerClientEvent("nvx_core:multicharacter:setup", playerId, characters, account.slots)
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

RegisterNetEvent("nvx_core:onPlayerTick", function()
    local player = NVX.Functions.Player.Get(source)
    player.onTick()
end)
