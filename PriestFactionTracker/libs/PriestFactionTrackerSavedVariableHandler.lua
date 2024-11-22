-- Initialize addon namespace
-- =============================================================================
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionTrackerSavedVariableHandler = {}
local PriestFactionTrackerSavedVariableHandler = WoWFactionTracker.PRST_FactionTrackerSavedVariableHandler

-- Function to be called when the addon is loaded
function PriestFactionTrackerSavedVariableHandler.Initialize()
    print("Initializing PriestFactionTrackerSavedVariableHandler")
    if not PriestFactionTrackerDB then
        print("Initializing PriestFactionTrackerDB")
        PriestFactionTrackerDB = {}
    end
end

--- Get a value from the saved variables
function PriestFactionTrackerSavedVariableHandler.Get(key)
    return PriestFactionTrackerDB and PriestFactionTrackerDB[key]
end

--- Set a value in the saved variables
function PriestFactionTrackerSavedVariableHandler.Set(key, value)
    if PriestFactionTrackerDB then
        -- Add data validation if necessary
        print(key)
        for k, v in pairs(value) do
            print(k, v)
        end

        PriestFactionTrackerDB[key] = value
    end
end

--- Reset the saved variables to the default values
function PriestFactionTrackerSavedVariableHandler.Reset(defaults)
    PriestFactionTrackerDB = CopyTable(defaults)
end
