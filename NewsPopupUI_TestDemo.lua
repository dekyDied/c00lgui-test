--[[
	NewsPopupUI_TestDemo.lua

	A LocalScript that shows a single popup using every element type
	NewsPopupUI supports, so you can see how they stack and eyeball
	spacing/sizing before wiring up your own content.

	Place this in StarterPlayerScripts (or run it from the command bar
	in Studio while playtesting).
--]]

local NewsPopupUI = require(game:GetService("ReplicatedStorage"):WaitForChild("NewsPopupUI"))
-- If you're using the GitHub loader instead, swap the line above for:
-- local NewsPopupUI = loadstring(game:HttpGet(LOADER_URL))(LIBRARY_RAW_URL)

local E = NewsPopupUI.Elements

-- A custom element example: a little colored tag/badge row built by hand
-- and slotted in with E.Custom(). Anything that's a GuiObject works here.
local function buildBadgeRow()
	local row = Instance.new("Frame")
	row.Name = "BadgeRow"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, 0, 0, 26)

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 8)
	layout.Parent = row

	local labels = { "NEW", "PERFORMANCE", "BUGFIX" }
	local colors = {
		Color3.fromRGB(80, 170, 90),
		Color3.fromRGB(80, 130, 220),
		Color3.fromRGB(210, 150, 60),
	}

	for i, text in ipairs(labels) do
		local badge = Instance.new("TextLabel")
		badge.AutomaticSize = Enum.AutomaticSize.X
		badge.Size = UDim2.new(0, 0, 1, 0)
		badge.BackgroundColor3 = colors[i]
		badge.Text = "  " .. text .. "  "
		badge.Font = Enum.Font.GothamBold
		badge.TextSize = 12
		badge.TextColor3 = Color3.fromRGB(255, 255, 255)

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = badge

		badge.Parent = row
	end

	return row
end

NewsPopupUI.Show({
	Title = "News!",
	ButtonText = "Proceed",
	ButtonColor = Color3.fromRGB(255, 255, 255),
	ButtonTextColor = Color3.fromRGB(20, 20, 20),
	Width = 520,
	ContentPadding = 20,
	ElementSpacing = 12,

	Elements = {
		-- 1. Icon element (default drawn eye graphic)
		E.Icon({ Height = 200 }),

		-- 2. Headline text, larger + bold
		E.Text("Update 1.4 is here!", {
			Size = 20,
			Font = Enum.Font.GothamBold,
			Color = Color3.fromRGB(255, 255, 255),
		}),

		-- 3. Divider under the headline
		E.Divider(),

		-- 4. Body text, default style (matches the "Yoooo..." screenshot look)
		E.Text("Yoooo, a new update just dropped.", {
			Size = 16,
		}),

		-- 5. Secondary/dimmer body text, wrapped since it's longer
		E.Text(
			"This patch focuses on stability: we fixed several crash reports, "
				.. "improved mobile performance, and reworked the trading UI "
				.. "based on your feedback.",
			{
				Size = 14,
				Color = Color3.fromRGB(170, 170, 170),
				Wrapped = true,
				Height = 54, -- taller box since this text wraps to ~3 lines
			}
		),

		-- 6. Spacer for breathing room before the badge row
		E.Spacer(4),

		-- 7. Custom element: hand-built badge row dropped straight in
		E.Custom(buildBadgeRow()),

		-- 8. Another divider before the closing line
		E.Divider(),

		-- 9. Small footnote-style text at the bottom
		E.Text("Thanks for playing -- see you in the next update.", {
			Size = 13,
			Color = Color3.fromRGB(130, 130, 130),
		}),
	},

	OnProceed = function()
		print("[NewsPopupUI Demo] Player clicked Proceed")
	end,
})
