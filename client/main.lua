local sharedConfig = require 'config.shared'
local playerBlips = {}

---@param playerId number
local function removePlayer(playerId)
    local blip = playerBlips[playerId]

    if blip then
        RemoveBlip(blip)
        playerBlips[playerId] = nil
    end
end

RegisterNetEvent('qbx_dutyblips:client:removePlayer', removePlayer)

RegisterNetEvent('qbx_dutyblips:client:updatePositions', function(players)
    for i = 1, #players do
        local player = players[i]
        local blip = playerBlips[player.playerId]

        if not blip then
            local label = ('player:%s'):format(player.playerId)
            local name = ('%s. %s'):format(player.firstName:sub(1, 1):upper(), player.lastName)

            if player.group == 'police' or player.group == 'ambulance' then
                name = ('%s | %s. %s'):format(player.callsign, player.firstName:sub(1, 1):upper(), player.lastName)
            end

            blip = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(player.playerId)))

            playerBlips[player.playerId] = blip

            local group = sharedConfig.groups[player.group]

            SetBlipSprite(blip, group.sprite or 1)
            SetBlipColour(blip, group.color or 42)
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