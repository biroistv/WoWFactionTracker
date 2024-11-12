-- PriestFactionGUI.lua: Library for creating and managing GUI elements in WoW with Object Pooling
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionGUI = {}
local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI

-- GUI Pool to store and reuse frames and buttons
PriestFactionGUI.pool = { frames = {}, buttons = {}, labels = {}, progressBars = {} }


--- Applies a backdrop style to a frame.
-- @param frame The frame to style
-- @param bgFile Background texture file path
-- @param edgeFile Edge texture file path
-- @param bgColor Table with RGBA values for background color
-- @param edgeColor Table with RGBA values for edge color
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


--- Creates or reuses a main frame with custom styling options.
-- @param name The unique frame name
-- @param width The width of the frame
-- @param height The height of the frame
-- @param title The title of the frame (optional)
-- @param draggable Boolean indicating if the frame can be dragged
-- @param bgFile Background texture file path
-- @param edgeFile Edge texture file path
-- @param bgColor Table with RGBA values for background color
-- @param edgeColor Table with RGBA values for edge color
-- @param titleFontSize Font size for the title
-- @return The created or reused frame
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

    -- Function to update child frame widths when resizing
    function frame.UpdateChildFrameWidths()
        if not frame or not frame.GetWidth then
            print("Error: Parent frame does not exist or has no width.")
            return
        end

        local children = {frame:GetChildren()}

        local parentWidth = frame:GetWidth()
        for i, child in ipairs(children) do
            if child and child.GetWidth then  -- Ensure `child` exists and has GetWidth method
                local childType = child.Type or ""
                if childType == "FactionProgressFrame" then
                    child:SetWidth(parentWidth - 20) -- Set new width for child frame
                end
            else
                print("Warning: Skipping child; it does not have a GetWidth method or is nil.")
            end
        end
    end

    return frame
end


--- Creates a button within a parent frame.
-- @param parent The parent frame
-- @param label The button label text
-- @param width The button width
-- @param height The button height
-- @param onClick The function to call on click
-- @param bgColor Table with RGBA values for background color
-- @param textColor Table with RGBA values for text color
-- @param fontSize The font size of the button text
-- @return The created or reused button
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
    titleFontSize,
    tileSize,
    borderSize)
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
        edgeColor or {r = 1, g = 1, b = 1, a = 1},
        tileSize,
        borderSize
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


--- Creates a label within a parent frame.
-- @param parent The parent frame
-- @param text The label text
-- @param fontSize The font size
-- @param posX X-offset position
-- @param posY Y-offset position
-- @return The created or reused label
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


--- Creates a progress bar with background and fill color.
-- @param parent The parent frame
-- @param width The width of the progress bar
-- @param height The height of the progress bar
-- @param bgColor Table with RGBA values for background color
-- @param fillColor Table with RGBA values for fill color
-- @return The created or reused progress bar
function PriestFactionGUI:CreateProgressBar(parent, width, height, bgColor, fillColor)
    -- Create the outer frame to act as the border container
    local outerFrame = table.remove(self.pool.progressBars)  -- Try to reuse from pool
    if not outerFrame then
        outerFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    end

    -- Configure outer frame as the border container
    outerFrame:SetSize(width + 4, height + 4)  -- Add 2 pixels for the border on each side
    outerFrame:SetPoint("TOP", parent, "TOP", 0, -40)  -- Adjust position as needed
    outerFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        tileSize = 0,
        edgeSize = 2,  -- Border thickness
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    outerFrame:SetBackdropColor(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0, bgColor.a or 1)
    outerFrame:SetBackdropBorderColor(0, 0, 0, 1)  -- Black border color

    -- Create the inner progress bar (StatusBar) inside the outer frame
    local progressBar = outerFrame.progressBar or CreateFrame("StatusBar", nil, outerFrame)
    progressBar:SetSize(width, height)
    progressBar:SetPoint("CENTER", outerFrame, "CENTER", 0, 0)
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetValue(0)  -- Initial progress

    -- Set the fill texture and color
    progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    progressBar:GetStatusBarTexture():SetHorizTile(false)
    progressBar:SetStatusBarColor(fillColor.r or 0, fillColor.g or 1, fillColor.b or 0, fillColor.a or 1)

    outerFrame.progressBar = progressBar  -- Store reference to the inner progress bar
    outerFrame:Show()

    -- Adding update function for setting progress on the outer frame, operating on the inner progress bar
    function outerFrame:SetProgress(value)
        value = math.min(math.max(value, 0), 100)  -- Clamp value between 0 and 100
        progressBar:SetValue(value)
    end

    return outerFrame
