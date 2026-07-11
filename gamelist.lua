--[[
	gamelist.lua — Supported Game List
	Add or remove entries here. Each entry needs:
	  Name    - display name shown in the Game List tab
	  Status  - "Working" | "Partial" | "Broken" | "Testing" | "Undetected"
	  GameId  - the Roblox PlaceId (number) used for teleporting and loading the game script
]]

return {
	{
		Name   = "Beach Escape",
		Status = "Working",
		GameId = 113780042580709,
	},
	{
		Name   = "Blade Ball",
		Status = "Partial",
		GameId = 13772394625,
	},
	{
		Name   = "Fisch",
		Status = "Testing",
		GameId = 16732694052,
	},
	-- Add more games below:
	-- {
	-- 	Name   = "My Game",
	-- 	Status = "Working",
	-- 	GameId = 123456789,
	-- },
}
