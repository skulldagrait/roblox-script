-- Murder VS Sheriff Hub (Codex Edition) by skulldagrait
-- GitHub: github.com/skulldagrait

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Feature Flags
local Aimbot = false
local Silent = false
local AutoKill = false
local ExpandHitbox = false
local ESP = false
local ShowNames = false

-- UI Setup
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
Combat:CreateToggle({ Name = "Aimbot (Visible Only)", CurrentValue = false, Callback = function(v) Aimbot = v end })
Combat:CreateToggle({ Name = "Silent Aim (Smooth)", CurrentValue = false, Callback = function(v) Silent = v end })
Combat:CreateToggle({ Name = "Auto Kill (Auto Shoot)", CurrentValue = false, Callback = function(v) AutoKill = v end })
Combat:CreateToggle({ Name = "Hitbox Extender", CurrentValue = false, Callback = function(v) ExpandHitbox = v end })

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Callback = function(v) ESP = v end })
ESPTab:CreateToggle({ Name = "Show Player Names", CurrentValue = false, Callback = function(v) ShowNames = v end })

-- Credits
local UITab = Window:CreateTab("Credits", 4483362458)
UITab:CreateParagraph({
    Title = "By skulldagrait",
    Content = "YT: @skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: discord.gg/wUtef63fms"
})

-- Utility Functions
local function isVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 500
    local ray = Ray.new(origin, direction)
    local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character, false, true)
    return hit and part:IsDescendantOf(hit.Parent)
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            if isVisible(root) then
                local d = (Camera.CFrame.Position - root.Position).Magnitude
                if d < dist then
                    closest, dist = p, d
                end
            end
        end
    end
    return closest
end

-- Hitbox Extender
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local part = p.Character.HumanoidRootPart
            local existing = part:FindFirstChild("Resizer")
            if ExpandHitbox then
                if not existing then
                    local box = Instance.new("SelectionBox", part)
                    box.Name = "Resizer"
                    box.Adornee = part
                    box.LineThickness = 0
                    part.Size = Vector3.new(8, 8, 8)
                    part.Transparency = 0.5
                    part.Material = Enum.Material.ForceField
                end
            elseif existing then
                part.Size = Vector3.new(2, 2, 1)
                part.Transparency = 0
                part.Material = Enum.Material.Plastic
                existing:Destroy()
            end
        end
    end
end)

-- Main Loop: Aim + AutoKill
RunService.RenderStepped:Connect(function()
    local target = getClosestEnemy()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local root = target.Character.HumanoidRootPart

        if Aimbot then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
        elseif Silent then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, root.Position), 0.15)
        end

        if AutoKill then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end
end)

-- ESP System
local ESPList = {}
RunService.RenderStepped:Connect(function()
    if ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not ESPList[p] then
                    local tag = Instance.new("BillboardGui", p.Character.Head)
                    tag.Name = "ESP"
                    tag.Size = UDim2.new(0, 200, 0, 50)
                    tag.Adornee = p.Character.Head
                    tag.AlwaysOnTop = true
                    tag.StudsOffset = Vector3.new(0, 2, 0)

                    local label = Instance.new("TextLabel", tag)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(1, 0, 0)
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Font = Enum.Font.SourceSansBold
                    label.Text = ShowNames and p.Name or "ENEMY"

                    ESPList[p] = tag
                else
                    local tag = ESPList[p]
                    tag.TextLabel.Text = ShowNames and p.Name or "ENEMY"
                    tag.Enabled = true
                end
            end
        end
    else
        for _, tag in pairs(ESPList) do
            if tag then tag:Destroy() end
        end
        ESPList = {}
    end
end)

-- Clean up on leave
Players.PlayerRemoving:Connect(function(plr)
    if ESPList[plr] then
        ESPList[plr]:Destroy()
        ESPList[plr] = nil
    end
end)

print("✅ MVS Hub Fully Loaded with AutoKill ✅")
