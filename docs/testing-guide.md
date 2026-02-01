# Testing Guide - House Robbery System Fixes

## Overview
This document provides a comprehensive testing guide for the recent fixes to the house robbery system, specifically addressing issues where the target interaction was not showing and items were not being added to inventory.

---

## What Was Fixed

### 1. **Config Variable References**
All config variable references were updated to match the actual config structure:

| Old (Broken) | New (Fixed) |
|-------------|-------------|
| `Config.BreakInItem` | `Config.BreakIn.requiredItem` |
| `Config.lawmenMinimun` | `Config.LawEnforcement.lawmenMinimum` |
| `Config.LockpickBreaksOnError` | `Config.BreakIn.lockpickBreaksOnError` |
| `Config.PoliceChance` | `Config.PoliceAlert.alertChance` |
| `Config.SearchingTime` | `Config.Search.searchTime` |
| `Config.DeletePropAfterInteraction` | `Config.Props.deleteAfterInteraction` |

### 2. **Client-Side Item Checking**
- Replaced non-working `RSGCore.Functions.HasItem()` client check
- Added server callback `lxr-houserob:server:hasItem` for proper inventory validation
- Target now always shows the interaction prompt, validation happens on click

### 3. **User Notifications**
Added helpful error messages for:
- Missing lockpick
- Not enough lawmen online
- House on cooldown

### 4. **NPC Spawn Logic**
- Fixed dead code that prevented NPCs from spawning
- Now properly checks house configuration for NPC model

---

## Pre-Testing Checklist

Before testing, ensure:

- [ ] Server is running RSG-Core or compatible framework
- [ ] `ox_lib` is installed and started
- [ ] `ox_target` is installed and started  
- [ ] `jo_libs` is installed and started
- [ ] Resource is properly started (check F8 console for errors)
- [ ] You have a lockpick item in your inventory (default item: `lockpick`)

---

## Testing Steps

### Test 1: Target Interaction Visibility ✓
**Objective:** Verify the "Break-in" target prompt appears at house entrances

1. Go to any house location (coordinates in config):
   - House 1: `/tp -929.45 -1271.96 51.44`
   - House 2: `/tp 2594.74 -1113.96 52.88`
   - House 3: `/tp 2642.89 -1072.41 49.33`

2. Look for the interaction prompt/target
   - **Expected:** Should see "Break-in" prompt when close to door
   - **Previous Issue:** No prompt appeared due to broken item check

### Test 2: Item Requirement Check ✓
**Objective:** Verify lockpick requirement is properly checked

1. Remove lockpick from inventory: `/removeitem lockpick 999`
2. Try to interact with house entrance
   - **Expected:** Error notification "You need a lockpick to break in"
   
3. Add lockpick back: `/giveitem lockpick 1`
4. Try again
   - **Expected:** Should proceed to minigame

### Test 3: Lawmen Requirement ✓
**Objective:** Verify minimum lawmen check works

1. Set `Config.LawEnforcement.lawmenMinimum` to 1 in config.lua
2. Restart resource
3. Try to rob a house with no lawmen online
   - **Expected:** Error notification "Not enough lawmen online"
   
4. Have another player join as lawman OR set `lawmenMinimum` to 0
5. Try again
   - **Expected:** Should proceed to minigame

### Test 4: Minigame & Entry ✓
**Objective:** Verify minigame works and house entry is successful

1. Interact with house entrance
2. Complete the lockpicking minigame
   - **Expected:** Skill check appears (default: ox_lib skillcheck)
   
3. On success:
   - **Expected:** Screen fades, teleports inside house
   - **Expected:** Lockpick is removed from inventory
   - **Expected:** Props spawn inside house
   
4. On failure (if `Config.BreakIn.lockpickBreaksOnError = true`):
   - **Expected:** Lockpick is removed from inventory
   - **Expected:** Stays outside house

### Test 5: Interior Searching ✓
**Objective:** Verify items are properly added to inventory

1. Inside house, look for searchable props (cabinets, dressers, etc.)
2. Interact with a prop
3. Complete the search minigame
4. Wait for progress bar to complete
   - **Expected:** Notification showing item received
   - **Expected:** Item appears in inventory (check with /showme command or inventory UI)
   - **Example:** "You Received hair_razor 2x"

5. Verify multiple props can be searched
   - **Expected:** Each prop gives rewards when searched

### Test 6: Special Props ✓
**Objective:** Verify special loot spawning works

1. Configure a house with high special prop chance:
   ```lua
   SpecialProp = { 
       chance = 100, -- 100% spawn for testing
       prop = 'p_cs_footlocker01x',
       -- ... other settings
   }
   ```
2. Enter house and look for special prop
3. Search it
   - **Expected:** Special reward added to inventory

### Test 7: NPC & Dog Spawning ✓
**Objective:** Verify NPCs and dogs spawn correctly

1. Configure house with NPC and dog:
   ```lua
   Dog = { 
       chance = 100, -- Always spawn for testing
       model = 'a_c_doghound_01',
       coords = vec4(x, y, z, heading)
   }
   ```
2. Enter house
   - **Expected:** NPC spawns and attacks player
   - **Expected:** Dog spawns (if configured) and attacks player

### Test 8: Exit & Cooldown ✓
**Objective:** Verify house exit and cooldown system

1. Inside house, find the exit zone (usually near entrance)
2. Interact with exit zone
   - **Expected:** Screen fades, teleports outside
   - **Expected:** Props and NPCs are cleaned up
   
