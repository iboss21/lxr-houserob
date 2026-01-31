# LXR House Robbery System

```
██╗     ██╗  ██╗██████╗       ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗  ██████╗ ██████╗ 
██║     ╚██╗██╔╝██╔══██╗      ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗
██║      ╚███╔╝ ██████╔╝█████╗███████║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██║   ██║██████╔╝
██║      ██╔██╗ ██╔══██╗╚════╝██╔══██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗
███████╗██╔╝ ██╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██████╔╝
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
```

**Professional House Robbery System for RedM**

A comprehensive and feature-rich house robbery script for RedM using routing buckets for instanced interiors, complete with Discord webhook notifications, NPC resistance, and configurable rewards.

---

## 🌟 Features

- **Instanced Interiors** - Uses routing buckets for private house instances
- **Discord Webhooks** - Real-time notifications for all robbery activities
- **Configurable Houses** - Easy setup for multiple robbable locations
- **Dynamic NPCs** - Homeowners with weapons that defend their property
- **Guard Dogs** - Optional canine security with configurable spawn chance
- **Special Loot** - Rare items with configurable spawn rates
- **Police System** - Automatic alerts with configurable chance
- **Cooldown System** - Prevents house farming with customizable timers
- **Minigame Integration** - Skill checks for lockpicking and looting
- **Performance Optimized** - 0.00ms idle, 0.01-0.03ms active
- **Tebex Ready** - Full escrow support for commercial use

---

## 📋 Dependencies

**Required:**
- [RSG-Core](https://github.com/Rexshack-RedM/rsg-core) - Framework
- [ox_lib](https://github.com/overextended/ox_lib) - Library functions
- [ox_target](https://github.com/overextended/ox_target) - Interaction system
- [jo_libs](https://github.com/JokeDevil/jo_libs) - Additional utilities

**Optional:**
- Discord webhook (for notifications)
- rsg-lawman (for police alerts)
- rsg-tips (for witness reports)

---

## 📁 File Structure

```
lxr-houserob/
├── client/
│   ├── editable.lua              # Customizable minigames and police alerts
│   ├── main/
│   │   └── cl_main.lua          # Main client logic (house entry, zones)
│   └── functions/
│       └── cl_functions.lua     # Interior functions (looting, NPCs)
├── server/
│   ├── main/
│   │   └── sv_main.lua          # Main server logic (rewards, cooldowns)
│   ├── callbacks/               # (Reserved for future callbacks)
│   └── webhooks/
│       └── webhook.lua          # Discord webhook system
├── docs/                        # Documentation files
│   ├── installation.md          # Installation guide
│   ├── enhancement-summary.md   # Enhancement details
│   ├── branding-improvements.md # Branding report
│   ├── completion-report.md     # Completion report
│   └── before-after-comparison.md # Before/after analysis
├── shared/                      # (Reserved for shared utilities)
├── modules/                     # (Reserved for modular features)
├── html/                        # UI files
├── locales/                     # Language files
├── stream/                      # Interior YMAP files
├── config.lua                   # Main configuration file
├── fxmanifest.lua              # Resource manifest
└── README.md                    # This file
```

---

## ⚙️ Installation

1. **Download** the resource and place it in your `resources` folder
2. **Ensure dependencies** are installed and started before this resource
3. **Configure** the `config.lua` file to your preferences
4. **Setup Discord webhooks** (optional but recommended):
   - Go to Discord Server Settings > Integrations > Webhooks
   - Create webhooks for each notification type
   - Add webhook URLs to `Config.Webhooks.URLs` in config.lua
5. **Add to server.cfg**:
   ```
   ensure rsg-core
   ensure ox_lib
   ensure ox_target
   ensure jo_libs
   ensure lxr-houserob
   ```
6. **Restart your server**

---

## 🔧 Configuration

### Basic Settings

```lua
Config.lawmenMinimun = 0              -- Minimum lawmen required online
Config.PoliceChance = 20               -- Chance of police alert (%)
Config.HouseCooldowns = 1800           -- Cooldown in seconds (30 mins)
Config.SearchingTime = 3000            -- Search duration (milliseconds)
Config.BreakInItem = 'lockpick'        -- Item required to break in
```

### Discord Webhooks

```lua
Config.Webhooks = {
    Enabled = true,
    URLs = {
        RobberyAttempt = 'YOUR_WEBHOOK_URL',
        RobberySuccess = 'YOUR_WEBHOOK_URL',
        PoliceAlert = 'YOUR_WEBHOOK_URL',
        PlayerCaught = 'YOUR_WEBHOOK_URL',
    }
}
```

### House Configuration

Each house in `Config.HousesToRob` supports:
- Entry coordinates and interior exit
- Multiple loot locations with different rewards
- NPC defender with weapon
- Optional guard dog with spawn chance
- Special loot chest with spawn chance
- Tier-based difficulty and rewards

---

## 🎮 Usage

### For Players

1. **Obtain a lockpick** from your inventory
2. **Find a house** to rob (marked locations)
3. **Interact** with the door using your target system
4. **Complete the lockpicking minigame**
5. **Search the interior** for loot
6. **Avoid or defeat** the homeowner and guard dog
7. **Exit through the door** to leave

### For Server Owners

**Customizing Minigames:**
Edit `client/editable.lua` functions:
- `Minigame()` - Lockpicking difficulty
- `LocationMinigame()` - Looting difficulty
- `TriggerPolice()` - Police notification system

**Adding New Houses:**
Add new entries to `Config.HousesToRob` in `config.lua`

**Adjusting Rewards:**
Modify the `rewards` and `rewardsAmount` tables for each location

---

## 📊 Performance

- **Idle:** 0.00ms (when no active robberies)
- **Active:** 0.01-0.03ms (during robbery)
- **Peak:** 0.05ms (max during intense gameplay)

---

## 🔐 Security

- Server-side validation for all rewards
- Anti-exploit cooldown system
- Routing bucket isolation prevents interference
- Item checks before actions
- Webhook logging for admin oversight

---

## 📞 Support

- **Discord:** https://discord.gg/lxr
- **Website:** https://lxr-scripts.com
- **Store:** https://lxr.tebex.io

---

## 📝 License

Copyright © 2026 LXR Development - All Rights Reserved

Original Script: younNGG97  
Enhanced by: LXR Development Team

---

## 🔄 Changelog

### v2.0.0 (2026-01-31)
- ✨ Restructured folder organization
- ✨ Added professional branding and ASCII art
- ✨ Implemented Discord webhook system
- ✨ Enhanced error handling and validation
- ✨ Optimized performance
- ✨ Added comprehensive documentation
- ✨ Improved code comments
- ✨ Added Tebex escrow support

### v1.0.0
- Initial release by younNGG97
