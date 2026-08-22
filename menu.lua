--[[
	Expanded example menu built with NullUI (message.luau / v2.4.6)

	Demonstrates most of the widgets the library ships with:
	sections, labels, dividers, line-text, paragraphs, buttons, cards,
	gradient cards, toggles, sliders, dropdowns, textboxes, keybinds,
	color pickers, rating widgets, info grids, tables, a debug console,
	sub-tabs, and the built-in chat + credits panels.

	Every callback is a harmless placeholder -- replace with your own
	logic. Search for "REPLACE" to find the spots meant to be edited.
]]

local NullUI = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/dekyDied/c00lgui-test/refs/heads/main/message.luau"
))()

--------------------------------------------------------------------
-- Window
--------------------------------------------------------------------
local Window = NullUI:CreateWindow({
	Title         = "Example Hub",
	Subtitle      = "built with NullUI",
	Icon          = "Lucide:layout-grid",
	Size          = UDim2.fromOffset(680, 460),
	Draggable     = true,
	Resizable     = true,
	ToggleKeybind = Enum.KeyCode.RightShift, -- press RightShift to show/hide
})

--------------------------------------------------------------------
-- Home tab -- overview widgets
--------------------------------------------------------------------
local Home = Window:AddTab({ Name = "Home", Icon = "Lucide:house" })

Home:AddParagraph({
	Title = "Welcome",
	Icon  = "Lucide:sparkles",
	Text  = "This menu shows off most of NullUI's widgets in one place. "
		.. "Every callback below is a harmless placeholder -- REPLACE with your own logic.",
})

Home:AddGradientCard({
	Title       = "Getting started",
	Description = "Tap around the tabs on the left to see each widget type",
	ColorA      = Color3.fromRGB(88, 101, 242),
	ColorB      = Color3.fromRGB(52, 58, 138),
	Callback    = function()
		NullUI:Notify({ Title = "Nice", Text = "You tapped the gradient card.", Duration = 2 })
	end,
})

Home:AddDivider()
Home:AddSection("Quick actions")

