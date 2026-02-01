# Installation Guide

## LXR House Robbery System - Step-by-Step Setup

### Prerequisites

Before installing, ensure you have:
- ✅ A working RedM server (build 1355 or higher recommended)
- ✅ RSG-Core framework installed
- ✅ ox_lib installed and working
- ✅ ox_target installed and working  
- ✅ jo_libs installed and working

---

## Step 1: Download & Extract

1. Download the `lxr-houserob` resource
2. Extract it to your server's `resources` folder
3. Verify the folder structure matches:
   ```
   resources/
   └── lxr-houserob/
       ├── client/
       ├── server/
       ├── html/
       ├── config.lua
       └── fxmanifest.lua
   ```

---

## Step 2: Configure Webhooks (Optional)

1. **Open Discord** and navigate to your server
2. Go to **Server Settings** → **Integrations** → **Webhooks**
3. Click **Create Webhook** (or edit existing)
4. **Copy the webhook URL**
5. **Open** `config.lua` in the lxr-houserob folder
6. Find the `Config.Webhooks.URLs` section
7. **Paste your webhook URLs**:

```lua
Config.Webhooks = {
    Enabled = true,
    URLs = {
        RobberyAttempt = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
        RobberySuccess = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
        PoliceAlert = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
        PlayerCaught = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE',
    }
}
```

**Note:** You can use the same webhook for all types, or create separate ones for better organization.

---

## Step 3: Customize Configuration

Open `config.lua` and adjust settings to your preference:

### Inventory System Configuration (New in v2.1)

The script now supports multiple inventory systems. By default, it auto-detects your inventory:

```lua
Config.Inventory = {
    system = 'auto', -- Auto-detect (recommended)
    -- Or specify: 'rsg-inventory', 'lxr-inventory', 'qb-inventory', 'rsg-core', 'lxr-core'
}
```

**Supported Inventory Systems:**
- ✅ RSG-Core (built-in framework inventory)
- ✅ LXR-Core (built-in framework inventory)
- ✅ QB-Core (for qb-core framework)
- ✅ rsg-inventory v2 (standalone inventory)
- ✅ lxr-inventory (standalone inventory)
- ✅ qb-inventory (standalone inventory)

**Auto-detection** checks for running inventory resources and uses the appropriate method. If you experience issues, manually set the system:

```lua
Config.Inventory = {
    system = 'rsg-inventory', -- Force specific inventory
}
```

### Basic Settings

```lua
-- Minimum lawmen required to rob houses
Config.lawmenMinimun = 0  -- Set to 2-3 for balance

-- Chance of police being alerted (%)
Config.PoliceChance = 20  -- 20% chance

-- Cooldown between robberies (seconds)
Config.HouseCooldowns = 1800  -- 30 minutes

-- Item required to break in
Config.BreakInItem = 'lockpick'  -- Change to match your server's lockpick
```

### House Locations

Each house in `Config.HousesToRob` can be customized:
- Entry coordinates
- Interior coordinates
- Loot rewards and amounts
- NPC weapons and behavior
- Guard dog spawn chance
- Special loot spawn chance

---

## Step 4: Add to server.cfg

Add the resource to your `server.cfg` in the correct load order:

```cfg
# Framework (load first)
ensure rsg-core

# Libraries (load before resources that use them)
ensure ox_lib
ensure ox_target
ensure jo_libs

# House Robbery (load after dependencies)
ensure lxr-houserob
```

**IMPORTANT:** Make sure dependencies load BEFORE lxr-houserob!

---

## Step 5: Customize Minigames (Optional)

If you want to use different minigames or police systems:

1. **Open** `client/editable.lua`
2. **Edit** the following functions:
   - `Minigame()` - Lockpicking difficulty
   - `LocationMinigame()` - Looting difficulty
   - `TriggerPolice()` - Police notification system

Example with custom police:
```lua
function TriggerPolice(coords, houseName)
    -- Replace with your police script
    exports['your-police-script']:CreateAlert('House Robbery', coords)
    
    -- Keep webhook trigger
    TriggerServerEvent('lxr-houserob:server:PoliceAlert', coords, houseName or "Unknown House")
end
```

---

## Step 6: Test the Resource

1. **Start your server**
2. **Join the server** with your character
3. **Give yourself a lockpick** (or the configured break-in item):
   ```
   /giveitem [your-id] lockpick 5
   ```
4. **Find a house** from your config (check coordinates)
5. **Test the robbery** - try the full process:
   - ✅ Lockpicking minigame
   - ✅ Entering the house
   - ✅ Looting locations
   - ✅ Fighting NPC/dog (if spawned)
   - ✅ Exiting the house
   - ✅ Receiving rewards
6. **Check Discord** - verify webhooks are working
7. **Check logs** - look for any errors in server console

---

## Troubleshooting

### "Items not being added to inventory"
- Check server console for `[LXR-HouseRob]` messages to see which inventory system is detected
- Verify your inventory resource is started before lxr-houserob
- Try manually setting the inventory system in config.lua:
  ```lua
  Config.Inventory = {
      system = 'rsg-inventory', -- or your inventory system name
  }
  ```
- Ensure your inventory system is compatible with exports (check its documentation)
- Check for errors in F8 console on the client side

### "Cannot find lockpick item"
- Check your inventory system's lockpick name
- Update `Config.BreakInItem` to match

### "No interaction prompt at door"
- Verify ox_target is running: `/ox`
- Check house coordinates in config.lua
- Restart both ox_target and lxr-houserob

### "Webhooks not sending"
- Verify webhook URL is correct (no spaces, complete URL)
- Check `Config.Webhooks.Enabled = true`
- Test webhook manually: https://discohook.org/

### "Player stuck in bucket"
- Player may have disconnected during robbery
- Run server command: `/setbucket [player-id] 0`
- Add to your admin commands for easy access

### "Cooldown not working"
- Cooldowns are stored in server memory
- They reset on server restart
- This is normal behavior to prevent permanent locks

---

## Performance Tips

1. **Reduce search time** if you want faster gameplay:
   ```lua
   Config.SearchingTime = 2000  -- 2 seconds instead of 3
   ```

2. **Adjust cooldowns** for your server population:
   - High pop: 30-60 minutes
   - Medium pop: 15-30 minutes
   - Low pop: 5-15 minutes

3. **NPC/Dog chances** affect performance slightly:
   - 100% spawn = more entities
   - Lower % = better performance

---

## Adding New Houses

1. **Find coordinates** in-game using `/getcoords` or similar
2. **Add to config.lua** following the existing format
3. **Test the entry point** - make sure it's accessible
4. **Choose interior** - use existing interior coordinates or find new ones
5. **Configure loot** - set rewards appropriate for difficulty
6. **Set NPC weapons** - harder houses = better guns
7. **Restart resource** - `/restart lxr-houserob`

---

## Support

Need help? Contact us:
- 💬 **Discord:** https://discord.gg/lxr
- 🌐 **Website:** https://lxr-scripts.com
- 🛒 **Store:** https://lxr.tebex.io

---

## Next Steps

Once installed and tested:
1. ✅ Set appropriate cooldowns for your server
2. ✅ Balance rewards based on your economy
3. ✅ Customize minigame difficulty
4. ✅ Add more houses if needed
5. ✅ Configure webhook colors and names
6. ✅ Test with multiple players

**Enjoy your new house robbery system!** 🏠💰
