local QBCore = exports['qb-core']:GetCoreObject()
local spawnedPeds = {}
local currentShop = nil

-- Debug print function
local function DebugPrint(msg)
    if Config.Debug then
        print('^3[Black Market Debug]^7 ' .. msg)
    end
end

-- Spawn all black market peds
CreateThread(function()
    Wait(1000)
    
    for _, location in ipairs(Config.Locations) do
        -- Request ped model
        local model = GetHashKey(location.ped.model)
        RequestModel(model)
        
        local timeout = 0
        while not HasModelLoaded(model) and timeout < 100 do
            Wait(100)
            timeout = timeout + 1
        end
        
        if HasModelLoaded(model) then
            -- Create the ped
            local ped = CreatePed(4, model, location.ped.coords.x, location.ped.coords.y, location.ped.coords.z - 1.0, location.ped.coords.w, false, true)
            
            -- Configure ped
            SetEntityHeading(ped, location.ped.coords.w)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            
            -- Set scenario if specified
            if location.ped.scenario then
                TaskStartScenarioInPlace(ped, location.ped.scenario, 0, true)
            end
            
            -- Store ped reference
            spawnedPeds[location.id] = ped
            
            DebugPrint('Spawned ped for: ' .. location.label)
            
            -- Add interaction
            if Config.UseTarget then
                -- Using ox_target
                exports.ox_target:addLocalEntity(ped, {
                    {
                        name = 'blackmarket_' .. location.id,
                        icon = Config.TargetIcon,
                        label = location.label,
                        onSelect = function()
                            OpenShop(location)
                        end,
                        distance = Config.TargetDistance
                    }
                })
                DebugPrint('Added ox_target to: ' .. location.label)
            end
            
            -- Create blip if enabled
            if location.blip and location.blip.enabled then
                local blip = AddBlipForCoord(location.ped.coords.x, location.ped.coords.y, location.ped.coords.z)
                SetBlipSprite(blip, location.blip.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, location.blip.scale)
                SetBlipColour(blip, location.blip.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(location.blip.label)
                EndTextCommandSetBlipName(blip)
            end
            
            SetModelAsNoLongerNeeded(model)
        else
            print('^1[Black Market Error]^7 Failed to load ped model: ' .. location.ped.model)
        end
    end
end)

-- Key press interaction (if not using ox_target)
if not Config.UseTarget then
    CreateThread(function()
        while true do
            local sleep = 1000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, location in ipairs(Config.Locations) do
                local distance = #(playerCoords - vector3(location.ped.coords.x, location.ped.coords.y, location.ped.coords.z))
                
                if distance < Config.Interaction.distance then
                    sleep = 0
                    
                    -- Draw text
                    DrawText3D(location.ped.coords.x, location.ped.coords.y, location.ped.coords.z + 1.0, Config.Interaction.label)
                    
                    -- Check for key press
                    if IsControlJustReleased(0, Config.Interaction.key) then
                        OpenShop(location)
                    end
                end
            end
            
            Wait(sleep)
        end
    end)
end

-- Open shop function
function OpenShop(location)
    DebugPrint('Opening shop: ' .. location.id)
    
    currentShop = location.id
    
    -- Create items array for ox_inventory
    local items = {}
    for i, itemData in ipairs(location.items) do
        items[i] = {
            name = itemData.item,
            price = itemData.price,
            metadata = {},
            currency = itemData.currency or 'money'
        }
    end
    
    -- Open inventory
    TriggerServerEvent('ox_blackmarket:server:openShop', location.id, location.label, items)
    
    -- Alternative method - direct client opening
    exports.ox_inventory:openInventory('shop', {
        type = location.id,
        id = 1,
        title = location.label,
        items = items
    })
end

-- Draw 3D text
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for _, ped in pairs(spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    
    DebugPrint('Resource stopped - cleaned up peds')
end)

-- Notification helper
RegisterNetEvent('ox_blackmarket:client:notify', function(message, type)
    QBCore.Functions.Notify(message, type)
end)
