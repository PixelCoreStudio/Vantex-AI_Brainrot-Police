return function(Vantex)

	-- ── WINDOW ───────────────────────────────────────────────
	local window = Vantex:win({
		Name = "Vantex AI/Brainrot Police",
		Icon = "siren",
		LoadingTitle = "Vantex AI/Brainrot Police",
		LoadingSubtitle = "by Pixel Core",
		ShowText = "Vantex AI/Brainrot Police",
		ToggleUIKeybind = "K",
		TabsPosition = "Left",
		Theme = "default",
		ConfigurationSaving = {
			Enable = true,
			FolderName = "VantexAiBrainrotPolice",
			FileName = "Config",
			All = false,
		},
		Discord = {
			Enable = true,
			Invite = "AqZmmXQDm3",
			RememberJoins = true,
		},
	})

	-- ── TABS ─────────────────────────────────────────────────
	local Home     = window:tab("Home",      "mail")
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
			Vantex:Notify({
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
		Title = "Vantex AI/Brainrot Police",
		Content = "Version 1.0.0",
	})
	Credits:CreateDivider()

	Credits:CreateParagraph({
		Title = "Developer",
		Content = "Pixel Core",
	})

	Credits:CreateParagraph({
		Title = "Designer",
		Content = "Pixel Core",
	})

	Credits:CreateParagraph({
		Title = "Contributors",
		Content = "none",
	})

	Credits:CreateDivider()

	Credits:label("Join the Discord for updates and support.", "discord")

	Credits:button("Copy Discord Link", function()
		local clip = setclipboard or toclipboard
		if clip then pcall(clip, "https://discord.gg/AqZmmXQDm3") end
		Vantex:Notify({ Title = "Copied", Content = "Discord link copied to clipboard.", Duration = 3, Image = "check" })
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
