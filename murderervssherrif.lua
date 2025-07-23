--// Murder VS Sheriff Hub - Made by skulldagrait
-- YouTube: youtube.com/@skulldagrait
-- GitHub: github.com/skulldagrait
-- Discord: discord.gg/wUtef63fms

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Murder VS Sheriff Hub - skulldagrait",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Optimized for Codex",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MVS_Hub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- States
local AimbotEnabled = false
local SilentAimEnabled = false
local ESPEnabled = false
local TracersEnabled = false
local NameEnabled = false

local ESPObjects = {}

-- Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({
    Name = "Aimbot (Visible Only)",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim (Beta)",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end
})

local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
    end
})

ESPTab:CreateToggle({
    Name = "Show Tracers",
    CurrentValue = false,
    Callback = function(Value)
        TracersEnabled = Value
    end
})

ESPTab:CreateToggle({
    Name = "Show Player Names",
    CurrentValue = false,
    Callback = function(Value)
        NameEnabled = Value
    end
})

local UITab = Window:CreateTab("Credits", 4483362458)
UITab:CreateParagraph({
    Title = "Script by skulldagrait",
    Content = "YT: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nServer: discord.gg/wUtef63fms"
})

-- Utility
local function isVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000
    local ray = Ray.new(origin, direction)
    local hitPart = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    return hitPart and part:IsDescendantOf(hitPart.Parent)
end

local function getClosestPlayer()
    local closest, shortest = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local part = player.Character.HumanoidRootPart
            if isVisible(part) then
                local dist = (part.Position - Camera.CFrame.Position).Magnitude
                if dist < shortest then
                    closest = player
                    shortest = dist
                end
            end
        end
    end
    return closest
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Silent Aim (Simulated)
RunService.RenderStepped:Connect(function()
    if SilentAimEnabled then
        local target = getClosestPlayer()
        if target then
            -- This is just visual lock-on, not packet/shot hijacking
            print("[Silent Aim] Targeting: " .. target.Name)
        end
    end
end)

-- ESP Builder
local function createESP(player)
    if ESPObjects[player] then return end
    local espHolder = Instance.new("BillboardGui")
    espHolder.Name = "ESP"
    espHolder.Size = UDim2.new(4, 0, 5, 0)
    espHolder.AlwaysOnTop = true
    espHolder.Adornee = player.Character:WaitForChild("HumanoidRootPart")
    espHolder.Parent = player.Character

    local tracer = Instance.new("Frame")
    tracer.Name = "Tracer"
    tracer.Size = UDim2.new(0, 2, 1, 0)
    tracer.BackgroundColor3 = Color3.new(1, 0, 0)
    tracer.Position = UDim2.new(0.5, -1, 0, 0)
    tracer.AnchorPoint = Vector2.new(0.5, 0)
    tracer.BackgroundTransparency = 0.3
    tracer.Visible = TracersEnabled
    tracer.Parent = espHolder

    local name = Instance.new("TextLabel")
    name.Name = "NameTag"
    name.Text = player.Name
    name.BackgroundTransparency = 1
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextStrokeTransparency = 0
    name.Size = UDim2.new(1, 0, 0.25, 0)
    name.Position = UDim2.new(0, 0, -0.5, 0)
    name.Visible = NameEnabled
    name.Parent = espHolder

    ESPObjects[player] = espHolder
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if ESPEnabled then
                createESP(player)
                local gui = ESPObjects[player]
                if gui then
                    gui.Enabled = true
                    gui.Tracer.Visible = TracersEnabled
                    gui.NameTag.Visible = NameEnabled
                end
            elseif ESPObjects[player] then
                ESPObjects[player]:Destroy()
                ESPObjects[player] = nil
            end
        end
    end
end

-- ESP Loop
RunService.RenderStepped:Connect(updateESP)

-- Cleanup on leave
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end)

print("✅ MVS GUI Loaded | By skulldagrait")
