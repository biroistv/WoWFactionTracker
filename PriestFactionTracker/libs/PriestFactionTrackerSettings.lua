-- SettingsWindow.lua: Handles the creation and management of the settings window for Priest Faction Tracker.
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionTrackerSettings = {}
local PriestFactionTrackerSettingsGUI = WoWFactionTracker.PRST_FactionTrackerSettings
local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI
local PriestFactionTrackerSavedVariableHandler = WoWFactionTracker.PRST_FactionTrackerSavedVariableHandler

-- Define settings sections with collapsible headers and their respective options
local settingsSections = {
    {
        header = "General",
        options = {"Settings Frame", "Tracker Frame"}
    },
    {
        header = "Faction Tracker",
        options = {"Faction", "Bars"}
    },
    {
        header = "System",
        options = {"Help", "About"}
    }
}

-- Reference to the cyan frame
local cyanFrame = nil
local currentOptions = ""

-- Function to create the cyan frame (if not already created)
local function CreateCyanFrame(parent, separatorFrame, settingsFrame)
    if not cyanFrame then
        cyanFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        cyanFrame:SetPoint("TOPLEFT", separatorFrame, "TOPRIGHT", 10, 0)
        cyanFrame:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 60)
        cyanFrame:SetBackdrop(
            {
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\Buttons\\WHITE8X8",
                edgeSize = 2
            }
        )
        cyanFrame:SetBackdropBorderColor(0, 1, 1, 1) -- Cyan border
        cyanFrame:SetBackdropColor(0, 0, 0, 0) -- Transparent background
    end
    return cyanFrame
end

-- Function to clear the cyan frame's content
local function ClearCyanFrame()
    print("----------------------ClearCyanFrame()----------------------")

    if cyanFrame then
        -- Clear FontString regions
        print("Clearing FontString regions")

        for _, region in ipairs({cyanFrame:GetRegions()}) do
            if region:GetObjectType() == "FontString" then
                PriestFactionGUI:ReleaseLabel(region) -- Release the FontString
            end
        end

        print("Clearing children")
        -- Clear child frames (if any)
        for _, child in ipairs({cyanFrame:GetChildren()}) do
            if child:GetObjectType() == "Frame" then
                PriestFactionGUI:ReleaseFrame(child)
            end
        end
    end
end

-- Function to load specific content into the cyan frame
local function LoadCyanContent(contentType)
    if (currentOptions == contentType) then
        return
    end

    ClearCyanFrame()

    if contentType == "Settings Frame" then
        -- Example: Add content for the General section
        local label = PriestFactionGUI:CreateLabel(cyanFrame, "Settings Frame", 16, 10, -10)
        label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        currentOptions = contentType
    elseif contentType == "Tracker Frame" then
        -- Example: Add content for the Faction Tracker section
        local label = PriestFactionGUI:CreateLabel(cyanFrame, "Faction Tracker Settings", 16, 10, -10)
        label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        currentOptions = contentType
    elseif contentType == "Faction" then
        print("Creating Factions content")

        -- Example: Add content for the System section
        local factionFrame =
            PriestFactionGUI:AddFrame(
            cyanFrame,
            contentType,
            cyanFrame:GetWidth() - 20,
            cyanFrame:GetHeight() - 20,
            "Factions",
            "Interface\\Buttons\\WHITE8X8",
            "Interface\\Buttons\\WHITE8X8",
            {r = 1, g = 0, b = 1, a = 0},
            {r = 1, g = 0, b = 1, a = 1},
            16,
            2,
            2
        )
        -- Set the size of the child frame relative to the parent frame's sizew
        factionFrame:SetPoint("TOPLEFT", cyanFrame, "TOPLEFT", 10, -10) -- Offset -30 from the top
        factionFrame:SetPoint("BOTTOMRIGHT", cyanFrame, "BOTTOMRIGHT", -10, 10) -- Attach to the bottom-right corner without offset
        factionFrame:Show()

        currentOptions = contentType
    end
end

