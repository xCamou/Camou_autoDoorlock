Config = Config or {}

Config.AllowedDoorControlGroups = { 'admin', 'mod', 'support' } -- add  more groups
Config.AllowedDoorControlJobs = { 'clerk' } -- add more jobs

Config.DoorTimes = {
    --Door 1
    {hour = 17, minute = 10, action = "open", doorId = 78},
    {hour = 17, minute = 11, action = "close", doorId = 78},
    --Door 2
    {hour = 17, minute = 12, action = "open", doorId = 79},
    {hour = 17, minute = 13, action = "close", doorId = 79},

    -- add more doors
    
}
