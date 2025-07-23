-- Murder VS Sheriff Hub (Codex Stable) by skulldagrait
-- GitHub: github.com/skulldagrait

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Feature Flags
local Aimbot = false
local AutoKill = false
local ExpandHitbox = false
local ESP = false
local ShowNames = false

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Murderer VS Sherrif Script - by skulldagrait",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MVS_Hub",
        FileName = "Config"
    },
    KeySystem = false
})

-- Combat Tab
local Combat = Window:CreateTab("Combat", 4483362458)
Combat:CreateToggle({
    Name = "Aimbot (Visible Only)",
    CurrentValue = false,
    Callback = function(value) Aimbot = value end,
})
Combat:CreateToggle({
    Name = "Auto Kill (Auto Shoot)",
    CurrentValue = false,
    Callback = function(value) AutoKill = value end,
})
Combat:CreateToggle({
    Name = "Hitbox Extender",
    CurrentValue = false,
    Callback = function(value) ExpandHitbox = value end,
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(value) ESP = value end,
})
ESPTab:CreateToggle({
    Name = "Show Player Names",
    CurrentValue = false,
    Callback = function(value) ShowNames = value end,
})

-- Credits Tab
local UITab = Window:CreateTab("Credits", 4483362458)
UITab:CreateParagraph({
    Title = "By skulldagrait",
    Content = "YT: @skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: discord.gg/wUtef63fms"
})

-- Helpers
local function isVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 500
    local ray = Ray.new(origin, direction)
    local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character, false, true)
    return hit and part:IsDescendantOf(hit.Parent)
end

local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if isVisible(root) then
                local distance = (Camera.CFrame.Position - root.Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Hitbox Extender
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local resizer = root:FindFirstChild("HitboxResizer")
            if ExpandHitbox then
                if not resizer then
                    local selectionBox = Instance.new("SelectionBox")
                    selectionBox.Name = "HitboxResizer"
                    selectionBox.Adornee = root
                    selectionBox.LineThickness = 0
                    selectionBox.Parent = root
                    root.Size = Vector3.new(8, 8, 8)
                    root.Transparency = 0.5
                    root.Material = Enum.Material.ForceField
                end
            else
                if resizer then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 0
                    root.Material = Enum.Material.Plastic
                    resizer:Destroy()
                end
            end
        end
    end
end)

-- Main Logic Loop
RunService.RenderStepped:Connect(function()
    local target = getClosestEnemy()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local root = target.Character.HumanoidRootPart

        if Aimbot then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
        end

        if AutoKill then
            -- Aim at target first
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
            -- Simulate mouse click to shoot
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end
end)

-- ESP System (persistent)
local ESPObjects = {}

local function createESP(player)
    if ESPObjects[player] then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end

    local head = player.Character.Head
    local espGui = Instance.new("BillboardGui")
    espGui.Name = "ESP"
    espGui.Adornee = head
    espGui.Size = UDim2.new(0, 150, 0, 50)
    espGui.StudsOffset = Vector3.new(0, 2, 0)
    espGui.AlwaysOnTop = true
    espGui.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextScaled = true
    nameLabel.Text = ShowNames and player.Name or "ENEMY"
    nameLabel.Parent = espGui

    ESPObjects[player] = espGui
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character and player.Character:FindFirstChild("Head") then
                    createESP(player)
                    if ESPObjects[player] then
                        ESPObjects[player].Enabled = true
                        ESPObjects[player].TextLabel.Text = ShowNames and player.Name or "ENEMY"
                    end
                else
                    removeESP(player)
                end
            end
        end
    else
        for player, gui in pairs(ESPObjects) do
            gui:Destroy()
            ESPObjects[player] = nil
        end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

print("✅ MVS Hub Loaded - Stable Version")
