local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local autoKill = false
local killCount = 0
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera
local virtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")

local Window = Rayfield:CreateWindow({
    Name = "Be a Parkour Ninja – By skulldagrait",
    LoadingTitle = "skulldagrait GUI",
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
        lighting.GlobalShadows = false
    end,
})

Visuals:CreateButton({
    Name = "FPS Boost (Remove Lag Effects)",
    Callback = function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v:Destroy()
            end
        end
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 1000000
        lighting.Brightness = 1
        pcall(function()
            sethiddenproperty(lighting, "Technology", Enum.Technology.Compatibility)
        end)
    end,
})

local Main = Window:CreateTab("⚙️ Main", 4483362458)

local KillDisplay = Main:CreateParagraph({
    Title = "Kill Log",
    Content = "Kills: 0"
})

Main:CreateToggle({
    Name = "Auto-Kill + Huge Hitboxes (Looping)",
    CurrentValue = false,
    Callback = function(state)
        autoKill = state
        getgenv().GODLYSKIDDERXISASKID = state

        if state then
            task.spawn(function()
                while autoKill do
                    for _, enemy in pairs(Players:GetPlayers()) do
                        if enemy ~= plr and enemy.Character and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then
                            local root = enemy.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.Size = Vector3.new(40, 40, 40)
                                root.Transparency = 0.7
                                root.Material = Enum.Material.Neon
                                root.CanCollide = false
                            end
                        end
                    end
                    task.wait(1)
                end
            end)

            task.spawn(function()
                while autoKill do
                    for _, target in pairs(Players:GetPlayers()) do
                        if target ~= plr and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                            repeat
                                pcall(function()
                                    virtualUser:Button1Down(Vector2.new(0.9, 0.9))
                                    virtualUser:Button1Up(Vector2.new(0.9, 0.9))

                                    if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                                        game:GetService("RunService").Stepped:Connect(function()
                                            if plr.Character then
                                                local c = plr.Character
                                                if c:FindFirstChild("Head") then c.Head.CanCollide = false end
                                                if c:FindFirstChild("Torso") then c.Torso.CanCollide = false end
                                                if c:FindFirstChild("Left Leg") then c["Left Leg"].CanCollide = false end
                                                if c:FindFirstChild("Right Leg") then c["Right Leg"].CanCollide = false end
                                            end
                                        end)
                                    end

                                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                                        local tween = tweenService:Create(
                                            plr.Character.HumanoidRootPart,
                                            TweenInfo.new(0.29),
                                            {CFrame = target.Character.HumanoidRootPart.CFrame}
                                        )
                                        tween:Play()
                                        tween.Completed:Wait()
                                    end

                                    if plr.Character and plr.Character:FindFirstChild("Head") then
                                        plr.Character.Head.Anchored = true
                                        task.wait(0.03)
                                        plr.Character.Head.Anchored = false
                                    end
                                end)
                                task.wait()
                            until not target.Character or target.Character.Humanoid.Health <= 0 or not autoKill

                            killCount += 1
                            KillDisplay:Set({Content = "Kills: " .. killCount})
                        end
                    end
                    task.wait(1)
                end
            end)

            plr.CharacterAdded:Connect(function(char)
                repeat task.wait() until char:FindFirstChild("Humanoid")
                cam.CameraSubject = char.Humanoid
                cam.CameraType = Enum.CameraType.Custom
                task.wait(1)
            end)

            task.spawn(function()
                while autoKill do
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health <= 0 then
                        game:GetService("ReplicatedStorage").RemoteTriggers.SpawnIn:FireServer()
                        repeat task.wait() until plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
                        cam.CameraSubject = plr.Character.Humanoid
                        cam.CameraType = Enum.CameraType.Custom
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local Credits = Window:CreateTab("📜 Credits", 4483362458)

Credits:CreateParagraph({
    Title = "By skulldagrait",
    Content = "Discord: skulldagrait\nYouTube: @skulldagrait\nGitHub: github.com/skulldagrait"
})
