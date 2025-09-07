local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Set initial library settings
WindUI:SetNotificationLower(true)
WindUI:SetTheme("Dark")
WindUI:SetFont("rbxassetid://11702779517") -- Using a default Roblox font

-- Create main window
local Window = WindUI:CreateWindow({
    Title = "Cosmic Hub",
    Icon = "star",
    Author = "Created by You",
    Folder = "CosmicHub",
    Size = UDim2.fromOffset(600, 480),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() print("User profile clicked") end,
        Anonymous = false
    },
    SideBarWidth = 220,
    HasOutline = true,
    KeySystem = {
        Key = { "COSMIC2025", "HUB1234" },
        Note = "Enter key to access Cosmic Hub.\nKeys: COSMIC2025 or HUB1234",
        URL = "https://github.com/Footagesus/WindUI"
    }
})

-- Create tabs
local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "home" }),
    Scripts = Window:Tab({ Title = "Scripts", Icon = "code" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings" }),
    Config = Window:Tab({ Title = "Config", Icon = "save" })
}

-- Home Tab
Tabs.Home:Section({ Title = "Welcome to Cosmic Hub" })
Tabs.Home:Paragraph({
    Title = "Greetings, " .. Players.LocalPlayer.Name,
    Desc = "Welcome to Cosmic Hub, your all-in-one solution for Roblox scripting!",
    Color = "White"
})

Tabs.Home:Button({
    Title = "Quick Start",
    Icon = "play",
    Callback = function()
        WindUI:Notify({
            Title = "Starting...",
            Content = "Quick start initiated!",
            Icon = "rocket",
            Duration = 3
        })
    end
})

-- Scripts Tab
Tabs.Scripts:Section({ Title = "Available Scripts" })

local scriptOptions = { "Speed Boost", "Infinite Jump", "ESP" }
Tabs.Scripts:Dropdown({
    Title = "Select Script",
    Values = scriptOptions,
    Value = scriptOptions[1],
    Callback = function(option)
        WindUI:Notify({
            Title = "Script Selected",
            Content = "Loaded: " .. option,
            Icon = "check",
            Duration = 3
        })
    end
})

Tabs.Scripts:Toggle({
    Title = "Auto-Execute",
    Desc = "Automatically run selected script",
    Value = false,
    Callback = function(value)
        print("Auto-Execute set to: " .. tostring(value))
    end
})

-- Settings Tab
Tabs.Settings:Section({ Title = "Appearance" })

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tabs.Settings:Dropdown({
    Title = "Select Theme",
    Multi = false,
    AllowNone = false,
    Value = WindUI:GetCurrentTheme(),
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "Theme Changed",
            Content = "Applied theme: " .. theme,
            Icon = "palette",
            Duration = 3
        })
    end
})

Tabs.Settings:Toggle({
    Title = "Window Transparency",
    Value = WindUI:GetTransparency(),
    Callback = function(enabled)
        Window:ToggleTransparency(enabled)
    end
})

Tabs.Settings:Keybind({
    Title = "Toggle UI",
    Desc = "Key to show/hide UI",
    Value = "H",
    Callback = function(value)
        Window:SetToggleKey(Enum.KeyCode[value])
    end
})

-- Config Tab
Tabs.Config:Section({ Title = "Configuration Manager" })

local configFolder = "CosmicHub/Configs"
makefolder(configFolder)

local function SaveConfig(fileName, data)
    local filePath = configFolder .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
    WindUI:Notify({
        Title = "Saved",
        Content = "Configuration saved: " .. fileName,
        Icon = "save",
        Duration = 3
    })
end

local function LoadConfig(fileName)
    local filePath = configFolder .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
    return nil
end

local function ListConfigs()
    local files = {}
    for _, file in ipairs(listfiles(configFolder)) do
        local name = file:match("^.+/(.+)%.json$")
        if name then
            table.insert(files, name)
        end
    end
    return files
end

local configName = ""
Tabs.Config:Input({
    Title = "Config Name",
    Placeholder = "Enter config name",
    Callback = function(text)
        configName = text
    end
})

Tabs.Config:Button({
    Title = "Save Config",
    Icon = "save",
    Callback = function()
        if configName ~= "" then
            SaveConfig(configName, {
                theme = WindUI:GetCurrentTheme(),
                transparency = WindUI:GetTransparency(),
                windowSize = { x = WindUI:GetWindowSize().X.Offset, y = WindUI:GetWindowSize().Y.Offset },
                lastSave = os.date("%Y-%m-%d %H:%M:%S")
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a config name",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

local configDropdown
configDropdown = Tabs.Config:Dropdown({
    Title = "Select Config",
    Multi = false,
    AllowNone = true,
    Values = ListConfigs(),
    Callback = function(selected)
        configName = selected
    end
})

Tabs.Config:Button({
    Title = "Load Config",
    Icon = "refresh-cw",
    Callback = function()
        if configName ~= "" then
            local data = LoadConfig(configName)
            if data then
                WindUI:SetTheme(data.theme)
                Window:ToggleTransparency(data.transparency)
                Window:Resize(UDim2.fromOffset(data.windowSize.x, data.windowSize.y))
                WindUI:Notify({
                    Title = "Loaded",
                    Content = "Configuration loaded: " .. configName,
                    Icon = "check",
                    Duration = 3
                })
                configDropdown:UpdateValues(ListConfigs())
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Failed to load config",
                    Icon = "x",
                    Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a config",
                Icon = "x",
                Duration = 3
            })
        end
    end
})

-- Footer
local footerSection = Window:Section({ Title = "Cosmic Hub v1.0" })
Tabs.Config:Paragraph({
    Title = "Support Us",
    Desc = "Check out our GitHub for more!",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "Copy GitHub Link",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://github.com/Footagesus/WindUI")
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "GitHub link copied to clipboard",
                    Icon = "copy",
                    Duration = 2
                })
            end
        }
    }
})

-- Handle window close
Window:OnClose(function()
    print("Cosmic Hub closed")
end)
