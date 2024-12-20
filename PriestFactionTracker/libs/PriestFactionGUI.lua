-- PriestFactionGUI.lua: Library for creating and managing GUI elements in WoW with Object Pooling
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_FactionGUI = {}
local PriestFactionGUI = WoWFactionTracker.PRST_FactionGUI
local PriestFactionTrackerSavedVariableHandler = WoWFactionTracker.PRST_FactionTrackerSavedVariableHandler
local PriestFactionLogger = WoWFactionTracker.PRST_Logger

-- Constants for GUI element types
local UNIQUE_FRAME_ID = 0 -- Initialize a global identifier counter

-- GUI Pool to store and reuse frames and buttons
PriestFactionGUI.pool = PriestFactionGUI.pool or {frames = {}, buttons = {}, labels = {}, progressBars = {}}

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
    parent,
    name,
    width,
    height,
    title,
    draggable,
    resizable,
    bgFile,
    edgeFile,
    bgColor,
    edgeColor,
    titleFontSize,
    tileSize,
    borderSize)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateFrame")
    local frame = table.remove(self.pool.frames) -- Try to reuse from pool
    if not frame then
        PriestFactionLogger:Warning("Condition might evaluate nil: if parent == nil then")
        if parent == nil then
            frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
        else
            frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
        end
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

    -- Enable resizing if specified
    if resizable then
        -- Enable resizing on the main frame
        frame:SetResizable(true)
        frame:SetResizeBounds(300, 200, 800, 600)

        -- Add a resize handle (usually at the bottom right corner)
        local resizeHandle = CreateFrame("Button", nil, frame)
        resizeHandle:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
        resizeHandle:SetSize(16, 16)
        resizeHandle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        resizeHandle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        resizeHandle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        resizeHandle:SetScript(
            "OnMouseDown",
            function()
                frame:StartSizing("BOTTOMRIGHT")
            end
        )
        resizeHandle:SetScript(
            "OnMouseUp",
            function()
                frame:StopMovingOrSizing()

                local point, relativeTo, relativePoint, xOffset, yOffset = frame:GetPoint() -- Get the frame's position details

                -- Save the position details, storing the frame name instead of the frame object
                PriestFactionTrackerSavedVariableHandler.Set(
                    name .. "Point",
                    {
                        point = point,
                        relativePoint = relativePoint,
                        xOffset = xOffset,
                        yOffset = yOffset,
                        width = frame:GetWidth(),
                        height = frame:GetHeight()
                    }
                )
            end
        )
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
            if child and child.GetWidth then -- Ensure `child` exists and has GetWidth method
                local childType = child.Type or ""
                if childType == "FactionProgressFrame" then
                    child:SetWidth(parentWidth - 20) -- Set new width for child frame
                end
            else
                print("Warning: Skipping child; it does not have a GetWidth method or is nil.")
            end
        end
    end

    -- Function to reorganize child frames vertically with padding
    function frame.ReorganizeChildFrames(verticalPadding)
        PriestFactionLogger:Info("Entering function: frame.ReorganizeChildFrames")
        verticalPadding = verticalPadding or 5
        local childFrames = frame.childFrames or {}

        for index, child in ipairs(childFrames) do
            child:ClearAllPoints() -- Clear existing position

            if index == 1 then
                child:SetPoint("TOP", frame, "TOP", 0, -verticalPadding)
            else
                local previousFrame = childFrames[index - 1]
                child:SetPoint("TOP", previousFrame, "BOTTOM", 0, -verticalPadding)
            end
        end
    end

    frame:SetScript(
        "OnSizeChanged",
        function()
            frame.UpdateChildFrameWidths()
        end
    )

    PriestFactionLogger:Info("Returning from function with value: frame")
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
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateButton")
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

    PriestFactionLogger:Info("Returning from function with value: button")
    return button
end

