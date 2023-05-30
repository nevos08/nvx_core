Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            DoScreenFadeOut(0)
            Wait(5000)
            DoScreenFadeIn(5000)
            return
        end
    end
end)
