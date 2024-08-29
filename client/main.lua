local officerBlips = {}

---@param playerId number
local function removeOfficer(playerId)
    local blip = officerBlips[playerId]

    if blip then
        RemoveBlip(blip)
        officerBlips[playerId] = nil
    end
end

RegisterNetEvent('qbx_police:client:removeOfficer', removeOfficer)

RegisterNetEvent('qbx_police:client:updatePositions', function(officers)
    for i = 1, #officers do
        local officer = officers[i]
        local blip = officerBlips[officer.playerId]

        if not blip then
            local label = ('leo:%s'):format(officer.playerId)
            local name = ('%s | %s. %s'):format(officer.callsign, officer.firstName:sub(1, 1):upper(), officer.lastName)

            blip = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(officer.playerId)))

            officerBlips[officer.playerId] = blip

            SetBlipSprite(blip, 1)
            SetBlipColour(blip, 42)
            SetBlipDisplay(blip, 3)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 2)
            ShowHeadingIndicatorOnBlip(blip, true)
            AddTextEntry(label, name)
            BeginTextCommandSetBlipName(label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)