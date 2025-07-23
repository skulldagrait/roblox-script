-- Murder VS Sheriff Hub (Codex Stable with Teams) by skulldagrait

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

local TeamsMode = false
local TeamAimbot = false
local TeamAutoKill = false
local TeamExpandHitbox = false
local TeamESP = false
local TeamShowNames = false

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Murderer VS Sherrif Script - by skulldagrait",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By skulldagrait",
    ConfigurationSaving = { Enabled = true, FolderName = "MVS_Hub", FileName = "Config" },
    KeySystem = false
})

-- Main Tab (non-team aware)
local Combat = Window:CreateTab("Combat", 4483362458)
Combat:CreateToggle({ Name = "Aimbot (Visible Only)", CurrentValue = false, Callback = function(v) Aimbot = v end })
Combat:CreateToggle({ Name = "Auto Kill (Auto Shoot)", CurrentValue = false, Callback = function(v) AutoKill = v end })
Combat:CreateToggle({ Name = "Hitbox Extender", CurrentValue = false, Callback = function(v) ExpandHitbox = v end })

local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Callback = function(v) ESP = v end })
ESPTab:CreateToggle({ Name = "Show Player Names", CurrentValue = false, Callback = function(v) ShowNames = v end })

-- Teams Tab (team aware)
local TeamsTab = Window:CreateTab("Teams Mode", 4483362458)
TeamsTab:CreateToggle({ Name = "Enable Teams Mode", CurrentValue = false, Callback = function(v) TeamsMode = v end })

TeamsTab:CreateToggle({ Name = "Aimbot (Enemies Only)", CurrentValue = false, Callback = function(v) TeamAimbot = v end })
TeamsTab:CreateToggle({ Name = "Auto Kill (Enemies Only)", CurrentValue = false, Callback = function(v) TeamAutoKill = v end })
TeamsTab:CreateToggle({ Name = "Hitbox Extender (Enemies Only)", CurrentValue = false, Callback = function(v) TeamExpandHitbox = v end })

TeamsTab:CreateToggle({ Name = "Enable ESP (Enemies Only)", CurrentValue = false, Callback = function(v) TeamESP = v end })
TeamsTab:CreateToggle({ Name = "Show Enemy Names", CurrentValue = false, Callback = function(v) TeamShowNames = v end })

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

local function isEnemy(player)
    if not player.Team or not LocalPlayer.Team then
        return true -- no teams assigned means treat as enemy
    end
    return player.Team ~= LocalPlayer.Team
end

-- Get closest enemy (team aware)
local function getClosestEnemyTeam()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and isEnemy(player) then
            local root = player.Character.HumanoidRootPart
            if isVisible(root) then
                local mag = (Camera.CFrame.Position - root.Position).Magnitude
                if mag < dist then
                    closest = player
                    dist = mag
                end
            end
        end
    end
    return closest
end

-- Get closest player (non-team aware)
local function getClosestEnemy()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if isVisible(root) then
                local mag = (Camera.CFrame.Position - root.Position).Magnitude
                if mag < dist then
                    closest = player
                    dist = mag
                end
            end
        end
    end
    return closest
end

-- Hitbox Extender
local function updateHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local existing = root:FindFirstChild("HitboxResizer")
            local shouldExpand = false

            if TeamsMode then
                shouldExpand = TeamExpandHitbox and isEnemy(player)
            else
                shouldExpand = ExpandHitbox
            end

            if shouldExpand then
                if not existing then
                    local box = Instance.new("SelectionBox")
                    box.Name = "HitboxResizer"
                    box.Adornee = root
                    box.LineThickness = 0
                    box.Parent = root
                    root.Size = Vector3.new(8, 8, 8)
                    root.Transparency = 0.5
                    root.Material = Enum.Material.ForceField
                end
            else
                if existing then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 0
                    root.Material = Enum.Material.Plastic
                    existing:Destroy()
                end
            end
        end
    end
end

-- ESP Management
local ESPObjects = {}

local function createESP(player, showName)
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = showName and player.Name or "ENEMY"
    label.Parent = espGui

    ESPObjects[player] = espGui
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    updateHitboxes()

    if TeamsMode then
        -- Team Mode targeting
        local target = getClosestEnemyTeam()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            if TeamAimbot then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
            end
            if TeamAutoKill then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
                mouse1press()
                task.wait(0.05)
                mouse1release()
            end
        end

        -- ESP for enemies only
        if TeamESP then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and isEnemy(player) and player.Character and player.Character:FindFirstChild("Head") then
                    createESP(player, TeamShowNames)
                    if ESPObjects[player] then
                        ESPObjects[player].Enabled = true
                        ESPObjects[player].TextLabel.Text = TeamShowNames and player.Name or "ENEMY"
                    end
                else
                    removeESP(player)
                end
            end
        else
            for player, gui in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    else
        -- Non-team mode targeting
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            if Aimbot then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
            end
            if AutoKill then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
                mouse1press()
                task.wait(0.05)
                mouse1release()
            end
        end

        -- ESP non-team mode
        if ESP then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    createESP(player, ShowNames)
                    if ESPObjects[player] then
                        ESPObjects[player].Enabled = true
                        ESPObjects[player].TextLabel.Text = ShowNames and player.Name or "ENEMY"
                    end
                else
                    removeESP(player)
                end
            end
        else
            for player, gui in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

print("✅ MVS Hub with Teams Mode Loaded!")
