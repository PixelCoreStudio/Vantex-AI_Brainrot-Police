local moneyAmount = 100
local gemsAmount = 100

_G.giveMoney = false
_G.giveGems = false
_G.Rebirth = false
_G.Merges = false

local give = game:GetService("ReplicatedStorage").Remotes.AddValueEvent
local giveGems = game:GetService("ReplicatedStorage").Remotes.GemEvent
local rebirth = game:GetService("ReplicatedStorage").Remotes.RebirthConfirmEvent
local bestBlock = game:GetService("ReplicatedStorage").Remotes.UpdateBestBlockEvent

return function(section)
    local e = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()(section)

    e:separator("Money")

    e:textbox("Money to give", moneyAmount, function(v)
        moneyAmount = tonumber(v)
    end)

    e:button("Give Money", function()
        give:FireServer("Cash", moneyAmount)
    end)

    e:toggle("Auto Give Money", false, function(v)
        _G.giveMoney = v

        while _G.giveMoney == true do
            give:FireServer("Cash", moneyAmount)
            wait()
        end
    end)

    e:separator("Gems")

    e:textbox("Gems to give", gemsAmount, function(v)
        gemsAmount = tonumber(v)
    end)

    e:button("Give Gems", function()
        giveGems:FireServer(gemsAmount)
    end)

    e:toggle("Auto Give Gems", false, function(v)
        _G.giveGems = v

        while _G.giveGems == true do
            giveGems:FireServer(gemsAmount)
            wait()
        end
    end)

    e:separator("Rebirth")

    e:button("Rebirth", function()
        give:FireServer("Cash", 100000000000000000000000000000000000000000000000000000000000000000000000)
        rebirth:FireServer(1,1,1)
    end)

    e:toggle("Auto Rebirth", false, function(v)
        _G.Rebirth = v

        while _G.Rebirth == true do
            give:FireServer("Cash", 100000000000000000000000000000000000000000000000000000000000000000000000)
            rebirth:FireServer(1,1,1)
            wait(1)
        end
    end)

    e:separator("Merges")

    e:toggle("Add merges", false, function(v)
        _G.Merges = v

        while _G.Merges == true do
            give:FireServer("Merges",1)
            wait()
        end
    end)

    e:label("Only gives 1 merge but fast.")

    e:separator("Blocks")

    e:button("Give best block", function()
        bestBlock:FireServer(100)
    end)
end
