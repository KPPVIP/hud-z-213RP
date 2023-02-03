if Config.Player then 
    if Config.PlayerWeight then 
        ESX.RegisterCommand('openinv', 'admin', function(xPlayer, args, showError)
            local target = ESX.GetPlayerFromId(args.id)
            if not target then 
                xPlayer.triggerEvent("inventory:notify", "error", "Nie ma podanego gracza")
                return 
            end
    
            if xPlayer.getIdentifier() == target.getIdentifier() then
                xPlayer.triggerEvent("inventory:notify", "error", "Nie możesz zobaczyć własnego ekwipunku")
                return
            end
    
            if GetPlayerName(args.id) then 
                xPlayer.triggerEvent("inventory:openPlayerInventory", args.id)
            else 
                xPlayer.triggerEvent("inventory:notify", "error", "Nie ma podanego gracza")
            end
        end, false, {help = "Zobacz ekwipunek gracza", validate = true, arguments = {
            {name = 'id', help = 'Server ID of player', type = 'number'},
        }})
    else 
        TriggerEvent('es:addGroupCommand', 'openinv', 'admin', function(source, args, user)
            local xPlayer = ESX.GetPlayerFromId(args.id)
            if not xPlayer then return end
    
            local target = ESX.GetPlayerFromId(args.id)
            if not target then 
                TriggerClientEvent("inventory:notify", source, "error", "Nie ma podanego gracza")
                return 
            end
    
            if xPlayer.getIdentifier() == target.getIdentifier() then
                TriggerClientEvent("inventory:notify", source, "error", "Nie możesz zobaczyć własnego ekwipunku")
                return
            end
    
            if GetPlayerName(args.id) then 
                TriggerClientEvent("inventory:openPlayerInventory", source, args.id)
            else 
                TriggerClientEvent("inventory:notify", source, "error", "Nie ma podanego gracza")
            end
        end, function(source, args, user)
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
        end, {help = "Zobacz ekwipunek gracza", params = {{name = "id", help = "Server ID of player"}}})
    end
end