Home:AddButton({
	Text        = "Send test notification",
	Description = "Fires NullUI:Notify()",
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

Home:AddButton({
	Text        = "Modal with fields",
	Description = "Shows NullUI:Modal() with an input field",
	Icon        = "Lucide:pencil-line",
	Callback    = function()
		NullUI:Modal({
			Title       = "Quick note",
			ConfirmText = "Save",
			Window      = Window,
			Fields      = {
				{ Key = "note", Label = "Note", Placeholder = "Type something...", Type = "textarea" },
			},
			Callback = function(confirmed, values)
				if confirmed then
					NullUI:Notify({ Title = "Saved", Text = values.note, Duration = 3 })
				end
			end,
		})
	end,
})

Home:AddDivider()
Home:AddLineText("stats")

Home:AddSystemInfoGrid({
	Title   = "System Info",
	Columns = 2,
})

--------------------------------------------------------------------
-- Player tab -- sliders, toggles, card
--------------------------------------------------------------------
local Player = Window:AddTab({ Name = "Player", Icon = "Lucide:user" })

Player:AddCard({
	Title          = "Local Player",
	Description    = "Card with an avatar thumbnail",
	UserId         = game.Players.LocalPlayer.UserId,
	ButtonText     = "Refresh",
	ButtonCallback = function()
		NullUI:Notify({ Title = "Refreshed", Duration = 1.5 })
	end,
})

Player:AddDivider()
Player:AddSection("Movement")

Player:AddSlider({
	Text      = "WalkSpeed",
	Flag      = "WalkSpeed",
	Min       = 16,
	Max       = 100,
	Default   = 16,
	Increment = 1,
	Callback  = function(value) -- REPLACE
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
	Callback  = function(value) -- REPLACE
		local char = game.Players.LocalPlayer.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = value end
	end,
})

Player:AddDivider()
Player:AddSection("Toggles")

Player:AddToggle({
	Text        = "Example toggle",
	Description = "Prints its state -- wire this to whatever you need",
	Icon        = "Lucide:toggle-left",
	Flag        = "ExampleToggle",
	Default     = false,
	Callback    = function(state) -- REPLACE
		print("ExampleToggle:", state)
	end,
})

Player:AddKeybind({
	Text     = "Sprint key",
	Icon     = "Lucide:keyboard",
	Default  = Enum.KeyCode.LeftShift,
	Flag     = "SprintKey",
	Callback = function(key) -- REPLACE
		NullUI:Notify({ Title = "Sprint key set to " .. key.Name, Duration = 2 })
	end,
})

--------------------------------------------------------------------
-- Visuals tab -- color picker, dropdown, gradient, rating
--------------------------------------------------------------------
local Visuals = Window:AddTab({ Name = "Visuals", Icon = "Lucide:palette" })

Visuals:AddSection("Appearance")

Visuals:AddColorPicker({
	Text     = "Accent color",
	Icon     = "Lucide:paintbrush",
	Flag     = "AccentColor",
	Default  = Color3.fromRGB(255, 255, 255),
	Callback = function(color) -- REPLACE
		print("Accent color changed to", color)
	end,
})

Visuals:AddDropdown({
	Text     = "Theme",
	Flag     = "Theme",
	Options  = { "Dark", "Light", "Auto" },
	Default  = "Dark",
	Callback = function(value)
		NullUI:Notify({ Title = "Theme set to " .. value, Duration = 2 })
	end,
})

Visuals:AddDropdown({
	Text        = "HUD elements",
	Description = "Multi-select example",
	MultiSelect = true,
	Options     = { "Health", "Minimap", "Chat", "FPS Counter" },
	Default     = { "Health", "Chat" },
	Callback    = function(values) -- REPLACE
		print("HUD elements enabled:", table.concat(values, ", "))
	end,
})

Visuals:AddDivider()
Visuals:AddSection("Feedback")

Visuals:AddRating({
	Title       = "Rate this menu",
	MaxStars    = 5,
	Placeholder = "Leave a comment (optional)",
})

--------------------------------------------------------------------
-- Data tab -- table, textbox, console
--------------------------------------------------------------------
local Data = Window:AddTab({ Name = "Data", Icon = "Lucide:database" })

Data:AddSection("Text input")

Data:AddTextbox({
	Text        = "Player search",
	Icon        = "Lucide:search",
	Placeholder = "Enter a username",
	Flag        = "PlayerSearch",
	Callback    = function(text) -- REPLACE
		print("Searching for:", text)
	end,
})

Data:AddDivider()
Data:AddSection("Table")

Data:AddTable({
	Title   = "Players in server",
	Columns = {
		{ Key = "Name", Label = "Name", Weight = 2 },
		{ Key = "Team", Label = "Team", Weight = 1 },
		{ Key = "Ping", Label = "Ping", Weight = 1, Align = "Right" },
	},
	Rows = (function()
		local rows = {}
		for _, plr in ipairs(game.Players:GetPlayers()) do
			table.insert(rows, {
				Name = plr.Name,
				Team = plr.Team and plr.Team.Name or "None",
				Ping = 0,
			})
		end
		return rows
	end)(),
	Height = 160,
})

Data:AddDivider()
Data:AddSection("Console")

local console = Data:AddConsole({
	Title       = "Debug Console",
	Height      = 160,
	AutoCapture = true, -- mirrors real print()/warn() output here too
})

Data:AddButton({
	Text     = "Log a test message",
	Icon     = "Lucide:terminal",
	Callback = function()
		console:Log("This is a test log line.", "info")
	end,
})

--------------------------------------------------------------------
-- Info tab -- sub-tabs + changelog
--------------------------------------------------------------------
local Info = Window:AddTab({ Name = "Info", Icon = "Lucide:info" })

local subOverview = Info:AddSubTab({ Name = "Overview", Icon = "Lucide:layout-list" })
subOverview:AddInfoGrid({
	Title   = "Session",
	Columns = 2,
	Items   = {
		{ Label = "Player",  Value = game.Players.LocalPlayer.Name },
		{ Label = "Game ID", Value = tostring(game.PlaceId) },
	},
})

local subChangelog = Info:AddSubTab({ Name = "Changelog", Icon = "Lucide:history" })
subChangelog:AddChangelogEntry({
	Version = "v1.1",
	Date    = "2026-08-22",
	Changes = {
		"Added Visuals and Data tabs",
		"Added debug console and player table",
	},
})
subChangelog:AddChangelogEntry({
	Version = "v1.0",
	Date    = "2026-08-15",
	Changes = {
		"Initial release",
	},
})

--------------------------------------------------------------------
-- Assistant panel (slide-out, opened from a dock button)
--------------------------------------------------------------------
Window:AddChatPanel({
	Name  = "Assistant",
	Icon  = "Lucide:bot",
	Title = "Assistant",
	-- Providing an OnRunCode lets the chat's code blocks get a Run button.
	-- OnRunCode = function(code, lang) loadstring(code)() end, -- REPLACE if you want this
})

--------------------------------------------------------------------
-- Credits (built-in panel + dock button)
--------------------------------------------------------------------
Window:AddDefaultCreditsPanel()
