local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NDS Hub | skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NDS_Hub",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Workspace = game:GetService("Workspace")
local HRP = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "No Fall Damage",
    Callback = function()
        RunService.Stepped:Connect(function()
            if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        Rayfield:Notify({Title="NDS Hub",Content="No Fall Damage Enabled",Duration=2})
    end,
})

MainTab:CreateButton({
    Name = "Anti Fling / Knockback",
    Callback = function()
        RunService.Heartbeat:Connect(function()
            for _,v in pairs(Character:GetDescendants()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyForce") or v:IsA("BodyAngularVelocity") then
                    v:Destroy()
                end
            end
            HRP.Velocity = Vector3.new(0,HRP.Velocity.Y,0)
            HRP.RotVelocity = Vector3.new(0,0,0)
        end)
        Rayfield:Notify({Title="NDS Hub",Content="Anti Fling/Knockback Enabled",Duration=2})
    end,
})

MainTab:CreateButton({
    Name = "Auto Sit When Launched",
    Callback = function()
        RunService.Heartbeat:Connect(function()
            if Humanoid.Sit == false and HRP.Velocity.Magnitude > 100 then
                Humanoid.Sit = true
                task.wait(0.1)
                Humanoid.Sit = false
            end
        end)
        Rayfield:Notify({Title="NDS Hub",Content="Auto Sit Enabled",Duration=2})
    end,
})

MainTab:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        UserInputService.JumpRequest:Connect(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        Rayfield:Notify({Title="NDS Hub",Content="Infinite Jump Enabled",Duration=2})
    end,
})

local noclipEnabled = false

MainTab:CreateButton({
    Name = "Toggle Noclip [Press 'N']",
    Callback = function()
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.N then
                noclipEnabled = not noclipEnabled
                Rayfield:Notify({Title="NDS Hub",Content="Noclip: "..tostring(noclipEnabled),Duration=2})
            end
        end)

        RunService.Stepped:Connect(function()
            if noclipEnabled then
                for _,v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end,
})

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        Humanoid.WalkSpeed = Value
    end,
})

MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        Humanoid.JumpPower = Value
    end,
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1,1,1)
        lighting.Brightness = 5
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    end,
})

VisualTab:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end
    end,
})

local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nDiscord: skulldagrait\nDiscord Server: discord.gg/FmMuvkaWvG"
})
