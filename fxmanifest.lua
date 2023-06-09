fx_version "cerulean"
game "gta5"

lua54 "yes"
use_experimental_fxv2_oal 'yes'

-- Resource Information
name "NVX Core"
author "Nevos"
description "Roleplay core resource for FiveM servers"
version "1.0.0"
repository "https://github.com/nevos08/nvx_core"

ui_page "web/dist/index.html"
files {
    "locales/*",
    "web/dist/*",
    "web/dist/**/*",

    "client/*.lua",
    "client/**/*.lua",
    "imports.lua"
}

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
    "locales.lua",
    "shared/init.lua",
    "shared/*.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",

    "server/init.lua",
    "server/functions/*",
    "server/classes/*",
    "server/commands/*",
    "server/systems/**/*",
    "server/events.lua",
}

client_scripts {
    "client/init.lua",
    "client/functions/*",
    "client/nui/*",
    "client/events.lua",
    "client/main.lua",
}

dependencies {
    "/onesync",
    "oxmysql",
    "ox_lib",
    "fivem-appearance"
}