-- Function to reposition all sections and options dynamically
local function UpdateSectionLayout(redFrame, sections)
    local offsetY = -5
    for _, section in ipairs(sections) do
        -- Position the headerButton relative to redFrame
        section.headerButton:ClearAllPoints()
        section.headerButton:SetPoint("TOPLEFT", redFrame, "TOPLEFT", 5, offsetY)
        offsetY = offsetY - section.headerButton:GetHeight() - 5

        if section.headerButton.isExpanded then
            for _, optionButton in ipairs(section.optionButtons) do
                -- Position the optionButton relative to redFrame using cumulative offsetY
                optionButton:ClearAllPoints()
                optionButton:SetPoint("TOPLEFT", redFrame, "TOPLEFT", 15, offsetY)
                optionButton:Show()
                offsetY = offsetY - optionButton:GetHeight() - 5
            end
        else
            for _, optionButton in ipairs(section.optionButtons) do
                optionButton:Hide()
            end
        end
    end
end

-- Function to create a collapsible section in the red frame
local function CreateCollapsibleSection(parent, sectionData, allSections)
    -- Create header button with collapsible indicator
    local headerButton =
        PriestFactionGUI:CreateStylizedButton(
        parent,
        140,
        20,
        sectionData.header,
        {r = 0, g = 0, b = 0, a = 0},
        {r = 92 / 255, g = 92 / 255, b = 92 / 255, a = 1},
        "Fonts\\FRIZQT__.TTF",
        13
    )
    headerButton:GetFontString():SetJustifyH("LEFT")
    headerButton:GetFontString():SetTextColor(1, 0.8, 0) -- Gold color for header
    headerButton.isExpanded = true -- Initial state as expanded

    -- Create collapsible indicator "+" (collapsed) or "-" (expanded)
    local collapseIndicator = headerButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    collapseIndicator:SetPoint("RIGHT", headerButton, "RIGHT", -10, 0)
    collapseIndicator:SetText(headerButton.isExpanded and "-" or "+") -- Set initial state to "-"

    -- Create option buttons under this header (hidden initially)
    local optionButtons = {}
    for _, option in ipairs(sectionData.options) do
        local optionButton =
            PriestFactionGUI:CreateStylizedButton(
            parent,
            120,
            18,
            option,
            {r = 0, g = 0, b = 0, a = 0},
            {r = 1, g = 1, b = 1, a = 0}
        )
        optionButton:SetNormalFontObject("GameFontHighlight")
        optionButton:Hide() -- Initially hidden
        table.insert(optionButtons, optionButton)

        -- Add functionality for each option button
        optionButton:SetScript(
            "OnClick",
            function()
                LoadCyanContent(option)
            end
        )
    end

    -- Toggle button visibility and update layout when header is clicked
    headerButton:SetScript(
        "OnClick",
        function()
            headerButton.isExpanded = not headerButton.isExpanded
            collapseIndicator:SetText(headerButton.isExpanded and "-" or "+") -- Toggle between "+" and "-"
            UpdateSectionLayout(parent, allSections) -- Recalculate layout
        end
    )

    return {headerButton = headerButton, optionButtons = optionButtons}
end

-- Function to populate the red frame with collapsible sections
local function PopulateRedFrameWithSections(redFrame)
    local sections = {}
    for _, sectionData in ipairs(settingsSections) do
        -- Create each collapsible section
        local section = CreateCollapsibleSection(redFrame, sectionData, sections)
        table.insert(sections, section)
    end

    -- Initial layout update
    UpdateSectionLayout(redFrame, sections)
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
    greenFrame:SetBackdropBorderColor(0, 1, 0, 1) -- Green border
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
    redFrame:SetBackdropColor(0, 0, 0, 0) -- Transparent background

    PopulateRedFrameWithSections(redFrame)

    -- Create the red subframe (fixed width, tracks Y-axis)
    local separatorFrame = CreateFrame("Frame", nil, settingsFrame, "BackdropTemplate")
    separatorFrame:SetSize(2, redFrame:GetHeight()) -- Fixed width, stretches vertically
    separatorFrame:SetPoint("TOPLEFT", redFrame, "TOPRIGHT", 10, 0)
    separatorFrame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2
        }
    )
    separatorFrame:SetBackdropBorderColor(92 / 255, 92 / 255, 92 / 255, 1) -- Red border
    separatorFrame:SetBackdropColor(0, 0, 0, 0) -- Transparent background

    -- Create the cyan subframe (tracks both X and Y axes)
    CreateCyanFrame(settingsFrame, separatorFrame, settingsFrame)

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
    yellowFrame:SetBackdropColor(0, 0, 0, 0) -- Transparent background

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
            separatorFrame:SetHeight(height - 100)
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
