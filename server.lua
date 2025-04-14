ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local currentTime = tonumber(os.date("%H"))  -- %H gives the hour in 24-hour format
        local currentMinute = tonumber(os.date("%M"))  -- %M gives the minute

        for _, timeConfig in ipairs(Config.DoorTimes) do
            if currentTime == timeConfig.hour and currentMinute == timeConfig.minute then
                if timeConfig.action == "open" then
                    exports.ox_doorlock:setDoorState(timeConfig.doorId, false)
                    print("Door " .. timeConfig.doorId .. " opened at " .. currentTime .. ":" .. currentMinute)
                elseif timeConfig.action == "close" then
                    exports.ox_doorlock:setDoorState(timeConfig.doorId, true)
                    print("Door " .. timeConfig.doorId .. " closed at " .. currentTime .. ":" .. currentMinute)
                end
            end
        end
    end
end)


RegisterCommand("doorcontrol", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local job = xPlayer.getJob().name
    local group = xPlayer.getGroup()

    local allowed = false

    for _, allowedJob in ipairs(Config.AllowedDoorControlJobs) do
        if job == allowedJob then
            allowed = true
            break
        end
    end

    for _, allowedGroup in ipairs(Config.AllowedDoorControlGroups) do
        if group == allowedGroup then
            allowed = true
            break
        end
    end

    if not allowed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access denied',
            description = 'You do not have authorization for this command.',
            type = 'error'
        })
        return
    end

    local doorId = tonumber(args[1])
    local action = args[2]

    if not doorId or not action or (action ~= "open" and action ~= "close") then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Usage: /doorcontrol [doorId] [open/close]',
            type = 'error'
        })
        return
    end

    local newState = (action == "close") -- true = closed, false = open
    exports.ox_doorlock:setDoorState(doorId, newState)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Türsteuerung',
        description = 'Door #' .. doorId .. ' was successfully ' .. (newState and 'closed' or 'opened') .. '.',
        type = 'success'
    })

    print("Player " .. GetPlayerName(source) .. " , " .. doorId .. " " .. (newState and "closes" or "opens"))
end, false)
