local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "99 Nights In The Forest - Hub by skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "99NITF_Hub",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK (auto enabled)
task.spawn(function()
    while true do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        task.wait(300) -- jumps every 5 mins
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        end
    end
end)

-- Visuals auto on load
local lighting = game:GetService("Lighting")
lighting.Ambient = Color3.new(0.6,0.6,0.6)
lighting.Brightness = 3
lighting.ClockTime = 12
lighting.FogEnd = 10000
lighting.GlobalShadows = false

for _,v in pairs(Workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        v.Enabled = false
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
    elseif v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
        if v.Material ~= Enum.Material.SmoothPlastic then
            v.Material = Enum.Material.SmoothPlastic
        end
        v.Reflectance = 0
    end
end

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local ProtectionTab = Window:CreateTab("Protection", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)

-- Auto Win Function
local function AutoWin()
    local events = ReplicatedStorage:FindFirstChild("Events")
    if not events then
        print("Events folder not found")
        return
    end

    local buildShelter = events:FindFirstChild("BuildShelter")
    local lightFire = events:FindFirstChild("LightFire")
    if not buildShelter or not lightFire then
        print("Required RemoteEvents missing")
        return
    end

    -- Chop wood
    for _,log in pairs(Workspace.Wood:GetDescendants()) do
        if log:IsA("ProximityPrompt") then
            fireproximityprompt(log)
            task.wait(0.5)
        end
    end

    -- Build shelter
    buildShelter:FireServer()
    task.wait(0.5)

    -- Light fire
    lightFire:FireServer()
end

MainTab:CreateButton({
    Name = "Auto Win",
    Callback = function()
        pcall(function()
            AutoWin()
        end)
    end,
})

-- Become Safe toggle (airwalk + float)
local safeFloat = false
local safeConnection

ProtectionTab:CreateToggle({
    Name = "Auto Float (Stay Safe)",
    CurrentValue = false,
    Callback = function(Value)
        safeFloat = Value
        if safeFloat then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                safeConnection = RunService.Heartbeat:Connect(function()
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.1, 0)
                end)
            end
        else
            if safeConnection then
                safeConnection:Disconnect()
                safeConnection = nil
            end
        end
    end,
})

ProtectionTab:CreateButton({
    Name = "Become Safe (Teleport Up + Airwalk)",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0,20,0)
            safeFloat = true
            if not safeConnection then
                safeConnection = RunService.Heartbeat:Connect(function()
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.1, 0)
                end)
            end
        end
    end,
})

-- Credits
CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
