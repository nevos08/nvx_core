function NVX.Commands.Add(cmdName, group, cb, params)
    lib.addCommand(cmdName,
        { help = params.help or "", params = params.suggestions or {}, restricted = "group." .. group },
        function(source, args, raw)
            local player = NVX.Functions.GetPlayer(source)
            if not player then
                return
            end
            cb(player, args, raw)
        end)
end

NVX.Commands.Add("veh", "owner", function(player, args)
    local coords = player.getPosition(true)
    local vehicle = CreateVehicle(args.model, coords.x, coords.y, coords.z, coords.w, true, true)
    SetPedIntoVehicle(player.getPed(), vehicle, -1)
end, {
    help = "Spawne ein Fahrzeug",
    suggestions = {
        {
            name = "model",
            type = "string",
            help = "Das Fahrzeugmodell"
        }
    }
})

NVX.Commands.Add("dv", "owner", function(player)
    local vehicle = GetVehiclePedIsIn(player.getPed(), false)
    if vehicle and DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end, {
    help = "Lösche das Fahrzeug, in dem du sitzt."
})
