local _pages = {}
local _hiddenPersistentPages = {}
local _pageReadyEvents = {}

local function UpdatePages()
    SendNUIMessage({ eventName = "setPages", pages = _pages })
end

function Core.UI.OpenPage(pageName)
    if lib.table.contains(_pages, pageName) then
        return
    end

    table.insert(_pages, pageName)
    UpdatePages()
end

function Core.UI.ClosePage(pageName)
    if not lib.table.contains(_pages, pageName) then
        return
    end

    for index, v in ipairs(_pages) do
        if v == pageName then
            table.remove(_pages, index)
            break
        end
    end
    UpdatePages()
end

function Core.UI.TogglePersistentPage(pageName, state)
    if state then
        for k, v in pairs(_hiddenPersistentPages) do
            if v == pageName then
                table.remove(_hiddenPersistentPages, k)
                break
            end
        end
    else
        if not lib.table.contains(_hiddenPersistentPages, pageName) then
            table.insert(_hiddenPersistentPages, pageName)
        end
    end

    Core.UI.emit("setHiddenPersistentPages", { hiddenPersistentPages = _hiddenPersistentPages })
end

function Core.UI.emit(eventName, data)
    local messageData = lib.table.merge({ eventName = eventName }, data)
    SendNUIMessage(messageData)
end

function Core.UI.SetFocus(hasFocus, hasCursor)
    SetNuiFocus(hasFocus, hasCursor)
end

function Core.UI.OnPageReady(pageName, cb)
    _pageReadyEvents[pageName] = cb
end

RegisterNUICallback("ready", function(data, cb)
    cb("ok")

    -- Send Locales to NUI
    while not Locales do
        Wait(100)
    end

    SendNUIMessage({ eventName = "setLocales", locales = Locales.NUI })
end)

RegisterNUICallback("pageReady", function(data, cb)
    if _pageReadyEvents[data.pageName] then
        _pageReadyEvents[data.pageName]()
    end
    cb("ok")
end)
