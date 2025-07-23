-- Stands Awakening Hub – by skulldagrait
-- Version v1.2

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
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local rareItems = {
  ["Camera"] = true, ["Pot"] = true, ["Dio's Skull"] = true,
  ["Uncanny Key"] = true, ["Samurai Diary"] = true
}
local veryRareItems = { ["Canny Key"] = true }

local function updateHumanoid()
  if LocalPlayer.Character then
    Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
  end
end

LocalPlayer.CharacterAdded:Connect(function()
  wait(1)
  updateHumanoid()
end)

local function showVersion(tab)
  tab:CreateParagraph({ Title = "Version", Content = "v1.2" })
end

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
  {"D4C Location", Vector3.new(-3070,464,-421)}
}
for _,tp in ipairs(teleports) do
  TeleportTab:CreateButton({
    Name = tp[1],
    Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tp[2])
      end
    end
  })
end
showVersion(TeleportTab)

-- Boss Tab
local BossTab = Window:CreateTab("Boss", 4483362458)
BossTab:CreateButton({
  Name = "Kill Nearest Boss",
  Callback = function()
    for _,mob in pairs(workspace:GetChildren()) do
      if mob:FindFirstChildOfClass("Humanoid") and mob.Name:match("Boss") then
        mob:FindFirstChildOfClass("Humanoid").Health = 0
      end
    end
  end
})
showVersion(BossTab)

-- Items Tab
local ItemsTab = Window:CreateTab("Items", 4483362458)
local ignoredPos = Vector3.new(-225, 461, -1396)
ItemsTab:CreateToggle({
  Name = "AutoFarm All Items",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoFarmItems = v
    task.spawn(function()
      while getgenv().AutoFarmItems do
        task.wait(0.5)
        for _,item in pairs(workspace:GetChildren()) do
          if item:IsA("Tool") and item:FindFirstChild("Handle") and not item:FindFirstAncestorOfClass("Model") then
            if (item.Handle.Position - ignoredPos).Magnitude > 15 then
              LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame
            end
          end
        end
      end
    end)
  end
})

ItemsTab:CreateToggle({
  Name = "Auto Collect Banknote",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoBanknote = v
    task.spawn(function()
      while getgenv().AutoBanknote do
        task.wait(1)
        local function tryUseBanknote(container)
          if container then
            for _, tool in ipairs(container:GetChildren()) do
              if tool.Name == "Banknote" and tool:IsA("Tool") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                wait(0.3)
                pcall(function() tool:Activate() end)
              end
            end
          end
        end
        tryUseBanknote(LocalPlayer:FindFirstChild("Backpack"))
        tryUseBanknote(LocalPlayer.Character)
      end
    end)
  end
})

-- Notify on rare tool
task.spawn(function()
  while true do
    task.wait(5)
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
      if rareItems[tool.Name] then
        Rayfield:Notify({ Title = "Rare Item!", Content = tool.Name .. " is rare. Store it in the bank!" })
      elseif veryRareItems[tool.Name] then
        Rayfield:Notify({ Title = "VERY RARE!", Content = tool.Name .. " is VERY RARE. Store it ASAP!" })
      end
    end
  end
end)
showVersion(ItemsTab)

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", 4483362458)
VisualTab:CreateButton({
  Name = "Enable Fullbright",
  Callback = function()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 3
    Lighting.ClockTime = 12
    Lighting.FogEnd = 10000
    Lighting.GlobalShadows = false
  end
})
VisualTab:CreateButton({
  Name = "FPS Booster",
  Callback = function()
    for _,v in pairs(workspace:GetDescendants()) do
      if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        v.Enabled = false
      elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
      elseif v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
      end
    end
  end
})
showVersion(VisualTab)

-- Movement Tab
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSlider({
  Name = "WalkSpeed",
  Min = 16, Max = 500, CurrentValue = 16,
  Callback = function(v)
    updateHumanoid()
    if Humanoid then Humanoid.WalkSpeed = v end
  end
})
MoveTab:CreateSlider({
  Name = "JumpPower",
  Min = 50, Max = 500, CurrentValue = 50,
  Callback = function(v)
    updateHumanoid()
    if Humanoid then Humanoid.JumpPower = v end
  end
})
getgenv().InfJump = false
MoveTab:CreateToggle({
  Name = "Infinite Jump",
  CurrentValue = false,
  Callback = function(v) getgenv().InfJump = v end
})
UserInputService.JumpRequest:Connect(function()
  if getgenv().InfJump and Humanoid then
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end)
getgenv().Noclip = false
MoveTab:CreateToggle({
  Name = "Noclip",
  CurrentValue = false,
  Callback = function(v) getgenv().Noclip = v end
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
    local flying = false
    local bv, bg
    UserInputService.InputBegan:Connect(function(input)
      if input.KeyCode == Enum.KeyCode.E then
        flying = not flying
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if flying and hrp then
          bv = Instance.new("BodyVelocity", hrp)
          bg = Instance.new("BodyGyro", hrp)
          bv.MaxForce = Vector3.new(1e5,1e5,1e5)
          bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        elseif bv and bg then
          bv:Destroy() bg:Destroy()
        end
      end
    end)
    RunService.RenderStepped:Connect(function()
      if flying and bv and bg then
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
        bg.CFrame = workspace.CurrentCamera.CFrame
      end
    end)
  end
})
showVersion(MoveTab)

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateButton({
  Name = "Anti-AFK",
  Callback = function()
    local vu = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:Connect(function()
      vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      wait(1)
      vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
  end
})
showVersion(MiscTab)

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({
  Title = "By skulldagrait",
  Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: discord.gg/wUtef63fms"
})
showVersion(CreditsTab)
