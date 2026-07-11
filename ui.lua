--[[
	ui.lua — Window & Tabs Setup
	Called from hubinit.lua as: local tabs = setupUI(VoidLib)
	Returns a table with every tab object so hubinit and game scripts can populate them.

	Edit the window config, theme, and tab names here.
]]

return function(VoidLib)

	-- ── WINDOW ───────────────────────────────────────────────
	local window = VoidLib:win({
		Name = "My Hub",                         -- ← change this
		Icon = "layout-dashboard",
		LoadingTitle = "My Hub",
		LoadingSubtitle = "Loading...",
		ShowText = "layout-dashboard",
		ToggleUIKeybind = "K",
		TabsPosition = "Left",                   -- "Left" or "Top"
		Theme = "default",                       -- "default", "light", "glass", or any themes/*.lua name
		ConfigurationSaving = {
			Enable = true,
			FolderName = "MyHub",
			FileName = "Config",
			All = false,                         -- only elements with Save = true are persisted
		},
		Discord = {
			Enable = true,
			Invite = "AqZmmXQDm3",               -- ← your Discord invite code
			RememberJoins = true,
		},
	})

	-- ── TABS ─────────────────────────────────────────────────
	local Home     = window:tab("Home",      "house")
	local Game     = window:tab("Game",      "swords")
	local GameList = window:tab("Game List", "list")
	local Settings = window:tab("Settings",  "settings")
	local Credits  = window:tab("Credits",   "heart")

	-- ── SETTINGS TAB (built here since it's always the same) ─
	Settings:CreateParagraph({
		Title = "Interface",
		Content = "Customize the hub's appearance and behavior.",
	})
	Settings:CreateDivider()

	local themeDropdown = Settings:dropdown(
		"Theme",
		"settingsTheme",
		{"default", "light", "glass"},
		"default",
		function(selected)
			VoidLib:Notify({
				Title = "Theme Changed",
				Content = "Restart the hub to apply the '" .. selected .. "' theme.",
				Duration = 4,
				Image = "palette",
			})
		end,
		{ Save = true }
	)

	Settings:keybind("Toggle UI", "settingsToggleKey", Enum.KeyCode.K, function() end, { Save = true })

	-- ── CREDITS TAB (built here since it's always the same) ──
	Credits:CreateParagraph({
		Title = "My Hub",
		Content = "Version 1.0.0",
	})
	Credits:CreateDivider()

	Credits:CreateParagraph({
		Title = "Developer",
		Content = "YourName",               -- ← change this
	})

	Credits:CreateParagraph({
		Title = "Special Thanks",
		Content = "VoidLib / VantexUI",
	})

	Credits:CreateDivider()

	Credits:label("Join the Discord for updates and support.", "discord")

	Credits:button("Copy Discord Link", function()
		local clip = setclipboard or toclipboard
		if clip then pcall(clip, "https://discord.gg/AqZmmXQDm3") end
		VoidLib:Notify({ Title = "Copied", Content = "Discord link copied to clipboard.", Duration = 3, Image = "check" })
	end)

	-- ── RETURN TAB REFERENCES ─────────────────────────────────
	return {
		Home     = Home,
		Game     = Game,
		GameList = GameList,
		Settings = Settings,
		Credits  = Credits,
	}
end
