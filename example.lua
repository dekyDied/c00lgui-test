--[[
    Example script using WindStyleUI
    Loads the library from your GitHub repo and builds a small demo menu.
]]

local UI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/WindStyleUI.lua"
))()

local Player = game.Players.LocalPlayer

--// Window ------------------------------------------------------------
local Window = UI:CreateWindow({
    Title    = "c00lgui",
    SubTitle = "v1.0.0",
    Size     = UDim2.fromOffset(560, 380),
})

--// Tabs --------------------------------------------------------------
local MainTab = Window:CreateTab({
    Title = "Main",
    Icon  = "house",
})

local PlayerTab = Window:CreateTab({
    Title = "Player",
    Icon  = "user-round",
})

local SettingsTab = Window:CreateTab({
    Title = "Settings",
    Icon  = "settings",
})

--// Main tab -----------------------------------------------------------
local InfoSection = MainTab:CreateSection("Info")

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

--// Welcome notification --------------------------------------------------
UI:Notify({
    Title = "c00lgui loaded",
    Content = "Welcome back, " .. Player.Name .. "!",
    Duration = 4,
})
