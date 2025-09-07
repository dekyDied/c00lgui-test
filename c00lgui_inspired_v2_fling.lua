-- Expanded c00lgui-inspired Roblox GUI by Grok (Version 2 with Fling and Player Select)
-- Adds client-side fling with player selection while keeping all previous features.
-- Fling is client-side (visual only on your screen) to avoid server-side exploits.
-- Use in private servers to minimize ban risk due to anti-cheat detection.

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Services
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "c00lguiInspiredV2"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Create main frame with ScrollingFrame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.BorderSizePixel = 4
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -60)
scrollFrame.Position = UDim2.new(0, 0, 0, 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

-- UIListLayout for buttons
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "c00lgui Inspired V2 - Fling Added"
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.Font = Enum.Font.Arcade
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- Player Selection Frame (Dropdown-like)
local playerSelectFrame = Instance.new("Frame")
playerSelectFrame.Size = UDim2.new(1, -20, 0, 30)
playerSelectFrame.Position = UDim2.new(0, 10, 0, 30)
playerSelectFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playerSelectFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
playerSelectFrame.BorderSizePixel = 2
playerSelectFrame.Parent = mainFrame

local playerSelectLabel = Instance.new("TextLabel")
playerSelectLabel.Size = UDim2.new(1, 0, 1, 0)
playerSelectLabel.BackgroundTransparency = 1
playerSelectLabel.Text = "Select Player: None"
playerSelectLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
playerSelectLabel.Font = Enum.Font.Arcade
playerSelectLabel.TextSize = 16
playerSelectLabel.Parent = playerSelectFrame

-- Player List Frame (shows when clicking playerSelectFrame)
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, -20, 0, 100)
playerListFrame.Position = UDim2.new(0, 10, 0, 60)
playerListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playerListFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
playerListFrame.BorderSizePixel = 2
playerListFrame.Visible = false
playerListFrame.Parent = mainFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 2)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Parent = playerListFrame

-- Variables for state
local flyEnabled = false
local noclipEnabled = false
local connection
local bodyVelocity
local bodyAngularVelocity
local noclipConnection
local selectedPlayer = nil

-- Update player list
local function updatePlayerList()
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, p in pairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 20)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
        btn.BorderSizePixel = 1
        btn.TextColor3 = Color3.fromRGB(255, 0, 0)
        btn.Font = Enum.Font.Arcade
        btn.TextSize = 14
        btn.Text = p.Name
        btn.Parent = playerListFrame
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = p
            playerSelectLabel.Text = "Select Player: " .. p.Name
            playerListFrame.Visible = false
        end)
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 10)
end

-- Toggle player list visibility
playerSelectFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        playerListFrame.Visible = not playerListFrame.Visible
        updatePlayerList()
    end
end)

-- Update ScrollingFrame CanvasSize
local function updateCanvas()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- Button factory function
local function createButton(name, text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0) -- Handled by layout
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.BorderSizePixel = 2
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.Font = Enum.Font.Arcade
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Fling Button (Client-Side)
createButton("FlingButton", "Fling Selected Player", function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = selectedPlayer.Character.HumanoidRootPart
        local existingVelocity = targetRoot:FindFirstChild("c00lFlingVelocity")
        if existingVelocity then existingVelocity:Destroy() end
        local bv = Instance.new("BodyVelocity")
        bv.Name = "c00lFlingVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(math.random(-50, 50), 200, math.random(-50, 50)) -- Upward with random horizontal
        bv.Parent = targetRoot
        game:GetService("Debris"):AddItem(bv, 0.5) -- Remove after 0.5 seconds
    else
        playerSelectLabel.Text = "Select Player: None (Invalid)"
    end
end)

-- Previous Features
createButton("MusicButton", "Play Music", function()
    local existing = workspace:FindFirstChild("c00lMusic")
    if existing then existing:Destroy() end
    local sound = Instance.new("Sound")
    sound.Name = "c00lMusic"
    sound.SoundId = "rbxassetid://1839246711" -- Replace with valid ID
    sound.Volume = 1
    sound.Looped = true
    sound.Parent = workspace
    sound:Play()
end)

createButton("StopMusicButton", "Stop Music", function()
    local existing = workspace:FindFirstChild("c00lMusic")
    if existing then existing:Destroy() end
end)

