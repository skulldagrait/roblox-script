-- v1.9 Stands Awakening Hub – by skulldagrait
-- Full script with GUI, features from v1.5-v1.9, merged with GUI layout from image

repeat wait() until game:IsLoaded() and game:GetService("Players")
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Disable() end

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Stands Awakening Hub | v1.9",
    LoadingTitle = "Stands Awakening Hub",
    LoadingSubtitle = "by skulldagrait",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "SAHub",
       FileName = "settings"
    },
    Discord = {
       Enabled = true,
       Invite = "yTfcM6VNs8",
       RememberJoins = true
    },
    KeySystem = false
})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", 4483362458)
MovementTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(enabled)
        local player = game.Players.LocalPlayer
        player.Character.Humanoid.WalkSpeed = enabled and 50 or 16
    end
})
MovementTab:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(enabled)
        local player = game.Players.LocalPlayer
        player.Character.Humanoid.JumpPower = enabled and 100 or 50
    end
})
MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        local Player = game:GetService("Players").LocalPlayer
        local UIS = game:GetService("UserInputService")
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if state then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
        end)
    end
})
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local flyspeed = 100
        if v then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "FlyVelocity"
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            local con = game:GetService("RunService").Heartbeat:Connect(function()
                local move = Vector3.new()
                if lp:GetMouse().KeyDown("w") then move = move + (lp.Character.HumanoidRootPart.CFrame.LookVector * flyspeed) end
                if lp:GetMouse().KeyDown("s") then move = move - (lp.Character.HumanoidRootPart.CFrame.LookVector * flyspeed) end
                if lp:GetMouse().KeyDown("a") then move = move - (lp.Character.HumanoidRootPart.CFrame.RightVector * flyspeed) end
                if lp:GetMouse().KeyDown("d") then move = move + (lp.Character.HumanoidRootPart.CFrame.RightVector * flyspeed) end
                bv.Velocity = move
            end)
            hrp:SetAttribute("FlyingConnection", con)
        else
            local bv = hrp and hrp:FindFirstChild("FlyVelocity")
            if bv then bv:Destroy() end
            local con = hrp and hrp:GetAttribute("FlyingConnection")
            if con then con:Disconnect() end
        end
    end
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visuals", 4483362458)
VisualTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
    end
})
VisualTab:CreateButton({
    Name = "FPS Booster",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end
    end
})

-- Boss Tab (AutoBoss)
local BossTab = Window:CreateTab("Boss", 4483362458)
local AutobossToggle
AutobossToggle = BossTab:CreateToggle({
    Name = "AutoBoss Kill",
    CurrentValue = false,
    Callback = function(state)
        if state then
            -- Full AutoBoss Logic From Earlier
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local Character = LocalPlayer.Character
                local HRP = Character:WaitForChild("HumanoidRootPart")
                local Attacking = workspace:WaitForChild("Dead")
                local Obby = workspace:WaitForChild("ObbyW")
                local Phase = workspace:WaitForChild("BossPhase")
                local Health = workspace:WaitForChild("TrollHealth")
                local Sword = Character:FindFirstChild("KnightsSword") or LocalPlayer.Backpack:FindFirstChild("KnightsSword")
                if Sword then Sword.Parent = Character end
                if Sword and Sword:FindFirstChild("Handle") then
                    Sword.Handle.Size = Vector3.new(20, 20, 500)
                end
                while AutobossToggle.CurrentValue and not Attacking.Value do wait()
                    if Obby.Value then
                        HRP.CFrame = CFrame.new(20.45, 113.24, 196.61)
                    elseif Phase.Value == "None" then
                        HRP.CFrame = CFrame.new(-5.46, -4.45, 248.21)
                    else
                        HRP.CFrame = CFrame.new(-19.89, -4.77, 142.49)
                    end
                end
                while AutobossToggle.CurrentValue and not Attacking.Value do wait()
                    if Character:FindFirstChild("KnightsSword") then
                        for i = 1,5 do Character.KnightsSword:Activate() end
                    end
                end
            end)
        end
    end
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateLabel("Script by skulldagrait")
CreditsTab:CreateLabel("Discord: skulldagrait")
CreditsTab:CreateLabel("GitHub: github.com/skulldagrait")
CreditsTab:CreateLabel("YouTube: youtube.com/@skulldagrait")

-- Footer Version Label
Window:CreateLabel("Version: v1.9")
