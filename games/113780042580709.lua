local ws = game:WaitForChild("Workspace")
ws.StreamingEnabled = false

local pl = game:GetService("Players")
local lpl = pl.LocalPlayer
local addSpeed = game:GetService("ReplicatedStorage").Events.AddSpeed
local ATTRIBUTE_NAME = "WinAmount"

_G.AutoSpeed = false
_G.TpWins = false

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
                task.wait()
            end
        end)
    end)

    e:separator("Teleport Test")

    amountDropdown = e:dropdown("Wähle WinAmount", getAvailableWinAmounts(), "", function(value)
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
end
