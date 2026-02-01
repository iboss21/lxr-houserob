--[[
    ██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                                                                                                        
    🏠 LXR House Robbery System - SUPREME CONFIGURATION FILE
    
    This is the SUPREME CONFIGURATION FILE that controls all aspects of the house robbery system.
    All settings are consolidated here for enterprise-grade control.
    
    Minimal edits needed to server.lua and client.lua - everything is configured here!
    
    ┌─────────────────────────────────────────────────────────────────────────────────────────┐
    │ Author:          LXR Development Team (Original: younNGG97)                             │
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
    • Restructured configuration for maximum customization
    • Added professional branding and comprehensive documentation
    • Implemented advanced Discord webhook notification system with multiple event types
    • Enhanced error handling, validation, and security features
    • Optimized performance with configurable update intervals
    • Added extensive NPC behavior and difficulty tier system
    • Implemented comprehensive reward and loot table system
    • Added economic balance controls and payment processing
    • Enhanced minigame configuration with multiple difficulty levels
    • Added police alert system with dynamic dispatch
    • Implemented sound and visual effects configuration
    • Added translation/locale support structure
    • Enhanced house configuration with unlimited property support
    • Added billing system and logging configuration
    • Improved code documentation with detailed comments
]]

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████ FRAMEWORK CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Framework = 'rsg-core' -- Options: 'rsg-core', 'qbcore', 'lxrcore', 'standalone'
Config.CoreName = 'rsg-core' -- Core resource name
Config.FrameworkTriggers = {
    ['rsg-core'] = {
        resource = 'rsg-core',
        getObject = 'rsg-core:getSharedObject',
        playerLoaded = 'RSGCore:Client:OnPlayerLoaded',
        playerUnloaded = 'RSGCore:Client:OnPlayerUnload',
        jobUpdate = 'RSGCore:Client:OnJobUpdate'
    },
    qbcore = {
        resource = 'qb-core',
        getObject = 'qb-core:getSharedObject',
        playerLoaded = 'QBCore:Client:OnPlayerLoaded',
        playerUnloaded = 'QBCore:Client:OnPlayerUnload',
        jobUpdate = 'QBCore:Client:OnJobUpdate'
    },
    lxrcore = {
        resource = 'lxr-core',
        getObject = 'lxr-core:getSharedObject',
        playerLoaded = 'LXR:Client:OnPlayerLoaded',
        playerUnloaded = 'LXR:Client:OnPlayerUnload',
        jobUpdate = 'LXR:Client:OnJobUpdate'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DATABASE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Database = {
    enabled = true,
    resource = 'oxmysql', -- Options: 'oxmysql', 'mysql-async', 'ghmattimysql'
    tableName = 'lxr_house_robberies',
    autoCreateTable = true, -- Automatically create table if it doesn't exist
    saveRobberyHistory = true, -- Save robbery attempts to database
    saveCooldowns = true -- Save house cooldowns to database for persistence across restarts
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SYSTEM SETTINGS ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Enable debug mode for testing and troubleshooting
Config.UseMetadata = true -- Save robbery data as player metadata
Config.UseInventory = true -- Use inventory system for items and rewards

-- Inventory System Configuration
Config.Inventory = {
    system = 'auto', -- Options: 'auto' (detect), 'rsg-inventory', 'lxr-inventory', 'rsg-core', 'lxr-core', 'qb-inventory', 'custom'
    resource = nil, -- Inventory resource name (auto-detected if nil)
    
    -- Inventory system exports (customize for specific inventory systems)
    exports = {
        ['rsg-inventory'] = {
            addItem = function(source, item, amount, metadata)
                return exports['rsg-inventory']:AddItem(source, item, amount, nil, metadata)
            end,
            removeItem = function(source, item, amount)
                return exports['rsg-inventory']:RemoveItem(source, item, amount)
            end
        },
        ['lxr-inventory'] = {
            addItem = function(source, item, amount, metadata)
                return exports['lxr-inventory']:AddItem(source, item, amount, metadata)
            end,
            removeItem = function(source, item, amount)
                return exports['lxr-inventory']:RemoveItem(source, item, amount)
            end
        },
        ['qb-inventory'] = {
            addItem = function(source, item, amount, metadata)
                return exports['qb-inventory']:AddItem(source, item, amount, nil, metadata)
            end,
            removeItem = function(source, item, amount)
                return exports['qb-inventory']:RemoveItem(source, item, amount)
            end
        }
    }
}

-- Notification system
Config.Notifications = {
    type = 'native', -- Options: 'native', 'mythic_notify', 'ox_lib', 'custom'
    position = 'top-right', -- Position for notifications
    duration = 5000 -- Duration in milliseconds
}

-- Target system for interactions
Config.Target = {
    enabled = true,
    system = 'ox_target', -- Options: 'ox_target', 'qb-target', 'rsg-target'
    distance = 2.0 -- Interaction distance
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████████ PERFORMANCE SETTINGS ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    updateInterval = 1000, -- Main thread update interval (ms)
    houseCheckDistance = 50.0, -- Distance to check for house markers
    interactionDistance = 2.0, -- Distance for house entry interactions
    saveInterval = 300000, -- Save robbery data every 5 minutes
    blipUpdateInterval = 5000, -- Update blips every 5 seconds
    npcUpdateInterval = 500, -- NPC AI update interval (ms)
    optimizeProps = true, -- Optimize prop rendering
    maxActiveHouses = 10 -- Maximum number of houses with active robbery state
}

--────────────────────────────────────────────────────────────────────────────
-- DISCORD WEBHOOK CONFIGURATION
--────────────────────────────────────────────────────────────────────────────
Config.Webhooks = {
    Enabled = true, -- Enable/disable entire webhook system
    
    -- Webhook URLs (get from Discord Server Settings > Integrations > Webhooks)
    URLs = {
        RobberyAttempt = '', -- Webhook for robbery attempts/starts
        RobberySuccess = '', -- Webhook for successful robberies
        RobberyFailed = '', -- Webhook for failed robbery attempts
        PoliceAlert = '', -- Webhook for police alerts and dispatches
        PlayerCaught = '', -- Webhook for player caught/killed by NPC or police
        PlayerEscaped = '', -- Webhook for successful escapes
        LootAcquired = '', -- Webhook for special loot acquisitions
        AdminLog = '', -- Webhook for admin logs and suspicious activity
        General = '' -- General webhook (fallback if specific ones not set)
    },
    
    -- Webhook Settings
    Settings = {
        BotName = 'LXR House Robbery',
        BotAvatar = 'https://i.imgur.com/your-avatar.png',
        Color = 15158332, -- Decimal color (red: 15158332, green: 3066993, blue: 3447003, orange: 16744448, yellow: 16776960)
        Footer = 'LXR House Robbery System | v2.0.0 | lxr-scripts.com',
        Timestamp = true, -- Include timestamp in embeds
        ShowServerInfo = true, -- Include server name in embeds
        ShowPlayerIdentifiers = true, -- Include player identifiers (steam, license, discord)
        ShowCoordinates = true, -- Include coordinates in embeds
        PingRoleOnAlert = false, -- Ping specific role on alerts
        AlertRoleId = '', -- Discord role ID to ping on alerts
    },
    
    -- Notification Types - Customize each event type
    Types = {
        RobberyAttempt = {
            enabled = true,
            title = '🏠 House Robbery Attempt',
            description = 'A player has initiated a house robbery',
            color = 16776960, -- Yellow
            thumbnail = true,
            includeFields = {
                playerName = true,
                houseName = true,
                houseCoords = true,
                timestamp = true,
                lawmenOnline = true,
                identifier = true
            }
        },
        RobberySuccess = {
            enabled = true,
            title = '✅ Successful Robbery',
            description = 'A player has successfully completed a house robbery',
            color = 3066993, -- Green
            thumbnail = true,
            includeFields = {
                playerName = true,
                houseName = true,
                totalLoot = true,
                itemsStolen = true,
                timeElapsed = true,
                policeAlerted = true,
                escapeStatus = true,
                identifier = true
            }
        },
        RobberyFailed = {
            enabled = true,
            title = '❌ Failed Robbery',
            description = 'A robbery attempt has failed',
            color = 15158332, -- Red
            thumbnail = true,
            includeFields = {
                playerName = true,
                houseName = true,
                failReason = true, -- killed, caught, escaped without loot
                policeAlerted = true,
                timestamp = true,
                identifier = true
            }
        },
        PoliceAlert = {
            enabled = true,
            title = '🚨 Police Alert - House Robbery',
            description = 'Emergency dispatch: House robbery in progress',
            color = 15158332, -- Red
            thumbnail = true,
            includeFields = {
                houseName = true,
                houseCoords = true,
                suspectDescription = true,
                lawmenOnline = true,
                priority = true,
                timestamp = true
            }
        },
        PlayerCaught = {
            enabled = true,
            title = '⚠️ Player Caught',
            description = 'A player has been caught during a robbery',
            color = 16744448, -- Orange
            thumbnail = true,
            includeFields = {
                playerName = true,
                houseName = true,
                caughtBy = true, -- 'NPC', 'Police', 'Dog'
                itemsStolen = true,
                timestamp = true,
                identifier = true
            }
        },
        PlayerEscaped = {
            enabled = true,
            title = '🏃 Player Escaped',
            description = 'A player has escaped from a robbery',
            color = 3447003, -- Blue
            thumbnail = true,
            includeFields = {
                playerName = true,
                houseName = true,
                lootValue = true,
                escapeTime = true,
                policeAlerted = true,
                identifier = true
            }
        },
        LootAcquired = {
            enabled = true,
            title = '💎 Special Loot Acquired',
            description = 'A player has acquired special/rare loot',
            color = 10181046, -- Purple
            thumbnail = true,
            includeFields = {
                playerName = true,
                houseName = true,
                specialItem = true,
                itemValue = true,
                rarity = true,
                identifier = true
            }
        },
        AdminLog = {
            enabled = true,
            title = '🛡️ Admin Log',
            description = 'Administrative action or suspicious activity detected',
            color = 9807270, -- Dark gray
            thumbnail = true,
            includeFields = {
                eventType = true,
                playerName = true,
                details = true,
                timestamp = true,
                identifier = true
            }
        }
    }
}

--────────────────────────────────────────────────────────────────────────────
-- GAMEPLAY CONFIGURATION
--────────────────────────────────────────────────────────────────────────────

-- ████ LAW ENFORCEMENT SETTINGS ████
Config.LawEnforcement = {
    lawmenMinimum = 0, -- Minimum number of lawmen required online for robberies
    lawmenJobs = { -- Jobs that count as law enforcement
        'police',
        'sheriff',
        'marshal',
        'lawman',
        'deputy'
    },
    checkInterval = 5000 -- How often to check lawmen count (ms)
}

-- ████ POLICE ALERT SYSTEM ████
Config.PoliceAlert = {
    enabled = true,
    alertChance = 20, -- Base chance (percentage) of police being alerted during robbery
    alertChanceIncrease = 10, -- Increase alert chance for each search action
    maxAlertChance = 80, -- Maximum alert chance cap
    alertDelay = math.random(10000, 30000), -- Delay before alert is sent (random 10-30 seconds)
    alertRadius = 500.0, -- Radius for police alert blip
    alertDuration = 600000, -- How long alert blip stays active (10 minutes)
    alertBlip = {
        sprite = 'blip_proc_home_robbery',
        color = 'BLIP_MODIFIER_MP_COLOR_1',
        scale = 1.0
    },
    notifyAllLawmen = true, -- Send notification to all lawmen
    showLocationOnMap = true, -- Show exact location on map
    dispatchMessage = 'Robbery in progress at residential property',
    
    -- Progressive alert system
    progressiveAlerts = true,
    alertStages = {
        { time = 0, message = 'Possible break-in reported' },
        { time = 60000, message = 'Confirmed robbery in progress' },
        { time = 120000, message = 'Suspects still on scene' }
    }
}

-- ████ NPC HOMEOWNER SYSTEM ████
Config.NPC = {
    enabled = true,
    spawnChance = 100, -- Base chance (percentage) of NPC spawning inside house
    
    -- NPC Behavior
    behavior = {
        alertRadius = 10.0, -- Distance at which NPC becomes aware of player
        chaseRadius = 15.0, -- Distance NPC will chase player
        attackRadius = 5.0, -- Distance NPC will attack player
        giveUpDistance = 50.0, -- Distance at which NPC gives up chase
        returnToHomeDistance = 75.0, -- Distance at which NPC returns home
        
        -- Combat behavior
        accuracy = 0.6, -- NPC shooting accuracy (0.0 - 1.0)
        reactionTime = 1500, -- Time before NPC reacts (ms)
        combatStyle = 'aggressive', -- 'passive', 'defensive', 'aggressive'
        canCallPolice = true, -- NPC can alert police
        policeCallChance = 100, -- Chance NPC will call police when alerted
        policeCallDelay = 3000, -- Delay before NPC calls police
        
        -- Movement
        walkSpeed = 1.0,
        runSpeed = 1.5,
        canBlockDoors = false, -- NPC can block exits
        patrolsHouse = false -- NPC patrols house randomly
    },
    
    -- NPC Health and Damage
    health = {
        tier1 = 100, -- Health for tier 1 houses
        tier2 = 150, -- Health for tier 2 houses
        tier3 = 200 -- Health for tier 3 houses
    },
    
    -- Weapons by tier
    weaponsByTier = {
        tier1 = {
            'WEAPON_UNARMED',
            'WEAPON_MELEE_KNIFE',
            'WEAPON_MELEE_HATCHET'
        },
        tier2 = {
            'WEAPON_PISTOL_M1899',
            'WEAPON_REVOLVER_CATTLEMAN',
            'WEAPON_REVOLVER_DOUBLEACTION'
        },
        tier3 = {
            'WEAPON_SHOTGUN_DOUBLEBARREL',
            'WEAPON_RIFLE_SPRINGFIELD',
            'WEAPON_REVOLVER_SCHOFIELD'
        }
    },
    
    -- NPC Models pool
    models = {
        'mp_male',
        'mp_female',
        'msp_reverend1_males_01',
        'cs_mp_travellingsaleswoman',
        'u_m_m_bht_oldman',
        'u_f_m_rhdbackroomgrl_01'
    },
    
    -- Loot dropped on death
    dropLootOnDeath = true,
    dropLootChance = 50, -- Chance NPC drops extra loot when killed
    extraLoot = { -- Extra items NPC might drop
        { item = 'money', amount = { min = 5, max = 50 } },
        { item = 'pocket_watch', amount = { min = 1, max = 1 } },
        { item = 'wedding_ring', amount = { min = 1, max = 1 } }
    }
}

-- ████ GUARD DOG SYSTEM ████
Config.Dog = {
    enabled = true,
    models = { -- Available dog models
        'a_c_dog_americanfoxhound_01',
        'a_c_dog_bluetickcoohound_01',
        'a_c_dog_bloodhound_01'
    },
    
    -- Dog behavior
    behavior = {
        alertRadius = 15.0, -- Distance at which dog becomes aware
        attackRadius = 3.0, -- Distance at which dog attacks
        chaseRadius = 30.0, -- Distance dog will chase
        canBarks = true, -- Dog barks when alerting
        barkAlertsNPC = true, -- Dog barking alerts NPC
        barkAlertsPolice = false, -- Dog barking alerts police
        aggressive = true -- Dog will attack on sight
    },
    
    -- Dog stats
    health = 100,
    damage = 15, -- Damage per attack
    speed = 2.0,
    
    -- Dog loot (if killed)
    dropLoot = false
}

-- ████ COOLDOWN SYSTEM ████
Config.Cooldowns = {
    houseCooldown = 1800, -- Cooldown between robberies of same house (seconds) - 30 minutes
    playerCooldown = 300, -- Cooldown before player can rob again (seconds) - 5 minutes
    globalCooldown = 0, -- Global cooldown for all houses (0 = disabled)
    persistCooldowns = true, -- Save cooldowns to database across restarts
    showCooldownTimer = true, -- Show remaining cooldown time to players
    cooldownNotification = true -- Notify player when cooldown is active
}

-- ████ BREAK-IN MECHANICS ████
Config.BreakIn = {
    requiredItem = 'lockpick', -- Item required to break into houses
    removeItemOnUse = false, -- Remove item after use regardless of success
    removeItemOnFail = true, -- Remove item only on failed attempt
    lockpickBreaksOnError = true, -- Lockpick breaks if minigame fails
    breakChance = 50, -- Chance lockpick breaks on fail (percentage)
    
    -- Alternative items (players can use any of these)
    alternativeItems = {
        'advancedlockpick',
        'crowbar'
    },
    
    -- Break-in difficulty
    difficulty = 'medium', -- 'easy', 'medium', 'hard' (affects minigame)
    timeLimit = 30000, -- Time limit for break-in minigame (ms)
    
    -- Detection during break-in
    detectionDuringBreakIn = true,
    detectionChance = 15, -- Chance of being detected during break-in
    detectionAlertsPolice = true -- Detection alerts police
}

-- ████ SEARCHING MECHANICS ████
Config.Search = {
    searchTime = 3000, -- Base time required to search locations (milliseconds)
    searchTimeVariation = 1000, -- Random variation in search time (+/-)
    
    -- Search interruption
    canInterruptSearch = true, -- Players can be interrupted while searching
    interruptOnDamage = true, -- Taking damage interrupts search
    interruptOnMovement = true, -- Moving interrupts search
    
    -- Multiple searches
    allowMultipleSearches = false, -- Allow searching same location multiple times
    diminishingReturns = true, -- Each additional search has lower rewards
    
    -- Progress bar
    showProgressBar = true,
    progressBarColor = 'green'
}

-- ████ PROP MANAGEMENT ████
Config.Props = {
    deleteAfterInteraction = true, -- Delete props after interaction (true) or when leaving house (false)
    respawnProps = false, -- Respawn props after cooldown
    respawnTime = 1800, -- Time to respawn props (seconds)
    propOpacity = 255, -- Prop opacity (0-255)
    
    -- Prop highlighting
    highlightSearchableProps = true,
    highlightColor = { r = 255, g = 255, b = 0, a = 150 }, -- Yellow highlight
    highlightDistance = 5.0 -- Distance at which props highlight
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ MINIGAME CONFIGURATION ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Minigame = {
    enabled = true,
    system = 'ps-ui', -- Options: 'ps-ui', 'ox_lib', 'qb-lock', 'custom'
    
    -- Difficulty settings
    difficulties = {
        easy = {
            circles = 1,
            time = 10,
            failRemovesItem = false
        },
        medium = {
            circles = 2,
            time = 8,
            failRemovesItem = true
        },
        hard = {
            circles = 3,
            time = 6,
            failRemovesItem = true
        },
        extreme = {
            circles = 4,
            time = 5,
            failRemovesItem = true
        }
    },
    
    -- Minigame by house tier
    tierDifficulty = {
        tier1 = 'easy',
        tier2 = 'medium',
        tier3 = 'hard'
    },
    
    -- Rewards for perfect minigame
    perfectBonusEnabled = true,
    perfectBonusMultiplier = 1.5, -- 50% bonus loot for perfect minigame
    
    -- Fail consequences
    failAlertChance = 30, -- Chance to alert police on fail
    failNoiseDetection = true, -- Failed attempt creates noise
    failDamagePlayer = false, -- Failed attempt damages player
    failDamageAmount = 10 -- Damage amount if enabled
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ REWARDS & LOOT SYSTEM ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Rewards = {
    -- Reward system type
    rewardType = 'item', -- Options: 'item', 'money', 'both'
    
    -- Money rewards (if enabled)
    moneyRewards = {
        enabled = false,
        type = 'cash', -- Options: 'cash', 'bank'
        tier1 = { min = 50, max = 150 },
        tier2 = { min = 150, max = 350 },
        tier3 = { min = 350, max = 750 }
    },
    
    -- Loot quality system
    lootQuality = {
        enabled = true,
        qualities = {
            common = {
                chance = 60,
                multiplier = 1.0,
                label = 'Common',
                color = '^7' -- White
            },
            uncommon = {
                chance = 25,
                multiplier = 1.25,
                label = 'Uncommon',
                color = '^2' -- Green
            },
            rare = {
                chance = 10,
                multiplier = 1.5,
                label = 'Rare',
                color = '^4' -- Blue
            },
            epic = {
                chance = 4,
                multiplier = 2.0,
                label = 'Epic',
                color = '^6' -- Purple
            },
            legendary = {
                chance = 1,
                multiplier = 3.0,
                label = 'Legendary',
                color = '^8' -- Orange
            }
        }
    },
    
    -- Random events
    randomEvents = {
        enabled = true,
        hiddenStashChance = 5, -- Chance to find hidden stash
        hiddenStashRewards = {
            { item = 'goldbar', amount = { min = 1, max = 3 } },
            { item = 'gold_nugget', amount = { min = 5, max = 15 } },
            { item = 'diamond', amount = { min = 1, max = 2 } }
        },
        
        safeChance = 10, -- Chance to find a safe
        safeRequiresItem = true, -- Requires special item to open
        safeItem = 'safecracker',
        safeRewards = {
            { item = 'money', amount = { min = 500, max = 1500 } },
            { item = 'goldbar', amount = { min = 1, max = 2 } },
            { item = 'jewelry_box', amount = { min = 1, max = 1 } }
        }
    },
    
    -- Bonus rewards
    bonusRewards = {
        enabled = true,
        firstRobberyBonus = true, -- Extra reward for first robbery
        firstRobberyMultiplier = 1.5,
        
        speedBonus = true, -- Bonus for quick robberies
        speedThreshold = 120000, -- 2 minutes
        speedBonusMultiplier = 1.25,
        
        stealthBonus = true, -- Bonus for not alerting police
        stealthBonusMultiplier = 1.3,
        
        cleanEscapeBonus = true, -- Bonus for escaping without getting caught
        cleanEscapeBonusMultiplier = 1.2
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ LOOT TABLES BY TIER ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.LootTables = {
    -- Tier 1 Houses (Low-value items)
    tier1 = {
        common = {
            { item = 'bread', weight = 20 },
            { item = 'water', weight = 20 },
            { item = 'apple', weight = 15 },
            { item = 'corn', weight = 15 },
            { item = 'cigarette', weight = 10 },
            { item = 'matches', weight = 10 },
            { item = 'rope', weight = 5 },
            { item = 'cloth', weight = 5 }
        },
        uncommon = {
            { item = 'lockpick', weight = 30 },
            { item = 'hair_razor', weight = 25 },
            { item = 'harmonica', weight = 20 },
            { item = 'pocket_watch', weight = 15 },
            { item = 'wedding_ring', weight = 10 }
        },
        rare = {
            { item = 'silver_chain_necklace', weight = 40 },
            { item = 'earring_silver', weight = 35 },
            { item = 'silver_ring', weight = 25 }
        }
    },
    
    -- Tier 2 Houses (Medium-value items)
    tier2 = {
        common = {
            { item = 'lockpick', weight = 25 },
            { item = 'harmonica', weight = 20 },
            { item = 'pocket_watch', weight = 20 },
            { item = 'wedding_ring', weight = 15 },
            { item = 'silver_chain_necklace', weight = 10 },
            { item = 'cloth', weight = 10 }
        },
        uncommon = {
            { item = 'earring_gold', weight = 30 },
            { item = 'golden_ring', weight = 25 },
            { item = 'earring_pearl', weight = 20 },
            { item = 'gold_chain', weight = 15 },
            { item = 'silver_pocket_watch', weight = 10 }
        },
        rare = {
            { item = 'emerald_ring', weight = 30 },
            { item = 'sapphire_necklace', weight = 25 },
            { item = 'gold_nugget', weight = 20 },
            { item = 'ruby_ring', weight = 15 },
            { item = 'jewelry_box', weight = 10 }
        },
        epic = {
            { item = 'diamond_ring', weight = 50 },
            { item = 'platinum_pocket_watch', weight = 30 },
            { item = 'rare_collectible', weight = 20 }
        }
    },
    
    -- Tier 3 Houses (High-value items)
    tier3 = {
        common = {
            { item = 'golden_ring', weight = 25 },
            { item = 'earring_gold', weight = 20 },
            { item = 'gold_chain', weight = 20 },
            { item = 'silver_pocket_watch', weight = 15 },
            { item = 'earring_pearl', weight = 10 },
            { item = 'jewelry_box', weight = 10 }
        },
        uncommon = {
            { item = 'ring_thorburn_turquoise', weight = 25 },
            { item = 'emerald_ring', weight = 20 },
            { item = 'sapphire_necklace', weight = 20 },
            { item = 'ruby_ring', weight = 15 },
            { item = 'gold_nugget', weight = 10 },
            { item = 'diamond_ring', weight = 10 }
        },
        rare = {
            { item = 'earring_orchidee_diamond', weight = 25 },
            { item = 'platinum_pocket_watch', weight = 20 },
            { item = 'rare_collectible', weight = 15 },
            { item = 'goldbar', weight = 15 },
            { item = 'diamond', weight = 15 },
            { item = 'ancient_artifact', weight = 10 }
        },
        epic = {
            { item = 'legendary_jewelry', weight = 40 },
            { item = 'goldbar', weight = 30 },
            { item = 'diamond', weight = 20 },
            { item = 'rare_weapon_part', weight = 10 }
        },
        legendary = {
            { item = 'family_heirloom', weight = 40 },
            { item = 'treasure_map', weight = 30 },
            { item = 'ancient_coin_collection', weight = 20 },
            { item = 'legendary_artifact', weight = 10 }
        }
    }
}

-- Special loot pools (for special props like safes, footlockers)
Config.SpecialLoot = {
    weapons = {
        { item = 'WEAPON_REVOLVER_CATTLEMAN', weight = 30 },
        { item = 'WEAPON_PISTOL_VOLCANIC', weight = 25 },
        { item = 'WEAPON_REVOLVER_SCHOFIELD', weight = 20 },
        { item = 'WEAPON_PISTOL_MAUSER', weight = 15 },
        { item = 'WEAPON_REVOLVER_LEMAT', weight = 10 }
    },
    valuables = {
        { item = 'goldbar', weight = 30 },
        { item = 'diamond', weight = 25 },
        { item = 'rare_collectible', weight = 20 },
        { item = 'legendary_jewelry', weight = 15 },
        { item = 'family_heirloom', weight = 10 }
    },
    documents = {
        { item = 'treasure_map', weight = 40 },
        { item = 'property_deed', weight = 30 },
        { item = 'bank_bond', weight = 20 },
        { item = 'rare_photograph', weight = 10 }
    }
}
-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ ANIMATION CONFIGURATION █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Animations = {
    -- House entry animation
    HouseEnter = {
        enabled = true,
        anim = 'script_ca@carust@02@ig@ig1_rustlerslockpickingconv01',
        clip = 'idle_04_smhthug_01',
        duration = 5000,
        frozen = true, -- Player frozen during animation
        upperbody = false
    },
    
    -- Searching animation
    Searching = {
        enabled = true,
        anim = 'script_re@gold_panner@start@',
        clip = 'pan_loop_gold',
        duration = 3000,
        frozen = false,
        upperbody = true
    },
    
    -- Lockpicking animation
    Lockpicking = {
        enabled = true,
        anim = 'script_re@burglary@',
        clip = 'lockpick_loop',
        duration = 0, -- 0 = loops until completed
        frozen = true,
        upperbody = true,
        prop = 'p_cs_lockpick01x',
        propBone = 57005,
        propPlacement = { 0.09, 0.02, -0.02, -78.0, 13.0, 28.0 }
    },
    
    -- Loot collection animation
    LootCollection = {
        enabled = true,
        anim = 'amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop',
        clip = 'exit_withprop',
        duration = 2000,
        frozen = false,
        upperbody = true
    },
    
    -- Fleeing/escaping animation
    Fleeing = {
        enabled = false, -- Usually handled by player naturally
        forceRun = true -- Force player to run when fleeing
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SOUND & EFFECTS CONFIGURATION █████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Sounds = {
    enabled = true,
    
    -- Sound effects
    lockpicking = {
        enabled = true,
        sound = 'LOCKPICK',
        soundSet = 'SAFE_CRACK_SOUNDSET',
        volume = 0.5
    },
    
    doorBreak = {
        enabled = true,
        sound = 'DOOR_BREAK',
        soundSet = 'DOOR_SOUNDSET',
        volume = 0.7
    },
    
    searching = {
        enabled = true,
        sound = 'DRAWER_OPEN',
        soundSet = 'GENERIC_SOUNDSET',
        volume = 0.4
    },
    
    lootFound = {
        enabled = true,
        sound = 'COLLECT',
        soundSet = 'COLLECT_SOUNDSET',
        volume = 0.6
    },
    
    alert = {
        enabled = true,
        sound = 'ROBBERY_MONEY_ALERT',
        soundSet = 'DLC_SECURITY_VAN_HEIST_SOUNDS',
        volume = 0.8
    },
    
    dogBark = {
        enabled = true,
        sound = 'BARK',
        soundSet = 'DOG_SOUNDSET',
        volume = 0.7
    }
}

Config.VisualEffects = {
    enabled = true,
    
    -- Particle effects
    particles = {
        lockpickingFail = {
            enabled = true,
            dict = 'core',
            name = 'ent_anim_sm_smoke',
            scale = 1.0
        },
        
        lootSparkle = {
            enabled = true,
            dict = 'core',
            name = 'ent_anim_sm_sparkle',
            scale = 0.5
        }
    },
    
    -- Screen effects
    screenEffects = {
        alertFlash = {
            enabled = true,
            effect = 'MP_Celeb_Win',
            duration = 2000
        },
        
        caughtEffect = {
            enabled = true,
            effect = 'RespawnPulse',
            duration = 5000
        }
    },
    
    -- Lighting
    lighting = {
        highlightLootable = true,
        highlightColor = { r = 255, g = 215, b = 0 }, -- Gold color
        highlightIntensity = 2.0,
        highlightRadius = 1.0
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ ECONOMY & BILLING █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Economy = {
    -- Item values (for selling to fences)
    fenceEnabled = true,
    fenceLocations = {
        { coords = vector3(-1496.33, -375.28, 44.35), blipEnabled = false },
        { coords = vector3(2714.12, -1285.43, 49.63), blipEnabled = false }
    },
    fencePriceMultiplier = 0.6, -- Fence pays 60% of item value
    
    -- Black market
    blackMarket = {
        enabled = true,
        sellToBlackMarket = true,
        blackMarketMultiplier = 0.8 -- Black market pays 80% of item value
    },
    
    -- Item price ranges (for reference)
    itemPrices = {
        -- Low tier
        bread = 2,
        water = 1,
        rope = 5,
        cloth = 3,
        
        -- Medium tier
        lockpick = 15,
        pocket_watch = 25,
        wedding_ring = 50,
        silver_chain_necklace = 75,
        
        -- High tier
        golden_ring = 100,
        earring_gold = 150,
        jewelry_box = 200,
        diamond_ring = 500,
        goldbar = 1000
    }
}

Config.Billing = {
    enabled = false, -- Enable billing system for fines
    
    -- Fine system (when caught)
    fines = {
        enabled = true,
        tier1Fine = 100,
        tier2Fine = 250,
        tier3Fine = 500,
        fineMultiplier = 1.5, -- Multiplier if police involved
        payToPolice = true, -- Fine goes to police department
        jailTime = true, -- Also apply jail time
        jailDuration = { min = 60, max = 300 } -- Jail time in seconds
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ COMMANDS SETTINGS ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Commands = {
    -- Admin commands
    admin = {
        enabled = true,
        requiredPermission = 'admin',
        
        resetHouseCooldown = {
            enabled = true,
            command = 'resethousecooldown',
            description = 'Reset cooldown for a specific house'
        },
        
        resetAllCooldowns = {
            enabled = true,
            command = 'resetallcooldowns',
            description = 'Reset all house cooldowns'
        },
        
        setHouseTier = {
            enabled = true,
            command = 'sethousetier',
            description = 'Change house tier'
        },
        
        teleportToHouse = {
            enabled = true,
            command = 'tphouse',
            description = 'Teleport to house location'
        }
    },
    
    -- Player commands
    player = {
        checkCooldown = {
            enabled = true,
            command = 'housecooldown',
            description = 'Check house robbery cooldowns'
        },
        
        robberyStats = {
            enabled = true,
            command = 'robberystats',
            description = 'View your robbery statistics'
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████ LOGGING SETTINGS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Logging = {
    enabled = true,
    
    -- What to log
    logRobberyAttempts = true,
    logRobberySuccess = true,
    logRobberyFailures = true,
    logPoliceAlerts = true,
    logPlayerCaught = true,
    logLootAcquired = true,
    logAdminActions = true,
    
    -- Console logging
    consoleLog = true,
    consoleLogLevel = 'info', -- 'debug', 'info', 'warn', 'error'
    
    -- File logging
    fileLog = false,
    logFilePath = 'logs/house_robbery.log',
    
    -- Database logging
    databaseLog = true,
    keepLogsForDays = 30 -- Delete logs older than 30 days
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████ TRANSLATIONS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Locale = 'en' -- Default language

Config.Translations = {
    en = {
        -- General
        ['house_robbery'] = 'House Robbery',
        ['press_to_rob'] = 'Press [E] to break in',
        ['lockpicking'] = 'Lockpicking...',
        ['searching'] = 'Searching...',
        ['collecting_loot'] = 'Collecting loot...',
        
        -- Success messages
        ['robbery_success'] = 'Robbery successful!',
        ['loot_acquired'] = 'You found: %s',
        ['escaped_successfully'] = 'You escaped successfully!',
        
        -- Error messages
        ['not_enough_police'] = 'Not enough police online (%s/%s required)',
        ['house_on_cooldown'] = 'This house was recently robbed (cooldown: %s)',
        ['you_on_cooldown'] = 'You must wait before robbing again (cooldown: %s)',
        ['no_lockpick'] = 'You need a lockpick to break in',
        ['lockpick_broke'] = 'Your lockpick broke!',
        ['lockpicking_failed'] = 'Lockpicking failed!',
        ['already_being_robbed'] = 'This house is already being robbed',
        ['search_interrupted'] = 'Your search was interrupted!',
        
        -- Police alerts
        ['police_alert'] = '🚨 ROBBERY ALERT: Break-in reported at %s',
        ['police_alert_location'] = 'Location marked on map',
        
        -- NPC messages
        ['npc_alerted'] = 'The homeowner heard you!',
        ['npc_attacking'] = 'The homeowner is attacking!',
        ['npc_calling_police'] = 'The homeowner is calling the police!',
        
        -- Dog messages
        ['dog_detected'] = 'A guard dog detected you!',
        ['dog_barking'] = 'The dog is barking loudly!',
        ['dog_attacking'] = 'The dog is attacking!',
        
        -- Admin messages
        ['cooldown_reset'] = 'House cooldown has been reset',
        ['all_cooldowns_reset'] = 'All house cooldowns have been reset',
        ['tier_changed'] = 'House tier changed to: %s',
        
        -- UI messages
        ['tier_1_house'] = 'Small House (Tier 1)',
        ['tier_2_house'] = 'Medium House (Tier 2)',
        ['tier_3_house'] = 'Large House (Tier 3)',
        ['house_difficulty'] = 'Difficulty: %s',
        ['potential_reward'] = 'Potential Reward: %s',
        
        -- Statistics
        ['total_robberies'] = 'Total Robberies: %s',
        ['successful_robberies'] = 'Successful: %s',
        ['failed_robberies'] = 'Failed: %s',
        ['total_loot_value'] = 'Total Loot Value: $%s',
        ['times_caught'] = 'Times Caught: %s'
    }
}

--────────────────────────────────────────────────────────────────────────────
-- HOUSES CONFIGURATION
-- Configure all robbable houses with rewards, NPCs, and special loot
--────────────────────────────────────────────────────────────────────────────

--────────────────────────────────────────────────────────────────────────────
-- HOUSES CONFIGURATION
-- Configure all robbable houses with rewards, NPCs, and special loot
-- Each house can have unlimited searchable locations, NPCs, dogs, and special props
--────────────────────────────────────────────────────────────────────────────

Config.HousesToRob = {
	-- ████████████████████ TIER 1 HOUSE (Low Difficulty) ████████████████████
	[1] = { 
		name = "house1",
		tier = 1, -- Difficulty tier (1-3)
		displayName = "Small Farmhouse", -- Display name for UI
		entercoords = vec4(-929.45, -1271.96, 51.44, 162.72),
		
		houseInformation = {
			exit = vec3(-691.928, 1042.7164, 123.98477),
			
			-- Searchable locations
			locations = {
				[1] = { 
					prop = 'p_cabinet03x',
					coords = vec4(-688.49, 1045.67, 124.99, 297.45),
					rot = vec3(0, 0, 0),
					rewards = { "hair_razor", "harmonica" },
					rewardsAmount = { min = 1, max = 3 },
					searchTime = 3000, -- Optional: override global search time
					lootQuality = 'common' -- Optional: override loot quality
				},
				[2] = { 
					prop = 'p_sofa01x',
					coords = vec4(-687.68, 1041.37, 124.99, 215.67),
					rot = vec3(0, 0, 0),
					rewards = { "bread", "lockpick" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[3] = { 
					prop = 'p_dresser01x',
					coords = vec4(-689.12, 1043.85, 124.99, 180.23),
					rot = vec3(0, 0, 0),
					rewards = { "pocket_watch", "wedding_ring", "cloth" },
					rewardsAmount = { min = 1, max = 2 }
				}
			},
			
			-- Guard dog configuration
			Dog = { 
				chance = 0, -- Percentage chance of dog spawning
				model = 'a_c_doghound_01',
				coords = vec4(-690.10, 1046.70, 124.98, 164.13)
			},
			
			-- Special loot prop (safe, footlocker, etc.)
			SpecialProp = { 
				chance = 0, -- Percentage chance of special prop spawning
				prop = 'p_cs_footlocker01x',
				coords = vec4(-688.23, 1039.54, 124.99, 213.09),
				rewards = { "weapon_bow" },
				rewardsAmount = { min = 1, max = 1 },
				requiresItem = false, -- Requires special item to open
				requiredItem = 'safecracker'
			},
			
			-- NPC homeowner configuration
			npcModel = 'msp_reverend1_males_01',
			npcSpawnLocation = vec3(-689.13, 1044.29, 124.99),
			npcWeapon = "WEAPON_UNARMED",
			ammoCount = 50,
			npcHealth = 100, -- Optional: override default health
			npcAccuracy = 0.4 -- Optional: override default accuracy
		}
	},
	
	-- ████████████████████ TIER 2 HOUSE (Medium Difficulty) ████████████████████
	[2] = {
		name = "house2",
		tier = 2,
		displayName = "Town Residence",
		entercoords = vec4(2594.74, -1113.96, 52.88, 359.73),
		
		houseInformation = {
			exit = vec3(223.31, 990.19, 179.88),
			
			locations = {
				[1] = { 
					prop = 'p_vase01x',
					coords = vec4(222.60, 983.50, 180.88, 200.58),
					rot = vec3(0, 0, 0),
					rewards = { "earring_gold", "golden_ring" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[2] = { 
					prop = 'p_cabinet03x',
					coords = vec4(216.29, 985.56, 180.88, 83.49),
					rot = vec3(0, 0, 0),
					rewards = { "harmonica", "golden_ring" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[3] = { 
					prop = 'p_sofa01x',
					coords = vec4(219.06, 984.11, 180.88, 192.93),
					rot = vec3(0, 0, 0),
					rewards = { "earring_pearl", "earring_gold" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[4] = { 
					prop = 'p_desk01x',
					coords = vec4(220.45, 987.23, 180.88, 145.67),
					rot = vec3(0, 0, 0),
					rewards = { "jewelry_box", "gold_chain", "silver_pocket_watch" },
					rewardsAmount = { min = 1, max = 2 }
				}
			},
			
			Dog = { 
				chance = 10,
				model = 'a_c_doghound_01',
				coords = vec4(224.33, 985.10, 180.89, 20.62)
			},
			
			SpecialProp = { 
				chance = 0,
				prop = 'p_cs_footlocker01x',
				coords = vec4(217.89, 982.34, 180.88, 213.09),
				rewards = { "weapon_bow" },
				rewardsAmount = { min = 1, max = 3 }
			},
			
			npcModel = 'msp_reverend1_males_01',
			npcSpawnLocation = vec3(217.45, 986.90, 180.88),
			npcWeapon = "WEAPON_REVOLVER_CATTLEMAN",
			ammoCount = 50,
			npcHealth = 150,
			npcAccuracy = 0.6
		}
	},
	
	-- ████████████████████ TIER 3 HOUSE (High Difficulty) ████████████████████
	[3] = {
		name = "house3",
		tier = 3,
		displayName = "Luxury Mansion",
		entercoords = vec4(2642.89, -1072.41, 49.33, 89.97),
		
		houseInformation = {
			exit = vec3(2820.5056, 278.17382, 34.49282),
			
			locations = {
				[1] = { 
					prop = 'p_vase01x',
					coords = vec4(2818.39, 275.73, 35.50, 230.85),
					rot = vec3(0, 0, 0),
					rewards = { "golden_ring", "ring_thorburn_turquoise" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[2] = { 
					prop = 'p_cabinet03x',
					coords = vec4(2816.13, 273.00, 35.50, 47.71),
					rot = vec3(0, 0, 0),
					rewards = { "golden_ring", "jewelry_box" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[3] = { 
					prop = 'p_sofa01x',
					coords = vec4(2827.01, 275.18, 35.50, 225.24),
					rot = vec3(0, 0, 0),
					rewards = { "earring_orchidee_diamond", "jewelry_box" },
					rewardsAmount = { min = 1, max = 3 }
				},
				[4] = { 
					prop = 'p_desk01x',
					coords = vec4(2819.67, 271.45, 35.50, 315.89),
					rot = vec3(0, 0, 0),
					rewards = { "diamond_ring", "platinum_pocket_watch", "rare_collectible" },
					rewardsAmount = { min = 1, max = 2 }
				},
				[5] = { 
					prop = 'p_dresser01x',
					coords = vec4(2825.12, 279.34, 35.50, 125.45),
					rot = vec3(0, 0, 0),
					rewards = { "goldbar", "diamond", "legendary_jewelry" },
					rewardsAmount = { min = 1, max = 2 }
				}
			},
			
			Dog = { 
				chance = 100, -- Always spawns
				model = 'a_c_doghound_01',
				coords = vec4(2823.83, 274.86, 35.49, 37.39)
			},
			
			SpecialProp = { 
				chance = 10,
				prop = 'p_cs_footlocker01x',
				coords = vec4(2822.94, 270.74, 35.50, 213.09),
				rewards = { "WEAPON_REVOLVER_CATTLEMAN" },
				rewardsAmount = { min = 1, max = 3 }
			},
			
			npcModel = 'msp_reverend1_males_01',
			npcSpawnLocation = vec3(2816.45, 271.24, 35.49),
			npcWeapon = "weapon_shotgun_doublebarrel",
			ammoCount = 50,
			npcHealth = 200,
			npcAccuracy = 0.8
		}
	}
	
	-- ████ ADD MORE HOUSES HERE ████
	-- Copy and paste the structure above to add more houses
	-- Simply increment the number [4], [5], etc.
	-- Example:
	-- [4] = {
	--     name = "house4",
	--     tier = 1,
	--     displayName = "Small Cabin",
	--     entercoords = vec4(x, y, z, heading),
	--     houseInformation = { ... }
	-- }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████ END OF CONFIGURATION FILE ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    ═══════════════════════════════════════════════════════════════════════════════
    THANK YOU FOR CHOOSING LXR HOUSE ROBBERY SYSTEM!
    
    For support, updates, and more scripts:
    • Discord: https://discord.gg/lxr
    • Website: https://lxr-scripts.com
    • Store:   https://lxr.tebex.io
    
    Configuration Tips:
    • Always test changes on a development server first
    • Back up your config before making major changes
    • Use the debug mode (Config.Debug = true) for troubleshooting
    • Check the documentation for advanced configuration options
    • Join our Discord for community support and updates
    
    Performance Tips:
    • Reduce Config.Performance.updateInterval for better performance
    • Disable unused features (webhooks, sounds, effects) if not needed
    • Limit the number of active houses (Config.Performance.maxActiveHouses)
    • Use optimized prop models and reduce prop count per house
    
    Made with ❤️ by LXR Development Team
    © 2026 LXR Development - All Rights Reserved
    ═══════════════════════════════════════════════════════════════════════════════
]]

print('^2[LXR House Robbery]^7 Configuration loaded successfully | ^3lxr-scripts.com^7')