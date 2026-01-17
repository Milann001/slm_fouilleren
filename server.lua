RegisterNetEvent('fouilleer:requestSearch', function(targetId)
    local source = source
    if source == targetId then return end
    TriggerClientEvent('fouilleer:receiveRequest', targetId, source)
end)

RegisterNetEvent('fouilleer:acceptSearch', function(searcherId)
    local source = source -- De speler die gefouilleerd wordt
    -- Stuur signaal naar fouilleerder om animatie te starten
    TriggerClientEvent('fouilleer:startSearching', searcherId, source)
end)

RegisterNetEvent('fouilleer:denySearch', function(searcherId)
    TriggerClientEvent('fouilleer:notifyDenial', searcherId)
end)

-- NIEUW: Dit event opent de inventory daadwerkelijk
RegisterNetEvent('fouilleer:openInventory', function(targetId)
    local source = source
    
    -- We gebruiken forceOpenInventory server-side.
    -- Dit negeert de standaard checks en dwingt de inventory open voor de speler.
    exports.ox_inventory:forceOpenInventory(source, 'player', targetId)
end)