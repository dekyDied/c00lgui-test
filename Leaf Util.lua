local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Leafy Utility",
    Icon = "leaf",
    Author = ".delyon",
    Folder = "LeafyUtil",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

local LocalPlayer = Window:Tab({
    Title = "Local Player",
    Icon = "circle-user",
    Locked = false,
})

local Section = LocalPlayer:Section({ 
    Title = "Stamina",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Button = LocalPlayer:Button({
    Title = "Infinite Stamina",
    Desc = "Run non-stop as far as you want.",
    Locked = false,
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if character:GetAttribute("MaxStamina") ~= nil then
            character:SetAttribute("MaxStamina", math.huge)
        elseif player:GetAttribute("MaxStamina") ~= nil then
            player:SetAttribute("MaxStamina", math.huge)
        else
            for _, obj in pairs({character, player, character:FindFirstChildOfClass("Humanoid")}) do
                if obj and obj:GetAttributes() then
                    for name, _ in pairs(obj:GetAttributes()) do
                        if name:lower():find("stamina") then
                            obj:SetAttribute(name, math.huge)
                        end
                    end
                end
            end
        end
    end
})