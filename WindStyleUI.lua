--[[
    WindStyleUI
    A self-contained Roblox UI library inspired by the visual language of
    Wind UI: dark theme, rounded corners, left icon-tab sidebar, smooth
    tweened interactions, and the standard set of controls
    (Button, Toggle, Slider, Dropdown, Input, Keybind, Notification).

    USAGE
    ------------------------------------------------------------------
    local UI = loadstring(game:HttpGet("https://yourhost/WindStyleUI.lua"))()

    local Window = UI:CreateWindow({
        Title    = "My Script",
        SubTitle = "v1.0.0",
        Size     = UDim2.fromOffset(560, 380),
    })

    local Tab = Window:CreateTab({
        Title = "Main",
        Icon  = "house", -- any name from the Lucide icon set, or "rbxassetid://..."
    })

    local Section = Tab:CreateSection("Player")

    Section:CreateButton({
        Title = "Say Hello",
        Callback = function()
            print("Hello!")
        end,
    })

    Section:CreateToggle({
        Title = "Auto Farm",
        Default = false,
        Callback = function(state) end,
    })

    Section:CreateSlider({
        Title = "WalkSpeed",
        Min = 16, Max = 200, Default = 16, Rounding = 0,
        Callback = function(value) end,
    })

    Section:CreateDropdown({
        Title = "Mode",
        Options = {"Legit", "Silent", "Off"},
        Default = "Off",
        Callback = function(option) end,
    })

    UI:Notify({ Title = "Loaded", Content = "WindStyleUI is ready.", Duration = 4 })
    ------------------------------------------------------------------
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// ICONS (Lucide set, keyed by name) --------------------------------------
-- Source: https://github.com/Footagesus/Icons (lucide/dist/Icons.lua)
-- Loaded once and cached; falls back silently if the fetch fails so the UI
-- still works with raw "rbxassetid://..." strings passed directly.
local Icons = {}
do
    local ok, result = pcall(function()
        return game:HttpGet(
            "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
        )
    end)
    if ok and result then
        local okLoad, loaded = pcall(function()
            return loadstring(result)()
        end)
        if okLoad and type(loaded) == "table" then
            Icons = loaded
        end
    end
end

-- Resolves an icon value: a Lucide name ("house"), a raw "rbxassetid://..."
-- string, or nil. Returns an asset id string or nil.
local function resolveIcon(icon)
    if not icon then return nil end
    if type(icon) == "string" and icon:match("^rbxassetid://") then
        return icon
    end
    return Icons[icon]
end

--// THEME (Wind UI-like dark palette) ------------------------------------
local Theme = {
    Background   = Color3.fromRGB(24, 24, 27),
    Sidebar      = Color3.fromRGB(20, 20, 23),
    Section      = Color3.fromRGB(30, 30, 34),
    Element      = Color3.fromRGB(37, 37, 42),
    ElementHover = Color3.fromRGB(45, 45, 51),
    Stroke       = Color3.fromRGB(50, 50, 56),
    Accent       = Color3.fromRGB(90, 110, 255),
    Text         = Color3.fromRGB(235, 235, 240),
    SubText      = Color3.fromRGB(150, 150, 160),
    Font         = Enum.Font.GothamMedium,
    FontBold     = Enum.Font.GothamBold,
}

local function tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(
        time or 0.2,
        style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
end

local function stroke(color, thickness)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = 0.2,
    })
end

local function padding(all)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, all),
        PaddingBottom = UDim.new(0, all),
        PaddingLeft = UDim.new(0, all),
        PaddingRight = UDim.new(0, all),
    })
end

local function makeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos
    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// LIBRARY ROOT -----------------------------------------------------------
local Library = {}
Library.__index = Library