end


--- Creates a faction progress frame with an icon, name, progress bar, and status text.
--- @param parent Frame The parent frame
--- @param iconPath String path to the icon texture
--- @param factionName String name of the faction
--- @param progress Integer current progress value
--- @param maxProgress Integer maximum progress value
--- @return The created or reused faction progress frame
function PriestFactionGUI:CreateFactionProgressFrame(parent, iconPath, factionName, progress, maxProgress)
    -- Create the main container frame
    local frame = self:AddFrame(parent, "", 400, 40, " ", "Interface\\Buttons\\WHITE8X8", "Interface\\Buttons\\WHITE8X8", {r=0, g=0, b=0, a=0.2}, {r=0, g=0, b=0, a=1}, 12, 0, 2)
    frame:SetPoint("CENTER", parent, "CENTER")
    frame.Type = "FactionProgressFrame"

     -- Create the icon border
     local iconBorder = CreateFrame("Frame", nil, frame, "BackdropTemplate")
     iconBorder:SetSize(26, 26)  -- 2 pixels larger than the icon (40 + 2*2)
     iconBorder:SetPoint("LEFT", frame, "LEFT", 10, 0)
     iconBorder:SetBackdrop({
         bgFile = "Interface\\Buttons\\WHITE8X8",  -- Solid color background for the border
         edgeFile = "Interface\\Buttons\\WHITE8X8",  -- Solid color edge
         tile = false,
         tileSize = 0,
         edgeSize = 2,
         insets = { left = 2, right = 2, top = 2, bottom = 2 }
     })
     iconBorder:SetBackdropColor(0, 0, 0, 1)  -- Solid black color for the border
     iconBorder:SetBackdropBorderColor(0, 0, 0, 1)  -- Solid black border edge color

     -- Create the icon inside the border
     local icon = iconBorder:CreateTexture(nil, "ARTWORK")
     icon:SetSize(24, 24)
     icon:SetPoint("CENTER", iconBorder, "CENTER", 0, 0)
     icon:SetTexture(iconPath or "Interface\\Icons\\INV_Misc_QuestionMark")  -- Default icon if none provided
     icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)  -- Crop edges for cleaner appearance

    -- Create the faction name label
    local nameLabel = self:CreateLabel(frame, factionName or "Faction Name", 10, 60, 10)
    nameLabel:SetFont("Fonts\\FRIZQT__.TTF", 10)
    nameLabel:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 0)

    -- Create the progress bar
    local progressBar = self:CreateProgressBar(frame, 260, 8, { r = 0.2, g = 0.2, b = 0.2, a = 1 }, { r = 0.1, g = 0.6, b = 1, a = 1 })
    progressBar:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -13)
    progressBar:SetProgress(math.floor((progress / maxProgress) * 100))  -- Set initial progress

    -- Create the status text
    local statusText = self:CreateLabel(frame, string.format("%d/%d", progress, maxProgress), 14, 60, -20)
    statusText:SetFont("Fonts\\FRIZQT__.TTF", 10)
    statusText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 100, 0)

    -- Update function for progress values
    function frame:SetProgress(current, maximum)
        progressBar:SetProgress(math.floor((current / maximum) * 100))
        statusText:SetText(string.format("%d/%d", current, maximum))
    end

    frame:SetWidth(parent:GetWidth() - 20)
    parent.childFrames = parent.childFrames or {}
    table.insert(parent.childFrames, frame)

    return frame
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

-- Method to release a progress bar back to the pool
function PriestFactionGUI:ReleaseProgressBar(progressBar)
    progressBar:Hide()
    progressBar:SetValue(0)  -- Reset to 0
    table.insert(self.pool.progressBars, progressBar)
end

return PriestFactionGUI
