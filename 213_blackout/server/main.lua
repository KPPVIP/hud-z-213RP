
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('213_blackout:dzwon')
AddEventHandler('213_blackout:dzwon', function(list, damage)	
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('213_blackout:dzwon', v, damage)
	end
	
	TriggerClientEvent('213_blackout:dzwon', _source, damage)
end)

RegisterServerEvent('213_blackout:impact')
AddEventHandler('213_blackout:impact', function(list, speedBuffer, velocityBuffer)
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('213_blackout:impact', v, speedBuffer, velocityBuffer)
	end
	
	TriggerClientEvent('213_blackout:impact', _source, speedBuffer, velocityBuffer)
end)