--- Creates a stylized button with custom color, font, font size, border, and highlight effect.
-- @param parent The parent frame to attach the button to
-- @param width The width of the button
-- @param height The height of the button
-- @param text The text to display on the button
-- @param bgColor Table with RGBA values for the background color (e.g., {r=0.2, g=0.5, b=0.8, a=1})
-- @param borderColor Table with RGBA values for the border color (e.g., {r=0, g=0, b=0, a=1})
-- @param fontPath Path to the custom font (e.g., "Fonts\\FRIZQT__.TTF")
-- @param fontSize The size of the font
-- @return The created button
function PriestFactionGUI:CreateStylizedButton(parent, width, height, text, bgColor, borderColor, fontPath, fontSize)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateStylizedButton")
    -- Create or reuse a button from the pool
    local button = table.remove(self.pool.buttons) or CreateFrame("Button", nil, parent, "BackdropTemplate")

    -- Set button size
    button:SetSize(width, height)

    -- Set button text
    button:SetText(text)
    button:SetNormalFontObject("GameFontNormal")

    -- Set custom font and font size
    local fontString = button:GetFontString()
    fontString:SetFont(fontPath or "Fonts\\FRIZQT__.TTF", fontSize or 12)
    fontString:SetTextColor(1, 1, 1, 1) -- Default text color to white

    -- Apply background color and border
    button:SetBackdrop(
        {
            bgFile = "Interface\\Buttons\\WHITE8X8", -- Solid color background
            edgeFile = "Interface\\Buttons\\WHITE8X8", -- Solid color border
            edgeSize = 2
        }
    )
    button:SetBackdropColor(bgColor.r, bgColor.g, bgColor.b, bgColor.a) -- Background color
    button:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a) -- Border color

    -- Define colors for the highlight and pressed states
    local highlightColor = {
        r = math.min(bgColor.r + 0.2, 1),
        g = math.min(bgColor.g + 0.2, 1),
        b = math.min(bgColor.b + 0.2, 1),
        a = bgColor.a
    }
    local pressedColor = {
        r = math.max(bgColor.r - 0.2, 0),
        g = math.max(bgColor.g - 0.2, 0),
        b = math.max(bgColor.b - 0.2, 0),
        a = bgColor.a
    }

    -- Event handlers for highlight effect
    button:SetScript(
        "OnEnter",
        function(self)
            self:SetBackdropColor(highlightColor.r, highlightColor.g, highlightColor.b, highlightColor.a)
        end
    )
    button:SetScript(
        "OnLeave",
        function(self)
            self:SetBackdropColor(bgColor.r, bgColor.g, bgColor.b, bgColor.a)
        end
    )
    button:SetScript(
        "OnMouseDown",
        function(self)
            self:SetBackdropColor(pressedColor.r, pressedColor.g, pressedColor.b, pressedColor.a)
        end
    )
    button:SetScript(
        "OnMouseUp",
        function(self)
            self:SetBackdropColor(highlightColor.r, highlightColor.g, highlightColor.b, highlightColor.a)
        end
    )

    -- Show the button and return it
    button:Show()
    PriestFactionLogger:Info("Returning from function with value: button")
    return button
end

