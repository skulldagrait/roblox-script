local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local autoKill = false
local killCount = 0
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
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
    Name = "Auto-Kill + Big Hitboxes (Random Loop)",
    CurrentValue = false,
    Callback = function(state)
        autoKill = state
        getgenv().GODLYSKIDDERXISASKID = state

        if state then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    root.Size = Vector3.new(40, 40, 40)
                    root.Transparency = 0.7
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                end
            end

            task.spawn(function()
                while autoKill do
                    local candidates = {}
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= plr and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            table.insert(candidates, p)
                        end
                    end

                    if #candidates > 0 then
                        local target = candidates[math.random(1, #candidates)]
                        local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local tween = tweenService:Create(
                                plr.Character.HumanoidRootPart,
                                TweenInfo.new(0.29),
                                {CFrame = hrp.CFrame}
                            )
                            tween:Play()
                            tween.Completed:Wait()

                            for i = 1, 3 do
                                virtualUser:Button1Down(Vector2.new(0.9, 0.9))
                                virtualUser:Button1Up(Vector2.new(0.9, 0.9))
                                task.wait(0.1)
                            end

                            if target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health <= 0 then
                                killCount += 1
                                KillDisplay:Set({Content = "Kills: " .. killCount})
                            end
                        end
                    end
                    task.wait(0.4)
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
