--[[
    Example script using WindStyleUI
    Loads the library from your GitHub repo and builds a fuller demo menu
    showing off every control: Button, Toggle, Slider, Dropdown, Input,
    Keybind, ColorPicker, Paragraph, and Notifications.
]]

local UI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/WindStyleUI.lua"
))()

local Player = game.Players.LocalPlayer

--// Window ------------------------------------------------------------
local Window = UI:CreateWindow({
    Title    = "c00lgui",
    SubTitle = "v1.1.0",
    Size     = UDim2.fromOffset(600, 420),
})

--// Tabs --------------------------------------------------------------
local MainTab = Window:CreateTab({ Title = "Main", Icon = "house" })
local PlayerTab = Window:CreateTab({ Title = "Player", Icon = "user-round" })
local VisualsTab = Window:CreateTab({ Title = "Visuals", Icon = "eye" })
local SettingsTab = Window:CreateTab({ Title = "Settings", Icon = "settings" })

--// Main tab -----------------------------------------------------------
local InfoSection = MainTab:CreateSection("Info")

InfoSection:CreateParagraph({
    Title = "Welcome",
    Content = "This is a demo menu built with WindStyleUI. Every control below is wired to something in your game or just prints to output.",
})

InfoSection:CreateButton({
    Title = "Say Hello",
    Callback = function()
        print("Hello from WindStyleUI, " .. Player.Name .. "!")
    end,
})

InfoSection:CreateToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end,
})

local ScriptSection = MainTab:CreateSection("Script")

ScriptSection:CreateKeybind({
    Title = "Toggle Menu",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        print("Menu keybind set to:", key.Name)
    end,
})

ScriptSection:CreateDropdown({
    Title = "Config Profile",
    Options = { "Default", "Legit", "Rage" },
    Default = "Default",
    Callback = function(option)
        print("Profile set to:", option)
    end,
})

--// Player tab ---------------------------------------------------------
local MovementSection = PlayerTab:CreateSection("Movement")

MovementSection:CreateSlider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 0,
    Callback = function(value)
        local char = Player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end,
})

MovementSection:CreateSlider({
    Title = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Rounding = 0,
    Callback = function(value)
        local char = Player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end,
})

MovementSection:CreateToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        print("Infinite Jump:", state)
        -- hook your own UserInputService jump logic here
    end,
})

MovementSection:CreateToggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        print("Noclip:", state)
        -- hook your own CollisionGroup / CanCollide logic here
    end,
})

local StatsSection = PlayerTab:CreateSection("Stats")

StatsSection:CreateSlider({
    Title = "FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Rounding = 0,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end,
})

--// Visuals tab ---------------------------------------------------------
local ESPSection = VisualsTab:CreateSection("ESP")

ESPSection:CreateToggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        print("Player ESP:", state)
    end,
})

ESPSection:CreateColorPicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(90, 110, 255),
    Callback = function(color)
        print("ESP Color set to:", color)
    end,
})

ESPSection:CreateSlider({
    Title = "ESP Max Distance",
    Min = 100,
    Max = 5000,
    Default = 1000,
    Rounding = 0,
    Callback = function(value)
        print("ESP distance:", value)
    end,
})

local WorldSection = VisualsTab:CreateSection("World")

WorldSection:CreateToggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(state)
        game:GetService("Lighting").Brightness = state and 2 or 1
    end,
})

WorldSection:CreateColorPicker({
    Title = "Ambient Color",
    Default = Color3.fromRGB(150, 150, 150),
    Callback = function(color)
        game:GetService("Lighting").Ambient = color
    end,
})

--// Settings tab ---------------------------------------------------------
local UISection = SettingsTab:CreateSection("Interface")

UISection:CreateDropdown({
    Title = "Menu Bind",
    Options = { "RightControl", "RightShift", "Insert" },
    Default = "RightControl",
    Callback = function(option)
        print("Menu bind set to:", option)
    end,
})

UISection:CreateInput({
    Title = "Webhook Name",
    Placeholder = "Enter a name...",
    Callback = function(text, enterPressed)
        print("Webhook name set to:", text)
    end,
})

local MiscSection = SettingsTab:CreateSection("Misc")

MiscSection:CreateButton({
    Title = "Copy Discord Invite",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/example")
            UI:Notify({ Title = "Copied", Content = "Discord invite copied to clipboard.", Duration = 3 })
        end
    end,
})

MiscSection:CreateButton({
    Title = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, Player)
    end,
})

--// Welcome notification --------------------------------------------------
UI:Notify({
    Title = "c00lgui loaded",
    Content = "Welcome back, " .. Player.Name .. "!",
    Duration = 4,
})
