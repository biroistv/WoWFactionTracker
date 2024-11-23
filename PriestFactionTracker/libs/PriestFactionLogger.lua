-- PriestFactionLogger.lua

-- PriestFactionGUI.lua: Library for creating and managing GUI elements in WoW with Object Pooling
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_Logger = {}
local PriestFactionLogger = WoWFactionTracker.PRST_Logger

-- Define log levels and their colors in WoW's coloring syntax
PriestFactionLogger.Levels = {
    INFO = {color = "|cFF00FF00", name = "INFO"}, -- White
    WARNING = {color = "|cFFFFFF00", name = "WARNING"}, -- Yellow
    ERROR = {color = "|cFFFF0000", name = "ERROR"}, -- Red
    DEBUG = {color = "|cFF00FFFF", name = "DEBUG"} -- Cyan
}

-- Toggle verbosity for each level
PriestFactionLogger.verbosity = {
    INFO = true,
    WARNING = true,
    ERROR = true,
    DEBUG = false -- Default off, enable as needed
}

-- Function to log messages with WoW's coloring format
function PriestFactionLogger:Log(level, message)
    local logLevel = self.Levels[level]
    if not logLevel then
        error("|cFFFF0000Invalid log level:|r " .. tostring(level))
    end

    if self.verbosity[level] then
        print(string.format("%s[%s]|r %s", logLevel.color, logLevel.name, message))
    end
end

-- Shorthand functions for each severity level
function PriestFactionLogger:Info(message)
    self:Log("INFO", message)
end

function PriestFactionLogger:Warning(message)
    self:Log("WARNING", message)
end

function PriestFactionLogger:Error(message)
    self:Log("ERROR", message)
end

function PriestFactionLogger:Debug(message)
    self:Log("DEBUG", message)
end

return Logger