function Library:CreateWindow(config)
    config = config or {}
    local title    = config.Title or "Window"
    local subtitle = config.SubTitle or ""
    local size     = config.Size or UDim2.fromOffset(560, 380)

    local ScreenGui = create("ScreenGui", {
        Name = "WindStyleUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or CoreGui,
    })

    local Main = create("Frame", {
        Name = "Main",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
        BackgroundColor3 = Theme.Background,
        Parent = ScreenGui,
    }, { corner(10), stroke() })

    -- Top bar
    local TopBar = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Sidebar,
        Parent = Main,
    }, { corner(10) })

    -- mask bottom corners of topbar square
    create("Frame", {
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BorderSizePixel = 0,
        Parent = TopBar,
    })

    create("TextLabel", {
        Text = title,
        Font = Theme.FontBold,
        TextSize = 15,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 6),
        Size = UDim2.new(0.6, 0, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })

    create("TextLabel", {
        Text = subtitle,
        Font = Theme.Font,
        TextSize = 12,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 24),
        Size = UDim2.new(0.6, 0, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })

    local CloseBtn = create("TextButton", {
        Text = "âœ•",
        Font = Theme.FontBold,
        TextSize = 16,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -38, 0, 6),
        Parent = TopBar,
    })
    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, { Size = UDim2.fromOffset(0, 0) }, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    local MinBtn = create("TextButton", {
        Text = "âˆ’",
        Font = Theme.FontBold,
        TextSize = 18,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -70, 0, 6),
        Parent = TopBar,
    })

    makeDraggable(Main, TopBar)

    -- Sidebar (icon tabs)
    local Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = Theme.Sidebar,
        Parent = Main,
    })

    local TabList = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Sidebar,
    }, {
        create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
        padding(8),
    })

    local body = create("Frame", {
        Name = "Body",
        Size = UDim2.new(1, -150, 1, -44),
        Position = UDim2.new(0, 150, 0, 44),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local Window = setmetatable({
        ScreenGui = ScreenGui,
        Main = Main,
        TabList = TabList,
        Body = body,
        Tabs = {},
        _first = true,
    }, { __index = Library })

    local isVisible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            isVisible = not isVisible
            Main.Visible = isVisible
        end
    end)

    MinBtn.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        Sidebar.Visible = not Sidebar.Visible
        tween(Main, { Size = body.Visible and size or UDim2.fromOffset(size.X.Offset, 44) }, 0.2)
    end)

    return Window
end

--// TAB ---------------------------------------------------------------------
function Library:CreateTab(config)
    config = config or {}
    local title = config.Title or "Tab"
    local icon  = resolveIcon(config.Icon) -- Lucide name or rbxassetid string, optional

    local TabButton = create("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = self._first and 0 or 1,
        AutoButtonColor = false,
        Parent = self.TabList,
    }, { corner(6) })

    if icon then
        create("ImageLabel", {
            Image = icon,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 10, 0.5, -8),
            BackgroundTransparency = 1,
            ImageColor3 = self._first and Theme.Accent or Theme.SubText,
            Parent = TabButton,
        })
    end

    local Label = create("TextLabel", {
        Text = title,
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = self._first and Theme.Text or Theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 34 or 12, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TabButton,
    })

    local Page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = self._first,
        Parent = self.Body,
    }, {
        create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }),
        padding(12),
    })

    self._first = false

    TabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            tween(t.Button, { BackgroundTransparency = 1 }, 0.15)
            t.Label.TextColor3 = Theme.SubText
            if t.Icon then t.Icon.ImageColor3 = Theme.SubText end
            t.Page.Visible = false
        end
        tween(TabButton, { BackgroundTransparency = 0 }, 0.15)
        Label.TextColor3 = Theme.Text
        Page.Visible = true
    end)

    local TabObject = setmetatable({
        Button = TabButton,
        Label = Label,
        Page = Page,
        Icon = icon and TabButton:FindFirstChildOfClass("ImageLabel"),
    }, { __index = Library })

    table.insert(self.Tabs, TabObject)
    TabObject.Page = Page
    TabObject._window = self

    return TabObject
end

