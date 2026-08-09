-- vars & funcs
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GroupService = game:GetService("GroupService")

local function JoinGroup(groupid)
    GroupService:PromptJoinAsync(groupid)
end

JoinGroup(1030692)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "ExaSaturn",
    Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image7.png",
    Author = "none",
    Folder = "ExaSaturn-Evade",
    Transparent = true,
    Theme = "Crimson",
    NewElements = true,
    ElementRadius = 13,
    Resizable = true,
    HideSearchBar = false,
    ScrollBarEnabled = true
})

Window:SetToggleKey(Enum.KeyCode.G)

Window:Tag({
    Icon = "sun",
    Title = "Evade | Summer 2026",
    Color = Color3.fromHex("#FFD050"),
    Radius = 13
})

Window:Tag({
    Title = "V0.1",
    Color = Color3.fromHex("#990000"),
    Radius = 13
})


Window:EditOpenButton({
    Title = "ExaSaturn",
    Icon = "shield-cog-corner",
    CornerRadius = UDim.new(0,50),
    StrokeThickness = 1,
    Color = ColorSequence.new(
        Color3.fromHex("FF0000"),
        Color3.fromHex("000080")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image1.png", Locked = false, })
Window:Divider()
local PlayerTab = Window:Tab({ Title = "Player", Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image2.png", Locked = false, })
local UiTab = Window:Tab({ Title = "Ui", Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image3.png", Locked = false,})
local MiscTab = Window:Tab({ Title = "Misc", Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image4.png", Locked = false, })
Window:Divider()
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image5.png", Locked = false, })
local CreditsTab = Window:Tab({ Title = "Credits", Icon = "https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/images/image6.png", Locked = false, })

MainTab:Paragraph({
    Title = "Open or Minimize UI IN PC",
    Desc = "PRESS G in your keyboard to open the ui or minimize the ui in pc",
    Color = "Green",
    Locked = false,
})

MainTab:Divider()

MainTab:Section({
    Title = "Interface Customization",
    Icon = "brush",
})

MainTab:Dropdown({
    Title = "Theme",
    Values = { "Rose","Light","MonokaiPro","Plant","Midnight","CottonCandy","Dark","Indigo","Sky","Crimson","Amber","Violet","Red" },
    Value = "Crimson",
    Callback = function(option)
        WindUI:SetTheme(option)
    end
})

MainTab:Toggle({
    Title = "Transparency",
    Icon = "palette",
    Value = true,
    Callback = function(state)
        Window:ToggleTransparency(state)
    end
})

MainTab:Section({
    Title = "User Profile",
    Icon = "shield-user",
})

MainTab:Toggle({
    Title = "Profile icon",
    Desc = "Your profile on your left down",
    Icon = "user",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        local stateinfo = state
        if stateinfo then
            Window.User:Enable()
        else
            Window.User:Disable()
        end
    end
})

MainTab:Toggle({
    Title = "Set profile anonymous",
    Desc = "Your profile on your left down",
    Icon = "hat-glasses",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        local stateinfo = state
        if stateinfo then
            Window.User:SetAnonymous(true)
        else
            Window.User:SetAnonymous(false)
        end
    end
})

-- Player Tab

PlayerSec = PlayerTab:Section({
    Title = "Player Properties",
    Icon = "traffic-cone",
    Box = true,
    Opened = true
})

PlayerSec:Paragraph({
    Title = "Speed Multiplier:"
})

-- Variáveis
local DefaultWalkSpeed = 16
local SpeedMultiplier = 1
local SpeedEnabled = false

-- Detecta a velocidade padrão do jogo
local function DetectDefaultSpeed()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid", 3)
    
    if humanoid then
        DefaultWalkSpeed = humanoid.WalkSpeed
    end
end

-- Aplica a velocidade
local function UpdatePlayerSpeed()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if SpeedEnabled then
        humanoid.WalkSpeed = DefaultWalkSpeed * SpeedMultiplier
    else
        humanoid.WalkSpeed = DefaultWalkSpeed
    end
end

PlayerSec:Slider({
    Title = "Multiplicador",
    Desc = "1.0 = velocidade normal",
    Value = {
        Min = 1,
        Max = 10,
        Default = 2,
    },
    Step = 0.1,
    Callback = function(value)
        SpeedMultiplier = value
        if SpeedEnabled then
            UpdatePlayerSpeed()
        end
    end
})

PlayerSec:Toggle({
    Title = "Ativar Multiplicador de Velocidade",
    Desc = "Liga/desliga o multiplicador",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        UpdatePlayerSpeed()
    end
})

PlayerSec:Toggle({
    Title = "Noclip",
    Callback = function(state)
        local stateinfo = state
        if stateinfo then
            -- Toggle ativado (Noclip Ativo)
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer

            _G.NoclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
                _G.NoclipConnection = nil
            end

            local character = game:GetService("Players").LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Restaura a colisão padrão das partes principais do avatar
                        if part.Name == "HumanoidRootPart" then
                            part.CanCollide = false -- Mantém falso por padrão do Roblox para evitar bugs físicos
                        elseif part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Head" or part.Name == "Torso" then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

MiscTab:Section({
    Title = "External Scripts",
    Icon = "folder-open",
})

MiscTab:Button({
    Title = "Infinite yield",
    Icon = "file",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

MiscTab:Button({
    Title = "Dex explorer",
    Icon = "file",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})

MiscTab:Button({
    Title = "Dex plus",
    Icon = "file",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/DexPlusBackup.luau"))()
    end
})

SettingsTab:Section({
    Title = "General Settings",
    Icon = "cog",
})

SettingsTab:Input({
    Title = "Config name",
    Desc = "",
    Value = "",
    Placeholder = "Enter config name...",
    Callback = function(input)
        _cfgName = input and input:match("%S") and input or nil
        _selectedConfig = nil
    end
})

local dropdown = SettingsTab:Dropdown({
    Title = "Configs",
    Desc = "",
    Values = {},
    Value = nil,
    Callback = function(option)
        _selectedConfig = option
        _cfgName = nil
    end
})

local function refreshDropdown()
    local ConfigManager = Window.ConfigManager
    local ok, values = pcall(function()
        return ConfigManager:AllConfigs()
    end)

    if ok and type(values) == "table" then
        table.sort(values, function(a,b)
            return tostring(a):lower() < tostring(b):lower()
        end)
        dropdown:Refresh(values)
    else
        dropdown:Refresh({})
    end
end

SettingsTab:Button({
    Title = "Refresh",
    Desc = "",
    Callback = function()
        refreshDropdown()

        WindUI:Notify({
            Title = "Config Manager",
            Content = "Dropdown refreshed",
            Duration = 5,
            Icon = "folder-sync",
        })
    end
})

SettingsTab:Button({
    Title = "Load",
    Desc = "",
    Callback = function()
        if not _selectedConfig then return end

        local ConfigManager = Window.ConfigManager
        local name = _selectedConfig

        local exists = false
        local ok, configs = pcall(function()
            return ConfigManager:AllConfigs()
        end)

        if ok and type(configs) == "table" then
            for _,v in pairs(configs) do
                if v == name then
                    exists = true
                    break
                end
            end
        end

        if not exists then
            _selectedConfig = nil

            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") doesn't exist",
                Duration = 5,
                Icon = "folder-closed",
            })

            return
        end

        local success = pcall(function()
            ConfigManager:CreateConfig(name):Load()
        end)

        if success then
            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") loaded",
                Duration = 5,
                Icon = "folder-input",
            })
        end
    end
})

SettingsTab:Button({
    Title = "Save",
    Desc = "",
    Callback = function()
        local ConfigManager = Window.ConfigManager
        local name = _cfgName or _selectedConfig
        if not name or name == "" then return end

        local ok = pcall(function()
            ConfigManager:CreateConfig(name):Save()
        end)

        if ok then
            _selectedConfig = name
            _cfgName = nil

            refreshDropdown()

            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") saved",
                Duration = 5,
                Icon = "folder-open",
            })
        end
    end
})

SettingsTab:Button({
    Title = "Delete",
    Desc = "",
    Callback = function()
        if not _selectedConfig then return end

        local ConfigManager = Window.ConfigManager
        local name = _selectedConfig

        local ok = pcall(function()
            ConfigManager:DeleteConfig(name)
        end)

        if ok then
            _selectedConfig = nil

            refreshDropdown()

            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") deleted",
                Duration = 5,
                Icon = "folder-closed",
            })
        end
    end
})

SettingsTab:Section({
    Title = "Minor Settings",
    Icon = "cog",
})

SettingsTab:Button({
    Title = "ServerHop",
    Desc = "",
    Locked = false,
    Callback = function()

        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)

    end
})

SettingsTab:Button({
    Title = "Rejoin",
    Desc = "",
    Locked = false,
    Callback = function()

        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)

    end
})

CreditsTab:Paragraph({
    Title = "ExaSaturn Community",
    Desc = "After a long time, ExaSaturn has finally created a official discord server!\n[<font color="#aa57e6" face="FredokaOne"><stroke color="#6e467a" thickness="2">dekyo</stroke></font>] the dude",
    Image = "https://cdn.discordapp.com/icons/1534256918124564550/7c1dba492699e1a3b34c6f11a84df27e.png?size=2048",
    ImageSize = 24,
    Color = Color3.fromRGB(100, 200, 255),
    Buttons = {
        {
            Title = "Link",
            Icon = "link",
            Callback = function()
                setclipboard()
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "The Discord server link has been copied to your clipboard.",
                    Icon = "rbxassetid://11529076323",
                    Duration = 3,
                })
            end
        }
    }
})

WindUI:Notify({
    Title = "ExaSaturn",
    Content = "Welcome! We're glad to have you here. Enjoy your experience!",
    Icon = "sparkles",
    Duration = 5,
})
