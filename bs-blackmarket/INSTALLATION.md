# BLACK MARKET SCRIPT - COMPLETE INSTALLATION GUIDE

## 📦 WHAT YOU GET

✅ Multiple black market locations  
✅ Each location has unique inventory  
✅ Works with ox_inventory (all versions)  
✅ Works with ox_target OR key press  
✅ Fully tested and working  
✅ Easy to configure  

---

## 🚀 INSTALLATION (5 MINUTES)

### Step 1: Extract Files
1. Create a folder called `ox_blackmarket` in your `resources` folder
2. Put all these files inside:
   - fxmanifest.lua
   - config.lua
   - client.lua
   - server.lua

Your structure should be:
```
resources/
└── ox_blackmarket/
    ├── fxmanifest.lua
    ├── config.lua
    ├── client.lua
    └── server.lua
```

### Step 2: Add to server.cfg
Add this line to your server.cfg:
```
ensure ox_blackmarket
```

Make sure it's AFTER these resources:
```
ensure qb-core
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure ox_blackmarket  # <-- Add here
```

### Step 3: Configure Locations
Open `config.lua` and change the coordinates:

Find this line:
```lua
coords = vector4(707.99, -966.89, 30.41, 180.0),
```

Replace with YOUR coordinates (use `/getcoords` in game)

### Step 4: Start Your Server
```
restart ox_blackmarket
```

Or just restart your entire server.

### Step 5: Test It!
1. Go to one of the coordinates
2. You should see a ped
3. Look at the ped with ox_target (or press E if using key press)
4. Shop should open!

---

## ⚙️ CONFIGURATION

### Change Ped Location

Get your coordinates:
```
Stand where you want the dealer
Type: /getcoords
Copy the vector4 output
```

Paste in config.lua:
```lua
coords = vector4(YOUR_X, YOUR_Y, YOUR_Z, YOUR_HEADING),
```

### Change What's For Sale

In config.lua, find the `items` section:
```lua
items = {
    { item = 'WEAPON_PISTOL', price = 5000, currency = 'black_money' },
    { item = 'lockpick', price = 250, currency = 'black_money' },
}
```

**Important:** Item names MUST match your `ox_inventory/data/items.lua` exactly!

### Currency Types
- `'money'` = Cash
- `'black_money'` = Dirty money
- `'bank'` = Bank money

### Add More Locations

Copy this template at the end of `Config.Locations`:

```lua
{
    id = 'my_new_dealer', -- MUST BE UNIQUE
    label = 'My Dealer Name',
    ped = {
        model = 'g_m_m_armboss_01',
        coords = vector4(X, Y, Z, HEADING),
        scenario = 'WORLD_HUMAN_SMOKING'
    },
    blip = {
        enabled = false, -- true to show on map
        sprite = 110,
        color = 1,
        scale = 0.7,
        label = 'My Shop'
    },
    items = {
        { item = 'WEAPON_PISTOL', price = 5000, currency = 'black_money' },
        { item = 'lockpick', price = 250, currency = 'black_money' },
    }
},
```

### ox_target vs Key Press

**Using ox_target (Default):**
```lua
Config.UseTarget = true
```

**Using Key Press:**
```lua
Config.UseTarget = false
Config.Interaction.key = 38 -- E key
```

---

## 🎭 PED MODELS

Popular models for dealers:
- `g_m_m_armboss_01` - Gang Boss
- `g_m_m_mexboss_01` - Cartel Boss  
- `g_m_y_lost_01` - Biker
- `g_m_m_chemwork_01` - Chemical Worker
- `a_m_m_business_01` - Business Man
- `s_m_m_armoured_01` - Security Guard

Full list: https://docs.fivem.net/docs/game-references/ped-models/

---

## 🛠️ COMMON ITEMS

Copy these into your items list:

**Weapons:**
```lua
{ item = 'WEAPON_PISTOL', price = 5000, currency = 'black_money' },
{ item = 'WEAPON_COMBATPISTOL', price = 7500, currency = 'black_money' },
{ item = 'WEAPON_SMG', price = 15000, currency = 'black_money' },
{ item = 'WEAPON_ASSAULTRIFLE', price = 25000, currency = 'black_money' },
```

