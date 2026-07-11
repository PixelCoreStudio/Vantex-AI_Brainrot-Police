--[[
	HubInit — Main Entry Point
	Load this file from your executor script.

	Repo structure expected on GitHub:
	  /hubinit.lua         <- this file
	  /testlib.lua         <- VoidLib
	  /ui.lua              <- window + tabs config
	  /home.lua            <- home tab content
	  /gamelist.lua        <- game list data
	  /games/{placeId}.lua <- per-game scripts
	  /src/elements.lua    <- shared element helpers for game scripts

	Dev mode (faster iteration, no GitHub push needed):
	  getgenv().FileScripts = true
	  Put game scripts in executor workspace: games/{placeId}.lua
]]

-- ── CONFIG ────────────────────────────────────────────────
local GIT_BASE = "https://raw.githubusercontent.com/PixelCoreStudio/Vantex-AI_Brainrot-Police/refs/heads/main"

local function getgitpath(folder)
	return GIT_BASE .. (folder and folder .. "/" or "")
end
getgenv().getgitpath = getgitpath  -- globally accessible from game scripts too

-- ── LOAD VOIDLIB ─────────────────────────────────────────
local VoidLib = loadstring(game:HttpGet(getgitpath() .. "libary.lua"))()

-- ── BUILD WINDOW + TABS (ui.lua) ─────────────────────────
local setupUI = loadstring(game:HttpGet(getgitpath() .. "ui.lua"))()
local tabs = setupUI(VoidLib)
-- tabs = { Home, Game, GameList, Settings, Credits }

-- ── HOME TAB (home.lua) ───────────────────────────────────
local setupHome = loadstring(game:HttpGet(getgitpath() .. "home.lua"))()
setupHome(tabs.Home)

-- ── GAME LIST TAB (gamelist.lua) ─────────────────────────
local gamelistData = loadstring(game:HttpGet(getgitpath() .. "gamelist.lua"))()

local statusColors = {
	Working    = Color3.fromRGB(60,  210, 110),
	Partial    = Color3.fromRGB(255, 180,  40),
	Broken     = Color3.fromRGB(220,  55,  55),
	Testing    = Color3.fromRGB( 90, 160, 255),
	Undetected = Color3.fromRGB(160, 160, 160),
}

local TeleportService = game:GetService("TeleportService")

for i, entry in ipairs(gamelistData) do
	local color = statusColors[entry.Status] or statusColors.Undetected
	local infoLabel = tabs.GameList:label(entry.Name .. "   |   " .. (entry.Status or "Unknown"))
	infoLabel:Set(entry.Name .. "   |   " .. (entry.Status or "Unknown"), nil, color)

	tabs.GameList:button("Join: " .. entry.Name, function()
		local ok, err = pcall(function() TeleportService:Teleport(entry.GameId) end)
		if not ok then
			VoidLib:Notify({ Title = "Teleport Failed", Content = tostring(err), Duration = 4, Image = "alert-triangle" })
		end
	end)

	if i < #gamelistData then tabs.GameList:CreateDivider() end
end

-- ── GAME TAB: load {placeId}.lua for the current game ────
local placeId = tostring(game.PlaceId)

local function loadGameScript()
	local src

	-- Dev mode: load from executor's local workspace folder
	if getgenv().FileScripts then
		local path = "games/" .. placeId .. ".lua"
		if isfile and isfile(path) then
			src = readfile(path)
		end
	end

	-- Production: fetch from GitHub
	if not src then
		local ok, res = pcall(game.HttpGet, game, getgitpath("games") .. placeId .. ".lua")
		if ok and type(res) == "string" and not res:match("^404") and not res:match("Not Found") then
			src = res
		end
	end

	if src then
		local fn, loadErr = loadstring(src)
		if fn then
			local gameModule = fn()
			if type(gameModule) == "function" then
				local ok2, runErr = pcall(gameModule, tabs.Game)
				if not ok2 then
					tabs.Game:CreateParagraph({ Title = "Runtime Error", Content = tostring(runErr) })
				end
			end
		else
			tabs.Game:CreateParagraph({ Title = "Parse Error", Content = tostring(loadErr) })
		end
	else
		tabs.Game:CreateParagraph({
			Title = "No Script Available",
			Content = "There is no script for this game yet. (PlaceId: " .. placeId .. ")",
		})
		tabs.Game:label("Join the Discord to request support for this game.")
	end
end

loadGameScript()
