--[[
	home.lua — Home Tab Content
	Edit everything in the CONFIG section below.
	Called from hubinit.lua as: setupHome(tabs.Home)
]]

return function(tab)

	-- ── CONFIG ────────────────────────────────────────────────
	-- Edit these values to customize the Home tab.

	local HUB_NAME    = "Vantex AI/Brainrot Police"
	local HUB_VERSION = "v1.0.0"
	local HUB_STATUS  = "Working"   -- "Undetected" | "Detected" | "Updating"
	local DISCORD     = "discord.gg/AqZmmXQDm3"
	local AUTHOR      = "Pixel Core"

	local ANNOUNCEMENTS = {
		"Added Lick a Brainrot.",
		"Updated Beach Escape win.",
	}

	local STATUS_COLORS = {
		Working = Color3.fromRGB(60,  210, 110),
		Detected   = Color3.fromRGB(220,  55,  55),
		Updating   = Color3.fromRGB(255, 180,  40),
	}

	-- ── UI ────────────────────────────────────────────────────
	tab:CreateParagraph({
		Title = HUB_NAME .. "  " .. HUB_VERSION,
		Content = "by " .. AUTHOR .. "  |  " .. DISCORD,
	})

	-- Status
	local statusLabel = tab:label("Status: " .. HUB_STATUS)
	statusLabel:Set(
		"Status:  " .. HUB_STATUS,
		"shield-check",
		STATUS_COLORS[HUB_STATUS] or Color3.fromRGB(160, 160, 160)
	)

	tab:CreateDivider()

	-- Announcements
	tab:label("Announcements", "megaphone")
	for _, line in ipairs(ANNOUNCEMENTS) do
		tab:CreateParagraph({ Title = "", Content = "•  " .. line })
	end

	tab:CreateDivider()

	-- Quick info
	tab:CreateParagraph({
		Title = "Getting Started",
		Content = "1.  Go to the Game tab to load the script for your current game.\n"
			.. "2.  Browse Game List to see all supported games.\n"
			.. "3.  Adjust settings in the Settings tab.",
	})

end
