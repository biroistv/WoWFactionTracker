-- SettingsWindow.lua: Handles the creation and management of the settings window for Priest Faction Tracker.
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionTrackerSettings = {}
local PriestFactionTrackerSettingsGUI = WoWFactionTracker.PRST_FactionTrackerSettings
local PriestFactionGUI                = WoWFactionTracker.PRST_FactionGUI

-- Initialize the saved variable if it doesn’t exist
PriestFactionTrackerDB = PriestFactionTrackerDB or {}

-- Function to create the settings window
local function CreateSettingsWindow()
    -- Create the main settings frame
    local settingsFrame = PriestFactionGUI:CreateFrame(
        "MainTrackerFrame",
        400,
        300,
        " ",
        true,
        true,
        "Interface\\Buttons\\WHITE8X8",
        "Interface\\Buttons\\WHITE8X8",
        {r = 0, g = 0, b = 0, a = 0.6},
        {r = 0, g = 0, b = 0, a = 1},
        16,
        2,
        2)
    settingsFrame:Hide()  -- Hide the frame initially

    -- Close button in the bottom-right corner
    local closeButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
    closeButton:SetSize(80, 24)
    closeButton:SetText("Close")
    closeButton:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -5, 5)  -- 5-pixel padding

    -- Close button functionality
    closeButton:SetScript("OnClick", function()
        settingsFrame:Hide()
    end)

    return settingsFrame
end

-- Store the settings frame in a variable and create it only once
local settingsFrame = CreateSettingsWindow()

-- Function to toggle the settings window visibility
function PriestFactionTrackerSettingsGUI:ToggleFactionTrackerSettingsWindow()
    if settingsFrame:IsShown() then
        settingsFrame:Hide()
    else
        settingsFrame:Show()
    end
end
