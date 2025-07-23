-- Stands Awakening Hub – by skulldagrait
-- Version v1.7

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
  Name = "Stands Awakening Hub – by skulldagrait",
  LoadingTitle = "Loading...",
  LoadingSubtitle = "By skulldagrait",
  ConfigurationSaving = {
    Enabled = true,
    FolderName = "SA_Hub",
    FileName = "Config"
  },
  Discord = { Enabled = false },
  KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Humanoid
local function updateHumanoid()
  if LocalPlayer.Character then
    Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
  end
end
updateHumanoid()
LocalPlayer.CharacterAdded:Connect(function()
  wait(1)
  updateHumanoid()
end)

local rareItems = {
  ["Camera"] = true, ["Pot"] = true, ["Dio's Skull"] = true,
  ["Uncanny Key"] = true, ["Samurai Diary"] = true
}
local veryRareItems = { ["Canny Key"] = true }

local ignoredPos = Vector3.new(-225, 461, -1396)

-- Tabs
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local ItemsTab = Window:CreateTab("Items", 4483362458)
local BossTab = Window:CreateTab("Boss", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Version Display
for _,tab in pairs({TeleportTab, ItemsTab, BossTab, MovementTab, VisualsTab, MiscTab}) do
  tab:CreateParagraph({ Title = "Version", Content = "v1.7" })
end

-- Teleports
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

-- Item AutoFarm
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
  Name = "Auto Collect Banknote (anywhere)",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoBanknote = v
    task.spawn(function()
      while getgenv().AutoBanknote do
        task.wait(1)
        for _,inv in pairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
          if inv then
            local note = inv:FindFirstChild("Banknote")
            if note then
              LocalPlayer.Character.Humanoid:EquipTool(note)
              wait(0.2)
              pcall(function() note:Activate() end)
            end
          end
        end
      end
    end)
  end
})

-- Rare item notify
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

-- AutoBoss
BossTab:CreateToggle({
  Name = "Start AutoBoss",
  CurrentValue = false,
  Callback = function(v)
    getgenv().AutoBoss = v
    task.spawn(function()
      while getgenv().AutoBoss do
        task.wait(2)
        -- Trigger boss event by touching the key portal if it exists
        local portal = workspace:FindFirstChild("KeyPortal")
        if portal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
          LocalPlayer.Character.HumanoidRootPart.CFrame = portal.CFrame + Vector3.new(0, 3, 0)
          task.wait(2)
        end
        -- Kill boss
        for _,mob in pairs(workspace:GetChildren()) do
          if mob:FindFirstChildOfClass("Humanoid") and mob.Name:lower():find("boss") then
            mob:FindFirstChildOfClass("Humanoid").Health = 0
          end
        end
      end
    end)
  end
})

BossTab:CreateButton({
  Name = "Kill Nearest Boss",
  Callback = function()
    for _,mob in pairs(workspace:GetChildren()) do
      if mob:FindFirstChildOfClass("Humanoid") and mob.Name:lower():find("boss") then
        mob:FindFirstChildOfClass("Humanoid").Health = 0
      end
    end
  end
})

-- Movement
MovementTab:CreateToggle({
  Name = "Speed Boost",
  CurrentValue = false,
  Callback = function(v)
    getgenv().SpeedBoost = v
    RunService.RenderStepped:Connect(function()
      if getgenv().SpeedBoost and Humanoid then
        Humanoid.WalkSpeed = 45
      elseif Humanoid then
        Humanoid.WalkSpeed = 16
      end
    end)
  end
})

MovementTab:CreateToggle({
  Name = "Jump Boost",
  CurrentValue = false,
  Callback = function(v)
    getgenv().JumpBoost = v
    RunService.RenderStepped:Connect(function()
      if getgenv().JumpBoost and Humanoid then
        Humanoid.JumpPower = 100
      elseif Humanoid then
        Humanoid.JumpPower = 50
      end
    end)
  end
})

MovementTab:CreateButton({
  Name = "Enable Fly (toggle)",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/XPHk92R3"))()
  end
})

MovementTab:CreateToggle({
  Name = "Infinite Jump",
  CurrentValue = false,
  Callback = function(v)
    getgenv().InfJump = v
    UserInputService.JumpRequest:Connect(function()
      if getgenv().InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end
    end)
  end
})

-- Visuals
VisualsTab:CreateToggle({
  Name = "Enable Fullbright",
  CurrentValue = false,
  Callback = function(v)
    Lighting.Brightness = v and 3 or 1
    Lighting.ClockTime = v and 12 or 14
  end
})

VisualsTab:CreateToggle({
  Name = "FPS Booster (Main Game)",
  CurrentValue = false,
  Callback = function(v)
    for _, obj in pairs(workspace:GetDescendants()) do
      if obj:IsA("Part") then
        obj.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Plastic
      end
    end
  end
})

VisualsTab:CreateToggle({
  Name = "FPS Booster (Boss)",
  CurrentValue = false,
  Callback = function(v)
    for _, obj in pairs(workspace:GetDescendants()) do
      if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = not v
      end
    end
  end
})

-- Misc
MiscTab:CreateButton({
  Name = "Anti-AFK",
  Callback = function()
    local VirtualUser = game:service("VirtualUser")
    LocalPlayer.Idled:connect(function()
      VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      wait(1)
      VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
  end
})
