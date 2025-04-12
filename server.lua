Config = Config or {}

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
