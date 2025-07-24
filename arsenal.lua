-- Arsenal Script by skulldagrait (Mobile Compatible)
-- GitHub: https://github.com/skulldagrait/Roblox-scripts

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Arsenal Script",
    Text = "Loaded by skulldagrait (Mobile Mode)",
    Duration = 5
})

-- GUI Window
local Window = Rayfield:CreateWindow({
    Name = "Arsenal | by skulldagrait",
    LoadingTitle = "Loading Arsenal...",
    LoadingSubtitle = "Mobile Friendly",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Variables
local flyEnabled = false
local flySpeed = 50
local flyDirections = {Forward = false, Backward = false, Left = false, Right = false}
local hitboxEnabled = false
local hitboxSize = 25
local hitboxTransparency = 0.6
local noCollisionEnabled = false
local teamCheck = "FFA"
local triggerbotEnabled = false
local triggerbotDelay = 0.2

local hitbox_original_properties = {}

-- Utility Functions
local function saveOriginalProperties(player, part)
    if not hitbox_original_properties[player] then
        hitbox_original_properties[player] = {}
    end
    if not hitbox_original_properties[player][part.Name] then
        hitbox_original_properties[player][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function restoreOriginalProperties(player)
    if hitbox_original_properties[player] then
        for partName, props in pairs(hitbox_original_properties[player]) do
            local part = player.Character and player.Character:FindFirstChild(partName)
            if part then
                part.CanCollide = props.CanCollide
                part.Transparency = props.Transparency
                part.Size = props.Size
            end
        end
        hitbox_original_properties[player] = nil
    end
end

local function extendHitbox(player)
    if not player.Character then return end
    local partsToExtend = {"UpperTorso", "Head", "HumanoidRootPart"}
    for _, partName in ipairs(partsToExtend) do
        local part = player.Character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            saveOriginalProperties(player, part)
            part.CanCollide = not noCollisionEnabled
            part.Transparency = hitboxTransparency
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        end
    end
end

local function shouldExtendHitbox(player)
    if teamCheck == "FFA" or teamCheck == "Everyone" then
        return true
    elseif teamCheck == "Team-Based" then
        return player.Team ~= LocalPlayer.Team
    end
    return false
end

local function updateHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if hitboxEnabled and shouldExtendHitbox(player) then
                extendHitbox(player)
            else
                restoreOriginalProperties(player)
            end
        end
    end
end

-- Fly variables
local flying = false
local bodyVelocity, bodyAngularVelocity, character, humanoid

local function startFly()
    if flying then return end
    character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then return end
    humanoid = character.Humanoid
    humanoid.PlatformStand = true
    local rootPart = character.HumanoidRootPart
    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyAngularVelocity = Instance.new("BodyAngularVelocity", rootPart)
    bodyAngularVelocity.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0,0,0)
    flying = true
end

local function stopFly()
    if not flying then return end
    if humanoid then humanoid.PlatformStand = false end
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
    flying = false
end

-- Fly movement update
RunService.Heartbeat:Connect(function(deltaTime)
    if flying and bodyVelocity and character and character.PrimaryPart then
        local moveVec = Vector3.new(0,0,0)
        local camCFrame = Camera.CFrame
        if flyDirections.Forward then
            moveVec = moveVec + camCFrame.LookVector
        end
        if flyDirections.Backward then
            moveVec = moveVec - camCFrame.LookVector
        end
        if flyDirections.Left then
            moveVec = moveVec - camCFrame.RightVector
        end
        if flyDirections.Right then
            moveVec = moveVec + camCFrame.RightVector
        end
        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * flySpeed
        end
        bodyVelocity.Velocity = Vector3.new(moveVec.X, 0, moveVec.Z)
    end
end)

-- Tabs
local MainTab = Window:CreateTab("Main")
local HitboxTab = Window:CreateTab("Hitbox")
local GunModTab = Window:CreateTab("Gun Mods")
local CreditsTab = Window:CreateTab("Credits")

-- Main Tab Controls
MainTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        flyEnabled = value
        if value then
            startFly()
        else
            stopFly()
        end
    end,
})

MainTab:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 150,
    Default = flySpeed,
    Color = Color3.fromRGB(0, 170, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(value)
        flySpeed = value
    end,
})

-- Fly Direction Buttons (touch friendly)
local FlyControlsLabel = MainTab:CreateLabel("Fly Movement Controls (Tap to toggle)")

