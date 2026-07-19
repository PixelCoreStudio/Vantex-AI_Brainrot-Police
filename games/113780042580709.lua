local ws = game:WaitForChild("Workspace")
ws.StreamingEnabled = false

local pl = game:GetService("Players")
local lpl = pl.LocalPlayer
local addSpeed = game:GetService("ReplicatedStorage").Events.AddSpeed
local ATTRIBUTE_NAME = "WinAmount"

local function getHm()
	local char = lpl.Character
	if char then
		return char:FindFirstChildOfClass("Humanoid")
	end
	return nil
end

local ghm = getHm()

_G.AutoSpeed = false
_G.TpWins = false
_G.WalkSpeed = 16
_G.ActivateWalkSpeed = false
_G.WalkSpeedBefore = ghm.WalkSpeed
_G.WalkSpeedAfter = _G.WalkSpeed

return function(section)
    local e = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()(section)

    local selectedAmount = "" 
    local amountDropdown

    local function getAvailableWinAmounts()
        local amounts = {""}
        local unique = {}
        for _, object in ipairs(ws:GetDescendants()) do
            local winAmount = object:GetAttribute(ATTRIBUTE_NAME)
            if winAmount ~= nil then
                local amountStr = tostring(winAmount)
                if not unique[amountStr] then
                    unique[amountStr] = true
                    table.insert(amounts, amountStr)
                end
            end
        end
        return amounts
    end

    local function teleportToWinAmount(amountStr)
        local targetVal = tonumber(amountStr)
        if not targetVal then return end

        for _, object in ipairs(ws:GetDescendants()) do
            local winAmount = object:GetAttribute(ATTRIBUTE_NAME)
            if winAmount == targetVal then
                local targetCFrame = object:IsA("PVInstance") and object:GetPivot() or (object:IsA("BasePart") and object.CFrame)
                if targetCFrame and lpl.Character and lpl.Character:FindFirstChild("HumanoidRootPart") then
                    lpl.Character.HumanoidRootPart.CFrame = targetCFrame
                    break
                end
            end
        end
    end

    e:separator("Speed")

    e:toggle("Auto Farm Speed", false, function(v) 
        _G.AddSpeed = v

        task.spawn(function()
            while _G.AddSpeed == true do
                addSpeed:FireServer()
                task.wait(0.02)
            end
        end)
    end)

    e:toggle("Activate Walkspeed", false, function(v)
        local hm = getHm()
        _G.ActivateWalkSpeed = v
        _G.WalkSpeed = hm.WalkSpeed

        if _G.ActivateWalkSpeed == false then
            hm.WalkSpeed = _G.WalkSpeedBefore
        else
            hm.WalkSpeed = _G.WalkSpeedAfter
        end
    end)

    e:slider("Walkspeed", 1, 500, _G.WalkSpeed, function(v)
        _G.WalkSpeed = v
        _G.WalkSpeedAfter = v
        while _G.ActivateWalkSpeed == true do
            local hm = getHm()
            if hm then
			    hm.WalkSpeed = _G.WalkSpeed
                wait()
            end
            wait()
		end
    end)

    e:separator("Teleport")

    e:CreateParagraph({ Title = "Win Amount Info", Content = "The selectet amount might be wrong/doesnt work or a win amount doesnt appear. But thats because that game es hella AI Generated and I can't make a better detection to have it dynamic. And if I do it manually again the positions might be wrong. If you have a better detection system for the wins amount in this AI game feel free to share it." })

    amountDropdown = e:dropdown("Select Win Amount", getAvailableWinAmounts(), "", function(value)
        selectedAmount = value
    end)

    e:button("Update Dropdown", function()
        amountDropdown:Refresh(getAvailableWinAmounts(), selectedAmount)
    end)

    e:button("TP max wins", function()
        if selectedAmount ~= "" then
            teleportToWinAmount(selectedAmount)
        else
            print("Please select your amount first!")
        end
    end)

    e:toggle("TP max wins loop", false, function(v)
        _G.TpWins = v

        task.spawn(function()
            while _G.TpWins == true do
                if selectedAmount ~= "" then
                    teleportToWinAmount(selectedAmount)
                    task.wait()
                else
                    task.wait(1) 
                end
            end
        end)
    end)

    e:button("TP 2x Free treadmill", function()
        lpl.Character.HumanoidRootPart.CFrame = CFrame.new(-1113.14233, 4.0572257, 189.478302, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07)
    end)

    e:label("If it is still available. If not I would appreciate if you contact me on discord or some.")
end
