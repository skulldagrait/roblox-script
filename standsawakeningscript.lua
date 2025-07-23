-- Stands Awakening Hub – by skulldagrait
-- Version v1.8

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

local rareItems = {
  ["Camera"] = true, ["Pot"] = true, ["Dio's Skull"] = true, ["Uncanny Key"] = true,
  ["Samurai Diary"] = true
}
local veryRareItems = {
  ["Canny Key"] = true
}

local function updateHumanoid()
  if LocalPlayer.Character then
    return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
  end
end

local function showVersion(tab)
  tab:CreateParagraph({ Title = "Version", Content = "v1.8" })
end

-- TELEPORT TAB
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local teleports = {
  {"Timmy NPC", Vector3.new(1394,584,-219)},
  {"Tim NPC", Vector3.new(1399,584,-216)},
  {"Tom NPC", Vector3.new(1343,587,-554)},
  {"Sans NPC", Vector3.new(1045,583,-442)},
  {"Donation Leaderboard", Vector3.new(1670,583,-506)},
  {"Waterfall (Key spawn)", Vector3.new(1625,578,-747)},
  {"Doghouse (Key spawn)", Vector3.new(1033,583,-178)},
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
  Name = "AutoBoss (v1.8)",
  CurrentValue = false,
  Callback = function(v)
    getgenv().AutoBoss = v
    task.spawn(function()
      while getgenv().AutoBoss do
        task.wait(1)
        for _, obj in ipairs(workspace:GetDescendants()) do
          if obj:IsA("ProximityPrompt") then
            fireproximityprompt(obj)
            break
          elseif obj:IsA("ClickDetector") then
            fireclickdetector(obj)
            break
          end
        end
        task.wait(3)
        for _, mob in ipairs(workspace:GetChildren()) do
          local hum = mob:FindFirstChildOfClass("Humanoid")
          if hum and mob.Name:lower():find("boss") then
            hum.Health = 0
          end
        end
      end
    end)
  end
})
showVersion(BossTab)

-- ITEMS TAB
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
        local inv = LocalPlayer:GetChildren()
        for _,cont in pairs(inv) do
          if cont:IsA("Backpack") or cont:IsA("Model") then
            local note = cont:FindFirstChild("Banknote")
            if note and note:IsA("Tool") then
              LocalPlayer.Character.Humanoid:EquipTool(note)
              task.wait(0.25)
              pcall(function() note:Activate() end)
            end
          end
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

-- MOVEMENT TAB
local MovementTab = Window:CreateTab("Movement", 4483362458)
MovementTab:CreateToggle({
  Name = "Fly",
  CurrentValue = false,
  Callback = function(v)
    getgenv().Flying = v
    local bodyGyro, bodyVel
    local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    if v then
      bodyGyro = Instance.new("BodyGyro", hrp)
      bodyGyro.P = 9e4
      bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
      bodyGyro.cframe = hrp.CFrame
      bodyVel = Instance.new("BodyVelocity", hrp)
      bodyVel.velocity = Vector3.zero
      bodyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)
      RunService.RenderStepped:Connect(function()
        if not getgenv().Flying then return end
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += hrp.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= hrp.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= hrp.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += hrp.CFrame.RightVector end
        move += Vector3.new(0, 0.5, 0)
        bodyVel.velocity = move * 50
        bodyGyro.cframe = hrp.CFrame
      end)
    else
      if bodyGyro then bodyGyro:Destroy() end
      if bodyVel then bodyVel:Destroy() end
    end
  end
})
MovementTab:CreateToggle({
  Name = "Infinite Jump",
  CurrentValue = false,
  Callback = function(v)
    getgenv().InfJump = v
  end
})
UserInputService.JumpRequest:Connect(function()
  if getgenv().InfJump and LocalPlayer.Character then
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
  end
end)
showVersion(MovementTab)

-- MISC TAB
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateButton({
  Name = "Anti-AFK",
  Callback = function()
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do
      v:Disable()
    end
    Rayfield:Notify({ Title = "Anti-AFK Enabled", Content = "You will no longer get kicked for being idle." })
  end
})
showVersion(MiscTab)
