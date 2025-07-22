local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Natural Disaster Survival Hub | skulldagrait",
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

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "God Mode (Infinite Health)",
    Callback = function()
        Humanoid.Name = "1"
        local newHumanoid = Humanoid:Clone()
        newHumanoid.Parent = Character
        newHumanoid.Name = "Humanoid"
        task.wait(0.1)
        Character:FindFirstChild("1"):Destroy()
        workspace.CurrentCamera.CameraSubject = Character
        Humanoid = newHumanoid
        Rayfield:Notify({Title="NDS Hub",Content="God Mode Enabled",Duration=2})
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

MainTab:CreateButton({
    Name = "Teleport to Map",
    Callback = function()
        for _,v in pairs(Workspace:GetChildren()) do
            if v.Name == "Map" then
                LocalPlayer.Character:MoveTo(v.Position or v:GetModelCFrame().p)
                break
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Teleport to Lobby",
    Callback = function()
        LocalPlayer.Character:MoveTo(Vector3.new(0, 181, 0))
    end,
})

MainTab:CreateButton({
    Name = "No Fall Damage",
    Callback = function()
        local old; old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local args = {...}
            if getnamecallmethod() == "FireServer" and tostring(self) == "HumanoidStateType" then
                return
            end
            return old(self, unpack(args))
        end))
        Rayfield:Notify({Title="NDS Hub",Content="No Fall Damage Enabled",Duration=2})
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
