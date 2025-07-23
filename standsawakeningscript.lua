-- Stands Awakening Hub – by skulldagrait | Version v1.9
-- Full Script with GUI, AutoBoss, Item AutoFarm, Movement, Visuals, and More

repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Lighting = game:GetService("Lighting")

-- GUI Library
loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Stands Awakening Hub | v1.9",
   LoadingTitle = "Stands Awakening Hub",
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

-- Variables
local AutofarmEnabled = false
local AutobossEnabled = false
local BossThread = nil
local MovementOptions = {Speed = false, Jump = false, Fly = false, InfJump = false, Noclip = false}

-- Version Label
local function AddVersionLabel(tab)
   tab:CreateParagraph({Title = "", Content = "Version: v1.9"})
end

-- AutoFarm
local ItemsTab = Window:CreateTab("Items", 4483362458)
AddVersionLabel(ItemsTab)
ItemsTab:CreateToggle({
   Name = "AutoFarm Items",
   CurrentValue = false,
   Callback = function(v)
       AutofarmEnabled = v
       task.spawn(function()
           while AutofarmEnabled do
               for _, item in pairs(Workspace:GetDescendants()) do
                   if item:IsA("Tool") and item.Parent == Workspace then
                       if item.Name ~= "Arrow" and item.Name ~= "Rokaka" then
                           if (item.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 5 and item.Position ~= Vector3.new(-225, 461, -1396) then
                               LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
                               firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item.Handle, 0)
                               firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item.Handle, 1)
                           end
                       end
                   end
               end
               wait(0.5)
           end
       end)
   end
})

-- Auto Collect Banknote
ItemsTab:CreateToggle({
   Name = "Auto Collect Banknote",
   CurrentValue = false,
   Callback = function(v)
       getgenv().AutoBanknote = v
       task.spawn(function()
           while getgenv().AutoBanknote do
               local inv = LocalPlayer.Backpack:GetChildren()
               for _, item in pairs(inv) do
                   if item:IsA("Tool") and item.Name == "Banknote" then
                       item.Parent = LocalPlayer.Character
                       wait(0.1)
                       item:Activate()
                   end
               end
               wait(2)
           end
       end)
   end
})

-- Movement
local MovementTab = Window:CreateTab("Movement", 4483362458)
AddVersionLabel(MovementTab)

MovementTab:CreateToggle({
   Name = "Speed Boost",
   CurrentValue = false,
   Callback = function(v)
       MovementOptions.Speed = v
       if v then
           LocalPlayer.Character.Humanoid.WalkSpeed = 60
       else
           LocalPlayer.Character.Humanoid.WalkSpeed = 16
       end
   end
})

MovementTab:CreateToggle({
   Name = "Jump Boost",
   CurrentValue = false,
   Callback = function(v)
       MovementOptions.Jump = v
       if v then
           LocalPlayer.Character.Humanoid.JumpPower = 100
       else
           LocalPlayer.Character.Humanoid.JumpPower = 50
       end
   end
})

MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v)
       MovementOptions.InfJump = v
   end
})

UserInputService.JumpRequest:Connect(function()
   if MovementOptions.InfJump then
       LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

MovementTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(v)
       MovementOptions.Fly = v
       if v then
           loadstring(game:HttpGet("https://pastebin.com/raw/jGAeABHg"))()
       end
   end
})

-- Visuals
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
AddVersionLabel(VisualsTab)

VisualsTab:CreateButton({
   Name = "Enable Fullbright",
   Callback = function()
       Lighting.Brightness = 2
       Lighting.GlobalShadows = false
       Lighting.FogEnd = 100000
   end
})

VisualsTab:CreateButton({
   Name = "FPS Booster",
   Callback = function()
       for _, v in pairs(Workspace:GetDescendants()) do
           if v:IsA("BasePart") then
               v.Material = Enum.Material.SmoothPlastic
               v.Reflectance = 0
           end
       end
   end
})

-- Misc
local MiscTab = Window:CreateTab("Misc", 4483362458)
AddVersionLabel(MiscTab)

MiscTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
       for _, v in pairs(getconnections(LocalPlayer.Idled)) do
           v:Disable()
       end
   end
})

-- AutoBoss
local BossTab = Window:CreateTab("Boss", 4483362458)
AddVersionLabel(BossTab)

BossTab:CreateToggle({
   Name = "Start AutoBoss",
   CurrentValue = false,
   Callback = function(v)
       AutobossEnabled = v
       if not v and BossThread then
           BossThread:Disconnect()
       elseif v then
           BossThread = RunService.RenderStepped:Connect(function()
               local Char = LocalPlayer.Character
               local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
               local Sword = Char and Char:FindFirstChild("KnightsSword")
               local Boss = Workspace:FindFirstChild("Troll")
               local Health = Workspace:FindFirstChild("TrollHealth")
               if Sword then
                   Sword.Handle.Size = Vector3.new(20, 20, 500)
                   Sword:Activate()
               end
               if HRP and Boss then
                   HRP.CFrame = Boss.CFrame * CFrame.new(0, 0, -15)
               end
               if Health and Health.Value <= 0 then
                   AutobossEnabled = false
                   BossThread:Disconnect()
               end
           end)
       end
   end
})

-- Teleports
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
AddVersionLabel(TeleportTab)
TeleportTab:CreateButton({Name = "Arena", Callback = function()
   LocalPlayer.Character:PivotTo(CFrame.new(158.4, 390.2, -165.9))
end})
TeleportTab:CreateButton({Name = "Main Area", Callback = function()
   LocalPlayer.Character:PivotTo(CFrame.new(47, 391, -185))
end})
TeleportTab:CreateButton({Name = "Stand Farm", Callback = function()
   LocalPlayer.Character:PivotTo(CFrame.new(-225, 461, -1396))
end})

-- Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({
   Title = "Made by skulldagrait",
   Content = "GitHub: github.com/skulldagrait\nDiscord: skulldagrait\nServer: discord.gg/yTfcM6VNs8"
})
