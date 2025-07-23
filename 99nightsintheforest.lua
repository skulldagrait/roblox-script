local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "99 Nights in the Forest - AutoWin Hub by skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "99NightsHub",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

-- Auto Anti-AFK
task.spawn(function()
    while true do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        task.wait(300) -- every 5 minutes
    end
end)

-- Auto Win logic
local autoWinEnabled = false
local function AutoWinLoop()
    while autoWinEnabled do
        -- 1. Collect Wood
        for _, wood in pairs(Workspace.Wood:GetChildren()) do
            local log = wood:FindFirstChild("Log")
            if log and log:FindFirstChild("ProximityPrompt") then
                HumanoidRootPart.CFrame = log.CFrame + Vector3.new(0,3,0)
                fireproximityprompt(log.ProximityPrompt)
                task.wait(1)
            end
        end

        -- 2. Build Shelter
        local buildEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("BuildShelter")
        if buildEvent then
            buildEvent:FireServer()
        end

        -- 3. Light Campfire
        local lightEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("LightFire")
        if lightEvent then
            lightEvent:FireServer()
        end

        -- 4. Fuel Campfire (if separate fuel logic exists)

        -- 5. Check Hunger and hunt animals
        local hunger = LocalPlayer:FindFirstChild("Hunger") and LocalPlayer.Hunger.Value or 100
        if hunger < 20 then
            for _, animal in pairs(Workspace:GetDescendants()) do
                if animal.Name == "Rabbit" or animal.Name == "Wolf" then
                    HumanoidRootPart.CFrame = animal.CFrame + Vector3.new(0,3,0)
                    -- Add kill logic if known
                    task.wait(1)
                end
            end
        end

        task.wait(2)
    end
end

-- Deer avoidance
local deerProtectionEnabled = true
task.spawn(function()
    while true do
        if deerProtectionEnabled then
            for _, ent in pairs(Workspace:GetDescendants()) do
                if ent.Name == "Deer" and ent:IsA("Model") then
                    local dist = (ent.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude
                    if dist < 20 then -- adjust safe range
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0,20,0)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- ESP logic (Collectibles + NPCs)
local function AddESP(name)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == name and obj:IsA("BasePart") then
            local billboard = Instance.new("BillboardGui", obj)
            billboard.Size = UDim2.new(0,100,0,20)
            billboard.Adornee = obj
            billboard.AlwaysOnTop = true
            local textLabel = Instance.new("TextLabel", billboard)
            textLabel.Size = UDim2.new(1,0,1,0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = name
            textLabel.TextColor3 = Color3.new(1,1,1)
            textLabel.TextScaled = true
        end
    end
end

-- ESP for main categories
AddESP("Log")
AddESP("Rabbit")
AddESP("Wolf")
AddESP("Deer")
AddESP("Chest")
AddESP("Bed")
AddESP("CraftingBench")

-- GUI Tabs and Toggles
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
    Name = "Auto Win (Collect, Build, Light Fire)",
    CurrentValue = false,
    Callback = function(Value)
        autoWinEnabled = Value
        if Value then
            AutoWinLoop()
        end
    end,
})

local ProtectionTab = Window:CreateTab("Protection", 4483362458)

ProtectionTab:CreateButton({
    Name = "Become Safe (Fly up with Airwalk)",
    Callback = function()
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0,20,0)
        -- Airwalk logic here (anchor position if needed)
    end,
})

ProtectionTab:CreateToggle({
    Name = "Auto TP to SafeZone if Attacked",
    CurrentValue = true,
    Callback = function(Value)
        deerProtectionEnabled = Value
    end,
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1,1,1)
        lighting.Brightness = 2
        lighting.ClockTime = 12
        lighting.FogEnd = 10000
        lighting.GlobalShadows = false
    end,
})

VisualTab:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end,
})

-- Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script by skulldagrait",
    Content = "Discord: skulldagrait\nYouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait"
})