--- Creates a sub-frame within a parent frame with custom styling options.
-- @param parent The parent frame
-- @param name The unique name of the sub-frame
-- @param width The width of the sub-frame
-- @param height The height of the sub-frame
-- @param title The title of the sub-frame
-- @param bgFile Background texture file path
-- @param edgeFile Edge texture file path
-- @param bgColor Table with RGBA values for background color
-- @param edgeColor Table with RGBA values for edge color
-- @param titleFontSize Font size for the title
-- @param tileSize The size of the tile
-- @param borderSize The size of the border
-- @return The created or reused sub-frame
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
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:AddFrame")
    -- Validate required inputs
    if not parent or not name then
        error("Invalid arguments: 'parent' and 'name' are required.")
    end

    -- Check for pool initialization
    if not self.pool then
        error("PriestFactionGUI.pool is not initialized. Ensure it is set up properly.")
    end

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
    frame:Show()

    -- Title setup for the sub-frame
    if not frame.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    end
    frame.title:SetText(title or "Untitled Sub-Frame")
    frame.title:SetFont("Fonts\\FRIZQT__.TTF", titleFontSize or 12)

    PriestFactionLogger:Info("Returning from function with value: frame")
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
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateLabel")
    print("----------------------CreateLabel()----------------------")

    print("Label Pool Size:", #self.pool.labels)
    local label = table.remove(self.pool.labels) -- Reuse from pool if available

    if not label then
        -- Create a new label if none are available in the pool
        print("Creating new label")
        label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    else
        -- Ensure the label is reset properly when reusing from the pool
        print("Reusing label from pool")
        print("Label Pool Size:", #self.pool.labels)
    end

    -- Configure label properties
    label:ClearAllPoints() -- Reset points before setting new ones
    label:SetParent(parent) -- Ensure parent is set correctly
    label:SetPoint("TOPLEFT", posX, posY) -- Set position
    label:SetFont("Fonts\\FRIZQT__.TTF", fontSize or 12) -- Set font
    label:SetText(text) -- Set the label's text
    label:SetTextColor(1, 1, 1, 1) -- Reset to default color (optional)
    label:Show() -- Ensure the label is visible

    -- Debug output to verify state
    print("Label Text:", label:GetText())
    print("----------------------CreateLabel() Done----------------------")

    PriestFactionLogger:Info("Returning from function with value: label")
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
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateProgressBar")
    -- Create the outer frame to act as the border container
    local outerFrame = table.remove(self.pool.progressBars) -- Try to reuse from pool
    if not outerFrame then
        outerFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    end

    -- Configure outer frame as the border container
    outerFrame:SetSize(width + 4, height + 4) -- Add 2 pixels for the border on each side
    outerFrame:SetPoint("TOP", parent, "TOP", 0, -40) -- Adjust position as needed
    outerFrame:SetBackdrop(
        {
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            tile = false,
            tileSize = 0,
            edgeSize = 2, -- Border thickness
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        }
    )
    outerFrame:SetBackdropColor(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0, bgColor.a or 1)
    outerFrame:SetBackdropBorderColor(0, 0, 0, 1) -- Black border color

    -- Create the inner progress bar (StatusBar) inside the outer frame
    local progressBar = outerFrame.progressBar or CreateFrame("StatusBar", nil, outerFrame)
    progressBar:SetSize(width, height)
    progressBar:SetPoint("CENTER", outerFrame, "CENTER", 0, 0)
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetValue(0) -- Initial progress

    -- Set the fill texture and color
    progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    progressBar:GetStatusBarTexture():SetHorizTile(false)
    progressBar:SetStatusBarColor(fillColor.r or 0, fillColor.g or 1, fillColor.b or 0, fillColor.a or 1)

    outerFrame.progressBar = progressBar -- Store reference to the inner progress bar
    outerFrame:Show()

    -- Adding update function for setting progress on the outer frame, operating on the inner progress bar
    function outerFrame:SetProgress(value)
        PriestFactionLogger:Info("Entering function: outerFrame:SetProgress")
        value = math.min(math.max(value, 0), 100) -- Clamp value between 0 and 100
        progressBar:SetValue(value)
    end

    PriestFactionLogger:Info("Returning from function with value: outerFrame")
    return outerFrame
end

-- Creates a collapsible frame with a title, collapse/expand button, and content frame.
-- @param parent The parent frame
-- @param title The title of the collapsible frame
-- @param width The width of the frame
-- @param height The height of the frame
-- @param draggable Boolean indicating if the frame can be dragged
-- @param resizable Boolean indicating if the frame can be resized
-- @param bgFile Background texture file path
-- @param edgeFile Edge texture file path
-- @param bgColor Table with RGBA values for background color
-- @param edgeColor Table with RGBA values for edge color
-- @param titleFontSize Font size for the title
-- @param tileSize The size of the tile
-- @param borderSize The size of the border
function PriestFactionGUI:CreateCollapsibleFrame(
    parent,
    name,
    width,
    height,
    title,
    draggable,
    resizable,
    bgFile,
    edgeFile,
    bgColor,
    edgeColor,
    titleFontSize,
    tileSize,
    borderSize)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateCollapsibleFrame")
    -- Create the main frame using the existing CreateFrame function
    local frame =
        self:CreateFrame(
        parent,
        name,
        width,
        height,
        title,
        draggable,
        resizable,
        bgFile,
        edgeFile,
        bgColor,
        edgeColor,
        titleFontSize,
        tileSize,
        borderSize
    )

    -- **Set the anchor point to TOPLEFT to prevent repositioning**
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10) -- Adjust offsets as needed

    -- Add a toggle button for collapsibility
    if not frame.collapseButton then
        frame.collapseButton =
            self:CreateStylizedButton(
            frame,
            20,
            20,
            "-",
            {r = 0.2, g = 0.2, b = 0.2, a = 1},
            {r = 1, g = 1, b = 1, a = 1},
            "Fonts\\FRIZQT__.TTF",
            12
        )
        frame.collapseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
        frame.collapseButton:Show()
    end

    -- Create a content frame
    if not frame.contentFrame then
        frame.contentFrame =
            self:CreateFrame(
            frame,
            name .. "Content",
            width - 20,
            height - 40,
            "",
            false,
            false,
            bgFile,
            edgeFile,
            bgColor,
            edgeColor,
            titleFontSize,
            tileSize,
            borderSize
        )
        -- **Anchor contentFrame to TOPLEFT of frame**
        frame.contentFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
        frame.contentFrame:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
        frame.contentFrame:SetHeight(height - 60) -- Adjust based on your layout
        frame.contentFrame:Show()
    end

    -- Store expanded and collapsed heights
    local expandedHeight = height
    local collapsedHeight = 60 -- Adjust this based on the actual height of the title bar and collapse button

    -- Handle collapse/expand functionality
    local isCollapsed = false

    frame.collapseButton:SetScript(
        "OnClick",
        function()
            if isCollapsed then
                frame.contentFrame:Show()
                frame.collapseButton:SetText("-")
                frame:SetHeight(expandedHeight)
            else
                frame.contentFrame:Hide()
                frame.collapseButton:SetText("+")
                frame:SetHeight(collapsedHeight)
            end
            isCollapsed = not isCollapsed
        end
    )

    frame:SetScript(
        "OnHide",
        function()
            -- Release the Button
            self:ReleaseElement(frame.collapseButton)

            -- Release the content frame strings
            for _, region in ipairs({frame.contentFrame:GetRegions()}) do
                if region:GetObjectType() == "FontString" then
                    self:ReleaseElement(region) -- Release the FontString
                end
            end

            -- Release the content frame other children
            for _, child in ipairs({frame.contentFrame:GetChildren()}) do
                if child:GetObjectType() == "Frame" then
                    self:ReleaseElement(child)
                end
            end

            self:ReleaseElement(frame.contentFrame) -- Release the content frame
            self:ReleaseElement(frame) -- Release the main frame
        end
    )

    -- Attach child frames list for reorganizing
    frame.childFrames = frame.childFrames or {}

    -- Return both the main frame and the content frame for further customization
    PriestFactionLogger:Info("Returning from function with value: frame, frame.contentFrame")
    return frame, frame.contentFrame
end

--- Creates a faction progress frame with an icon, name, progress bar, and status text.
--- @param parent Frame The parent frame
--- @param iconPath String path to the icon texture
--- @param factionName String name of the faction
--- @param progress Integer current progress value
--- @param maxProgress Integer maximum progress value
--- @return The created or reused faction progress frame
function PriestFactionGUI:CreateFactionProgressFrame(parent, iconPath, factionName, progress, maxProgress)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:CreateFactionProgressFrame")
    -- Initialize the childFrames table if it doesn't exist
    if not parent.childFrames then
        parent.childFrames = {}
    end

    -- Create the main container frame
    local frame =
        self:AddFrame(
        parent,
        "",
        400,
        34,
        " ",
        "Interface\\Buttons\\WHITE8X8",
        "Interface\\Buttons\\WHITE8X8",
        {r = 0, g = 0, b = 0, a = 0.2},
        {r = 0, g = 0, b = 0, a = 1},
        12,
        0,
        2
    )
    frame:SetPoint("CENTER", parent)

    -- Determine the position of the new child frame
    if #parent.childFrames == 0 then
        -- First child: position it at the top
        frame:SetPoint("TOP", parent, "TOP", 0, -5)
    else
        -- Subsequent child: position it below the last child
        local lastChild = parent.childFrames[#parent.childFrames]
        frame:SetPoint("TOP", lastChild, "BOTTOM", 0, -5)
    end

    -- Add the new child frame to the list
    table.insert(parent.childFrames, frame)
    frame.Type = "FactionProgressFrame"
    frame.FrameID = "FactionProgressFrame" .. UNIQUE_FRAME_ID

    -- Create the icon border
    local iconBorder = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    iconBorder:SetSize(26, 26) -- 2 pixels larger than the icon (40 + 2*2)
    iconBorder:SetPoint("LEFT", frame, "LEFT", 10, 0)
    iconBorder:SetBackdrop(
        {
            bgFile = "Interface\\Buttons\\WHITE8X8", -- Solid color background for the border
            edgeFile = "Interface\\Buttons\\WHITE8X8", -- Solid color edge
            tile = false,
            tileSize = 0,
            edgeSize = 2,
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        }
    )
    iconBorder:SetBackdropColor(0, 0, 0, 1) -- Solid black color for the border
    iconBorder:SetBackdropBorderColor(0, 0, 0, 1) -- Solid black border edge color

    -- Create the icon inside the border
    local icon = iconBorder:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24)
    icon:SetPoint("CENTER", iconBorder, "CENTER", 0, 0)
    icon:SetTexture(iconPath or "Interface\\Icons\\INV_Misc_QuestionMark") -- Default icon if none provided
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- Crop edges for cleaner appearance

    -- Create the faction name label
    local nameLabel = self:CreateLabel(frame, factionName or "Faction Name", 10, 60, 10)
    nameLabel:SetFont("Fonts\\FRIZQT__.TTF", 10)
    nameLabel:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 0)

    -- Create the progress bar
    local progressBar =
        self:CreateProgressBar(frame, 260, 8, {r = 0.2, g = 0.2, b = 0.2, a = 1}, {r = 0.1, g = 0.6, b = 1, a = 1})
    progressBar:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -13)
    progressBar:SetProgress(math.floor((progress / maxProgress) * 100)) -- Set initial progress

    -- Create the status text
    local statusText = self:CreateLabel(frame, string.format("%d/%d", progress, maxProgress), 14, 60, -20)
    statusText:SetFont("Fonts\\FRIZQT__.TTF", 10)
    statusText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 100, 0)

    -- Update function for progress values
    function frame:SetProgress(current, maximum)
        PriestFactionLogger:Info("Entering function: frame:SetProgress")
        progressBar:SetProgress(math.floor((current / maximum) * 100))
        statusText:SetText(string.format("%d/%d", current, maximum))
    end

    frame:SetWidth(parent:GetWidth() - 20)
    parent.childFrames = parent.childFrames or {}
    table.insert(parent.childFrames, frame)

    PriestFactionLogger:Info("Returning from function with value: frame")
    return frame
