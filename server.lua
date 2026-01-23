RegisterNetEvent('fouilleer:requestSearch', function(targetId)
    local source = source
    if source == targetId then return end
    TriggerClientEvent('fouilleer:receiveRequest', targetId, source)
end)

RegisterNetEvent('fouilleer:acceptSearch', function(searcherId)
    local source = source
    TriggerClientEvent('fouilleer:startSearching', searcherId, source)
end)

RegisterNetEvent('fouilleer:denySearch', function(searcherId)
    TriggerClientEvent('fouilleer:notifyDenial', searcherId)
end)

RegisterNetEvent('fouilleer:openInventory', function(targetId)
    local source = source
    -- forceOpenInventory is nodig om beveiliging te omzeilen
    exports.ox_inventory:forceOpenInventory(source, 'player', targetId)
end)
