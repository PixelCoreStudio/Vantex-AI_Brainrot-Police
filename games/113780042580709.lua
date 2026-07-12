local ws = game:WaitForChild("Workspace")
ws.StreamingEnabled = false
local pl = game:GetService("Players")
local lpl = pl.LocalPlayer
local addSpeed = game:GetService("ReplicatedStorage").Events.AddSpeed
_G.AutoSpeed = false
_G.TpWins = false

local baseCFrame = CFrame.new(-1268.02893, 6.74012947, 1150.88391, 2.67028809e-05, 1, -2.60770321e-07, -0.999809265, 2.67028809e-05, 0.0195315108, 0.0195315108, -2.60770321e-07, 0.999809265)

local targetCFrame = baseCFrame + Vector3.new(0, 0.5, 0)

local function teleport()
    local character = lpl.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    if rootPart then
        -- Teleportiert den Spieler sicher an die neue Position
        rootPart.CFrame = targetCFrame
    end
end

return function(section)
    local e = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()(section)

    e:separator("Speed")

    e:toggle("Auto Farm Speed", false, function(v) 
        _G.AddSpeed = v

        while _G.AddSpeed == true do
            addSpeed:FireServer()
            wait()
        end
    end)

    e:separator("Teleport")

    e:button("TP max wins", function()
        teleport()
    end)
    e:toggle("TP max wins loop", false, function(v)
        _G.TpWins = v

        while _G.TpWins == true do
            teleport()
            wait()
        end
    end)
end
