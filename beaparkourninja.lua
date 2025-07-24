local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local autoKill = false
local killCount = 0

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
    Name = "Auto-Kill + Hitbox Expand (R6 Compatible)",
    CurrentValue = false,
    Callback = function(state)
        autoKill = state
        getgenv().GODLYSKIDDERXISASKID = state
        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local plr = Players.LocalPlayer
                local cam = workspace.CurrentCamera
                local virtualUser = game:GetService("VirtualUser")

                plr.CharacterAdded:Connect(function(char)
                    repeat task.wait() until char:FindFirstChild("Humanoid")
                    cam.CameraSubject = char.Humanoid
                    cam.CameraType = Enum.CameraType.Custom
                    task.wait(1)
                end)

                while getgenv().GODLYSKIDDERXISASKID do
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= plr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                            local root = v.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.Size = Vector3.new(15, 15, 15)
                                root.Transparency = 0.75
                                root.Material = Enum.Material.Neon
                                root.CanCollide = false
                            end

                            repeat
                                virtualUser:Button1Down(Vector2.new(0.9, 0.9))
                                virtualUser:Button1Up(Vector2.new(0.9, 0.9))

                                if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                                    getgenv().r6noclip = true
                                    game:GetService("RunService").Stepped:Connect(function()
                                        if getgenv().r6noclip and plr.Character then
                                            local c = plr.Character
                                            if c:FindFirstChild("Head") then c.Head.CanCollide = false end
                                            if c:FindFirstChild("Torso") then c.Torso.CanCollide = false end
                                            if c:FindFirstChild("Left Leg") then c["Left Leg"].CanCollide = false end
                                            if c:FindFirstChild("Right Leg") then c["Right Leg"].CanCollide = false end
                                        end
                                    end)
                                end

                                local croot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                if croot and root then
                                    local tween = game:GetService("TweenService"):Create(
                                        croot,
                                        TweenInfo.new(0.29),
                                        {CFrame = root.CFrame}
                                    )
                                    tween:Play()
                                    tween.Completed:Wait()
                                    if plr.Character:FindFirstChild("Head") then
                                        plr.Character.Head.Anchored = true
                                        task.wait(0.03)
                                        plr.Character.Head.Anchored = false
                                    end
                                end

                                if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health <= 0 then
                                    game:GetService("ReplicatedStorage").RemoteTriggers.SpawnIn:FireServer()
                                    repeat task.wait(0.5) until plr.Character and plr.Character:FindFirstChild("Humanoid")
                                    cam.CameraSubject = plr.Character:FindFirstChild("Humanoid")
                                    cam.CameraType = Enum.CameraType.Custom
                                end

                                task.wait()
                            until not v.Character or v.Character.Humanoid.Health <= 0 or not getgenv().GODLYSKIDDERXISASKID

                            killCount += 1
                            KillDisplay:Set({Content = "Kills: " .. killCount})
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
    Title = "By skulldagrait",
    Content = "Discord: skulldagrait\nYouTube: @skulldagrait\nGitHub: github.com/skulldagrait"
})
