-- Initialize addon namespace
local addonName, WoWFactionTracker = ...

local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI

-- Main function to run when the addon is loaded
local function OnLoad()
    print(addonName .. " loaded successfully!")

    -- Create a frame using the GUI library
    -- Create a frame with custom styling
    local mainFrame =
        PriestFactionGUI:CreateFrame(
        "MainTrackerFrame",
        400,
        300,
        "Faction Tracker",
        true,
        "Interface\\Buttons\\WHITE8X8",
        "Interface\\Buttons\\WHITE8X8",
        {r = 0, g = 0, b = 0, a = 0.7},
        {r = 0, g = 0, b = 0, a = 1  },
        16,
        2,
        2
    )

    local SubFrame = PriestFactionGUI:AddFrame(mainFrame, "MyTrackerSubFrame", 200, 100, "Sub Frame")

    -- Create a button with custom styling in the main frame
    local button =
        PriestFactionGUI:CreateButton(
        mainFrame,
        "Close",
        100,
        30,
        function()
            mainFrame:Hide()
            PriestFactionGUI:ReleaseFrame(mainFrame)
        end,
        {r = 0.5, g = 0, b = 0, a = 1}, -- Dark red button background
        {r = 1, g = 1, b = 1, a = 1}, -- White text color
        14 -- Font size for button text
    )
    button:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 20)

    -- Create a label within the frame
    local label = PriestFactionGUI:CreateLabel(mainFrame, "Track your faction progress here!", 14, 10, -30)
end

-- Event listener for addon loading
local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")

frame:SetScript(
    "OnEvent",
    function(_, event, name)
        if event == "ADDON_LOADED" and name == addonName then
            OnLoad()
        end
    end
)
