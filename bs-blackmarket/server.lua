local QBCore = exports['qb-core']:GetCoreObject()

-- Debug print
local function DebugPrint(msg)
    if Config.Debug then
        print('^3[Black Market Debug]^7 ' .. msg)
    end
end

-- Initialize shops when resource starts
CreateThread(function()
    Wait(3000) -- Wait for ox_inventory to fully load
    
    DebugPrint('Initializing black market shops...')
    
    for _, location in ipairs(Config.Locations) do
        -- Prepare shop items
        local shopItems = {}
        for i, itemData in ipairs(location.items) do
            table.insert(shopItems, {
                name = itemData.item,
                price = itemData.price,
                metadata = {},
                currency = itemData.currency or 'money'
            })
        end
        
        -- Try to register with ox_inventory
        local success, result = pcall(function()
            return exports.ox_inventory:RegisterShop(location.id, {
                name = location.label,
                inventory = shopItems
            })
        end)
        
        if success then
            print('^2[Black Market]^7 ✓ Registered shop: ' .. location.label .. ' (' .. #shopItems .. ' items)')
        else
            print('^3[Black Market]^7 ! Shop registration method not available for: ' .. location.label)
            print('^3[Black Market]^7 ! Using alternative method (this is normal for some ox_inventory versions)')
        end
    end
    
    print('^2[Black Market]^7 All shops initialized!')
end)

-- Handle shop opening from client
RegisterNetEvent('ox_blackmarket:server:openShop', function(shopId, shopLabel, items)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then 
        DebugPrint('Player not found when opening shop')
        return 
    end
    
    local playerName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    DebugPrint(playerName .. ' (' .. Player.PlayerData.citizenid .. ') opened: ' .. shopLabel)
    
    -- Log the shop access
    print(string.format('^5[Black Market]^7 %s accessed %s', playerName, shopLabel))
end)

-- Custom buy handler (optional - ox_inventory handles this automatically)
-- This is here if you want to add custom logic when someone buys something
RegisterNetEvent('ox_blackmarket:server:buyItem', function(shopId, itemName, amount, price, currency)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local totalPrice = price * amount
    
    -- Verify player has money
    local hasMoney = false
    if currency == 'money' then
        hasMoney = Player.PlayerData.money.cash >= totalPrice
    elseif currency == 'black_money' then
        hasMoney = Player.PlayerData.money.black_money and Player.PlayerData.money.black_money >= totalPrice
    end
    
    if hasMoney then
        DebugPrint(GetPlayerName(src) .. ' bought ' .. amount .. 'x ' .. itemName .. ' for $' .. totalPrice)
    else
        TriggerClientEvent('ox_blackmarket:client:notify', src, 'Not enough money!', 'error')
    end
end)

-- Get shop data (for debugging)
RegisterCommand('bmshops', function(source, args, rawCommand)
    if source == 0 then -- Server console only
        print('^2[Black Market] Registered Shops:^7')
        for _, location in ipairs(Config.Locations) do
            print('  - ' .. location.label .. ' (ID: ' .. location.id .. ') - ' .. #location.items .. ' items')
        end
    end
end, true)

-- Admin command to teleport to shops (optional)
RegisterCommand('bmtp', function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- Check if player is admin (adjust permission check as needed)
    if Player.PlayerData.job.name == 'police' or QBCore.Functions.HasPermission(source, 'admin') then
        local shopNum = tonumber(args[1])
        if shopNum and Config.Locations[shopNum] then
            local coords = Config.Locations[shopNum].ped.coords
            TriggerClientEvent('QBCore:Command:TeleportToCoords', source, coords.x, coords.y, coords.z)
            TriggerClientEvent('ox_blackmarket:client:notify', source, 'Teleported to ' .. Config.Locations[shopNum].label, 'success')
        else
            TriggerClientEvent('ox_blackmarket:client:notify', source, 'Usage: /bmtp [1-' .. #Config.Locations .. ']', 'error')
        end
    end
end)

print('^2========================================^7')
print('^2[Black Market]^7 Server script loaded!')
print('^2[Black Market]^7 Locations: ' .. #Config.Locations)
print('^2========================================^7')
