-- v1.9 Stands Awakening Hub – by skulldagrait
-- Fully working GUI, AutoBoss with toggle, enlarged hitbox, no cooldown

local kavoUi = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local window = kavoUi.CreateLib("DavHub", "BloodTheme")

-- Tabs
local Tab1 = window:NewTab("Stands Awakening")
local Tab1Section = Tab1:NewSection("Main")
local Tab2 = window:NewTab("Uncanny Boss")
local Tab2Section = Tab2:NewSection("Event Boss")
local Tab3 = window:NewTab("Credits")
local Tab3Section = Tab3:NewSection("dav#5053")

-- Version label
for _,v in pairs(game.CoreGui:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text == "DavHub" then
        local versionLabel = Instance.new("TextLabel", v)
        versionLabel.Text = "v1.9"
        versionLabel.Size = UDim2.new(0, 50, 0, 20)
        versionLabel.Position = UDim2.new(0, 5, 1, -20)
        versionLabel.BackgroundTransparency = 1
        versionLabel.TextColor3 = Color3.new(1, 1, 1)
        versionLabel.TextScaled = true
    end
end

-- Main Buttons
Tab1Section:NewButton("inf yeild","inf yeild",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

Tab2Section:NewButton("script 1","hub",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Just3itx/Deezs/main/Games/Stands%20Awakening/Loader.lua"))()
end)

Tab2Section:NewButton("script 2","no cooldown",function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/itsyouranya/free/main/Anya%20Stands%20Awakening%20Helper.lua'),true))()
end)

Tab2Section:NewButton("script 3","auto kill boss",function()
    getgenv().WaitTime = 420
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sunexn/standsawakening/main/uncanny.lua",true))() -- open source
end)

-- AutoBoss Toggle
local autoBossEnabled = false
Tab2Section:NewToggle("AutoBoss", "Toggle AutoBoss", function(state)
    autoBossEnabled = state
    if state then
        spawn(function()
            repeat wait() until game:IsLoaded() and game:GetService("Players")
            for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Disable() end

            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            local Humanoid = Character:WaitForChild("Humanoid")
            local Time = true
            local Workspace = game:GetService("Workspace")
            local Attacking = Workspace:WaitForChild("Dead")
            local Obby = Workspace:WaitForChild("ObbyW")
            local Phase = Workspace:WaitForChild("BossPhase")
            local Health = Workspace:WaitForChild("TrollHealth")

            if Workspace:FindFirstChild("Effects") then Workspace.Effects:Destroy() end
            if Workspace.Map:FindFirstChild("ThunderParts") then Workspace.Map.ThunderParts:Destroy() end

            local function equipSword()
                local sword = LocalPlayer.Backpack:FindFirstChild("KnightsSword") or Character:FindFirstChild("KnightsSword")
                if sword then
                    sword.Parent = Character
                    local Box = Instance.new("SelectionBox")
                    Box.Name = "SelectionBoxCreated"
                    Box.Adornee = sword.Handle
                    Box.Parent = sword.Handle
                    sword.Handle.Massless = true
                    sword.GripPos = Vector3.new(0, 0, 0)
                    Humanoid:UnequipTools()
                    sword.Parent = Character
                    sword.Handle.Size = Vector3.new(20, 20, 500)
                end
            end
            equipSword()

            task.spawn(function()
                while autoBossEnabled and not Attacking.Value do task.wait()
                    if Obby.Value == true then
                        HumanoidRootPart.CFrame = CFrame.new(20.45, 113.24, 196.61)
                    else
                        if Phase.Value == "None" then
                            HumanoidRootPart.CFrame = CFrame.new(-5.47, -4.45, 248.21)
                        else
                            HumanoidRootPart.CFrame = CFrame.new(-19.89, -4.77, 142.49)
                        end
                    end
                end
            end)

            task.spawn(function()
                while autoBossEnabled and not Attacking.Value do task.wait()
                    local sword = Character:FindFirstChild("KnightsSword")
                    if sword then sword:Activate() end
                end
            end)

            Health:GetPropertyChangedSignal("Value"):Connect(function()
                local function Percent(a, b) return a / b end
                if Percent(Health.Value, Health.MaxHealth.Value) <= 0.003 and Time then
                    Time = false
                    Humanoid:UnequipTools()
                    wait(getgenv().WaitTime or 420)
                    equipSword()
                end
            end)
        end)
    end
end)
