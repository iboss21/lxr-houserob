# Tebex Escrow Guide

## Understanding Escrow Protection

This guide explains how Tebex escrow works with LXR House Robbery and what it means for buyers and sellers.

---

## 🔐 What is Escrow?

**Escrow** is a protection system used by Tebex that encrypts Lua files to:
- Protect intellectual property and source code
- Prevent unauthorized redistribution
- Allow legitimate customization and configuration
- Maintain resource functionality

### How It Works
1. **Seller uploads resource** to Tebex with escrow configuration
2. **Tebex encrypts** the protected files automatically
3. **Buyer downloads** resource with encrypted core files
4. **Unencrypted files** remain editable for customization
5. **Resource runs normally** on the buyer's server

---

## 📁 File Protection Structure

### Encrypted Files (Protected Core Logic)
These files are **encrypted** and cannot be viewed or edited:

```
client/main/*.lua          ❌ Protected - Core client logic
client/functions/*.lua     ❌ Protected - Client utility functions
server/main/*.lua          ❌ Protected - Core server logic
server/callbacks/*.lua     ❌ Protected - Server callbacks
server/webhooks/*.lua      ❌ Protected - Webhook system
shared/*.lua               ❌ Protected - Shared utilities
```

**Why protected?**
- Contains proprietary algorithms and optimizations
- Prevents code theft and redistribution
- Ensures resource integrity
- Protects developer's intellectual property

### Unencrypted Files (Editable/Viewable)
These files are **unencrypted** and fully customizable:

```
config.lua                 ✅ Editable - All settings and configuration
client/editable.lua        ✅ Editable - Minigames, police alerts, hooks
locales/*.json             ✅ Editable - Translations
html/*.html                ✅ Editable - UI structure
html/*.css                 ✅ Editable - UI styling
html/*.js                  ✅ Editable - UI behavior
stream/*.ymap              ✅ Viewable - Map files
README.md                  ✅ Viewable - Documentation
docs/*.md                  ✅ Viewable - Additional documentation
LICENSE                    ✅ Viewable - License information
```

**Why unencrypted?**
- Allows full configuration for your server
- Enables UI customization and branding
- Permits translation to any language
- Provides transparency in customizable areas

---

## 🛠️ What You CAN Do

### Full Configuration Access
✅ Change all settings in `config.lua`:
- Framework selection
- Discord webhooks
- House locations and coordinates
- Loot tables and rewards
- NPC difficulty and weapons
- Police alert chances
- Cooldown timers
- And much more!

### Minigame Customization
✅ Edit `client/editable.lua` to:
- Replace lockpicking minigame with your own
- Customize looting skill checks
- Integrate with different minigame systems
- Change difficulty parameters
- Add custom police notification systems

### UI Customization
✅ Modify all UI files:
- Change colors, fonts, layouts
- Add custom animations
- Integrate with your server's theme
- Replace graphics and icons
- Completely redesign the interface

### Localization
✅ Translate to any language:
- Edit JSON locale files
- Add new language files
- Customize all text and messages
- Support multiple languages simultaneously

---

## ❌ What You CANNOT Do

### Cannot Access Core Logic
❌ View or edit encrypted server/client scripts
❌ Modify core functionality and algorithms
❌ Extract and reuse protected code
❌ Reverse engineer encrypted files

### Cannot Redistribute
❌ Share the resource with others
❌ Resell the resource
❌ Upload to public repositories
❌ Distribute encrypted or unencrypted files

### But You Can Still...
✅ Use on your licensed server(s)
✅ Modify unencrypted files freely
✅ Integrate with other resources
✅ Configure everything you need

---

## 🔧 Customization Examples

### Example 1: Change Lockpicking System
**File:** `client/editable.lua`

```lua
-- Default minigame
function Minigame()
    local success = exports['lxr-skillcheck']:StartCheck(3, 5000)
    return success
end

-- Replace with your preferred system
function Minigame()
    local success = exports['your-minigame']:StartGame('lockpick', 'medium')
    return success
end
```

### Example 2: Add New House Location
**File:** `config.lua`

