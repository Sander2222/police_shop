ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


ESX.RegisterServerCallback('police_shop:canAfford', function(source, cb, value, warenkorb)
    local s = source
    local x = ESX.GetPlayerFromId(s)

    if x.getMoney() >= value then
        for key, value in pairs(warenkorb) do
            local sourceItem = x.getInventoryItem(value.name)
        	    if sourceItem.weight ~= -1 and sourceItem.count >= 30 then
					x.showNotification("You can no longer carry " .. value.display .. "")
            	else
					cb(true)
                	x.addInventoryItem(value.name, 1)
					x.removeMoney(value.price)
        		end
    		end
				if x.getMoney() <= value then
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('police_shop:fetchItems', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM police_shop', {}, function(stores)
		cb(stores)
	end)
end)
