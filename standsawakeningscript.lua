-- Stands Awakening Hub – by skulldagrait
-- Version: v1.9
-- Loadstring version available at: https://github.com/skulldagrait/roblox-script

--// Initialization
repeat wait() until game:IsLoaded()

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

--// UI Setup
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "Stands Awakening Hub – by skulldagrait",
    LoadingTitle = "Loading",
    LoadingSubtitle = "by skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "StandsAwakeningHub"
    },
    Discord = {
        Enabled = true,
        Invite = "yTfcM6VNs8",
        RememberJoins = true
    },
    KeySystem = false
})

--// Tab Setup
local VisualTab = Window:CreateTab("🎨 Visual", nil)
local ItemTab = Window:CreateTab("🗝️ Items", nil)
local BossTab = Window:CreateTab("🗡️ Boss", nil)
local TeleportTab = Window:CreateTab("🗺️ Teleport", nil)
local MiscTab = Window:CreateTab("⚙️ Misc", nil)
local MovementTab = Window:CreateTab("🏃 Movement", nil)
local CreditsTab = Window:CreateTab("🙏 Credits", nil)

--// Version Display
for _, tab in ipairs({VisualTab, ItemTab, BossTab, TeleportTab, MiscTab, MovementTab, CreditsTab}) do
    tab:CreateParagraph({Title = "Version", Content = "v1.9"})
end

--// Anti-AFK
MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            for i,v in pairs(getconnections(LocalPlayer.Idled)) do
                v:Disable()
            end
        end
    end
})

--// AutoBoss Toggle and Logic
local autobossRunning = false
BossTab:CreateToggle({
    Name = "Start AutoBoss",
    CurrentValue = false,
    Flag = "AutoBoss",
    Callback = function(Value)
        autobossRunning = Value
        if not autobossRunning then return end

        task.spawn(function()
            repeat wait() until game:IsLoaded() and Players

            local Attacking = Workspace:WaitForChild("Dead")
            local Obby = Workspace:WaitForChild("ObbyW")
            local Phase = Workspace:WaitForChild("BossPhase")
            local Health = Workspace:WaitForChild("TrollHealth")

            -- Sword Setup
            local function setupSword()
                local tool = LocalPlayer.Backpack:FindFirstChild("KnightsSword") or Character:FindFirstChild("KnightsSword")
                if tool then
                    tool.Parent = Character
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        handle.Size = Vector3.new(20, 20, 500)
                        handle.Massless = true
                        local Box = Instance.new("SelectionBox")
                        Box.Name = "SelectionBoxCreated"
                        Box.Adornee = handle
                        Box.Parent = handle
                    end
                end
            end

            setupSword()

            -- Teleport Logic
            task.spawn(function()
                while autobossRunning and not Attacking.Value do task.wait()
                    if Obby.Value then
                        HRP.CFrame = CFrame.new(20.456, 113.246, 196.614)
                    elseif Phase.Value == "None" then
                        HRP.CFrame = CFrame.new(-5.47, -4.45, 248.21)
                    else
                        HRP.CFrame = CFrame.new(-19.896, -4.773, 142.499)
                    end
                end
            end)

            -- Attack Loop
            task.spawn(function()
                while autobossRunning and not Attacking.Value do task.wait()
                    if Character:FindFirstChild("KnightsSword") then
                        Character.KnightsSword:Activate()
                    end
                end
            end)

            -- Health % Monitor
            local function Percent(a, b)
                return (a / b)
            end

            Health:GetPropertyChangedSignal("Value"):Connect(function()
                if Percent(Health.Value, Health.MaxHealth.Value) <= 0.003 and Percent(Health.Value, Health.MaxHealth.Value) >= 0 then
                    Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
                    wait(1)
                    if LocalPlayer.Backpack:FindFirstChild("KnightsSword") then
                        LocalPlayer.Backpack["KnightsSword"].Parent = Character
                    end
                end
            end)

        end)
    end
})
