loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
   Name = "Elemental Grind GUI | Made by skulldagrait",
   LoadingTitle = "Elemental Grind GUI",
   LoadingSubtitle = "by skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EGGConfigs",
      FileName = "ElementalGrindGUI"
   },
   Discord = {
      Enabled = true,
      Invite = "FmMuvkaWvG",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
local InfoSection = MainTab:CreateSection("Info")
MainTab:CreateParagraph({Title = "Elemental Grind GUI", Content = "Made by skulldagrait\nDiscord: FmMuvkaWvG"})

local AutoTab = Window:CreateTab("Auto", 4483362458)
local FarmSection = AutoTab:CreateSection("Auto Farm")

local autoFarmEnabled = false
AutoTab:CreateToggle({
   Name = "Auto Farm Enemies",
   CurrentValue = false,
   Callback = function(Value)
       autoFarmEnabled = Value
       if autoFarmEnabled then
           while autoFarmEnabled do
               local enemies = workspace:FindFirstChild("NPCs")
               if enemies then
                   for _, enemy in ipairs(enemies:GetChildren()) do
                       if enemy:FindFirstChild("HumanoidRootPart") then
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                           wait(0.3)
                       end
                   end
               end
               wait(0.5)
           end
       end
   end,
})

local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Utilities")

MiscTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

MiscTab:CreateButton({
   Name = "Anti AFK",
   Callback = function()
       game:GetService("Players").LocalPlayer.Idled:connect(function()
           game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
           wait(1)
           game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
       end)
   end,
})

local CreditsTab = Window:CreateTab("Credits", 4483362458)
local CreditsSection = CreditsTab:CreateSection("Made By")
CreditsTab:CreateParagraph({Title = "Credits", Content = "Made by skulldagrait\nDiscord: FmMuvkaWvG"})

Rayfield:LoadConfiguration()
