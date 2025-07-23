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

-- Items Tab
local ItemsTab = Window:CreateTab("Items", 4483362458)

ItemsTab:CreateButton({
    Name = "Auto Pickup Uncanney Key + Teleport (Once)",
    Callback = function()
        local teleported = false
        task.spawn(function()
            while true do
                task.wait(1)
                for i,v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Tool") and v.Name == "Uncanney Key" then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Handle, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Handle, 1)
                        if not teleported then
                            teleported = true
                            HumanoidRootPart.CFrame = CFrame.new(-80.54, 3.66, 245.48)
                        end
                    end
                end
            end
        end)
    end,
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

VisualTab:CreateButton({
    Name = "FPS Booster (Boss)",
    Callback = function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Part") then
                if v.Name:lower():find("bomb") or v.Name:lower():find("effect") or v.Name:lower():find("blue") then
                    v.Transparency = 1
                    if v:FindFirstChild("Decal") then
                        v.Decal.Transparency = 1
                    end
                end
            end
        end
    end,
})

-- Boss Tab
local BossTab = Window:CreateTab("Boss", 4483362458)

BossTab:CreateButton({
    Name = "Start AutoBoss (Huge Hitbox + Dodge + Fast Swing)",
    Callback = function()
        local Attacking = Workspace.Dead
        local Obby = Workspace.ObbyW
        local Phase = Workspace.BossPhase

        if LocalPlayer.Backpack:FindFirstChild("KnightsSword") then
            LocalPlayer.Backpack["KnightsSword"].Parent = LocalPlayer.Character
        end

        if LocalPlayer.Character:FindFirstChild("KnightsSword") then
            local Sword = LocalPlayer.Character:FindFirstChild("KnightsSword")
            local Box = Instance.new("SelectionBox")
            Box.Name = "SelectionBoxCreated"
            Box.Parent = Sword.Handle
            Box.Adornee = Sword.Handle
            Sword.Handle.Massless = true
            Sword.GripPos = Vector3.new(0,0,0)
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
            LocalPlayer.Backpack["KnightsSword"].Parent = LocalPlayer.Character
            Sword.Handle.Size = Vector3.new(1000, 1000, 1000)
        end

        -- Dodge System
        task.spawn(function()
            local safeOffset = Vector3.new(0, 50, 0)
            game:GetService("RunService").Heartbeat:Connect(function()
                for _,v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Part") then
                        local name = v.Name:lower()
                        local size = v.Size
                        if (name:find("bomb") or name:find("laser") or name:find("attack") or name:find("effect") or name:find("hitbox") or size.X > 20 or size.Z > 20) then
                            if (v.Position - HumanoidRootPart.Position).Magnitude < 20 then
                                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + safeOffset
                            end
                        end
                    end
                end
            end)
        end)

        -- Auto Movement
        task.spawn(function()
            while Attacking.Value == false do
                task.wait(0.1)
                if Obby.Value == true then
                    HumanoidRootPart.CFrame = CFrame.new(20.4561386, 113.245972, 196.61351)
                else
                    if Phase.Value == "None" then
                        HumanoidRootPart.CFrame = CFrame.new(-5.46999931, -4.45343876, 248.209991)
                    else
                        local boss = Workspace:FindFirstChild("Boss") or Workspace:FindFirstChild("UncannyBoss")
                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 50, -50)
                        end
                    end
                end
            end
        end)

        -- Auto Attack
        task.spawn(function()
            while Attacking.Value == false do
                task.wait(0.1)
                if Obby.Value == false then
                    if LocalPlayer.Character:FindFirstChild("KnightsSword") then
                        LocalPlayer.Character.KnightsSword:Activate()
                    end
                end
            end
        end)
    end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

local function createTeleport(name, position)
    TeleportTab:CreateButton({
        Name = name,
        Callback = function()
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(unpack(position))
            end
        end,
    })
end

createTeleport("Timmy NPC", {1394, 584, -219})
createTeleport("Tim NPC", {1399, 584, -216})
createTeleport("Tom NPC", {1343, 587, -554})
createTeleport("Sans NPC", {1045, 583, -442})
createTeleport("Donation Leaderboard", {1670, 583, -506})
createTeleport("Waterfall (Uncanney Key spawn)", {1625, 578, -747})
createTeleport("Doghouse (Uncanney Key spawn)", {1033, 583, -178})
createTeleport("Arena", {1248, 583, -280})
createTeleport("Key Portal", {1093, 583, -699})
createTeleport("Stand/Rokaka/Arrow Farm", {-339, 461, -1514})
createTeleport("Main Area (Middle of map)", {1341, 583, -482})
createTeleport("D4C Location", {-3070, 464, -421})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
