Config = {}

-- Debug mode (set to false for production)
Config.Debug = false

-- Black Market Locations
-- Add as many as you want! Each location has its own inventory
Config.Locations = {

    -- LOCATION 1: Drugs Dealer
    {
        id = 'drugs_dealer',
        label = 'Drugs Dealer',
        ped = {
            model = 'u_m_m_streetart_01',
            coords = vector4(244.66, 374.63, 105.74, 163.36),
            scenario = 'WORLD_HUMAN_DRUG_DEALER'
        },
        blip = {
            enabled = false,
            sprite = 110,
            color = 1,
            scale = 0.7,
            label = 'Black Market'
        },
        items = {
            { item = 'pill_bottle', price = 150, currency = 'money' },
            { item = 'double_cup', price = 150, currency = 'money' },
            { item = 'plastic_bag', price = 150, currency = 'money' },
            { item = 'security_card_blue', price = 3000, currency = 'money' },
            { item = 'security_card_blue', price = 5000, currency = 'money' },
        }
    },


    -- ADD MORE LOCATIONS HERE BY COPYING THE STRUCTURE ABOVE
    -- Just make sure each 'id' is unique!
}

-- Interaction settings
Config.Interaction = {
    distance = 3.0, -- How close you need to be to interact
    key = 38, -- E key (default)
    label = '[E] Open Black Market'
}

-- ox_target settings (if you're using ox_target instead of key press)
Config.UseTarget = true -- Set to false to use key press instead
Config.TargetIcon = 'fas fa-shopping-bag'
Config.TargetDistance = 2.5