3. Try to rob same house again immediately
   - **Expected:** Error notification "This house was recently robbed"
   
4. Wait for cooldown (default: varies by house tier) OR use admin command to reset cooldown

### Test 9: Police Alert System ✓
**Objective:** Verify police alerts trigger correctly

1. Configure police alert chance:
   ```lua
   Config.PoliceAlert = {
       enabled = true,
       alertChance = 100, -- 100% for testing
   }
   ```
2. Rob a house successfully
   - **Expected:** Police alert triggered (check with lawmen job)
   - **Expected:** Webhook sent (if configured)

### Test 10: Inventory System Compatibility ✓
**Objective:** Verify items work with your inventory system

1. Check server console for inventory detection message:
   ```
   [LXR-HouseRob] Auto-detected inventory system: rsg-inventory
   ```
   or
   ```
   [LXR-HouseRob] Using configured inventory system: [system-name]
   ```

2. Search a house location and verify:
   - Items appear in inventory
   - No error messages in F8 console
   - Console shows: `[LXR-HouseRob] Added item via [system]: [item] x[amount]`

---

## Common Issues & Solutions

### Issue: Target prompt doesn't appear
**Solution:**
- Ensure ox_target is installed and running
- Check F8 console for errors
- Verify house coordinates are correct in config
- Try `/ensure ox_target` then `/ensure lxr-houserob`

### Issue: Items not added to inventory
**Solution:**
- Check server console for inventory errors
- Verify item names exist in your items database/config
- Check `Config.Inventory.system` setting (use 'auto' if unsure)
- Ensure player has inventory space

### Issue: "Not enough lawmen online" even when there are lawmen
**Solution:**
- Check if lawmen have job type 'leo' in their job config
- Verify `Config.LawEnforcement.lawmenJobs` includes their job name
- Set `lawmenMinimum = 0` for testing without lawmen requirement

### Issue: NPCs don't spawn
**Solution:**
- Verify `npcModel` and `npcSpawnLocation` are set in house config
- Check if jo_libs is properly installed
- Check server console for model loading errors

### Issue: Minigame doesn't appear
**Solution:**
- Ensure ox_lib is installed and running
- Check `client/editable.lua` Minigame() function
- Try `/ensure ox_lib` then `/ensure lxr-houserob`

---

## Performance Testing

### Check Resource Performance:
1. Open F8 console
2. Run: `resmon`
3. Find `lxr-houserob` in the list
4. Verify performance:
   - **Idle:** 0.00ms (when not robbing)
   - **Active:** 0.01-0.03ms (during robbery)
   - **Peak:** < 0.05ms

---

## Debug Mode

Enable debug mode for more detailed logging:

1. Open `config.lua`
2. Find or add:
   ```lua
   Config.Debug = true
   ```
3. Restart resource
4. Check server console for detailed logs

---

## Testing Completion Checklist

- [ ] Target prompt appears at all house locations
- [ ] Lockpick requirement check works
- [ ] Lawmen requirement check works
- [ ] Minigame appears and functions correctly
- [ ] House entry/exit works smoothly
- [ ] Items are added to inventory after searching
- [ ] Special props spawn and give rewards
- [ ] NPCs spawn and attack player
- [ ] Dogs spawn and attack player (if configured)
- [ ] Cooldown system prevents re-robbery
- [ ] Police alerts trigger (if configured)
- [ ] Notifications appear for all error conditions
- [ ] No errors in F8 console
- [ ] No errors in server console
- [ ] Performance is within acceptable range

---

## Reporting Issues

If you encounter any issues during testing:

1. Check F8 console for client errors
2. Check server console for server errors
3. Verify all dependencies are installed and running
4. Try with debug mode enabled
5. Report with:
   - Exact steps to reproduce
   - Error messages (if any)
   - Server/client console logs
   - Resource versions
   - Framework version

---

## Configuration Tips

### For Testing:
```lua
-- Set these values for easier testing
Config.LawEnforcement.lawmenMinimum = 0 -- No lawmen required
Config.BreakIn.lockpickBreaksOnError = false -- Don't lose lockpick on fail
Config.HouseCooldowns = 60 -- 1 minute cooldown instead of default
Config.PoliceAlert.alertChance = 0 -- No police alerts during testing
```

### For Production:
```lua
-- Restore these for live server
Config.LawEnforcement.lawmenMinimum = 2 -- Require 2 lawmen
Config.BreakIn.lockpickBreaksOnError = true -- Lose lockpick on fail
Config.HouseCooldowns = 3600 -- 1 hour cooldown
Config.PoliceAlert.alertChance = 20 -- 20% police alert chance
```

---

## Success Criteria

The fixes are working correctly when:

✅ Target interaction prompt appears reliably at house entrances
✅ Item requirements are properly validated before allowing robbery
✅ Clear error messages appear when requirements aren't met
✅ Minigame appears and functions as expected
✅ Items are successfully added to inventory after searching
✅ NPCs and dogs spawn correctly when configured
✅ House cooldown system prevents abuse
✅ No errors appear in console during normal operation
✅ Performance remains optimal (< 0.05ms peak)

---

## Additional Notes

- The script now uses server-side validation for item checks, which is more secure
- All notifications use the locale system for easy translation
- Config structure is now consistent with professional FiveM/RedM standards
- The inventory system auto-detects and adapts to your setup

---

**Last Updated:** 2026-02-01
**Version:** 2.1.0
**Tested On:** RSG-Core framework with ox_lib, ox_target, and jo_libs
