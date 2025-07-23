-- Stands Awakening Hub – by skulldagrait
-- Version: v2.0
-- Codex Executor + Android Supported

repeat wait() until game:IsLoaded() and game:GetService("Players")
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Disable() end

-- Services and Key Vars
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Anti-AFK (also in Misc tab)
spawn(function()
    while wait(300) do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
    end
end)

-- AutoBoss (v2.0 logic)
local Attacking = workspace:WaitForChild("Dead")
local Obby = workspace:WaitForChild("ObbyW")
local Phase = workspace:WaitForChild("BossPhase")
local Health = workspace:WaitForChild("TrollHealth")

if workspace:FindFirstChild("Effects") then workspace.Effects:Destroy() end
if workspace.Map:FindFirstChild("ThunderParts") then workspace.Map.ThunderParts:Destroy() end

local function equipSword()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local tool = Character:FindFirstChild("KnightsSword") or backpack:FindFirstChild("KnightsSword")
    if tool then
        tool.Parent = Character
        local handle = tool:FindFirstChild("Handle")
        if handle then
            handle.Size = Vector3.new(20, 20, 500)
            handle.Massless = true
            local box = Instance.new("SelectionBox")
            box.Adornee = handle
            box.Name = "SelectionBoxCreated"
            box.Parent = handle
        end
    end
end

equipSword()

-- No cooldown logic (v2.0)
spawn(function()
    while true do wait(0.15)
        local sword = Character:FindFirstChild("KnightsSword")
        if sword then
            pcall(function()
                sword:Activate()
                if sword:FindFirstChild("Cooldown") then sword.Cooldown:Destroy() end
                if sword:FindFirstChild("CanAttack") then sword.CanAttack:Destroy() end
            end)
        end
    end
end)

-- Teleport logic
spawn(function()
    while not Attacking.Value do wait()
        if Obby.Value then
            HumanoidRootPart.CFrame = CFrame.new(20.456, 113.246, 196.614)
        elseif Phase.Value == "None" then
            HumanoidRootPart.CFrame = CFrame.new(-5.47, -4.45, 248.21)
        else
            HumanoidRootPart.CFrame = CFrame.new(-19.896, -4.773, 142.499)
        end
    end
end)

-- Continuous Attack
spawn(function()
    while not Attacking.Value do wait()
        if not Obby.Value then
            local sword = Character:FindFirstChild("KnightsSword")
            if sword then
                sword:Activate()
            end
        end
    end
end)

-- Health Finish Logic
local WaitTime = 1.5
local function Percent(a, b)
    return (a / b)
end
Health:GetPropertyChangedSignal("Value"):Connect(function()
    if Percent(Health.Value, Health.MaxHealth.Value) <= 0.003 then
        Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
        wait(WaitTime)
        equipSword()
    end
end)

-- Additional features from previous versions assumed included here:
-- Visuals, Teleports, Items tab, Banknote auto-collect, Fly, InfJump, Anti-AFK, WalkSpeed toggle, JumpPower, Themes, GUI with version display, etc.
-- If needed, I can append the rest of the UI and logic blocks as one full script.
