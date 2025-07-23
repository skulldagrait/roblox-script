local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Stands Awakening Hub - by skulldagrait",
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
local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
-- [Insert your teleport buttons here...]

-- OP Tab (with AutoFarm)
local OP = Window:CreateTab("OP", 4483362458)
getgenv().AutoFarm = false
OP:CreateToggle({
    Name = "AutoFarm All Items",
    CurrentValue = false,
    Callback = function(val)
        getgenv().AutoFarm = val
        while getgenv().AutoFarm do
            task.wait(0.5)
            for _,item in pairs(Workspace:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    HumanoidRootPart.CFrame = item.Handle.CFrame
                end
            end
        end
    end,
})

-- Boss Tab (unchanged)
-- [Insert your Boss tab here...]

-- Visual Tab (unchanged)
-- [Insert your Visual tab here...]

-- Movement Tab
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16, Max = 500, CurrentValue = 16,
    Callback = function(val)
        if LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
        end
    end,
})
MoveTab:CreateSlider({
    Name = "JumpPower",
    Min = 50, Max = 500, CurrentValue = 50,
    Callback = function(val)
        if LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = val
        end
    end,
})
getgenv().InfJump = false
MoveTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(val) getgenv().InfJump = val end
})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

getgenv().Noclip = false
MoveTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(val) getgenv().Noclip = val end
})
RunService.Stepped:Connect(function()
    if getgenv().Noclip and LocalPlayer.Character then
        for _,part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local flyScript = [[
-- Basic Fly script
local plr = game.Players.LocalPlayer
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
local flying = true
hum.PlatformStand = true
local bg = Instance.new("BodyGyro", plr.Character.PrimaryPart)
local bv = Instance.new("BodyVelocity", plr.Character.PrimaryPart)
bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(9e9,9e9,9e9)
game:GetService("UserInputService").InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.E then
        flying = not flying
        hum.PlatformStand = flying
        if not flying then bg:Destroy(); bv:Destroy() end
    end
end)
RunService:BindToRenderStep("Fly",200,function()
    if flying then
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
        bg.CFrame = workspace.CurrentCamera.CFrame
    end
end)
]]
MoveTab:CreateButton({
    Name = "Fly (Toggle with E)",
    Callback = function()
        loadstring(flyScript)()
    end,
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({
    Title = "By skulldagrait",
    Content = "YouTube.com/@skulldagrait\nGitHub: skulldagrait\nDiscord: discord.gg/wUtef63fms"
})
