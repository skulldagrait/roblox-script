-- Version: v1.0
local VERSION = "v1.0"

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
local UIS = game:GetService("UserInputService")
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local function createVersionLabel(tab)
  tab:CreateParagraph({ Title = "", Content = "Version: " .. VERSION })
end

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
createVersionLabel(TeleportTab)
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

-- AutoFarm + Item Handling
local OP = Window:CreateTab("Items", 4483362458)
createVersionLabel(OP)

local STANDFARM_POS = Vector3.new(-225, 461, -1396)
local RARE_ITEMS = {"Camera", "Pot", "DIO's Skull", "Uncanny Key"}
local VERY_RARE_ITEMS = {"Canny Key"}

getgenv().AutoFarm = false
OP:CreateToggle({
  Name = "AutoFarm All Items",
  CurrentValue = false,
  Callback = function(v)
    getgenv().AutoFarm = v
    while getgenv().AutoFarm do
      task.wait(0.5)
      for _,item in pairs(workspace:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("Handle") and not item.Parent:IsA("Model") then
          local pos = item.Handle.Position
          if (pos - STANDFARM_POS).Magnitude > 50 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame

            local itemName = item.Name
            if table.find(RARE_ITEMS, itemName) then
              Rayfield:Notify({ Title = "Rare Item Acquired", Content = itemName .. " picked up! Store it in your bank!" })
            elseif table.find(VERY_RARE_ITEMS, itemName) then
              Rayfield:Notify({ Title = "VERY RARE ITEM!", Content = itemName .. " picked up! STORE THIS IN BANK ASAP!" })
            end
          end
        end
      end
    end
  end,
})

OP:CreateToggle({
  Name = "Auto Collect Banknote",
  CurrentValue = false,
  Callback = function(state)
    getgenv().AutoBanknote = state
    while getgenv().AutoBanknote do
      task.wait(0.25)
      local backpack = LocalPlayer:FindFirstChild("Backpack")
      if backpack then
        local banknote = backpack:FindFirstChild("Banknote")
        if banknote then
          LocalPlayer.Character.Humanoid:EquipTool(banknote)
          banknote:Activate()
        end
      end
    end
  end
})

-- Boss Tab
local BossTab = Window:CreateTab("Boss", 4483362458)
createVersionLabel(BossTab)
BossTab:CreateButton({
  Name = "AutoBoss (Kill nearest boss)",
  Callback = function()
    for _,mob in pairs(workspace:GetChildren()) do
      if mob:FindFirstChildOfClass("Humanoid") and mob.Name:match("Boss") then
        mob:FindFirstChildOfClass("Humanoid").Health = 0
      end
    end
  end,
})

-- Movement Tab
local MoveTab = Window:CreateTab("Movement", 4483362458)
createVersionLabel(MoveTab)

MoveTab:CreateSlider({
  Name = "WalkSpeed",
  Min = 16, Max = 750, CurrentValue = 16,
  Callback = function(v)
    if LocalPlayer.Character then
      local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
      if hum then hum.WalkSpeed = v end
    end
  end,
})

MoveTab:CreateSlider({
  Name = "JumpPower",
  Min = 50, Max = 750, CurrentValue = 50,
  Callback = function(v)
    if LocalPlayer.Character then
      local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
      if hum then hum.JumpPower = v end
    end
  end,
})

getgenv().InfJump = false
MoveTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) getgenv().InfJump = v end })
UIS.JumpRequest:Connect(function()
  if getgenv().InfJump and Humanoid then
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end)

getgenv().Noclip = false
MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) getgenv().Noclip = v end })
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
    local Fly = false
    local bv, bg
    UIS.InputBegan:Connect(function(i)
      if i.KeyCode == Enum.KeyCode.E then
        Fly = not Fly
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if Fly and hrp then
          bg = Instance.new("BodyGyro", hrp)
          bv = Instance.new("BodyVelocity", hrp)
          bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
          bv.MaxForce = Vector3.new(1e9,1e9,1e9)
          RunService.RenderStepped:Connect(function()
            if Fly then
              bg.CFrame = workspace.CurrentCamera.CFrame
              bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
            end
          end)
        elseif not Fly then
          if bg then bg:Destroy() end
          if bv then bv:Destroy() end
        end
      end
    end)
  end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
createVersionLabel(MiscTab)
MiscTab:CreateToggle({
  Name = "Anti-AFK (Auto jump/move every 5 min)",
  CurrentValue = false,
  Callback = function(enabled)
    getgenv().AntiAFK = enabled
    while getgenv().AntiAFK do
      task.wait(300)
      if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
  end
})

-- Settings (Themes)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
createVersionLabel(SettingsTab)
SettingsTab:CreateDropdown({
  Name = "Theme",
  Options = {"Default", "Dark", "Blood Red", "Ocean Blue"},
  CurrentOption = "Default",
  Callback = function(selected)
    Rayfield:SetTheme(selected)
  end
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)
createVersionLabel(CreditsTab)
CreditsTab:CreateParagraph({
  Title = "By skulldagrait",
  Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: discord.gg/wUtef63fms"
})
