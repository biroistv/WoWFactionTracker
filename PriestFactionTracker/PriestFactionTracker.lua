-- Initialize addon namespace
local addonName, WoWFactionTracker = ...

local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI

-- Main function to run when the addon is loaded
local function OnLoad()
    print(addonName .. " loaded successfully!")

    -- Create a frame using the GUI library
    local myFrame = PriestFactionGUI:CreateFrame("MyTrackerFrame", 300, 200, "Faction Tracker", true)

    local SubFrame = PriestFactionGUI:AddFrame(myFrame, "MyTrackerSubFrame", 200, 100, "Sub Frame")

    -- Create a button within the frame
    local button = PriestFactionGUI:CreateButton(SubFrame, "Close", 100, 30, function()
        myFrame:Hide()
        PriestFactionGUI:ReleaseFrame(myFrame)  -- Release back to pool when done
    end)
    button:SetPoint("BOTTOM", myFrame, "BOTTOM", 0, 20)

    -- Create a label within the frame
    local label = PriestFactionGUI:CreateLabel(SubFrame, "Track your faction progress here!", 14, 10, -30)
end

-- Event listener for addon loading
local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" and name == addonName then
        OnLoad()
    end
end)