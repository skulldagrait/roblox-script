local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "My Singing Brainrot Hub - Made by skulldagrait",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MSB_Hub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "Walk to Highest Cash/Sec Brainrot",
    Callback = function()
        local highest = nil
        local maxCash = 0
        for _, plot in pairs(Workspace.Plots:GetChildren()) do
            for _, brainrot in pairs(plot:GetDescendants()) do
                if brainrot:FindFirstChild("CashPerSecond") then
                    local cps = tonumber(brainrot.CashPerSecond.Value)
                    if cps and cps > maxCash then
                        maxCash = cps
                        highest = brainrot
                    end
                end
            end
        end
        if highest and highest:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = highest.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        end
    end,
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateButton({
    Name = "Enable Fullbright",
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

local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
