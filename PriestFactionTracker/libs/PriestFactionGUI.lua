-- PriestFactionGUI.lua: Library for creating and managing GUI elements in WoW with Object Pooling
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionGUI = {}
local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI

-- GUI Pool to store and reuse frames and buttons
PriestFactionGUI.pool = {frames = {}, buttons = {}, labels = {}}

-- Helper function to apply custom backdrop styling
local function ApplyBackdrop(frame, bgFile, edgeFile, bgColor, edgeColor, tileSize, edgeSize)
    frame:SetBackdrop(
        {
            bgFile = bgFile or "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = edgeFile or "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = false,
            tileSize = tileSize or 1,
            edgeSize = edgeSize or 4,
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        }
    )
    frame:SetBackdropColor(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0, bgColor.a or 1)
    frame:SetBackdropBorderColor(edgeColor.r or 1, edgeColor.g or 1, edgeColor.b or 1, edgeColor.a or 1)
end

-- Enhanced function to create or reuse a main frame with custom styling options
function PriestFactionGUI:CreateFrame(
    name,
    width,
    height,
    title,
    draggable,
    bgFile,
    edgeFile,
    bgColor,
    edgeColor,
    titleFontSize,
    tileSize,
    borderSize)
    local frame = table.remove(self.pool.frames) -- Try to reuse from pool
    if not frame then
        frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    end

    -- Apply custom backdrop styling
    ApplyBackdrop(
        frame,
        bgFile,
        edgeFile,
        bgColor or {r = 0, g = 0, b = 0, a = 1},
        edgeColor or {r = 1, g = 1, b = 1, a = 1},
        tileSize,
        borderSize
    )

    -- Configure frame properties
    frame:SetSize(width, height)
    frame:SetPoint("CENTER")
    frame:Show()

    -- Title setup
    if not frame.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    end
    frame.title:SetText(title or "Untitled Frame")
    frame.title:SetFont("Fonts\\FRIZQT__.TTF", titleFontSize or 12)

    -- Enable dragging if specified
    if draggable then
        frame:EnableMouse(true)
        frame:SetMovable(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    end

    return frame
end

-- Method to create or reuse a button with custom styling options
function PriestFactionGUI:CreateButton(parent, label, width, height, onClick, bgColor, textColor, fontSize)
    local button = table.remove(self.pool.buttons) -- Reuse from pool if available
    if not button then
        button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    end

    -- Configure button properties
    button:SetSize(width, height)
    button:SetText(label)
    button:SetScript("OnClick", onClick)
    button:Show()

    -- Apply background color if provided
    if bgColor then
        button:SetBackdropColor(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0, bgColor.a or 1)
    end

    -- Set custom font color and size
    local fontString = button:GetFontString()
    fontString:SetFont("Fonts\\FRIZQT__.TTF", fontSize or 12)
    fontString:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)

    return button
end

-- Function to add a sub-frame with customizable styling within a parent frame
function PriestFactionGUI:AddFrame(
    parent,
    name,
    width,
    height,
    title,
    bgFile,
    edgeFile,
    bgColor,
    edgeColor,
    titleFontSize)
    local frame = table.remove(self.pool.frames) -- Try to reuse from pool
    if not frame then
        frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
    end

    -- Apply custom backdrop styling
    ApplyBackdrop(
        frame,
        bgFile,
        edgeFile,
        bgColor or {r = 0, g = 0, b = 0, a = 1},
        edgeColor or {r = 1, g = 1, b = 1, a = 1}
    )

    -- Configure sub-frame properties
    frame:SetSize(width, height)
    frame:SetPoint("CENTER", parent)
    frame:Show()

    -- Title setup for the sub-frame
    if not frame.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    end
    frame.title:SetText(title or "Untitled Sub-Frame")
    frame.title:SetFont("Fonts\\FRIZQT__.TTF", titleFontSize or 12)

    return frame
end
-- Enhanced function to create or reuse a main frame with custom styling options

