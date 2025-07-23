-- Stands Awakening Hub – by skulldagrait (Codex + Android Friendly)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
  Name = "Stands Awakening Hub – by skulldagrait",
  LoadingTitle = "Loading...",
  LoadingSubtitle = "By skulldagrait",
  ConfigurationSaving = { Enabled = true, FolderName = "SA_Hub", FileName = "Config" },
  Discord = { Enabled = false },
  KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local teleports = {
  {"Timmy NPC", Vector3.new(1394,584,-219)},
  {"Tim NPC",   Vector3.new(1399,584,-216)},
  {"Tom NPC",   Vector3.new(1343,587,-554)},
  {"Sans NPC",  Vector3.new(1045,583,-442)},
  {"Donation Leaderboard", Vector3.new(1670,583,-506)},
  {"Waterfall (Key spawn)", Vector3.new(1625,578,-747)},
  {"Doghouse (Key spawn)",  Vector3.new(1033,583,-178)},
  {"Arena", Vector3.new(1248,583,-280)},
  {"Key Portal", Vector3.new(1093,583,-699)},
  {"Stand/Arrow Farm", Vector3.new(-339,461,-1514)},
  {"Main Area", Vector3.new(1341,583,-482)},
  {"D4C Location", Vector3.new(-3070,464,-421)},
}
for _,tp in ipairs(teleports) do
  TeleportTab:CreateButton({ Name = tp[1], Callback = function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tp[2])
    end
  end })
end

-- Items Tab
local ItemsTab = Window:CreateTab("Items", 4483362458)
getgenv().AutoFarmItems = false
local rareItems = {"DIO's Diary", "Requiem Arrow", "Camera", "Bone", "Stone Mask"}
ItemsTab:CreateToggle({
  Name = "AutoFarm All Items (Full Map)",
  CurrentValue = false,
  Callback = function(v)
    getgenv().AutoFarmItems = v
    while getgenv().AutoFarmItems do
      task.wait(0.5)
      for _,item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and item:FindFirstChild("Handle") then
          LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame + Vector3.new(0,2,0)
          if table.find(rareItems, item.Name) then
            Rayfield:Notify({
              Title = "Rare Item Collected!",
              Content = "You just got a rare item: " .. item.Name .. "\nConsider storing it in your bank.",
              Duration = 6
            })
          end
        end
      end
    end
  end,
})

-- Boss Tab
local BossTab = Window:CreateTab("Boss", 4483362458)
BossTab:CreateButton({
  Name = "AutoBoss (Kill all bosses)",
  Callback = function()
    for _,mob in pairs(workspace:GetChildren()) do
      if mob:FindFirstChildOfClass("Humanoid") and mob.Name:match("Boss") then
        mob:FindFirstChildOfClass("Humanoid").Health = 0
      end
    end
  end,
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateButton({
  Name = "Enable Fullbright",
  Callback = function()
    local light = game:GetService("Lighting")
    light.Ambient = Color3.new(0.6,0.6,0.6)
    light.Brightness = 3
    light.ClockTime = 12
    light.FogEnd = 10000
    light.GlobalShadows = false
  end,
})
VisualTab:CreateButton({
  Name = "FPS Booster",
  Callback = function()
    for _,v in pairs(workspace:GetDescendants()) do
      if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        v.Enabled = false
      elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
      elseif v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
      end
    end
  end,
})

-- Movement Tab
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSlider({
  Name = "WalkSpeed",
  Min = 16, Max = 750, CurrentValue = 16,
  Callback = function(v) if Humanoid then Humanoid.WalkSpeed = v end end,
})
MoveTab:CreateSlider({
  Name = "JumpPower",
  Min = 50, Max = 750, CurrentValue = 50,
  Callback = function(v) if Humanoid then Humanoid.JumpPower = v end end,
})
getgenv().InfJump = false
MoveTab:CreateToggle({
  Name = "Infinite Jump",
  CurrentValue = false,
  Callback = function(v) getgenv().InfJump = v end,
})
game:GetService("UserInputService").JumpRequest:Connect(function()
  if getgenv().InfJump and Humanoid then
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end)
getgenv().Noclip = false
MoveTab:CreateToggle({
  Name = "Noclip",
  CurrentValue = false,
  Callback = function(v) getgenv().Noclip = v end,
})
RunService.Stepped:Connect(function()
  if getgenv().Noclip and LocalPlayer.Character then
    for _,part in ipairs(LocalPlayer.Character:GetDescendants()) do
      if part:IsA("BasePart") then part.CanCollide = false end
    end
  end
end)
MoveTab:CreateButton({
  Name = "Toggle Fly (Press E)",
  Callback = function()
    local flyScript = [[
      local plr = game.Players.LocalPlayer
      local hum = plr.Character:FindFirstChildOfClass("Humanoid")
      if not hum then return end
      local flying = true
      hum.PlatformStand = true
      local bg = Instance.new("BodyGyro", hum.RootPart)
      local bv = Instance.new("BodyVelocity", hum.RootPart)
      bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
      bv.MaxForce = Vector3.new(9e9,9e9,9e9)
      bv.Velocity = Vector3.new(0,0,0)
      game:GetService("UserInputService").InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.E then
          flying = not flying
          hum.PlatformStand = flying
          if not flying then bg:Destroy(); bv:Destroy() end
        end
      end)
      game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
          bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
          bg.CFrame = workspace.CurrentCamera.CFrame
        end
      end)
    ]]
    loadstring(flyScript)()
  end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
getgenv().AntiAFK = false
MiscTab:CreateToggle({
  Name = "Anti-AFK (Every 5 min action)",
  CurrentValue = false,
  Callback = function(v)
    getgenv().AntiAFK = v
    while getgenv().AntiAFK do
      task.wait(300)
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        task.wait(0.5)
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame - Vector3.new(0,5,0)
      end
    end
  end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateDropdown({
  Name = "Theme",
  Options = {"Default", "Dark", "Light", "Vibrant", "Ocean"},
  CurrentOption = "Default",
  Callback = function(option)
    Rayfield:SetTheme(option)
  end
})

-- Hide UI with RShift
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
  if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
    Rayfield:Toggle()
  end
end)

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({
  Title = "By skulldagrait",
  Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: discord.gg/wUtef63fms"
})
