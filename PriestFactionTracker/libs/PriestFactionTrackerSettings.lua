-- SettingsWindow.lua: Handles the creation and management of the settings window for Priest Faction Tracker.
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionTrackerSettings = {}
local PriestFactionTrackerSettingsGUI = WoWFactionTracker.PRST_FactionTrackerSettings
local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI

-- Initialize the saved variable if it doesn’t exist
PriestFactionTrackerDB = PriestFactionTrackerDB or {}

-- Define settings groups with corresponding names
local settingsGroups = {
    {name = "Window"},
    {name = "Faction"},
    {name = "Help"},
    {name = "About"}
}

-- Function to populate the cyan frame with settings based on selected group
local function PopulateSettingsGroup(cyanFrame, groupName)
    -- Clear previous content
    for _, child in ipairs({cyanFrame:GetChildren()}) do
        child:Hide()
    end

    -- Create a checkbox for the selected settings group
    local checkbox = CreateFrame("CheckButton", nil, cyanFrame, "ChatConfigCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", cyanFrame, "TOPLEFT", 20, -20)
    checkbox.Text:SetText(groupName)
    checkbox.tooltip = "Toggle setting for " .. groupName

    -- Set initial state from the saved variable and define the script to save changes
    checkbox:SetChecked(PriestFactionTrackerDB[groupName] or false)
    checkbox:SetScript(
        "OnClick",
        function(self)
            PriestFactionTrackerDB[groupName] = self:GetChecked()
        end
    )
end

-- Function to create the settings window
local function CreateSettingsWindow()
    -- Create the main settings frame
    local settingsFrame =
        PriestFactionGUI:CreateFrame(
        "MainTrackerFrame",
        400,
        300,
        " ",
        true,
        true,
        "Interface\\Buttons\\WHITE8X8",
        "Interface\\Buttons\\WHITE8X8",
        {r = 0, g = 0, b = 0, a = 0.6},
        {r = 92 / 255, g = 92 / 255, b = 92 / 255, a = 1},
        16,
        2,
        2
    )
    settingsFrame:Hide() -- Hide the frame initially

    -- Create the green subframe (stretches horizontally across the top)
    local greenFrame = CreateFrame("Frame", nil, settingsFrame, "BackdropTemplate")
    greenFrame:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -10)
    greenFrame:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -10, -10)
    greenFrame:SetHeight(20) -- Fixed height for the green frame
    greenFrame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2
        }
    )
    greenFrame:SetBackdropBorderColor(0, 0, 0, 0) -- Green border
    greenFrame:SetBackdropColor(0, 0, 0, 0) -- Green border
    PriestFactionGUI:CreateLabel(greenFrame, "Priest Faction Tracker Settings", 16, 5, 0)

    -- Create the red subframe (fixed width, tracks Y-axis)
    local redFrame = CreateFrame("Frame", nil, settingsFrame, "BackdropTemplate")
    redFrame:SetSize(150, settingsFrame:GetHeight() - 100) -- Fixed width, stretches vertically
    redFrame:SetPoint("TOPLEFT", greenFrame, "BOTTOMLEFT", 0, -10)
    redFrame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2
        }
    )
    redFrame:SetBackdropBorderColor(1, 0, 0, 1) -- Red border

    -- Create the cyan subframe (tracks both X and Y axes)
    local cyanFrame = CreateFrame("Frame", nil, settingsFrame, "BackdropTemplate")
    cyanFrame:SetPoint("TOPLEFT", redFrame, "TOPRIGHT", 10, 0)
    cyanFrame:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 60)
    cyanFrame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2
        }
    )
    cyanFrame:SetBackdropBorderColor(0, 1, 1, 1) -- Cyan border

    -- Create buttons in the red frame for each settings group
    local previousButton
    for i, group in ipairs(settingsGroups) do
        local button = CreateFrame("Button", nil, redFrame, "UIPanelButtonTemplate")
        button:SetSize(120, 30)
        button:SetText(group.name)

        if i == 1 then
            button:SetPoint("TOPLEFT", redFrame, "TOPLEFT", 5, -5)
        else
            button:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, -5)
        end
        button:SetScript(
            "OnClick",
            function()
                PopulateSettingsGroup(cyanFrame, group.name)
            end
        )

        previousButton = button
    end

    -- Create the yellow subframe (stretches horizontally only)
    local yellowFrame = CreateFrame("Frame", nil, settingsFrame, "BackdropTemplate")
    yellowFrame:SetPoint("BOTTOMLEFT", settingsFrame, "BOTTOMLEFT", 10, 10)
    yellowFrame:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 10)
    yellowFrame:SetHeight(40) -- Fixed height
    yellowFrame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2
        }
    )
    yellowFrame:SetBackdropBorderColor(1, 1, 0, 1) -- Yellow border

    -- Create the close button in the bottom-right corner of the yellow frame
    local closeButton =
        PriestFactionGUI:CreateStylizedButton(
        yellowFrame,
        80,
        24,
        "Close",
        {r = 0, g = 0, b = 0, a = 1},
        {r = 1, g = 1, b = 1, a = 1}
    )
    closeButton:SetPoint("BOTTOMRIGHT", yellowFrame, "BOTTOMRIGHT", -5, 5) -- 5-pixel padding

    -- Close button functionality
    closeButton:SetScript(
        "OnClick",
        function()
            settingsFrame:Hide()
        end
    )

    -- OnSizeChanged script for main settings frame to resize subframes
    settingsFrame:SetScript(
        "OnSizeChanged",
        function(self, width, height)
            -- Adjust the height of the red frame to match the settings frame’s height minus padding for other frames
            redFrame:SetHeight(height - 100)
        end
    )

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