function PriestFactionGUI:CreateFrame(
    name,
    width,
    height,
    title,
    draggable,
    bgFile,
    edgeFile,
    bgColor,
    edgeColor,
    titleFontSize)
    local frame = table.remove(self.pool.frames) -- Try to reuse from pool
    if not frame then
        frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    end

    -- Apply custom backdrop styling
    ApplyBackdrop(
        frame,
        bgFile,
        edgeFile,
        bgColor or {r = 0, g = 0, b = 0, a = 1},
        edgeColor or {r = 1, g = 1, b = 1, a = 1}
    )

    -- Configure frame properties
    frame:SetSize(width, height)
    frame:SetPoint("CENTER")
    frame:Show()

    -- Title setup
    if not frame.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    end
    frame.title:SetText(title or "Untitled Frame")
    frame.title:SetFont("Fonts\\FRIZQT__.TTF", titleFontSize or 12)

    -- Enable dragging if specified
    if draggable then
        frame:EnableMouse(true)
        frame:SetMovable(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    end

    return frame
end

function PriestFactionGUI:CreateButton(parent, label, width, height, onClick, bgColor, textColor, fontSize)
    local button = table.remove(self.pool.buttons) -- Reuse from pool if available
    if not button then
        button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    end

    -- Configure button properties
    button:SetSize(width, height)
    button:SetText(label)
    button:SetScript("OnClick", onClick)
    button:Show()

    -- Wrap button in a backdrop frame if bgColor is provided
    if bgColor then
        local backdropFrame = button.backdrop or CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdropFrame:SetAllPoints()
        backdropFrame:SetFrameLevel(button:GetFrameLevel() - 1) -- Behind the button
        backdropFrame:SetBackdrop(
            {
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = true,
                tileSize = 32,
                edgeSize = 8,
                insets = {left = 2, right = 2, top = 2, bottom = 2}
            }
        )
        backdropFrame:SetBackdropColor(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0, bgColor.a or 1)
        button.backdrop = backdropFrame
    end

    -- Set custom font color and size
    local fontString = button:GetFontString()
    fontString:SetFont("Fonts\\FRIZQT__.TTF", fontSize or 12)
    fontString:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)

    return button
end

-- Function to add a sub-frame with customizable styling within a parent frame
function PriestFactionGUI:AddFrame(
    parent,
    name,
    width,
    height,
    title,
    bgFile,
    edgeFile,
    bgColor,
    edgeColor,
    titleFontSize)
    local frame = table.remove(self.pool.frames) -- Try to reuse from pool
    if not frame then
        frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
    end

    -- Apply custom backdrop styling
    ApplyBackdrop(
        frame,
        bgFile,
        edgeFile,
        bgColor or {r = 0, g = 0, b = 0, a = 1},
        edgeColor or {r = 1, g = 1, b = 1, a = 1}
    )

    -- Configure sub-frame properties
    frame:SetSize(width, height)
    frame:SetPoint("CENTER", parent)
    frame:Show()

    -- Title setup for the sub-frame
    if not frame.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    end
    frame.title:SetText(title or "Untitled Sub-Frame")
    frame.title:SetFont("Fonts\\FRIZQT__.TTF", titleFontSize or 12)

    return frame
end

-- Factory Method to create or reuse a label
function PriestFactionGUI:CreateLabel(parent, text, fontSize, posX, posY)
    local label = table.remove(self.pool.labels) -- Reuse from pool if available
    if not label then
        label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    end

    -- Configure label properties
    label:SetPoint("TOPLEFT", posX, posY)
    label:SetFont("Fonts\\FRIZQT__.TTF", fontSize or 12)
    label:SetText(text)
    label:Show()

    return label
end

-- Method to release a frame back to the pool
function PriestFactionGUI:ReleaseFrame(frame)
    frame:Hide()
    frame:ClearAllPoints()
    frame.title:SetText("")
    table.insert(self.pool.frames, frame)
end

-- Method to release a button back to the pool
function PriestFactionGUI:ReleaseButton(button)
    button:Hide()
    button:SetScript("OnClick", nil)
    table.insert(self.pool.buttons, button)
end

-- Method to release a label back to the pool
function PriestFactionGUI:ReleaseLabel(label)
    label:Hide()
    label:SetText("")
    table.insert(self.pool.labels, label)
end

return PriestFactionGUI
