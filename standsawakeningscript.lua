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

local ItemsTab = Window:CreateTab("Items", 4483362458)

ItemsTab:CreateButton({
    Name = "Auto Pickup Uncanney Key + Teleport (Once)",
    Callback = function()
        local teleported = false
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Workspace = game:GetService("Workspace")

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
        local Workspace = game:GetService("Workspace")
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
        for _,v in pairs(game.Workspace:GetDescendants()) do
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

local BossTab = Window:CreateTab("Boss", 4483362458)

BossTab:CreateButton({
    Name = "Start AutoBoss",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character.HumanoidRootPart
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local Workspace = game:GetService("Workspace")
        local Attacking = Workspace.Dead
        local Obby = Workspace.ObbyW
        local Phase = Workspace.BossPhase

        if LocalPlayer.Backpack:FindFirstChild("KnightsSword") then
            LocalPlayer.Backpack["KnightsSword"].Parent = Character
        end

        if Character:FindFirstChild("KnightsSword") then
            local Sword = Character:FindFirstChild("KnightsSword")
            local Box = Instance.new("SelectionBox")
            Box.Name = "SelectionBoxCreated"
            Box.Parent = Sword.Handle
            Box.Adornee = Sword.Handle
            Sword.Handle.Massless = true
            Sword.GripPos = Vector3.new(0,0,0)
            Humanoid:UnequipTools()
            LocalPlayer.Backpack["KnightsSword"].Parent = Character
            Sword.Handle.Size = Vector3.new(20, 20, 500)
        end

        task.spawn(function()
            while Attacking.Value == false do
                task.wait()
                if Obby.Value == true then
                    HumanoidRootPart.CFrame = CFrame.new(20.4561386, 113.245972, 196.61351)
                else
                    if Phase.Value == "None" then
                        HumanoidRootPart.CFrame = CFrame.new(-5.46999931, -4.45343876, 248.209991)
                    else
                        HumanoidRootPart.CFrame = CFrame.new(-19.8957844, -4.77343941, 142.49881)
                    end
                end
            end
        end)

        task.spawn(function()
            while Attacking.Value == false do
                task.wait()
                if Obby.Value == false then
                    if Character:FindFirstChild("KnightsSword") then
                        Character.KnightsSword:Activate()
                    end
                end
            end
        end)
    end,
})

local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
