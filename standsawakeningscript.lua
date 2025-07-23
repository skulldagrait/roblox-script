local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Stands Awakening Hub - Made by skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SA_Hub",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Troll Tab
local TrollTab = Window:CreateTab("Troll", 4483362458)

TrollTab:CreateToggle({
    Name = "Infinite Heirophant Emerald Splash",
    CurrentValue = false,
    Callback = function(Value)
        _G.SpamEmeralds = Value
        while _G.SpamEmeralds do
            task.wait(0.1)
            local tool = LocalPlayer.Character:FindFirstChild("HeirophantGreen")
            if tool then
                tool:Activate()
            end
        end
    end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local teleports = {
    {"Timmy NPC", Vector3.new(1394, 584, -219)},
    {"Tim NPC", Vector3.new(1399, 584, -216)},
    {"Tom NPC", Vector3.new(1343, 587, -554)},
    {"Sans NPC", Vector3.new(1045, 583, -442)},
    {"Donation Leaderboard", Vector3.new(1670, 583, -506)},
    {"Waterfall (Uncanney Key spawn)", Vector3.new(1625, 578, -747)},
    {"Doghouse (Uncanney Key spawn)", Vector3.new(1033, 583, -178)},
    {"Arena", Vector3.new(1248, 583, -280)},
    {"Key Portal", Vector3.new(1093, 583, -699)},
    {"Stand/Rokaka/Arrow Farm", Vector3.new(-339, 461, -1514)},
    {"Main Area (Middle of map)", Vector3.new(1341, 583, -482)},
    {"D4C Location", Vector3.new(-3070, 464, -421)},
}
for _,tp in pairs(teleports) do
    TeleportTab:CreateButton({
        Name = tp[1],
        Callback = function()
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(tp[2])
            end
        end,
    })
end

-- OP Tab
local OP = Window:CreateTab("OP", 4483362458)

OP:CreateToggle({
    Name = "God Mode (Toggle)",
    CurrentValue = false,
    Callback = function(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Name = Value and "1" or "Humanoid"
            end
        end
    end,
})

-- Beta Tab
local Beta = Window:CreateTab("Beta", 4483362458)

Beta:CreateButton({
    Name = "Infinite Ability Usage",
    Callback = function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local __namecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if tostring(self) == "Cooldown" and method == "InvokeServer" then
                return wait(0.00001) -- spam invoke to avoid actual cooldowns
            end
            return __namecall(self, ...)
        end)
    end
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateButton({
    Name = "Enable Fullbright (Natural)",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(0.6,0.6,0.6)
        lighting.Brightness = 3
        lighting.ClockTime = 12
        lighting.FogEnd = 10000
        lighting.GlobalShadows = false
    end,
})

VisualTab:CreateButton({
    Name = "FPS Booster (Main Game)",
    Callback = function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
                if v.Material ~= Enum.Material.SmoothPlastic then
                    v.Material = Enum.Material.SmoothPlastic
                end
                v.Reflectance = 0
            end
        end
    end,
})

-- Boss Tab
local BossTab = Window:CreateTab("Boss", 4483362458)

BossTab:CreateButton({
    Name = "Start AutoBoss (Stealth Optimized)",
    Callback = function()
        local Attacking = Workspace:FindFirstChild("Dead")
        local Obby = Workspace:FindFirstChild("ObbyW")
        local Phase = Workspace:FindFirstChild("BossPhase")

        if LocalPlayer.Backpack:FindFirstChild("KnightsSword") then
            LocalPlayer.Backpack["KnightsSword"].Parent = LocalPlayer.Character
        end

        local Sword = LocalPlayer.Character:FindFirstChild("KnightsSword")
        if Sword then
            local handle = Sword:FindFirstChild("Handle")
            handle.Massless = true
            handle.Size = Vector3.new(20, 20, 20)
        end

        task.spawn(function()
            while task.wait(0.1) do
                for _,v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("MeshPart") then
                        local name = v.Name:lower()
                        local size = v.Size
                        if (name:find("bomb") or name:find("laser") or name:find("attack") or name:find("effect") or name:find("hitbox") or size.X > 20 or size.Z > 20) then
                            if (v.Position - HumanoidRootPart.Position).Magnitude < 15 then
                                local bv = Instance.new("BodyVelocity")
                                bv.Velocity = Vector3.new(0,50,0)
                                bv.MaxForce = Vector3.new(0, math.huge, 0)
                                bv.Parent = HumanoidRootPart
                                game.Debris:AddItem(bv, 0.2)
                            end
                        end
                    end
                end
            end
        end)

        task.spawn(function()
            while Attacking and Attacking.Value == false do
                task.wait(0.1)
                if Obby and Obby.Value == true then
                    HumanoidRootPart.CFrame = CFrame.new(20.4561386, 113.245972, 196.61351)
                else
                    if Phase and Phase.Value == "None" then
                        HumanoidRootPart.CFrame = CFrame.new(-5.46999931, -4.45343876, 248.209991)
                    else
                        local boss = Workspace:FindFirstChild("Boss") or Workspace:FindFirstChild("UncannyBoss")
                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, -10)
                        end
                    end
                end
            end
        end)

        task.spawn(function()
            while Attacking and Attacking.Value == false do
                task.wait(math.random(8,12)/100)
                if Sword then
                    Sword:Activate()
                end
            end
        end)
    end,
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms\n\nCopy manually for clickable use."
})
