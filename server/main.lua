local config = require 'config.server'
local sharedConfig = require 'config.shared'
local activePlayers = {}

---@param name string
---@param data any
local function triggerPlayersEvent(name, data)
    for playerId in pairs(activePlayers) do
        TriggerClientEvent(name, playerId, data)
    end
end

---@param playerId number
local function getPlayer(playerId)
    return activePlayers[playerId]
end

---@param playerId number
local function removePlayer(playerId)
    triggerPlayersEvent('qbx_dutyblips:client:removePlayer', playerId)

    activePlayers[playerId] = nil
end

---@param playerId number
local function addPlayer(playerId)
    local player = exports.qbx_core:GetPlayer(playerId)

    if not player then return end

    local groups = {}

    for group in pairs(sharedConfig.groups) do
        groups[#groups + 1] = group
    end

    local hasGroup = exports.qbx_core:HasPrimaryGroup(playerId, groups)

    if not hasGroup then return end

    activePlayers[playerId] = {
        firstName = player.PlayerData.charinfo.firstname,
        lastName = player.PlayerData.charinfo.lastname,
        playerId = playerId,
        group = player.PlayerData.job.name,
        grade = player.PlayerData.job.grade.label,
    }

    if player.PlayerData.job.name == 'police' or player.PlayerData.job.name == 'ambulance' then
        activePlayers[playerId].callsign = player.PlayerData.metadata.callsign
    end
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    addPlayer(source)
end)

AddEventHandler('QBCore:Server:OnJobUpdate', function(source, job)
    local player = getPlayer(source)

    if player then
        if player.group == job.name then
            activePlayers[source].grade = job.grade.label
            return
        else
            local playerJob = exports.qbx_core:GetJob(job.name)

            if playerJob.type ~= 'leo' then
                removePlayer(source)
                return
            end

            activePlayers[source].group = job.name
            activePlayers[source].grade = job.grade.label
            return
        end
    end

    addPlayer(source)
end)

AddEventHandler('QBCore:Server:SetDuty', function(source, onDuty)
    local player = getPlayer(source)

    if player then
        if not onDuty then
            removePlayer(source)
            return
        end
    end

    addPlayer(source)
end)

SetInterval(function()
    triggerPlayersEvent('qbx_dutyblips:client:updatePositions', activePlayers)
end, config.refreshRate)