--// SECTION ------------------------------------------------------------------
function Library.CreateSection(self, title)
    local Section = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Section,
        Parent = self.Page,
    }, { corner(8), stroke(), padding(10) })

    create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Section,
    })

    create("TextLabel", {
        Text = title or "Section",
        Font = Theme.FontBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 0,
        Parent = Section,
    })

    return setmetatable({ Holder = Section }, { __index = Library })
end

--// BUTTON --------------------------------------------------------------------
function Library.CreateButton(self, config)
    config = config or {}
    local Btn = create("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Element,
        AutoButtonColor = false,
        Parent = self.Holder,
    }, { corner(6) })

    create("TextLabel", {
        Text = config.Title or "Button",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Btn,
    })

    Btn.MouseEnter:Connect(function() tween(Btn, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
    Btn.MouseLeave:Connect(function() tween(Btn, { BackgroundColor3 = Theme.Element }, 0.15) end)
    Btn.MouseButton1Click:Connect(function()
        tween(Btn, { BackgroundColor3 = Theme.Accent }, 0.1)
        task.wait(0.1)
        tween(Btn, { BackgroundColor3 = Theme.ElementHover }, 0.15)
        if config.Callback then
            task.spawn(config.Callback)
        end
    end)

    return Btn
end

--// TOGGLE --------------------------------------------------------------------
function Library.CreateToggle(self, config)
    config = config or {}
    local state = config.Default or false

    local Holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Element,
        Parent = self.Holder,
    }, { corner(6) })

    create("TextLabel", {
        Text = config.Title or "Toggle",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })

    local Switch = create("Frame", {
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = state and Theme.Accent or Theme.Stroke,
        Parent = Holder,
    }, { corner(10) })

    local Knob = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = Switch,
    }, { corner(8) })

    local Click = create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Holder,
    })

    local function set(newState, fireCallback)
        state = newState
        tween(Switch, { BackgroundColor3 = state and Theme.Accent or Theme.Stroke }, 0.15)
        tween(Knob, { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }, 0.15)
        if fireCallback ~= false and config.Callback then
            task.spawn(config.Callback, state)
        end
    end

    Click.MouseButton1Click:Connect(function() set(not state) end)

    if config.Default then set(true, false) end

    return { Set = set, Get = function() return state end }
end

--// SLIDER --------------------------------------------------------------------
function Library.CreateSlider(self, config)
    config = config or {}
    local min, max = config.Min or 0, config.Max or 100
    local rounding = config.Rounding or 0
    local value = config.Default or min

    local Holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.Element,
        Parent = self.Holder,
    }, { corner(6), padding(10) })

    create("TextLabel", {
        Text = config.Title or "Slider",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })

    local ValueLabel = create("TextLabel", {
        Text = tostring(value),
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, -4, 0, 16),
        Position = UDim2.new(0.6, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = Holder,
    })

    local Track = create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = Theme.Stroke,
        Parent = Holder,
    }, { corner(3) })

    local Fill = create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = Track,
    }, { corner(3) })

    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local raw = min + (max - min) * rel
        if rounding <= 0 then
            raw = math.floor(raw + 0.5)
        else
            raw = math.floor(raw * (10 ^ rounding) + 0.5) / (10 ^ rounding)
        end
        value = raw
        Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        ValueLabel.Text = tostring(value)
        if config.Callback then task.spawn(config.Callback, value) end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    return {
        Set = function(v)
            value = math.clamp(v, min, max)
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            ValueLabel.Text = tostring(value)
        end,
        Get = function() return value end,
    }
end

