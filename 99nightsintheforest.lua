local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "99 Nights Hub - Made by skulldagrait",
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
local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")

-- Anti-AFK
task.spawn(function()
    while true do
        task.wait(300)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
    Name = "Auto Win",
    CurrentValue = false,
    Callback = function(state)
        while state do
            task.wait(1)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("NightSkip") or game:GetService("ReplicatedStorage"):FindFirstChild("CompleteNight")
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            end
        end
    end,
})

local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1,1,1)
        lighting.Brightness = 3
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
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
                if v.Material ~= Enum.Material.SmoothPlastic then
                    v.Material = Enum.Material.SmoothPlastic
                end
                v.Reflectance = 0
            end
        end
    end,
})

local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

ESP.Players = true
ESP:Toggle(true)
ESP.Names = true
ESP.Boxes = true
ESP.Tracers = false

local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