end

--- Removes a faction progress frame from the parent frame and reorganizes remaining frames.
-- @param parent Frame The parent frame
-- @param frameId String The unique identifier of the frame to be removed
function PriestFactionGUI:RemoveFactionProgressFrame(parent, frameId)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:RemoveFactionProgressFrame")
    local childFrames = parent.childFrames or {}
    local indexToRemove = nil

    -- Find the index of the frame to remove
    for index, frame in ipairs(childFrames) do
        if frame.frameId == frameId then
            indexToRemove = index
            break
        end
    end

    -- If frame found, remove it and reorganize remaining frames
    if indexToRemove then
        -- Remove frame from display and release resources
        local frameToRemove = table.remove(childFrames, indexToRemove)
        frameToRemove:Hide() -- Hide frame
        frameToRemove:SetParent(nil) -- Detach from parent
        frameToRemove = nil -- Allow garbage collection

        -- Reorganize remaining frames
        parent.ReorganizeChildFrames(5)
    else
        print("Error: FactionProgressFrame with ID " .. frameId .. " not found.")
    end
end

-- Method to release a frame back to the pool
function PriestFactionGUI:ReleaseFrame(frame)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:ReleaseFrame")
    print("----------------------ReleaseFrame()----------------------")
    frame:Hide()
    frame:ClearAllPoints()
    frame.title:SetText("")
    table.insert(self.pool.frames, frame)
