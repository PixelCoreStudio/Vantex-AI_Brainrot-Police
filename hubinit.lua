local GIT_BASE = "https://raw.githubusercontent.com/PixelCoreStudio/Vantex-AI_Brainrot-Police/refs/heads/main/"

local function getgitpath(folder)
	local base = GIT_BASE:match("/$") and GIT_BASE or (GIT_BASE .. "/")
	return base .. (folder and folder .. "/" or "")
end
getgenv().getgitpath = getgitpath

local Vantex = loadstring(game:HttpGet(getgitpath() .. "libary.lua"))()

local function safeLoad(url, label)
	local ok, src = pcall(game.HttpGet, game, url)
	if not ok or not src or src:match("^404") or src:match("Not Found") then
		error("[Vantex] Failed to fetch " .. label .. " from: " .. url, 2)
	end
	local fn, err = loadstring(src)
	if not fn then
		error("[Vantex] Failed to parse " .. label .. ": " .. tostring(err), 2)
	end
	return fn()
end

local setupUI      = safeLoad(getgitpath() .. "ui.lua",       "ui.lua")
local tabs         = setupUI(Vantex)

local setupHome    = safeLoad(getgitpath() .. "home.lua",     "home.lua")
setupHome(tabs.Home)

local gamelistData = safeLoad(getgitpath() .. "gamelist.lua", "gamelist.lua")

local ExperienceService = game:GetService("ExperienceService")

local function teleportTo(entry)
    local ok, err = pcall(function()
        ExperienceService:LaunchExperience({ placeId = entry.GameId })
    end)
    if not ok then
        Vantex:Notify({ Title = "Teleport Failed", Content = tostring(err), Duration = 4, Image = "alert-triangle" })
    end
end

local searchBox = tabs.GameList:textbox("Search", "gameListSearch", "", function() end, {
	PlaceholderText = "Search games..."
})
tabs.GameList:CreateDivider()

local gameEntries = {}

for i, entry in ipairs(gamelistData) do
	local btn = tabs.GameList:button(entry.Name .. "  ·  " .. (entry.Status or "Unknown"), function()
		teleportTo(entry)
	end)

	local div = (i < #gamelistData) and tabs.GameList:CreateDivider() or nil

	table.insert(gameEntries, { name = entry.Name, btn = btn, div = div })
end

task.defer(function()
	local textBoxInst
	for _, desc in ipairs(searchBox.Instance:GetDescendants()) do
		if desc:IsA("TextBox") then textBoxInst = desc break end
	end
	if not textBoxInst then return end

	textBoxInst:GetPropertyChangedSignal("Text"):Connect(function()
		local query = textBoxInst.Text:lower()
		for _, entry in ipairs(gameEntries) do
			local visible = query == "" or entry.name:lower():find(query, 1, true) ~= nil
			entry.btn.Instance.Visible = visible
			if entry.div then entry.div.Instance.Visible = visible end
		end
	end)
end)

local placeId = tostring(game.PlaceId)

local ok, gamePath = pcall(function()
	return game:HttpGet(getgitpath("games") .. placeId .. ".lua")
end)

if not ok or #gamePath == 0 or gamePath == "404: Not Found" then
	local handledLocally = false

	if getgenv().FileScripts then
		if isfile("games/" .. placeId .. ".lua") then
		print("[Vantex] Loading local script for PlaceId: " .. placeId)
		local gameModule = loadstring(readfile("games/" .. placeId .. ".lua"))()
			if type(gameModule) == "function" then
				local ok2, runErr = pcall(gameModule, tabs.Game)
				if not ok2 then
					tabs.Game:CreateParagraph({ Title = "Runtime Error", Content = tostring(runErr) })
				end
			end
			handledLocally = true
		end
	end

	if not handledLocally then
		tabs.Game:CreateParagraph({
			Title = "No script Available",
			Content = "There is no script for this game yet. (PlaceId: " .. placeId .. ")",
		})
		tabs.Game:CreateParagraph({
			Title = "You have a script or want one for this game?",
			Content = "Come to the discord and request the game. If you have a script for it and want to share feel free to put it in the request."
		})
		tabs.Game:button("Copy Discord Link", function()
			local clip = setclipboard or toclipboard
			if clip then
				pcall(clip, "https://discord.gg/AqZmmXQDm3")
				Vantex:Notify({ Title = "Copied", Content = "Discord link copied", Duration = 3, Image = "check" })
			else
				Vantex:Notify({ Title = "Copie Failed", Content = "There was an error while the copying process.", Duration = 3, Image = "check" })
			end
		end)
	end
else
	local gameModule = loadstring(gamePath)()
	if type(gameModule) == "function" then
		local ok2, runErr = pcall(gameModule, tabs.Game)
		if not ok2 then
			tabs.Game:CreateParagraph({ Title = "Runtime Error", Content = tostring(runErr) })
		end
	end
end
