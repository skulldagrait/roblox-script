local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local autoKill = false

local Window = Rayfield:CreateWindow({
    Name = "Skulldagrait Hub",
    LoadingTitle = "Skulldagrait GUI",
    LoadingSubtitle = "Mobile & Codex Ready",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Visuals = Window:CreateTab("🎨 Visuals", 4483362458)

Visuals:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1, 1, 1)
        lighting.Brightness = 2
        lighting.FogEnd = 100000
    end,
})

Visuals:CreateButton({
    Name = "FPS Boost (Remove Effects)",
    Callback = function()
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy()
            end
        end
        game:GetService("Lighting").GlobalShadows = false
        sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility)
    end,
})

local Main = Window:CreateTab("⚙️ Main", 4483362458)

Main:CreateToggle({
    Name = "Auto-Kill (R6 Compatible)",
    CurrentValue = false,
    Callback = function(state)
        autoKill = state
        getgenv().GODLYSKIDDERXISASKID = state
        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local plr = Players.LocalPlayer
                while getgenv().GODLYSKIDDERXISASKID do
                    for _, v in pairs(Players:GetPlayers()) do
                        if v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health ~= 0 and v ~= plr then
                            repeat
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(0.9, 0.9))
                                game:GetService("VirtualUser"):Button1Up(Vector2.new(0.9, 0.9))

                                if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                                    getgenv().r6noclip = true
                                    game:GetService("RunService").Stepped:Connect(function()
                                        if getgenv().r6noclip then
                                            local c = plr.Character
                                            if c:FindFirstChild("Head") then c.Head.CanCollide = false end
                                            if c:FindFirstChild("Torso") then c.Torso.CanCollide = false end
                                            if c:FindFirstChild("Left Leg") then c["Left Leg"].CanCollide = false end
                                            if c:FindFirstChild("Right Leg") then c["Right Leg"].CanCollide = false end
                                        end
                                    end)
                                end

                                local CFrameEnd = v.Character.HumanoidRootPart.CFrame
                                local tween = game:GetService("TweenService"):Create(
                                    plr.Character.HumanoidRootPart,
                                    TweenInfo.new(0.29),
                                    {CFrame = CFrameEnd}
                                )
                                tween:Play()
                                task.wait()
                                tween.Completed:Wait()
                                if plr.Character:FindFirstChild("Head") then
                                    plr.Character.Head.Anchored = true
                                    task.wait(0.03)
                                    plr.Character.Head.Anchored = false
                                end

                                if plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health == 0 then
                                    game:GetService("ReplicatedStorage").RemoteTriggers.SpawnIn:FireServer()
                                end
                            until not v.Character or v.Character.Humanoid.Health <= 0 or not getgenv().GODLYSKIDDERXISASKID
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

local Credits = Window:CreateTab("📜 Credits", 4483362458)

Credits:CreateParagraph({
    Title = "Created by",
    Content = "Discord: skulldagrait\nYouTube: @skulldagrait\nGitHub: github.com/skulldagrait"
})
