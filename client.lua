local isSearching = false
local searchTarget = nil

local function snapToBehindTarget(targetPed)
    local playerPed = cache.ped or PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(targetPed, 0.0, -0.9, 0.0)
    local heading = GetEntityHeading(targetPed)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, true, false, false, false)
    SetEntityHeading(playerPed, heading)
end

-- TARGET OPTIE
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

-- EVENT: Gevangen dat de inventory sluit (ESC of kruisje)
RegisterNetEvent('ox_inventory:closed', function()
    -- Zodra de inventory sluit, zetten we de zoek-status direct uit
    isSearching = false
    searchTarget = nil
end)

-- EVENT: Verzoek ontvangen
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

-- EVENT: Starten met zoeken
RegisterNetEvent('fouilleer:startSearching', function(targetId)
    local targetPlayer = GetPlayerFromServerId(targetId)
    
    if targetPlayer == -1 then 
        lib.notify({type = 'error', description = 'Speler niet meer gevonden.'})
        return 
    end

    local targetPed = GetPlayerPed(targetPlayer)
    
    snapToBehindTarget(targetPed)

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
        isSearching = true
        searchTarget = targetId
        
        TriggerServerEvent('fouilleer:openInventory', targetId)

        -- START MONITOR LOOP
        Citizen.CreateThread(function()
            local monitorTargetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
            
            while isSearching do
                -- Check elke 200ms (sneller dan voorheen voor betere respons)
                Wait(200) 

                -- CHECK 1: Is de inventory handmatig gesloten via ox_inventory statebag?
                -- LocalPlayer.state.invOpen is false als je op ESC hebt gedrukt.
                if not LocalPlayer.state.invOpen then
                    isSearching = false
                    break -- Stop loop direct, GEEN melding geven
                end

                -- CHECK 2: Dubbele check op onze eigen variabele
                if not isSearching then break end

                -- AFSTAND CHECK
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local targetCoords = GetEntityCoords(monitorTargetPed)
                local dist = #(coords - targetCoords)

                -- Als speler niet meer bestaat OF te ver weg is
                if not DoesEntityExist(monitorTargetPed) or dist > 2.5 then
                    
                    -- Hier sluiten we hem geforceerd, DUS hier geven we wel een melding
                    isSearching = false
                    exports.ox_inventory:closeInventory()

                    lib.notify({type = 'error', description = 'Verbinding verbroken: Afstand te groot.'})
                    break 
                end
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