createButton("SkyboxButton", "Set Skybox", function()
    local existingSky = Lighting:FindFirstChildOfClass("Sky")
    if existingSky then existingSky:Destroy() end
    local sky = Instance.new("Sky")
    sky.Parent = Lighting
    sky.SkyboxBk = "rbxassetid://600830446"
    sky.SkyboxDn = "rbxassetid://600831635"
    sky.SkyboxFt = "rbxassetid://600832720"
    sky.SkyboxLf = "rbxassetid://600833862"
    sky.SkyboxRt = "rbxassetid://600835007"
    sky.SkyboxUp = "rbxassetid://600836281"
end)

createButton("ResetSkyboxButton", "Reset Skybox", function()
    local existingSky = Lighting:FindFirstChildOfClass("Sky")
    if existingSky then existingSky:Destroy() end
end)

createButton("BillboardButton", "Add Billboard", function()
    if character and character:FindFirstChild("Head") then
        local existing = character.Head:FindFirstChild("c00lBillboard")
        if existing then existing:Destroy() end
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "c00lBillboard"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = character.Head
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "c00lgui V2 User!"
        text.TextColor3 = Color3.fromRGB(255, 0, 0)
        text.Font = Enum.Font.Arcade
        text.TextSize = 20
        text.Parent = billboard
    end
end)

createButton("RemoveBillboardButton", "Remove Billboard", function()
    if character and character.Head:FindFirstChild("c00lBillboard") then
        character.Head.c00lBillboard:Destroy()
    end
end)

createButton("SpeedButton", "Set Speed (50)", function()
    if humanoid then
        humanoid.WalkSpeed = 50
    end
end)

createButton("JumpButton", "Set Jump (100)", function()
    if humanoid then
        humanoid.JumpPower = 100
    end
end)

createButton("FlyButton", "Toggle Fly", function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart

        bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        bodyAngularVelocity.Parent = rootPart

        connection = RunService.Heartbeat:Connect(function()
            if flyEnabled and rootPart and rootPart.Parent then
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                bodyVelocity.Velocity = moveVector * 50
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
        if connection then connection:Disconnect() end
    end
end)

createButton("NoclipButton", "Toggle Noclip", function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

createButton("AmbientButton", "Set Dark Ambient", function()
    Lighting.Ambient = Color3.fromRGB(50, 50, 50)
end)

createButton("ResetAmbientButton", "Reset Ambient", function()
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
end)

createButton("FogOnButton", "Fog On", function()
    Lighting.FogEnd = 100
    Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(128, 128, 128)
end)

createButton("FogOffButton", "Fog Off", function()
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
end)

createButton("ParticleButton", "Spawn Particles on Player", function()
    if character and character:FindFirstChild("Head") then
        local attachment = Instance.new("Attachment")
        attachment.Parent = character.Head
        local particles = Instance.new("ParticleEmitter")
        particles.Parent = attachment
        particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        particles.Lifetime = NumberRange.new(1, 2)
        particles.Rate = 50
        particles.SpreadAngle = Vector2.new(45, 45)
        particles.Speed = NumberRange.new(5)
        particles.Enabled = true
    end
end)

createButton("SpawnPartButton", "Spawn Red Part", function()
    local part = Instance.new("Part")
    part.Name = "c00lPart"
    part.Size = Vector3.new(4, 4, 4)
    part.Position = rootPart.Position + Vector3.new(0, 5, 0)
    part.BrickColor = BrickColor.new("Bright red")
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.Parent = workspace
    local tween = TweenService:Create(part, TweenInfo.new(2, Enum.EasingStyle.Bounce), {Position = part.Position + Vector3.new(0, 10, 0)})
    tween:Play()
end)

createButton("RemovePartsButton", "Remove c00l Parts", function()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "c00lPart" then
            obj:Destroy()
        end
    end
    if character.Head:FindFirstChild("Attachment") then
        character.Head.Attachment:Destroy()
    end
end)

createButton("TeleportButton", "Random Teleport", function()
    if rootPart then
        rootPart.CFrame = CFrame.new(Vector3.new(math.random(-100, 100), 50, math.random(-100, 100)))
    end
end)

createButton("CloseButton", "Close GUI", function()
    gui:Destroy()
end)

-- Handle Character Respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if flyEnabled then
        flyEnabled = false
    end
    if noclipEnabled then
        noclipEnabled = false
    end
end)

-- Update player list on player join/leave
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
    if selectedPlayer == p then
        selectedPlayer = nil
        playerSelectLabel.Text = "Select Player: None"
    end
    updatePlayerList()
end)

print("c00lgui Inspired V2 with Fling loaded!")