--// DROPDOWN ------------------------------------------------------------------
function Library.CreateDropdown(self, config)
    config = config or {}
    local options = config.Options or {}
    local selected = config.Default or options[1]
    local open = false

    local Holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Element,
        ClipsDescendants = true,
        Parent = self.Holder,
    }, { corner(6) })

    create("TextLabel", {
        Text = config.Title or "Dropdown",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 34),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })

    local SelectedLabel = create("TextLabel", {
        Text = tostring(selected or ""),
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.45, -30, 0, 34),
        Position = UDim2.new(0.5, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = Holder,
    })

    local Toggle = create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Parent = Holder,
    })

    local List = create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(1, 0, 0, #options * 26),
        Parent = Holder,
    }, {
        create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
    })

    for _, opt in ipairs(options) do
        local OptBtn = create("TextButton", {
            Text = tostring(opt),
            Font = Theme.Font,
            TextSize = 12,
            TextColor3 = Theme.SubText,
            BackgroundColor3 = Theme.ElementHover,
            Size = UDim2.new(1, -16, 0, 24),
            Position = UDim2.new(0, 8, 0, 0),
            AutoButtonColor = false,
            Parent = List,
        }, { corner(4) })

        OptBtn.MouseButton1Click:Connect(function()
            selected = opt
            SelectedLabel.Text = tostring(opt)
            if config.Callback then task.spawn(config.Callback, opt) end
            open = false
            tween(Holder, { Size = UDim2.new(1, 0, 0, 34) }, 0.15)
        end)
    end

    Toggle.MouseButton1Click:Connect(function()
        open = not open
        tween(Holder, { Size = open and UDim2.new(1, 0, 0, 36 + #options * 26) or UDim2.new(1, 0, 0, 34) }, 0.15)
    end)

    return {
        Set = function(v)
            selected = v
            SelectedLabel.Text = tostring(v)
        end,
        Get = function() return selected end,
    }
end

--// INPUT (TextBox) -------------------------------------------------------------
function Library.CreateInput(self, config)
    config = config or {}
    local Holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Element,
        Parent = self.Holder,
    }, { corner(6) })

    create("TextLabel", {
        Text = config.Title or "Input",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })

    local Box = create("TextBox", {
        Text = config.Default or "",
        PlaceholderText = config.Placeholder or "",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Text,
        ClearTextOnFocus = false,
        BackgroundColor3 = Theme.ElementHover,
        Size = UDim2.new(0.55, 0, 0, 24),
        Position = UDim2.new(0.43, 0, 0.5, -12),
        Parent = Holder,
    }, { corner(4), padding(4) })

    Box.FocusLost:Connect(function(enter)
        if config.Callback then task.spawn(config.Callback, Box.Text, enter) end
    end)

    return { Get = function() return Box.Text end, Set = function(v) Box.Text = v end }
end

--// NOTIFICATION -----------------------------------------------------------------
function Library:Notify(config)
    config = config or {}
    local gui = (gethui and gethui()) or CoreGui
    local holderName = "WindStyleUI_Notifications"
    local Holder = gui:FindFirstChild(holderName)
    if not Holder then
        Holder = create("ScreenGui", { Name = holderName, ResetOnSpawn = false, Parent = gui })
        create("Frame", {
            Name = "Container",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -16, 1, -16),
            Size = UDim2.new(0, 260, 1, -32),
            BackgroundTransparency = 1,
            Parent = Holder,
        }, {
            create("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
        })
    end
    local Container = Holder.Container

    local Card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Section,
        BackgroundTransparency = 1,
        Parent = Container,
    }, { corner(8), stroke(), padding(12) })

    create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Card })

    create("TextLabel", {
        Text = config.Title or "Notification",
        Font = Theme.FontBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Card,
    })

    create("TextLabel", {
        Text = config.Content or "",
        Font = Theme.Font,
        TextSize = 12,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Card,
    })

    for _, child in ipairs(Card:GetChildren()) do
        if child:IsA("TextLabel") then
            tween(child, { TextTransparency = 0 }, 0.25)
        end
    end
    tween(Card, { BackgroundTransparency = 0 }, 0.25)
    Card.UIStroke.Transparency = 1
    tween(Card.UIStroke, { Transparency = 0.2 }, 0.25)

    task.delay(config.Duration or 4, function()
        for _, child in ipairs(Card:GetDescendants()) do
            if child:IsA("TextLabel") then tween(child, { TextTransparency = 1 }, 0.25) end
        end
        tween(Card, { BackgroundTransparency = 1 }, 0.25)
        task.wait(0.3)
        Card:Destroy()
    end)
end

return Library
