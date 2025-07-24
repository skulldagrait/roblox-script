local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local virtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")

local autoKill = false
local killCount = 0
local version = "v1.0"

local Window = Rayfield:CreateWindow({
    Name = "Be a Parkour Ninja – By skulldagrait",
    LoadingTitle = "skulldagrait GUI",
    LoadingSubtitle = "Mobile & Codex Ready",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Main = Window:CreateTab("⚙️ Main", 4483362458)
Main:CreateParagraph({Title = "Version", Content = version})
local KillDisplay = Main:CreateParagraph({
    Title = "Kill Log",
    Content = "Kills: 0"
})

Main:CreateToggle({
    Name = "Auto-Kill + Moderate Hitboxes (Loop Until Dead)",
    CurrentValue = false,
    Callback = function(state)
        autoKill = state
        getgenv().GODLYSKIDDERXISASKID = state

        if state then
            task.spawn(function()
                while autoKill do
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                        local validTargets = {}
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= plr and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.Size = Vector3.new(10, 10, 10)
                                    hrp.Transparency = 0.4
                                    hrp.BrickColor = BrickColor.new("Really red")
                                    hrp.Material = Enum.Material.ForceField
                                    hrp.CanCollide = false
                                    table.insert(validTargets, p)
                                end
                            end
                        end

                        if #validTargets > 0 then
                            local target = validTargets[math.random(1, #validTargets)]
                            local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local tween = tweenService:Create(
                                    plr.Character.HumanoidRootPart,
                                    TweenInfo.new(0.29),
                                    {CFrame = hrp.CFrame}
                                )
                                tween:Play()
                                tween.Completed:Wait()

                                while target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 and plr.Character.Humanoid.Health > 0 do
                                    virtualUser:Button1Down(Vector2.new(0.9, 0.9))
                                    virtualUser:Button1Up(Vector2.new(0.9, 0.9))
                                    task.wait(0.1)
                                end

                                if target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health <= 0 then
                                    killCount = killCount + 1
                                    KillDisplay:Set({Content = "Kills: " .. tostring(killCount)})
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local Visuals = Window:CreateTab("🎨 Visuals", 4483362458)
Visuals:CreateParagraph({Title = "Version", Content = version})
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
    end,
})

local Credits = Window:CreateTab("📜 Credits", 4483362458)
Credits:CreateParagraph({Title = "Version", Content = version})
Credits:CreateParagraph({
    Title = "Credits",
    Content = "By Skulldagrait\nDiscord: skulldagrait\nYouTube: @skulldagrait\nGitHub: github.com/skulldagrait"
})
