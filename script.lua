local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
    Name = "Steal a Brainrot Modded | Made by skulldagrait",
    LoadingTitle = "Steal a Brainrot Modded",
    LoadingSubtitle = "Loading GUI...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BrainrotModdedHub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)

local noclip = false
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

local function stealBestBrainrot()
    local bestBrainrot = nil
    local highestCPS = 0

    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        if plot.Name ~= LocalPlayer.Name .. "'s Base" then
            for _, brainrot in ipairs(plot:GetDescendants()) do
                if brainrot:IsA("Model") and brainrot:FindFirstChild("CashPerSecond") then
                    local cps = tonumber(brainrot.CashPerSecond.Text) or 0
                    if cps > highestCPS then
                        highestCPS = cps
                        bestBrainrot = brainrot
                    end
                end
            end
        end
    end

    if bestBrainrot then
        noclip = true
        local target = bestBrainrot:FindFirstChild("HumanoidRootPart") or bestBrainrot.PrimaryPart
        if target then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            -- Teleport to brainrot
            hrp.CFrame = target.CFrame + Vector3.new(0,3,0)
            task.wait(0.5)

            -- Return to base
            local myBase
            for _, plot in ipairs(Workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("YourBase") and plot.YourBase.Enabled then
                    myBase = plot
                    break
                end
            end

            if myBase then
                local basePart = myBase:FindFirstChild("BasePart") or myBase.PrimaryPart
                if basePart then
                    hrp.CFrame = basePart.CFrame + Vector3.new(0,5,0)
                end
            end
        end
        noclip = false
    else
        Rayfield:Notify({ Title = "Steal a Brainrot", Content = "No Brainrot found to steal", Duration = 2 })
    end
end

MainTab:CreateButton({
    Name = "Steal Best Brainrot",
    Callback = function()
        stealBestBrainrot()
    end,
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateButton({
    Name = "Fullbright",
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
