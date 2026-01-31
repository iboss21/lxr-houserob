--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                                                                                                        
    🏠 LXR House Robbery System - Complete House Robbery & Burglary Script
    
    Enterprise-grade house robbery system for RedM servers with comprehensive features.
    Break into houses, search for valuables, avoid guards and dogs, escape from police!
    
    ┌─────────────────────────────────────────────────────────────────────────────────────────┐
    │ Script Name:     LXR House Robbery                                                      │
    │ Version:         2.0.0                                                                  │
    │ Author:          LXR Development Team (Original: younNGG97)                             │
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
    │ • GitHub:  https://github.com/iboss21/lxr-houserob                                      │
    │                                                                                         │
    │ Performance Targets:                                                                    │
    │ • Idle:   0.00ms (no active robberies)                                                 │
    │ • Active: 0.01-0.03ms (during robbery)                                                 │
    │ • Peak:   0.05ms (max during intense gameplay)                                         │
    │                                                                                         │
    │ Features:                                                                               │
    │ • Unlimited robbable houses with tier system                                           │
    │ • Dynamic NPC homeowners with combat AI                                                │
    │ • Guard dog system with attack behavior                                                │
    │ • Police alert and dispatch system                                                     │
    │ • Discord webhook integration with detailed logs                                       │
    │ • Lockpicking minigame with difficulty levels                                          │
    │ • Comprehensive loot table and reward system                                           │
    │ • Cooldown management and persistence                                                  │
    │ • Sound effects and visual feedback                                                    │
    │ • Fully configurable with extensive options                                            │
    └─────────────────────────────────────────────────────────────────────────────────────────┘
    
    Update Notes (v2.0.0):
    • Major code restructure for better maintainability and performance
    • Added professional branding and comprehensive documentation
    • Implemented advanced Discord webhook notification system with 8+ event types
    • Enhanced NPC AI with difficulty tiers and dynamic behavior
    • Added guard dog system with realistic attack patterns
    • Implemented progressive police alert system with multiple stages
    • Added extensive minigame configuration with multiple difficulty levels
    • Created comprehensive loot table system with 5 rarity tiers
    • Implemented economic balance controls and fence system
    • Added sound effects and visual feedback for all actions
    • Enhanced error handling, validation, and security features
    • Optimized performance with configurable update intervals
    • Added translation/locale support for multiple languages
    • Improved escrow structure for Tebex distribution
    • Added admin commands for server management
    • Implemented detailed logging system (console, file, database, webhooks)
    • Added player statistics tracking and robbery history
    
    Technical Specifications:
    • Resource resmon: 0.00-0.05ms (depending on activity)
    • Memory usage: ~5-10MB (optimized)
    • Database queries: Minimal, only on save intervals
    • Network events: Optimized with rate limiting
    • Compatible with: RSG-Core, QB-Core, LXRCore, Standalone
    • Dependencies: ox_lib (optional), ox_target (optional)
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ FIVEM METADATA ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'lxr-houserob'
description 'Complete house robbery and burglary system for RedM | lxr-scripts.com'
author 'LXR Development Team (Original: younNGG97)'
version '2.0.0'
url 'https://lxr-scripts.com'

lua54 'yes'
this_is_a_map 'yes'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ SHARED CONFIGURATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

shared_scripts {
    '@jo_libs/init.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ CLIENT SCRIPTS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

client_scripts {
    'client/editable.lua',
    'client/main/*.lua',
    'client/functions/*.lua'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ SERVER SCRIPTS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

server_scripts {
    'server/main/*.lua',
    'server/callbacks/*.lua',
    'server/webhooks/*.lua'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████████████ UI / HTML FILES ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'locales/*.json',
    'version.json'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████████████ DEPENDENCIES ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

dependencies {
    'rsg-core', -- Primary framework support
    'ox_lib'    -- UI and utility library
}

dependency '/assetpacks'

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████████████ ESCROW SETTINGS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- Files that will remain unencrypted for Tebex escrow distribution
-- Only configuration and customization files are exposed for buyer editing

escrow_ignore {
    'config.lua',                  -- Main configuration file (editable)
    'client/editable.lua',         -- Client-side editable functions (customizable minigames)
    'locales/*.json',              -- Translation files (translatable)
    'html/*.html',                 -- UI HTML files (customizable)
    'html/*.css',                  -- UI stylesheets (customizable)
    'html/*.js',                   -- UI JavaScript files (customizable)
    'stream/*.ymap',               -- Map files (viewable)
    'README.md',                   -- Documentation
    'docs/*.md',                   -- Additional documentation
    'LICENSE'                      -- License file
}

--[[
    ═══════════════════════════════════════════════════════════════════════════════
    INSTALLATION INSTRUCTIONS
    
    1. Extract the resource to your server's resources folder
    2. Ensure the following dependencies are installed and started:
       - rsg-core (or qbcore/lxrcore)
       - ox_lib
    3. Configure config.lua to your preferences:
       - Set framework type
       - Configure webhooks (optional)
       - Adjust difficulty and rewards
       - Add more houses as needed
    4. Add to your server.cfg:
       ensure lxr-houserob
    5. Restart your server
    6. Test the script and adjust settings as needed
    
    For detailed documentation and support, visit:
    https://lxr-scripts.com/docs/house-robbery
    
    Need help? Join our Discord: https://discord.gg/lxr
    ═══════════════════════════════════════════════════════════════════════════════
]]
