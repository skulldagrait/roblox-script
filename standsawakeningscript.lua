-- Stands Awakening Hub – by skulldagrait
-- Version v1.9

repeat wait() until game:IsLoaded() and game:GetService("Players")
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

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
  tab:CreateParagraph({ Title = "Version", Content = "v1.9" })
end

-- TELEPORT TAB
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

-- BOSS TAB
local BossTab = Window:CreateTab("Boss", 4483362458)
BossTab:CreateToggle({
  Name = "AutoBoss (Kill boss and auto-move)",
  CurrentValue = false,
  Callback = function(enabled)
    if not enabled then return end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character and Character:WaitForChild("Humanoid")
    local Attacking = workspace:WaitForChild("Dead")
    local Obby = workspace:WaitForChild("ObbyW")
    local Phase = workspace:WaitForChild("BossPhase")
    local Health = workspace:WaitForChild("TrollHealth")
    local WaitTime = 2
    local Time = true

    if workspace:FindFirstChild("Effects") then workspace.Effects:Destroy() end
    if workspace.Map:FindFirstChild("ThunderParts") then workspace.Map.ThunderParts:Destroy() end

    -- Equip Sword & Enlarge Hitbox
    local function equipSword()
      if LocalPlayer.Backpack:FindFirstChild("KnightsSword") then
        LocalPlayer.Backpack["KnightsSword"].Parent = Character
      end
      if Character:FindFirstChild("KnightsSword") then
        local Sword = Character:FindFirstChild("KnightsSword")
        local Box = Instance.new("SelectionBox")
        Box.Name = "SelectionBoxCreated"
        Box.Parent = Sword.Handle
        Box.Adornee = Sword.Handle
        Sword.Handle.Massless = true
        Sword.GripPos = Vector3.new(0,0,0)
        Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
        Sword.Handle.Size = Vector3.new(20, 20, 500)
      end
    end

    equipSword()

    -- Auto TP
    task.spawn(function()
      while Attacking.Value == false do
        task.wait()
        if Obby.Value == true then
          HumanoidRootPart.CFrame = CFrame.new(20.45, 113.24, 196.61)
        else
          if Phase.Value == "None" then
            HumanoidRootPart.CFrame = CFrame.new(-5.46, -4.45, 248.21)
          else
            HumanoidRootPart.CFrame = CFrame.new(-19.89, -4.77, 142.49)
          end
        end
      end
    end)

    -- Attack
    task.spawn(function()
      while Attacking.Value == false do
        task.wait()
        if Obby.Value == false and Character:FindFirstChild("KnightsSword") then
          Character.KnightsSword:Activate()
        end
      end
    end)

    -- Final health check
    local function Percent(first, second)
      return (first / second)
    end
    Health:GetPropertyChangedSignal("Value"):Connect(function()
      if Percent(Health.Value, Health.MaxHealth.Value) <= 0.003 and Time then
        Time = false
        Humanoid:UnequipTools()
        wait(WaitTime)
        if LocalPlayer.Backpack:FindFirstChild("KnightsSword") then
          LocalPlayer.Backpack["KnightsSword"].Parent = Character
        end
      end
    end)
  end
})
showVersion(BossTab)
