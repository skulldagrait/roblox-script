local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Stands Awakening AutoBoss - Made by skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SA_AutoBoss",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1,1,1)
        lighting.Brightness = 10
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    end,
})

MainTab:CreateButton({
    Name = "Teleport to Boss Lobby",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(11423379012)
    end,
})

MainTab:CreateButton({
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

MainTab:CreateButton({
    Name = "FPS Booster (Hide bombs, blue guys, effects)",
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

local CreditsTab = Window:CreateTab("Credits", 4483362458)
local CreditsSection = CreditsTab:CreateSection("Credits")

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
