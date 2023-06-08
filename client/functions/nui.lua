NVX.UI = {}

local _pages = {}
local _pageReadyEvents = {}

local function UpdatePages()
    SendNUIMessage({ eventName = "setPages", pages = _pages })
end

function NVX.UI.OpenPage(pageName)
    if lib.table.contains(_pages, pageName) then
        return
    end

    table.insert(_pages, pageName)
    UpdatePages()
end

function NVX.UI.ClosePage(pageName)
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

function NVX.UI.emit(eventName, data)
    local messageData = lib.table.merge({ eventName = eventName }, data)
    SendNUIMessage(messageData)
end

function NVX.UI.SetFocus(hasFocus, hasCursor)
    SetNuiFocus(hasFocus, hasCursor)
end

function NVX.UI.OnPageReady(pageName, cb)
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