```lua
Config.HousesToRob['new_house'] = {
    doorCoords = vector3(100.0, 200.0, 300.0),
    interiorExit = vector3(101.0, 201.0, 300.0),
    tier = 2,
    -- ... add all configuration
}
```

### Example 3: Customize Discord Webhook
**File:** `config.lua`

```lua
Config.Webhooks.URLs.RobberySuccess = 'your_webhook_url_here'
-- The webhook system code is protected, but you control the URLs and format
```

### Example 4: Translate to Spanish
**File:** `locales/es.json`

```json
{
    "search_location": "Buscar ubicación",
    "lockpick_door": "Forzar cerradura",
    "found_item": "Has encontrado: %s"
}
```

---

## 📋 Setup Instructions for Buyers

### First Time Setup

1. **Download from Tebex**
   - Log into your Tebex account
   - Download the purchased resource
   - Extract the ZIP file

2. **Install on Server**
   - Place `lxr-houserob` folder in `resources/`
   - Ensure dependencies are installed
   - DO NOT modify file structure

3. **Configure**
   - Edit `config.lua` for your server
   - Customize `client/editable.lua` if needed
   - Translate locales if desired
   - Style UI files if wanted

4. **Start Resource**
   - Add `ensure lxr-houserob` to server.cfg
   - Restart server
   - Test functionality

### Troubleshooting Escrow

**Problem:** "Failed to decrypt script"
- Ensure FXServer artifacts are up to date
- Verify resource wasn't modified incorrectly
- Re-download from Tebex if files corrupted

**Problem:** "Script not starting"
- Check all dependencies are installed
- Verify server.cfg order (dependencies first)
- Check server console for error messages

**Problem:** "Want to modify encrypted file"
- Check if the customization can be done in config.lua
- Look for hooks in client/editable.lua
- Contact support for custom features (paid service)

---

## 🔄 Updates with Escrow

### How Updates Work
1. New version released by developer
2. Tebex encrypts new version automatically
3. Buyers download updated version
4. Replace old files with new files
5. Your configuration persists (if you backed it up)

### Best Practices
✅ **Always backup** your config.lua before updating
✅ **Read changelog** to see what changed
✅ **Test on development** server first
✅ **Compare configs** if format changed
✅ **Keep dependencies** up to date

---

## 🏢 For Server Networks

### Multi-Server Usage
If you own multiple servers, you need:
- **Multiple licenses** (one per production server)
- **Network license** (unlimited servers, one company)
- Contact sales for network pricing

### Test Servers
- Each license includes ONE test server
- Test server = non-production, non-public
- Must be same company/organization

---

## 🤝 Support

### Getting Help
If you have questions about escrow or customization:

1. **Check Documentation** - Read all docs first
2. **Discord Support** - Ask in buyer support channel
3. **Open Ticket** - For specific issues
4. **Custom Development** - For paid modifications

### What Support Covers
✅ Installation help
✅ Configuration assistance
✅ Bug fixes in protected code
✅ Escrow-related issues
✅ Compatibility problems

### What's Not Covered
❌ Custom feature requests (paid service)
❌ Modifications to encrypted files (impossible)
❌ Server setup/administration
❌ Issues with other resources
❌ Compatibility with modified frameworks

---

## 📝 Legal & Compliance

### Tebex Terms
- Escrow protects both buyer and seller
- Buyer gets functional product with customization
- Seller's IP is protected from theft
- Disputes handled through Tebex system

### CFX.re Rules
- Resources must follow CFX escrow guidelines
- Cannot escape escrow protection
- Cannot circumvent encryption
- Violations may result in CFX ban

### License Agreement
- Review LICENSE file in resource
- Single server license by default
- Cannot transfer between users
- Cannot modify encrypted portions

---

## 📚 Additional Resources

- [Tebex Escrow Documentation](https://docs.tebex.io/store/escrow)
- [CFX.re Escrow Guidelines](https://docs.fivem.net/docs/scripting-manual/escrow/)
- [LXR Scripts Documentation](https://lxr-scripts.com/docs)
- [LXR Discord Community](https://discord.gg/lxr)

---

*This guide is for informational purposes and applies to LXR House Robbery v2.0.0+*  
*Copyright © 2026 LXR Development - All Rights Reserved*
