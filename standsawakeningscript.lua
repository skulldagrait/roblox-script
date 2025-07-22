-- Codex Stands Awakening Auto Boss Script
-- No key system, purely yours

-- // GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoBoss = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SA_AutoBoss"

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 200, 0, 150)

Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "SA Auto Boss"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true

AutoBoss.Parent = Frame
AutoBoss.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoBoss.Position = UDim2.new(0, 0, 0.35, 0)
AutoBoss.Size = UDim2.new(1, 0, 0.3, 0)
AutoBoss.Text = "Start Auto Boss"
AutoBoss.TextColor3 = Color3.new(1,1,1)
AutoBoss.TextScaled = true

-- // Auto Boss Function
local running = false
AutoBoss.MouseButton1Click:Connect(function()
    running = not running
    if running then
        AutoBoss.Text = "Stop Auto Boss"
        -- Loop to attack boss
        while running do
            task.wait(0.2)

            -- // Replace "BossNameHere" with actual boss name in Stands Awakening
            local boss = workspace:FindFirstChild("BossNameHere")
            local player = game.Players.LocalPlayer

            if boss and player and boss:FindFirstChild("Humanoid") then
                -- Example: move large hitbox to boss position
                for i,v in pairs(player.Character:GetChildren()) do
                    if v:IsA("Tool") then
                        v:Activate()
                    end
                end

                -- // Example direct damage hitbox manipulation
                if player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0,0, -10)
                end
            end
        end
    else
        AutoBoss.Text = "Start Auto Boss"
    end
end)

-- // Note:
-- To remove cooldown: If it is client-sided, find and disable the cooldown variable.
-- For server-sided cooldown, it cannot be bypassed without server exploit (not possible from normal executors).

print("SA Auto Boss Script Loaded")
