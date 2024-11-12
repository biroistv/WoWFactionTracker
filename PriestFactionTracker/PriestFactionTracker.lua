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
        true,
        "Interface\\Buttons\\WHITE8X8",
        "Interface\\Buttons\\WHITE8X8",
        {r = 0, g = 0, b = 0, a = 0},
        {r = 0, g = 0, b = 0, a = 0},
        16,
        2,
        2
    )

    local factionFrame =
        PriestFactionGUI:CreateFactionProgressFrame(
        mainFrame, -- Parent frame
        "Interface\\Icons\\INV_Misc_Head_Human_01", -- Icon path
        "Example Faction", -- Faction name
        1500, -- Current progress
        2000 -- Max progress
    )
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
