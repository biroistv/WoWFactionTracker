-- PriestFactionGUI.lua: Library for creating and managing GUI elements in WoW with Object Pooling
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionGUI = {}
local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI

-- GUI Pool to store and reuse frames and buttons
PriestFactionGUI.pool = { frames = {}, buttons = {}, labels = {} }

-- Factory Method to create or reuse a frame
function PriestFactionGUI:CreateFrame(name, width, height, title, draggable)
    local frame = table.remove(self.pool.frames)  -- Try to reuse from pool
    if not frame then  -- If no frame in pool, create a new one
        frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 }
        })
    end

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

-- New: Method to create or reuse a sub-frame with a specified parent
function PriestFactionGUI:AddFrame(parent, name, width, height, title)
    local frame = table.remove(self.pool.frames)  -- Try to reuse from pool
    if not frame then
        frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 }
        })
    end

    -- Configure sub-frame properties
    frame:SetSize(width, height)
    frame:SetPoint("CENTER", parent)  -- Centered within the parent frame
    frame:Show()

    -- Title setup for the sub-frame
    if not frame.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    end
    frame.title:SetText(title or "Untitled Sub-Frame")

    return frame
end

-- Method to release a frame back to the pool
function PriestFactionGUI:ReleaseFrame(frame)
    frame:Hide()
    frame:ClearAllPoints()
    frame.title:SetText("")
    table.insert(self.pool.frames, frame)
end

-- Factory Method to create or reuse a button
function PriestFactionGUI:CreateButton(parent, label, width, height, onClick)
    local button = table.remove(self.pool.buttons)  -- Reuse from pool if available
    if not button then
        button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    end

    -- Configure button properties
    button:SetSize(width, height)
    button:SetText(label)
    button:SetScript("OnClick", onClick)
    button:Show()

    return button
end

-- Method to release a button back to the pool
function PriestFactionGUI:ReleaseButton(button)
    button:Hide()
    button:SetScript("OnClick", nil)
    table.insert(self.pool.buttons, button)
end

-- Factory Method to create or reuse a label
function PriestFactionGUI:CreateLabel(parent, text, fontSize, posX, posY)
    local label = table.remove(self.pool.labels)  -- Reuse from pool if available
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

-- Method to release a label back to the pool
function PriestFactionGUI:ReleaseLabel(label)
    label:Hide()
    label:SetText("")
    table.insert(self.pool.labels, label)
end

return PriestFactionGUI
