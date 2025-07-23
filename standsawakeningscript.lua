-- Stands Awakening Hub – by skulldagrait
-- Version v1.0

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

-- Function to update Humanoid safely
local function updateHumanoid()
  if LocalPlayer.Character then
    Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
  end
end

LocalPlayer.CharacterAdded:Connect(function()
  wait(1)
  updateHumanoid()
end)

-- Helper for version display
local function showVersion(tab)
  tab:CreateParagraph({
    Title = "Version",
    Content = "v1.0"
  })
end

-- OP Tab
local OP = Window:CreateTab("Items", 4483362458)
local ignoredPosition = Vector3.new(-225, 461, -1396)
local rareItems = {
  ["Camera"] = true,
  ["Pot"] = true,
  ["Dio's Skull"] = true,
  ["Uncanny Key"] = true,
}
local veryRareItems = {
  ["Canny Key"] = true,
}

getgenv().AutoFarmItems = true
OP:CreateToggle({
  Name = "AutoFarm All Items",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoFarmItems = v
    while getgenv().AutoFarmItems do
      task.wait(0.5)
      for _,item in pairs(workspace:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("Handle") and not item:FindFirstAncestorOfClass("Model") then
          local pos = item.Handle.Position
          if (pos - ignoredPosition).magnitude > 15 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame

            local name = item.Name
            if rareItems[name] then
              Rayfield:Notify({
                Title = "High-Value Item Collected",
                Content = name .. " has been picked up. Consider storing it in the bank."
              })
            elseif veryRareItems[name] then
              Rayfield:Notify({
                Title = "VERY Rare Item Acquired!",
                Content = name .. " has been picked up. STORE IT IMMEDIATELY!"
              })
            end
          end
        end
      end
    end
  end
})

-- Auto Collect Banknote
OP:CreateToggle({
  Name = "Auto Collect Banknote",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoBanknote = v
    task.spawn(function()
      while getgenv().AutoBanknote do
        task.wait(1)
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
          local note = backpack:FindFirstChild("Banknote")
          if note then
            LocalPlayer.Character.Humanoid:EquipTool(note)
            task.wait(0.25)
            pcall(function()
              note:Activate()
            end)
          end
        end
      end
    end)
  end
})

showVersion(OP)
