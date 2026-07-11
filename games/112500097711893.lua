local cast = game:GetService("ReplicatedStorage").Remotes.OnCast
local startRun = game:GetService("ReplicatedStorage").Remotes.StartRun
local finishRun = game:GetService("ReplicatedStorage").Remotes.FinishRun
local claim = game:GetService("ReplicatedStorage").Remotes.Claim

local vim = game:GetService("VirtualInputManager")

local pl = game:GetService("Players")
local lpl = pl.LocalPlayer
local lplui = lpl:WaitForChild("PlayerGui")

local char = lpl.Character or lpl.CharacterAdded:Wait()
local hm = char:WaitForChild("Humanoid")

local gymIChar = char:FindFirstChild("Gym")
local bp = lpl:WaitForChild("Backpack")
local gymT = bp:WaitForChild("Gym")

_G.Gym = false
_G.GetBrainrot = false
_G.Claim = false

return function(section)
    local e = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()(section)

    e:button("Get Brainrot (Takes 6 seconds)", function()
        cast:InvokeServer(1)
        wait(3)
        startRun:InvokeServer()
        wait(3)
        finishRun:InvokeServer(true)
    end)

    e:toggle("Get Brainrot", false, function(v)
        _G.GetBrainrot = v

        while _G.GetBrainrot == true do
            cast:InvokeServer(1)
            wait(3)
            startRun:InvokeServer()
            wait(3)
            finishRun:InvokeServer(true)
            wait(1)
        end
    end)

    e:toggle("Gym", false, function(v)
        _G.Gym = v

        if _G.Gym == true then
            if hm and gymT then
                hm:EquipTool(gymT)
            end

            while _G.Gym == true do
                local mui = lplui:FindFirstChild("Main")
                if mui then
                    local btn = mui:FindFirstChild("doubleButton")
                    if btn then
                        if firesignal then
                            firesignal(btn.MouseButton1Click)
                            firesignal(btn.Activated)
                        else
                            warn("Your Executor doesn't support 'firesignal'!")
                            break
                        end
                    end
                end
                task.wait(1)
            end
        else
            if gymIChar then
                gymIChar.Parent = bp
            else
                if hm then
                    hm:UnequipTools()
                end
            end
        end
    end)

    e:toggle("Auto Claim", false, function(v)
        _G.Claim = v

        while _G.Claim == true do
            for i = 1, 30 do
                claim:InvokeServer(i)
                wait()
            end
        end
    end)
end
