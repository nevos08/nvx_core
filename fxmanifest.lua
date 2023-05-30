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
    "web/dist/**/*"
}

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",

    "shared/main.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",

    "server/*.lua"
}

client_scripts {
    "client/*.lua"
}

dependencies {
    "/onesync",
    "oxmysql",
    "ox_lib"
}
