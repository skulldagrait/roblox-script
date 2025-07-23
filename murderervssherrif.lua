--// Murder VS Sherrif | by skulldagrait
-- Requires Rayfield UI Library and basic exploit environment
-- Place this in your GitHub repo and run with: loadstring(game:HttpGet("https://raw.githubusercontent.com/skulldagrait/Roblox-scripts/main/murdersvssherrifs.lua"))()

-- Load Rayfield (must be executed in environment with exploit support)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local ESPEnabled = false
local TracersEnabled = false
local NameEnabled = false
local HealthEnabled = false
local SilentAimEnabled = false
local AimbotEnabled = false

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "Murder VS Sherrif | by skulldagrait",
    LoadingTitle = "Initializing GUI...",
    LoadingSubtitle = "Please wait",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Aimbot (Locks on when visible)",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP")

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
local UITab = Window:CreateTab("UI")
UITab:CreateParagraph({Title = "Credits", Content = "Script by @skulldagrait on GitHub\nHosted in 'Roblox-scripts' repo"})

-- Minimize Button
UITab:CreateButton({
    Name = "Minimize UI",
    Callback = function()
        Rayfield:Toggle()
    end
})

-- Core ESP and Aimbot Logic (basic stubs; extendable)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
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
        local closest = getClosestPlayer()
        if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Silent Aim / ESP (basic placeholders)
-- These systems can be extended using drawing APIs or custom overlays
-- Placeholder implementation until ESP module added
print("Murder VS Sherrif GUI loaded by skulldagrait")
