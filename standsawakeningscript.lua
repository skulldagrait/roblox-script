local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
end)
if not success or not Rayfield then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local staffList = {
    [1534146802] = true,
    [724026832]  = true,
    [1484252645] = true,
    [2938109169] = true,
    [1552962633] = true,
}

local StaffDetected = false
local function checkForStaff(player)
    if StaffDetected then return end
    if staffList[player.UserId] then
        StaffDetected = true
        LocalPlayer:Kick("Staff detected: " .. player.Name)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        checkForStaff(player)
    end
end

Players.PlayerAdded:Connect(checkForStaff)

local Window = Rayfield:CreateWindow({
    Name = "Skulldagrait - Stands Awakening",
    LoadingTitle = "Skulldagrait Hub",
    LoadingSubtitle = "by skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SkulldagraitHub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local autobossRunning = false

local autobossSection = Window:CreateTab("AutoBoss")
local fpsSection = Window:CreateTab("FPS Booster")
local teleportSection = Window:CreateTab("Teleports")
local miscSection = Window:CreateTab("Miscellaneous")

autobossSection:CreateToggle({
    Name = "Enable AutoBoss",
    CurrentValue = false,
    Flag = "AutoBossToggle",
    Callback = function(value)
        autobossRunning = value
        if value then
            task.spawn(function()
                repeat
                    task.wait()
                    if not autobossRunning then break end
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Workspace:FindFirstChild("Dead") and Workspace.Dead.Value == false then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        if Workspace:FindFirstChild("BossPhase") then
                            if Workspace.BossPhase.Value == "None" then
                                hrp.CFrame = CFrame.new(-5.47, -4.45, 248.21)
                            else
                                hrp.CFrame = CFrame.new(-19.89, -4.77, 142.49)
                            end
                        end
                    end
                until not autobossRunning
            end)
        end
    end
})

local fpsBoostActive = false
fpsSection:CreateToggle({
    Name = "Enable FPS Booster",
    CurrentValue = false,
    Flag = "FPSBoosterToggle",
    Callback = function(enabled)
        fpsBoostActive = enabled
        if enabled then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                end
            end
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            pcall(function()
                if Workspace:FindFirstChildOfClass("Lighting") then
                    for _, light in pairs(Workspace:GetDescendants()) do
                        if light:IsA("ShadowMapLighting") then
                            light.Enabled = false
                        end
                    end
                end
            end)
        else
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = true
                end
            end
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
        end
    end
})

teleportSection:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5.47, -4.45, 248.21)
        end
    end
})

teleportSection:CreateButton({
    Name = "Teleport to Boss",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-19.89, -4.77, 142.49)
        end
    end
})

miscSection:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

miscSection:CreateButton({
    Name = "Serverhop",
    Callback = function()
        task.spawn(function()
            local placeId = game.PlaceId
            local jobId = game.JobId
            local serversUrl = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
            local response = HttpService:GetAsync(serversUrl)
            local data = HttpService:JSONDecode(response)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= jobId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id)
                    break
                end
            end
        end)
    end
})

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(0, 300, 0, 30)
creditLabel.Position = UDim2.new(0, 10, 1, -40)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditLabel.Text = "Made by skulldagrait"
creditLabel.Font = Enum.Font.GothamBold
creditLabel.TextSize = 14
creditLabel.TextXAlignment = Enum.TextXAlignment.Right
creditLabel.Parent = Rayfield.UI.Window
