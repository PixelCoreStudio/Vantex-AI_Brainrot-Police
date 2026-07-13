return function(Vantex)
	local HttpService = game:GetService("HttpService")
	local RunService  = game:GetService("RunService")
	local VirtualUser = game:GetService("VirtualUser")

	local configPath = "VantexAiBrainrotPolice/Config.json"
	local savedTheme  = "default"
	local savedToggle = "K"
	if isfile and isfile(configPath) then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(configPath))
		end)
		if ok and data then
			if data.settingsTheme     then savedTheme  = tostring(data.settingsTheme)  end
			if data.settingsToggleKey then savedToggle = tostring(data.settingsToggleKey) end
		end
	end

	local window = Vantex:win({
		Name            = "Vantex AI/Brainrot Police",
		Icon            = "siren",
		LoadingTitle    = "Vantex AI/Brainrot Police",
		LoadingSubtitle = "by Pixel Core",
		ShowText        = "Vantex AI/Brainrot Police",
		TabsPosition    = "Left",
		Theme           = savedTheme,
		
		ToggleUIKeybind = Enum.KeyCode.F15,
		
		ConfigurationSaving = {
			Enable     = true,
			FolderName = "VantexAiBrainrotPolice",
			FileName   = "Config",
			All        = false,
		},
		Discord = {
			Enable       = true,
			Invite       = "AqZmmXQDm3",
			RememberJoins = true,
		},
	})

	local Home     = window:tab("Home",      "mail")
	local Game     = window:tab("Game",      "swords")
	local GameList = window:tab("Game List", "list")
	local Settings = window:tab("Settings",  "settings")
	local Credits  = window:tab("Credits",   "heart")

	Settings:CreateParagraph({ Title = "Interface", Content = "Customize the hub." })
	Settings:CreateDivider()

	Settings:dropdown(
		"Theme",
		"settingsTheme",
		{"default", "light"},
		savedTheme,
		function(selected)
			Vantex:Notify({
				Title   = "Theme gespeichert",
				Content = "'" .. selected .. "' wird beim nächsten Start angewendet.",
				Duration = 4,
				Image   = "palette",
			})
		end,
		{ Save = true }
	)

	local toggleuikey = Settings:keybind(
		"Toggle UI",
		"settingsToggleKey",
		savedToggle,
		function(key)
			savedToggle = tostring(key)
			return savedToggle
		end,
		{ Save = true }
	)

	Settings:CreateDivider()

	local afkConn
	Settings:toggle("Anti-AFK", "antiAfk", false, function(state)
		if state then
			afkConn = game:GetService("Players").LocalPlayer.Idled:Connect(function()
				VirtualUser:Button2Down(Vector2.new(0, 0), CFrame.new())
				task.wait(1)
				VirtualUser:Button2Up(Vector2.new(0, 0), CFrame.new())
			end)
		else
			if afkConn then afkConn:Disconnect(); afkConn = nil end
		end
	end, { Save = true })

	local autoRejoin = false
	Settings:toggle("Auto Rejoin on Kick", "autoRejoin", false, function(state)
		autoRejoin = state
	end, { Save = true })
 
	Settings:toggle("Auto-Load on Join (this session)", "sessionAutoLoad", getgenv().VantexAutoLoad or false, function(state)
		getgenv().VantexAutoLoad = state
	end)
 
	game:BindToClose(function()
		if not autoRejoin then return end
 
		local TeleportService = game:GetService("TeleportService")
		local player = game:GetService("Players").LocalPlayer
 
		pcall(function()
			if queue_on_teleport then
				queue_on_teleport('loadstring(game:HttpGet("' .. getgitpath() .. 'hubinit.lua"))()')
			end
		end)
 
		pcall(function()
			TeleportService:Teleport(game.PlaceId, player)
		end)
	end)

	Settings:toggle("Disable 3D Rendering", "disable3d", false, function(state)
		RunService:Set3dRenderingEnabled(not state)
	end, { Save = true })

	Credits:CreateParagraph({ Title = "Vantex AI/Brainrot Police", Content = "Version 1.0.0" })
	Credits:CreateDivider()
	Credits:CreateParagraph({ Title = "Developer", Content = "Pixel Core" })
	Credits:CreateParagraph({ Title = "Contributors", Content = "none" })
	Credits:CreateDivider()
	Credits:label("Join the Discord for updates and support.", "discord")
	Credits:button("Copy Discord Link", function()
		local clip = setclipboard or toclipboard
		if clip then pcall(clip, "https://discord.gg/AqZmmXQDm3") end
		Vantex:Notify({ Title = "Copied", Content = "Discord link copied.", Duration = 3, Image = "check" })
	end)

	local UserInputService = game:GetService("UserInputService")
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end 
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local currentKeyStr = tostring(savedToggle)
		if currentKeyStr:sub(1, 13) == "Enum.KeyCode." then
			currentKeyStr = currentKeyStr:sub(14)
		end
		local success, targetKeyCode = pcall(function()
			return Enum.KeyCode[currentKeyStr]
		end)
		if success and targetKeyCode and targetKeyCode ~= Enum.KeyCode.Unknown then
			if input.KeyCode == targetKeyCode then
				local currentVisibility = window:IsVisible()
				Vantex:SetVisible(not currentVisibility)
			end
		end
	end)
	
	return {
		Home     = Home,
		Game     = Game,
		GameList = GameList,
		Settings = Settings,
		Credits  = Credits,
	}
end
