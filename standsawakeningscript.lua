-- Stands Awakening Hub – by skulldagrait
-- Version v1.4

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
local Lighting = game:GetService("Lighting")
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local rareItems = {
    ["Camera"] = true,
    ["Pot"] = true,
    ["Dio's Skull"] = true,
    ["Uncanny Key"] = true,
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
    tab:CreateParagraph({ Title = "Version", Content = "v1.4" })
end

-- Teleport Tab
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
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if item:IsA("Tool") and item.Name == "Banknote" then
                        LocalPlayer.Character.Humanoid:EquipTool(item)
                        task.wait(0.2)
                        pcall(function() item:Activate() end)
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

MoveTab:CreateToggle({
    Name = "Speed Boost (Blatant)",
    CurrentValue = false,
    Callback = function(v)
        updateHumanoid()
        if Humanoid then
            Humanoid.WalkSpeed = v and 80 or 16
        end
    end
})

MoveTab:CreateToggle({
    Name = "Jump Boost (Blatant)",
    CurrentValue = false,
    Callback = function(v)
        updateHumanoid()
        if Humanoid then
            Humanoid.JumpPower = v and 150 or 50
        end
    end
})

MoveTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        getgenv().InfJump = v
    end
})
UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

MoveTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        if v then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local BodyGyro = Instance.new("BodyGyro", hrp)
            BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.P = 9e4
            BodyGyro.CFrame = hrp.CFrame

            local BodyVelocity = Instance.new("BodyVelocity", hrp)
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BodyVelocity.Velocity = Vector3.zero

            getgenv().FlyConn = RunService.RenderStepped:Connect(function()
                BodyGyro.CFrame = workspace.CurrentCamera.CFrame
                BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 80
            end)
            getgenv().FlyParts = {BodyGyro, BodyVelocity}
        else
            if getgenv().FlyConn then getgenv().FlyConn:Disconnect() end
            if getgenv().FlyParts then
                for _,v in pairs(getgenv().FlyParts) do
                    if v and v.Destroy then v:Destroy() end
                end
            end
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        local vu = game:service('VirtualUser')
        LocalPlayer.Idled:connect(function()
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