end

-- Method to release a button back to the pool
function PriestFactionGUI:ReleaseButton(button)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:ReleaseButton")
    button:Hide()
    button:SetScript("OnClick", nil)
    table.insert(self.pool.buttons, button)
end

-- Method to release a label back to the pool
function PriestFactionGUI:ReleaseLabel(label)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:ReleaseLabel")
    print("----------------------ReleaseLabel()----------------------")

    -- Reset the label's state
    label:ClearAllPoints()
    label:SetParent(nil) -- Detach from parent
    label:SetText("") -- Clear text
    label:SetFont("Fonts\\FRIZQT__.TTF", 12) -- Reset to default font
    label:SetTextColor(1, 1, 1, 1) -- Reset text color
    label:Hide() -- Hide the label to stop rendering

    print("Label Pool Size:", #self.pool.labels)
    print("Insert label back to pool")
    table.insert(self.pool.labels, label)
    print("Label Pool Size:", #self.pool.labels)
end

-- Method to release a progress bar back to the pool
function PriestFactionGUI:ReleaseProgressBar(progressBar)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:ReleaseProgressBar")
    progressBar:Hide()
    progressBar:SetValue(0) -- Reset to 0
    table.insert(self.pool.progressBars, progressBar)
end

-- Generalized method to release any GUI element back to its pool
function PriestFactionGUI:ReleaseElement(element)
    PriestFactionLogger:Info("Entering function: PriestFactionGUI:ReleaseElement")
    print("----------------------ReleaseElement()----------------------")

    -- Identify the type of element and delegate to the appropriate release function
    if element.title and element.SetText then
        -- It's a frame
        self:ReleaseFrame(element)
        print("Delegated to ReleaseFrame")
    elseif element.SetText and not element.SetFont then
        -- It's a button
        self:ReleaseButton(element)
        print("Delegated to ReleaseButton")
    elseif element.SetFont then
        -- It's a label
        self:ReleaseLabel(element)
        print("Delegated to ReleaseLabel")
    elseif element.SetValue then
        -- It's a progress bar
        self:ReleaseProgressBar(element)
        print("Delegated to ReleaseProgressBar")
    else
        -- Unknown type, fallback logic
        print("Unknown element type, hiding as fallback.")
        element:Hide()
        element:ClearAllPoints()
    end

    print("----------------------ReleaseElement() Done----------------------")
end

return PriestFactionGUI
