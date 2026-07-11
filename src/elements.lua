--[[
	src/elements.lua — Shared Element Helpers for Game Scripts
	Load this inside any games/{placeId}.lua file to get extra utilities
	on top of the standard VoidLib section methods.

	Usage in a game script:
	  return function(section)
	    local e = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()(section)
	    e:toggle("My Toggle", false, function(v) end)
	    e:separator("Combat")        -- extra: labeled divider
	    e:status("ESP", "Active")    -- extra: colored status label
	  end

	All standard VoidLib methods (toggle, slider, button, etc.) are forwarded
	transparently, so this is a drop-in replacement for plain `section`.
]]

return function(section)
	-- Proxy: all standard VoidLib calls go straight to section
	local e = setmetatable({}, {
		__index = function(_, key)
			return section[key]
		end,
	})

	--- A divider with a small title label above it — useful for grouping elements.
	--- @param title string
	function e:separator(title)
		if title and title ~= "" then
			section:label(title)
		end
		section:CreateDivider()
	end

	--- A colored status line, e.g. e:status("ESP", "Active")
	--- Status strings:  "Active" (green)  "Inactive" (grey)  "Error" (red)
	--- @param name   string  Feature name
	--- @param status string  Status label
	function e:status(name, status)
		local colors = {
			Active   = Color3.fromRGB(60,  210, 110),
			Inactive = Color3.fromRGB(160, 160, 160),
			Error    = Color3.fromRGB(220,  55,  55),
		}
		local lbl = section:label(name .. ":  " .. (status or ""))
		lbl:Set(name .. ":  " .. (status or ""), nil, colors[status] or colors.Inactive)
		return lbl
	end

	--- A toggle that also updates a status label automatically.
	--- @param name     string
	--- @param default  boolean
	--- @param callback function(state: boolean)
	function e:toggleWithStatus(name, default, callback)
		local statusLbl = e:status(name, default and "Active" or "Inactive")
		local tog = section:toggle(name, default, function(state)
			statusLbl:Set(
				name .. ":  " .. (state and "Active" or "Inactive"),
				nil,
				state and Color3.fromRGB(60, 210, 110) or Color3.fromRGB(160, 160, 160)
			)
			if callback then callback(state) end
		end)
		return tog
	end

	return e
end
