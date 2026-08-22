--[[
	Example script menu built with NullUI (message.luau / v2.4.6)

	Loads the library, then creates a window with a few tabs that
	each demonstrate one of the widgets NullUI ships with. Replace
	the callback bodies with your own logic.
]]

local NullUI = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/message.luau"
))()

--------------------------------------------------------------------
-- Window
--------------------------------------------------------------------
local Window = NullUI:CreateWindow({
	Title      = "Example Hub",
	Subtitle   = "built with NullUI",
	Icon       = "Lucide:layout-grid",
	Size       = UDim2.fromOffset(605, 405),
	Draggable  = true,
	Resizable  = true,
	ToggleKeybind = Enum.KeyCode.RightShift, -- press RightShift to show/hide
})

--------------------------------------------------------------------
-- Home tab
--------------------------------------------------------------------
local Home = Window:AddTab({ Name = "Home", Icon = "Lucide:house" })

Home:AddSection("Welcome")

Home:AddLabel("This is a starter menu. Every widget below is wired to a "
	.. "harmless example callback -- swap those out for your own code.")

Home:AddButton({
	Text        = "Send test notification",
	Description = "Fires NullUI:Notify() so you can see the toast style",
	Icon        = "Lucide:bell",
	Callback    = function()
		NullUI:Notify({
			Title    = "Hello!",
			Text     = "This came from the Home tab button.",
			Type     = "success",
			Duration = 3,
		})
	end,
})

Home:AddDivider()

Home:AddButton({
	Text        = "Confirm dialog example",
	Description = "Shows NullUI:Confirm() with a callback",
	Icon        = "Lucide:circle-help",
	Callback    = function()
		NullUI:Confirm({
			Title       = "Are you sure?",
			Text        = "This is just a demo confirmation dialog.",
			ConfirmText = "Yes",
			CancelText  = "Cancel",
			Window      = Window,
			Callback    = function(confirmed)
				if confirmed then
					NullUI:Notify({ Title = "Confirmed", Type = "info", Duration = 2 })
				end
			end,
		})
	end,
})

--------------------------------------------------------------------
-- Player tab
--------------------------------------------------------------------
local Player = Window:AddTab({ Name = "Player", Icon = "Lucide:user" })

Player:AddSection("Movement")

Player:AddSlider({
	Text      = "WalkSpeed",
	Flag      = "WalkSpeed", -- registers under NullUI.Flags.WalkSpeed
	Min       = 16,
	Max       = 100,
	Default   = 16,
	Increment = 1,
	Callback  = function(value)
		local char = game.Players.LocalPlayer.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = value end
	end,
})

Player:AddSlider({
	Text      = "JumpPower",
	Flag      = "JumpPower",
	Min       = 50,
	Max       = 200,
	Default   = 50,
	Increment = 5,
	Callback  = function(value)
		local char = game.Players.LocalPlayer.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = value end
	end,
})

Player:AddDivider()
Player:AddSection("Toggles")

Player:AddToggle({
	Text        = "Example toggle",
	Description = "Just prints its state -- wire this to whatever you need",
	Icon        = "Lucide:toggle-left",
	Flag        = "ExampleToggle",
	Default     = false,
	Callback    = function(state)
		print("ExampleToggle:", state)
	end,
})

--------------------------------------------------------------------
-- Settings tab
--------------------------------------------------------------------
local Settings = Window:AddTab({ Name = "Settings", Icon = "Lucide:settings" })

Settings:AddSection("Preferences")

Settings:AddDropdown({
	Text     = "Theme",
	Flag     = "Theme",
	Options  = { "Dark", "Light", "Auto" },
	Default  = "Dark",
	Callback = function(value)
		NullUI:Notify({ Title = "Theme set to " .. value, Duration = 2 })
	end,
})

Settings:AddToggle({
	Text     = "Enable blur",
	Icon     = "Lucide:droplet",
	Default  = true,
	Callback = function(state)
		NullUI:SetBlurEnabled(state)
	end,
})

Settings:AddKeybind({
	Text     = "Toggle menu keybind",
	Default  = Enum.KeyCode.RightShift,
	Flag     = "ToggleKeybind",
	Callback = function(key)
		NullUI:Notify({ Title = "Keybind set to " .. key.Name, Duration = 2 })
	end,
})

--------------------------------------------------------------------
-- Credits (built-in panel + dock button)
--------------------------------------------------------------------
Window:AddDefaultCreditsPanel()
