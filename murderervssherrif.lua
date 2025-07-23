--// Murder VS Sheriff Hub - Made by skulldagrait

-- Load Rayfield UI
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success then
    warn("Rayfield UI failed to load.")
    return
end

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "Murder VS Sheriff Hub - Made by skulldagrait",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MVS_Hub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Settings
local AimbotEnabled = false

-- Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({
    Name = "Aimbot (basic - auto camera)",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

local UITab = Window:CreateTab("Credits", 4483362458)
UITab:CreateParagraph({
    Title = "Script by skulldagrait",
    Content = "YT: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait"
})

-- Simple Aimbot: Lock camera on closest visible enemy
local function getClosestPlayer()
    local closest, shortest = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortest then
                closest = player
                shortest = distance
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

print("Murder VS Sheriff Hub loaded by skulldagrait")
