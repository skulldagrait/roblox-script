-- Stands Awakening Hub – by skulldagrait
-- Version v1.1

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
  ["Camera"] = true, ["Pot"] = true, ["Dio's Skull"] = true, ["Uncanny Key"] = true,
  ["Samurai Diary"] = true
}
local veryRareItems = {
  ["Canny Key"] = true
}

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
  tab:CreateParagraph({ Title = "Version", Content = "v1.1" })
end

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
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild("Banknote") then
          local note = bp:FindFirstChild("Banknote")
          LocalPlayer.Character.Humanoid:EquipTool(note)
          task.wait(0.25)
          pcall(function() note:Activate() end)
        end
      end
    end)
  end
})
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
