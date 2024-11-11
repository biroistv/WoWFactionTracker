-- Initialize addon namespace
local addonName, WoWFactionTracker = ...

-- Basic load message
local function OnLoad()
    print(addonName .. " loaded successfully!")
end

-- Event listener for addon loading
local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" and name == addonName then
        OnLoad()
    end
end)