**Tools:**
```lua
{ item = 'lockpick', price = 250, currency = 'black_money' },
{ item = 'advancedlockpick', price = 500, currency = 'black_money' },
{ item = 'drill', price = 2500, currency = 'black_money' },
{ item = 'thermite', price = 5000, currency = 'black_money' },
```

**Ammo:**
```lua
{ item = 'ammo-9', price = 50, currency = 'black_money' },
{ item = 'ammo-45', price = 75, currency = 'black_money' },
{ item = 'ammo-rifle', price = 150, currency = 'black_money' },
```

---

## 🐛 TROUBLESHOOTING

### Ped Doesn't Spawn
**Check:**
- Are coordinates correct? Use `/getcoords`
- Is the ped model spelled correctly?
- Check F8 console for errors

**Fix:**
```
restart ox_blackmarket
```

### Can't Open Shop
**Check F8 Console - Look for:**
```
[Black Market Debug] Opening shop: weapons_dealer
```

If you don't see this, the interaction isn't working.

**Fix:**
1. Make sure ox_target is running: `ensure ox_target`
2. Restart both: `restart ox_target` then `restart ox_blackmarket`
3. Or try key press mode: Set `Config.UseTarget = false` in config.lua

### Shop Opens But No Items
**Check:**
- Do the item names match `ox_inventory/data/items.lua` EXACTLY?
- Check server console for errors

**Fix:**
Type in server console: `bmshops`
This will show all registered shops.

### "Invalid Currency" Error
**Fix:**
Change currency from `'black_money'` to `'money'` in config.lua

### Ped Has No Animation
Add scenario in config.lua:
```lua
scenario = 'WORLD_HUMAN_SMOKING'
```

Popular scenarios:
- `WORLD_HUMAN_SMOKING`
- `WORLD_HUMAN_STAND_IMPATIENT`
- `WORLD_HUMAN_GUARD_STAND`
- `WORLD_HUMAN_DRUG_DEALER`

---

## 🔍 DEBUG MODE

In config.lua:
```lua
Config.Debug = true
```

This will show detailed messages in F8 console about what's happening.

Turn off for production:
```lua
Config.Debug = false
```

---

## 📋 ADMIN COMMANDS

**List all shops (Server console only):**
```
bmshops
```

**Teleport to shop (In-game - requires admin):**
```
/bmtp 1  (teleports to shop #1)
/bmtp 2  (teleports to shop #2)
etc...
```

---

## ✅ CHECKLIST

Before asking for help, check:

- [ ] All 4 files are in the ox_blackmarket folder
- [ ] Added `ensure ox_blackmarket` to server.cfg
- [ ] Dependencies are running (qb-core, ox_inventory, ox_target)
- [ ] Changed coordinates to your server's locations
- [ ] Item names match ox_inventory exactly
- [ ] Restarted the resource
- [ ] Checked F8 console for errors
- [ ] Checked server console for errors

---

## 🆘 STILL NOT WORKING?

1. Enable debug mode: `Config.Debug = true`
2. Restart: `restart ox_blackmarket`
3. Go to a dealer location
4. Press F8 and copy ALL messages
5. Check server console and copy errors

Share those messages and I can help!

---

## 📝 NOTES

- Item images come from ox_inventory automatically
- You can have unlimited locations
- Each location can have different items
- Works with ALL ox_inventory versions
- Works with qb-core

---

## 🎯 QUICK START EXAMPLE

Want to add a new electronics dealer?

1. **Get coordinates:** Go to location, type `/getcoords`

2. **Add to config.lua:**
```lua
{
    id = 'electronics',
    label = 'Electronics Dealer',
    ped = {
        model = 'a_m_m_business_01',
        coords = vector4(YOUR_COORDS_HERE),
    },
    blip = { enabled = false },
    items = {
        { item = 'phone', price = 500, currency = 'money' },
        { item = 'radio', price = 1000, currency = 'money' },
    }
},
```

3. **Restart:** `restart ox_blackmarket`

4. **Done!**

---

**That's it! You're all set up!** 🎉
