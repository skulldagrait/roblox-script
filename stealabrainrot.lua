local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Auto ESP for Mythic, Brainrot God, Secret
local function espBrainrot()
    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        for _, child in ipairs(plot:GetDescendants()) do
            if child.Name == "Rarity" and child:IsA("TextLabel") then
                local rarity = child.Text
                if rarity == "Mythic" or rarity == "Brainrot God" or rarity == "Secret" then
                    local parent = child.Parent.Parent
                    if not parent:FindFirstChild("ESP") then
                        local billboard = Instance.new("BillboardGui", parent)
                        billboard.Name = "ESP"
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.Adornee = parent:FindFirstChild("HumanoidRootPart") or parent.PrimaryPart

                        local label = Instance.new("TextLabel", billboard)
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = rarity
                        label.TextColor3 = Color3.new(1,1,0)
                        label.TextScaled = true
                    end
                end
            end
        end
    end
end

-- Noclip function
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- Steal best Brainrot function
local function stealBest()
    local bestBrainrot = nil
    local highestCPS = 0

    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        if plot.Name ~= LocalPlayer.Name .. "'s Base" then
            for _, brainrot in ipairs(plot:GetDescendants()) do
                if brainrot:IsA("Model") and brainrot:FindFirstChild("CashPerSecond") then
                    local cps = tonumber(brainrot.CashPerSecond.Text) or 0
                    if cps > highestCPS then
                        highestCPS = cps
                        bestBrainrot = brainrot
                    end
                end
            end
        end
    end

    if bestBrainrot then
        noclip = true
        local target = bestBrainrot:FindFirstChild("HumanoidRootPart") or bestBrainrot.PrimaryPart
        if target then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            -- Walk to Brainrot
            local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - target.Position).Magnitude/20), {CFrame = target.CFrame})
            tween:Play()
            tween.Completed:Wait()

            -- Wait to ensure pickup registered
            task.wait(0.5)

            -- Return to base
            local myBase
            for _, plot in ipairs(Workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("YourBase") and plot.YourBase.Enabled then
                    myBase = plot
                    break
                end
            end

            if myBase then
                local basePart = myBase:FindFirstChild("BasePart") or myBase.PrimaryPart
                if basePart then
                    local distance = (hrp.Position - basePart.Position).Magnitude
                    if distance < 30 then
                        -- Teleport if close enough
                        hrp.CFrame = basePart.CFrame + Vector3.new(0,5,0)
                    else
                        -- Walk back
                        local tween2 = TweenService:Create(hrp, TweenInfo.new(distance/20), {CFrame = basePart.CFrame + Vector3.new(0,5,0)})
                        tween2:Play()
                        tween2.Completed:Wait()
                    end
                end
            end

        end
        noclip = false
    else
        warn("No Brainrot found to steal")
    end
end

-- Run ESP automatically on load
espBrainrot()

-- Steal best Brainrot
stealBest()
