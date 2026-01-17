local function snapToBehindTarget(targetPed)
    local playerPed = cache.ped or PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(targetPed, 0.0, -0.9, 0.0)
    local heading = GetEntityHeading(targetPed)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, true, false, false, false)
    SetEntityHeading(playerPed, heading)
end

exports.ox_target:addGlobalPlayer({
    {
        label = 'Fouilleren',
        icon = 'fa-solid fa-magnifying-glass',
        distance = 2.0,
        onSelect = function(data)
            local targetPlayer = NetworkGetPlayerIndexFromPed(data.entity)
            local targetServerId = GetPlayerServerId(targetPlayer)

            if targetServerId == -1 then return end
            TriggerServerEvent('fouilleer:requestSearch', targetServerId)
        end
    }
})

RegisterNetEvent('fouilleer:receiveRequest', function(searcherId)
    local alert = lib.alertDialog({
        header = 'Fouilleer Verzoek',
        content = 'Iemand wil je fouilleren. Sta je dit toe?',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Accepteren',
            cancel = 'Weigeren'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('fouilleer:acceptSearch', searcherId)
    else
        TriggerServerEvent('fouilleer:denySearch', searcherId)
    end
end)

RegisterNetEvent('fouilleer:startSearching', function(targetId)
    local targetPlayer = GetPlayerFromServerId(targetId)
    
    if targetPlayer == -1 then 
        lib.notify({type = 'error', description = 'Speler niet meer gevonden.'})
        return 
    end

    local targetPed = GetPlayerPed(targetPlayer)
    
    -- Positie correctie
    snapToBehindTarget(targetPed)

    -- Animatie en Progressbar
    if lib.progressBar({
        duration = 5000,
        label = 'Persoon fouilleren...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search'
        },
    }) then 
        -- Open de inventory via server
        TriggerServerEvent('fouilleer:openInventory', targetId)

        -- NIEUW: Start een loop om de afstand in de gaten te houden
        Citizen.CreateThread(function()
            -- We slaan het ped ID van het doelwit op om te checken
            local searchTargetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
            
            while true do
                -- Check elke 500ms (halve seconde)
                Wait(500) 

                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local targetCoords = GetEntityCoords(searchTargetPed)
                local dist = #(coords - targetCoords)

                -- 1. Check of de andere speler nog bestaat (niet uitgelogd)
                -- 2. Check of de afstand groter is dan 2.5 meter
                if not DoesEntityExist(searchTargetPed) or dist > 2.5 then
                    -- Sluit de inventory geforceerd
                    exports.ox_inventory:closeInventory()
                    lib.notify({type = 'error', description = 'Inventory gesloten! Afstand met speler is te groot.'})
                    break -- Stop de loop
                end

                -- (Optioneel) Als je zelf op ESC drukt en de inventory sluit,
                -- blijft deze loop nog even draaien tot je wegloopt.
                -- Dit is de veiligste methode zonder complexe inventory-events te gebruiken.
            end
        end)
    else 
        lib.notify({
            title = 'Fouilleren',
            description = 'Je bent gestopt met fouilleren.',
            type = 'error'
        })
    end
end)

RegisterNetEvent('fouilleer:notifyDenial', function()
    lib.notify({
        title = 'Geweigerd',
        description = 'De persoon heeft het fouilleren geweigerd.',
        type = 'error'
    })
end)