--// Murder VS Sheriff Hub - Made by skulldagrait
-- YouTube: youtube.com/@skulldagrait
-- GitHub: github.com/skulldagrait
-- Discord: skulldagrait | discord.gg/wUtef63fms

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Variables
local ESPEnabled, TracersEnabled, NameEnabled, HealthEnabled, SilentAimEnabled, AimbotEnabled = false, false, false, false, false, false

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Aimbot (Locks on target)",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
    end,
})

ESPTab:CreateToggle({
    Name = "Show Tracers",
    CurrentValue = false,
    Callback = function(Value)
        TracersEnabled = Value
    end,
})

ESPTab:CreateToggle({
    Name = "Show Player Names",
    CurrentValue = false,
    Callback = function(Value)
        NameEnabled = Value
    end,
})

ESPTab:CreateToggle({
    Name = "Show Health Bars",
    CurrentValue = false,
    Callback = function(Value)
        HealthEnabled = Value
    end,
})

-- UI Tab
local UITab = Window:CreateTab("Credits", 4483362458)

UITab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: discord.gg/wUtef63fms"
})

-- Aimbot System
local function getClosestPlayer()
    local closest, shortestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
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

-- Silent Aim placeholder (implement your resolver/hit registration hook later)
if SilentAimEnabled then
    print("Silent Aim is enabled (setup resolver hook for function)")
end

print("Murder VS Sheriff GUI loaded by skulldagrait")
