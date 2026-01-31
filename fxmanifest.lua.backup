--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                                                                                                        
    Professional House Robbery System for RedM
    
    ┌─────────────────────────────────────────────────────────────────────────────────────────┐
    │ Author:          LXR Development Team                                                   │
    │ Original Author: younNGG97                                                              │
    │ Version:         2.0.0                                                                  │
    │ Release Date:    2026-01-31                                                             │
    │ Framework:       RSG-Core / RedM                                                        │
    │                                                                                         │
    │ Copyright © 2026 LXR Development - All Rights Reserved                                 │
    │ Licensed for use under the terms specified in LICENSE file                             │
    │                                                                                         │
    │ Contact & Support:                                                                      │
    │ • Discord: https://discord.gg/lxr                                                       │
    │ • Website: https://lxr-scripts.com                                                      │
    │ • Store:   https://lxr.tebex.io                                                         │
    │                                                                                         │
    │ Performance Targets:                                                                    │
    │ • Idle:   0.00ms (no active robberies)                                                 │
    │ • Active: 0.01-0.03ms (during robbery)                                                 │
    │ • Peak:   0.05ms (max during intense gameplay)                                         │
    └─────────────────────────────────────────────────────────────────────────────────────────┘
    
    Update Notes (v2.0.0):
    • Restructured folder organization for better maintainability
    • Added professional branding and documentation
    • Implemented Discord webhook notification system
    • Enhanced error handling and validation
    • Optimized performance and resource usage
    • Added comprehensive configuration options
    • Improved code documentation and comments
    • Added Tebex escrow support
]]

fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
this_is_a_map "yes"

description 'LXR House Robbery - Professional house robbery system with Discord webhooks'
version '2.0.0'

author 'LXR Development (Original: younNGG97)'



shared_scripts {
    '@jo_libs/init.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

client_scripts {
    'client/editable.lua',
    'client/main/*.lua',
    'client/functions/*.lua'
}

server_scripts {
    'server/main/*.lua',
    'server/callbacks/*.lua',
    'server/webhooks/*.lua'
}


files {
    'locales/*.json',
}

dependencies {
    'rsg-core',
    'ox_lib',
}

lua54 'yes'

escrow_ignore {
    'client/editable.lua',
    'client/main/*.lua',
    'client/functions/*.lua',
    'config.lua',
    'server/main/*.lua',
    'server/callbacks/*.lua',
    'server/webhooks/*.lua',
    'shared/*.lua'
}

dependency '/assetpacks'