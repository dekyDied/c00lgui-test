--!strict
--[[
    Generated with Roblox UI Designer Mobile (Standard)
    ----------------------------------------
    - Strict Luau, StyLua-friendly formatting, and Darklua-ready output.
    - GUI coordinates keep their scale and offset so exports stay DPI-safe.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer :: Player
local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local GUI: {[string]: any} = {}

-- ScreenGui: MainGui
GUI["GUI_MainGui"] = Instance.new("ScreenGui")
GUI["GUI_MainGui"]["Name"] = "MainGui"
GUI["GUI_MainGui"]["ResetOnSpawn"] = true
GUI["GUI_MainGui"]["Enabled"] = true
GUI["GUI_MainGui"]["IgnoreGuiInset"] = true
GUI["GUI_MainGui"]["DisplayOrder"] = 999
GUI["GUI_MainGui"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
GUI["GUI_MainGui"]["Parent"] = playerGui

-- Frame: MainFrame
GUI["GUI_MainFrame"] = Instance.new("Frame")
GUI["GUI_MainFrame"]["Name"] = "MainFrame"
GUI["GUI_MainFrame"]["Visible"] = true
GUI["GUI_MainFrame"]["Active"] = true
GUI["GUI_MainFrame"]["ZIndex"] = 1
GUI["GUI_MainFrame"]["LayoutOrder"] = 0
GUI["GUI_MainFrame"]["Size"] = UDim2.new(0.4, 190, 0.4, 160)
GUI["GUI_MainFrame"]["Position"] = UDim2.new(0.3, -280, 0.3, -60)
GUI["GUI_MainFrame"]["AnchorPoint"] = Vector2.new(0.0, 0.0)
GUI["GUI_MainFrame"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30)
GUI["GUI_MainFrame"]["BackgroundTransparency"] = 0
GUI["GUI_MainFrame"]["BorderSizePixel"] = 0
GUI["GUI_MainFrame"]["ClipsDescendants"] = false
GUI["GUI_MainFrame"]["Parent"] = GUI["GUI_MainGui"]

-- UICorner: FrameCorner
GUI["GUI_FrameCorner"] = Instance.new("UICorner")
GUI["GUI_FrameCorner"]["Name"] = "FrameCorner"
GUI["GUI_FrameCorner"]["CornerRadius"] = UDim.new(0.0, 12)
GUI["GUI_FrameCorner"]["TopLeftRadius"] = UDim.new(0.0, 8)
GUI["GUI_FrameCorner"]["TopRightRadius"] = UDim.new(0.0, 8)
GUI["GUI_FrameCorner"]["BottomLeftRadius"] = UDim.new(0.0, 8)
GUI["GUI_FrameCorner"]["BottomRightRadius"] = UDim.new(0.0, 8)
GUI["GUI_FrameCorner"]["Parent"] = GUI["GUI_MainFrame"]

-- TextLabel: TitleText
GUI["GUI_TitleText"] = Instance.new("TextLabel")
GUI["GUI_TitleText"]["Name"] = "TitleText"
GUI["GUI_TitleText"]["Visible"] = true
GUI["GUI_TitleText"]["Active"] = true
GUI["GUI_TitleText"]["ZIndex"] = 1
GUI["GUI_TitleText"]["LayoutOrder"] = 0
GUI["GUI_TitleText"]["Size"] = UDim2.new(1, -440, 0.25, -70)
GUI["GUI_TitleText"]["Position"] = UDim2.fromOffset(70, 10)
GUI["GUI_TitleText"]["AnchorPoint"] = Vector2.new(0.0, 0.0)
GUI["GUI_TitleText"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
GUI["GUI_TitleText"]["BackgroundTransparency"] = 1
GUI["GUI_TitleText"]["BorderSizePixel"] = 0
GUI["GUI_TitleText"]["Text"] = "Window Text"
GUI["GUI_TitleText"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
GUI["GUI_TitleText"]["TextSize"] = 18
GUI["GUI_TitleText"]["TextTransparency"] = 0
GUI["GUI_TitleText"]["TextWrapped"] = true
GUI["GUI_TitleText"]["TextScaled"] = false
GUI["GUI_TitleText"]["Font"] = Enum.Font.SourceSansBold
GUI["GUI_TitleText"]["TextXAlignment"] = Enum.TextXAlignment.Left
GUI["GUI_TitleText"]["TextYAlignment"] = Enum.TextYAlignment.Center
GUI["GUI_TitleText"]["RichText"] = false
GUI["GUI_TitleText"]["Parent"] = GUI["GUI_MainFrame"]

-- TextLabel: TitleText_Copy
GUI["GUI_TitleText_Copy"] = Instance.new("TextLabel")
GUI["GUI_TitleText_Copy"]["Name"] = "TitleText_Copy"
GUI["GUI_TitleText_Copy"]["Visible"] = true
GUI["GUI_TitleText_Copy"]["Active"] = true
GUI["GUI_TitleText_Copy"]["ZIndex"] = 1
GUI["GUI_TitleText_Copy"]["LayoutOrder"] = 0
GUI["GUI_TitleText_Copy"]["Size"] = UDim2.new(1, -460, 0.25, -70)
GUI["GUI_TitleText_Copy"]["Position"] = UDim2.fromOffset(70, 30)
GUI["GUI_TitleText_Copy"]["AnchorPoint"] = Vector2.new(0.0, 0.0)
GUI["GUI_TitleText_Copy"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
GUI["GUI_TitleText_Copy"]["BackgroundTransparency"] = 1
GUI["GUI_TitleText_Copy"]["BorderSizePixel"] = 0
GUI["GUI_TitleText_Copy"]["Text"] = "Window Desc"
GUI["GUI_TitleText_Copy"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
GUI["GUI_TitleText_Copy"]["TextSize"] = 13
GUI["GUI_TitleText_Copy"]["TextTransparency"] = 0.5
GUI["GUI_TitleText_Copy"]["TextWrapped"] = true
GUI["GUI_TitleText_Copy"]["TextScaled"] = false
GUI["GUI_TitleText_Copy"]["Font"] = Enum.Font.SourceSansBold
GUI["GUI_TitleText_Copy"]["TextXAlignment"] = Enum.TextXAlignment.Left
GUI["GUI_TitleText_Copy"]["TextYAlignment"] = Enum.TextYAlignment.Center
GUI["GUI_TitleText_Copy"]["RichText"] = false
GUI["GUI_TitleText_Copy"]["Parent"] = GUI["GUI_MainFrame"]

-- ImageLabel: Icon
GUI["GUI_Icon"] = Instance.new("ImageLabel")
GUI["GUI_Icon"]["Name"] = "Icon"
GUI["GUI_Icon"]["Visible"] = true
GUI["GUI_Icon"]["Active"] = true
GUI["GUI_Icon"]["ZIndex"] = 1
GUI["GUI_Icon"]["LayoutOrder"] = 0
GUI["GUI_Icon"]["Size"] = UDim2.new(0.15, -60, 0.15, -20)
GUI["GUI_Icon"]["Position"] = UDim2.new(0.1, -50, 0.1, -30)
GUI["GUI_Icon"]["AnchorPoint"] = Vector2.new(0.0, 0.0)
GUI["GUI_Icon"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
GUI["GUI_Icon"]["BackgroundTransparency"] = 1
GUI["GUI_Icon"]["BorderSizePixel"] = 0
GUI["GUI_Icon"]["Image"] = "rbxassetid://93142176757189"
GUI["GUI_Icon"]["ImageTransparency"] = 0
GUI["GUI_Icon"]["ScaleType"] = Enum.ScaleType.Stretch
GUI["GUI_Icon"]["Parent"] = GUI["GUI_MainFrame"]

return GUI
