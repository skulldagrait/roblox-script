local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Window = Fluent:CreateWindow({
    Title = "Steal A Brainrot - By skulldagrait",
    SubTitle = "By skulldagrait",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = nil
})

Fluent:SetTheme({
    Background = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(180, 40, 180)
})

local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "box"}),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "eye"}),
    Teleport = Window:AddTab({Title = "Teleport", Icon = "map-pin"}),
    Server = Window:AddTab({Title = "Server", Icon = "server"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"}),
    Credits = Window:AddTab({Title = "Credits", Icon = "info"})
}

Tabs.Credits:AddParagraph({
    Title = "By skulldagrait",
    Content = "Designed, scripted and developed by skulldagrait."
})

Tabs.Visuals:AddToggle("Fullbright", {
    Title = "Fullbright",
    Default = false,
    Callback = function(state)
        Lighting.Ambient = state and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5)
        Lighting.Brightness = state and 2 or 1
        Lighting.GlobalShadows = not state
    end
})

Tabs.Visuals:AddButton({
    Title = "FPS Boost",
    Callback = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Material ~= Enum.Material.ForceField then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end
})

local speedValue = 0
local speedConnection
local function updateSpeed()
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = RunService.Heartbeat:Connect(function()
        if character and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            character:TranslateBy(humanoid.MoveDirection * speedValue * 0.1)
        end
    end)
end

Tabs.Main:AddSlider("SpeedSlider", {
    Title = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(value)
        speedValue = value
        updateSpeed()
    end
})

Tabs.Main:AddButton({
    Title = "Steal Brainrots",
    Callback = function()
        local pos = CFrame.new(0, -500, 0)
        local startTime = os.clock()
        while os.clock() - startTime < 1 do
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = pos
                task.wait()
            end
        end
    end
})

Tabs.Main:AddButton({
    Title = "Invisibility Glitch",
    Callback = function()
        local cloak = character:FindFirstChild("Invisibility Cloak")
        if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
            cloak.Parent = workspace
            Fluent:Notify({Title = "Success", Content = "Invisibility glitch activated!", Duration = 3})
        else
            Fluent:Notify({Title = "Error", Content = "Equip Invisibility Cloak first!", Duration = 3})
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Spawn",
    Callback = function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn")
        if spawn and character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 5, 0))
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Find Highest Brainrot",
    Callback = function()
        local highest = nil
        local maxY = -math.huge
        for _, part in ipairs(workspace:GetDescendants()) do
            if part.Name:lower():find("brainrot") and part:IsA("BasePart") and part.Position.Y > maxY then
                maxY = part.Position.Y
                highest = part
            end
        end
        if highest and character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(highest.Position + Vector3.new(0, 3, 0))
        end
    end
})

Tabs.Server:AddButton({
    Title = "Server Hop",
    Callback = function()
        local servers = {}
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        else
            Fluent:Notify({Title = "Error", Content = "No available servers found", Duration = 3})
        end
    end
})

Tabs.Server:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

local sessionTimer = Tabs.Settings:AddParagraph({
    Title = "Session Time: 00:00:00",
    Content = ""
})

task.spawn(function()
    local startTime = os.time()
    while task.wait(1) do
        local elapsed = os.time() - startTime
        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = elapsed % 60
        sessionTimer:SetTitle(string.format("Session Time: %02d:%02d:%02d", h, m, s))
    end
end)

player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"ESP", "speedValue"})
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Steal A Brainrot - By skulldagrait",
    Content = "GUI loaded successfully",
    Duration = 4
})