local function createFlyButton(direction)
    local btn = MainTab:CreateButton({
        Name = direction,
        Callback = function()
            flyDirections[direction] = not flyDirections[direction]
            local state = flyDirections[direction] and "ON" or "OFF"
            Rayfield:Notify({
                Title = "Fly Direction",
                Content = direction .. " " .. state,
                Duration = 2,
                Image = 1048576, -- info icon
            })
        end,
    })
    return btn
end

createFlyButton("Forward")
createFlyButton("Backward")
createFlyButton("Left")
createFlyButton("Right")

-- Hitbox Tab Controls
HitboxTab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Callback = function(value)
        hitboxEnabled = value
        if not value then
            for _, player in pairs(Players:GetPlayers()) do
                restoreOriginalProperties(player)
            end
            hitbox_original_properties = {}
        else
            updateHitboxes()
        end
    end,
})

HitboxTab:CreateSlider({
    Name = "Hitbox Size",
    Min = 5,
    Max = 50,
    Default = hitboxSize,
    Increment = 1,
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then updateHitboxes() end
    end,
})

HitboxTab:CreateSlider({
    Name = "Hitbox Transparency",
    Min = 0,
    Max = 1,
    Default = hitboxTransparency,
    Increment = 0.05,
    Callback = function(value)
        hitboxTransparency = value
        if hitboxEnabled then updateHitboxes() end
    end,
})

HitboxTab:CreateDropdown({
    Name = "Team Check",
    Options = {"FFA", "Team-Based", "Everyone"},
    Default = teamCheck,
    Callback = function(value)
        teamCheck = value
        if hitboxEnabled then updateHitboxes() end
    end,
})

HitboxTab:CreateToggle({
    Name = "No Collision",
    CurrentValue = false,
    Callback = function(value)
        noCollisionEnabled = value
        if hitboxEnabled then updateHitboxes() end
    end,
})

-- Triggerbot Section in Main Tab
MainTab:CreateToggle({
    Name = "Enable Triggerbot",
    CurrentValue = false,
    Callback = function(value)
        triggerbotEnabled = value
    end,
})

MainTab:CreateSlider({
    Name = "Triggerbot Shot Delay (ms)",
    Min = 50,
    Max = 1000,
    Default = triggerbotDelay * 1000,
    Increment = 10,
    Callback = function(value)
        triggerbotDelay = value / 1000
    end,
})

-- Triggerbot logic
local function isEnemy(targetPlayer)
    if teamCheck == "FFA" then
        return true
    elseif teamCheck == "Everyone" then
        return targetPlayer ~= LocalPlayer
    elseif teamCheck == "Team-Based" then
        return targetPlayer.Team ~= LocalPlayer.Team
    end
    return false
end

local isAlive = true
local function checkHealth()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.HealthChanged:Connect(function(health)
            isAlive = health > 0
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(checkHealth)
checkHealth()

RunService.RenderStepped:Connect(function()
    if triggerbotEnabled and isAlive then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent and target.Parent ~= LocalPlayer.Character and target.Parent:FindFirstChild("Humanoid") then
            local targetPlayer = Players:FindFirstChild(target.Parent.Name)
            if targetPlayer and isEnemy(targetPlayer) then
                -- Fire mouse1 click event
                mouse1press()
                task.wait(triggerbotDelay)
                mouse1release()
            end
        end
    end
end)

-- Gun Mods Tab
GunModTab:CreateToggle({
    Name = "Infinite Ammo (v1)",
    CurrentValue = false,
    Callback = function(value)
        pcall(function()
            local val = value and "Infinite Ammo" or ""
            game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = val
        end)
    end,
})

GunModTab:CreateToggle({
    Name = "Fast Reload",
    CurrentValue = false,
    Callback = function(value)
        for _, weapon in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
            if weapon:FindFirstChild("ReloadTime") then
                weapon.ReloadTime.Value = value and 0.01 or 0.8
            end
            if weapon:FindFirstChild("EReloadTime") then
                weapon.EReloadTime.Value = value and 0.01 or 0.8
            end
        end
    end,
})

GunModTab:CreateToggle({
    Name = "Fast Fire Rate",
    CurrentValue = false,
    Callback = function(value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "FireRate" or v.Name == "BFireRate" then
                v.Value = value and 0.02 or 0.8
            end
        end
    end,
})

GunModTab:CreateToggle({
    Name = "Always Auto Fire",
    CurrentValue = false,
    Callback = function(value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
                v.Value = value and true or false
            end
        end
    end,
})

-- Credits Tab
CreditsTab:CreateLabel("Arsenal Script by skulldagrait")
CreditsTab:CreateLabel("GitHub: github.com/skulldagrait/Roblox-scripts")

