function OpenInventory(otherInv)
    if IsPauseMenuActive() then return end
    if weaponLock then return end

    if Config.Blur then SetTimecycleModifier('hud_def_blur') end

    local hotbar = nil
    hotbarLock = false

    if Config.Hotbar then
        hotbar = {slotCount = Config.HotbarSlots, items = nil}
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        inventory = {type = 'main', title = 'Twój <b>Ekwipunek</b>', weight = Config.PlayerWeight},
        otherInventory = otherInv,
        players = GetPlayersInArea(),
        sound = Config.SoundEffects,
        hotbar = hotbar,
        invName = GetCurrentResourceName(),
        middleClickUse = Config.MiddleClickToUse,
        clickOutside = Config.ClickOutsideToClose,
        locales = Locales
    })

    Wait(50)

    GetInventory()
    if otherInv then
        GetInventory(otherInv)
    end

    OtherInventory = otherInv
end

function GetInventory(otherInv, refresh)
    if otherInv then
        ESX.TriggerServerCallback("inventory:getOtherInventory", function(items)
            -- if otherInv.timeout and not refresh then Wait(otherInv.timeout) end
            SendNUIMessage({
                action = 'setOtherItems',
                items = items,
                weight = false
            })
        end, otherInv)
    else 
        ESX.TriggerServerCallback("inventory:getInventory", function(items, hotbar)
            SendNUIMessage({
                action = 'setItems',
                items = items,
                weight = false,
                hotbar = hotbar
            })
        end)
    end
end

function CloseInventory()
    SetNuiFocus(false, false)
    if Config.Blur then
        SetTimecycleModifier('default')
    end

    TriggerEvent("inventory:close")

    if OtherInventory then
        TriggerServerEvent("inventory:close", OtherInventory)
    end
end

function GetPlayersInArea()
    local players = {}

    for k,v in pairs(ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)) do 
        local src = GetPlayerServerId(v)
        local name = GetPlayerName(v)
        table.insert(players, {src = src, name = name})
    end

    return players
end

function UseItemFromHotbar(slot)
    local ped = PlayerPedId()
    ESX.TriggerServerCallback("inventory:getInventory", function(items, hotbar)
        local item = hotbar.items[slot]

        if item then
            local data = {}
            local found = false
            for k,v in pairs(items) do
                if v.name == item.name then
                    data = v
                    found = true
                end
            end
    
            if not found then return end

            if item.type == 'item_standard' then
                if data.use then
                    TriggerServerEvent('esx:useItem', item.name)
                    return
                end
                print(item.name)
                local isWeapon = exports['esx_weaponsync']:ItemIsWeapon(item.name)
                print(isWeapon)
                if isWeapon then 
                    if not weaponLock then
                        weaponLock = true
                        if not weaponEquiped or weaponEquiped.name ~= item.name then
                            weaponEquiped = item
                            ESX.Streaming.RequestAnimDict('reaction@intimidation@1h', function()
                                -- TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 2, 0, 0, 0)
                                Wait(250)
                                SetCurrentPedWeapon(ped, isWeapon, true)
                                ClearPedTasks(ped)
                                weaponLock = false
                            end)
                        else 
                            weaponEquiped = nil
                            ESX.Streaming.RequestAnimDict('reaction@intimidation@1h', function()
                                -- TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 2, 0, 0, 0)
                                Wait(250)
                                ClearPedTasks(ped)
                                SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)
                                weaponLock = false
                            end) 
                        end 
                    end
                end
            end
        end
    end)
end

function ShowHotbar()
    if not hotbarLock then
        ESX.TriggerServerCallback("inventory:getInventory", function(items, hotbar)
            SendNUIMessage({
                action = 'showHotbar',
                hotbar = hotbar,
                invName = GetCurrentResourceName(),
                timeout = Config.HotbarTimeout
            })
            hotbarLock = true
        end) 
    end
end

RegisterNetEvent('inventory:open', function(otherInv)
    OpenInventory(otherInv)
end)