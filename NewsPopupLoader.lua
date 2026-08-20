--[[
	NewsPopupLoader.lua

	Drop this ONE LINE (see bottom) into the middle of your main script
	instead of pasting the whole NewsPopupUI library every time.

	It fetches NewsPopupUI.lua from a raw GitHub URL, runs it, and
	returns the module table -- exactly as if you had `require`d it
	locally.

	SETUP:
		1. Push NewsPopupUI.lua to a GitHub repo.
		2. Get its "raw" URL, e.g.:
			 https://raw.githubusercontent.com/<user>/<repo>/main/NewsPopupUI.lua
		3. Put that URL in RAW_URL below (or pass it as an argument, see usage).
		4. In Game Settings -> Security, enable "Allow HTTP Requests".
		   (loadstring is enabled by default for the server; for
		   LocalScripts, loadstring is only available in Studio/beta
		   unless the experience has it enabled -- see note below.)

	USAGE (from anywhere in your main script):

		local NewsPopupUI = loadstring(game:HttpGet(
			"https://raw.githubusercontent.com/<user>/<repo>/main/NewsPopupLoader.lua"
		))("https://raw.githubusercontent.com/<user>/<repo>/main/NewsPopupUI.lua")

		local E = NewsPopupUI.Elements
		NewsPopupUI.Show({ ... })

	Or, simpler: just hardcode RAW_URL below and only pass the loader:

		local NewsPopupUI = loadstring(game:HttpGet(LOADER_URL))()

	SECURITY NOTE:
	loadstring() executes arbitrary remote code. Only ever point this at
	a URL you control (your own repo). Never load a third party's raw
	URL blindly -- if their file changes, you're running whatever they
	push, with full script access. Consider pinning to a commit hash
	instead of a branch (e.g. ".../<commit-sha>/NewsPopupUI.lua") so an
	upstream change can't silently alter your game.
--]]

local DEFAULT_RAW_URL = "https://raw.githubusercontent.com/<user>/<repo>/main/NewsPopupUI.lua"

return function(rawUrl)
	rawUrl = rawUrl or DEFAULT_RAW_URL

	local HttpService = game:GetService("HttpService")

	local ok, source = pcall(function()
		return HttpService:GetAsync(rawUrl)
	end)

	if not ok then
		error(("NewsPopupLoader: failed to fetch %s -- %s"):format(rawUrl, tostring(source)))
	end

	local chunk, compileErr = loadstring(source)
	if not chunk then
		error(("NewsPopupLoader: failed to compile fetched source -- %s"):format(tostring(compileErr)))
	end

	local success, moduleOrErr = pcall(chunk)
	if not success then
		error(("NewsPopupLoader: error while running NewsPopupUI.lua -- %s"):format(tostring(moduleOrErr)))
	end

	return moduleOrErr
end
