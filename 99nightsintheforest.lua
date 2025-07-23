local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "99 Nights Script - Made by skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "99Nights_Hub",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Anti-AFK
task.spawn(function()
    while true do
        task.wait(300)
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Variables
local campfireCFrame = CFrame.new(-4, 3, -1)
local autoTPEnabled = false

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "Auto Win",
    Callback = function()
        -- Replace with your actual Auto Win logic (rescue all children & win)
        Rayfield:Notify({
            Title = "Auto Win",
            Content = "Auto Win activated (placeholder, add actual logic).",
            Duration = 5,
        })
    end,
})

-- Protection Tab
local ProtectionTab = Window:CreateTab("Protection", 4483362458)

ProtectionTab:CreateToggle({
    Name = "Auto TP to Safezone if attacked",
    CurrentValue = false,
    Flag = "AutoTPIfAttacked",
    Callback = function(Value)
        autoTPEnabled = Value
    end,
})

task.spawn(function()
    while task.wait(0.5) do
        if autoTPEnabled then
            local deer = nil
            for _,v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find("deer") then
                    deer = v
                    break
                end
            end
            if deer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (deer.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < 30 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = campfireCFrame + Vector3.new(0,5,0)
                end
            end
        end
    end
end)

-- Visuals Tab
local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 5
        Lighting.ClockTime = 12
        Lighting.FogEnd = 10000
        Lighting.GlobalShadows = false
    end,
})

VisualTab:CreateButton({
    Name = "FPS Booster",
    Callback = function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end
    end,
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateButton({
    Name = "ESP Players",
    Callback = function()
        for _,player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local billboard = Instance.new("BillboardGui", player.Character.HumanoidRootPart)
                billboard.Size = UDim2.new(0,100,0,30)
                billboard.AlwaysOnTop = true
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = player.Name
                label.TextColor3 = Color3.new(1,1,1)
                label.TextScaled = true
            end
        end
    end,
})

ESPTab:CreateButton({
    Name = "ESP Collectibles & NPCs",
    Callback = function()
        for _,obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("npc") or obj.Name:lower():find("collectible")) and obj:FindFirstChild("HumanoidRootPart") then
                local billboard = Instance.new("BillboardGui", obj.HumanoidRootPart)
                billboard.Size = UDim2.new(0,100,0,30)
                billboard.AlwaysOnTop = true
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = obj.Name
                label.TextColor3 = Color3.fromRGB(255, 215, 0)
                label.TextScaled = true
            end
        end
    end,
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
