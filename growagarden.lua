--// Grow A Garden Ultimate AI Script by skulldagrait

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Grow A Garden | AI Hub",
    LoadingTitle = "Grow A Garden AI",
    LoadingSubtitle = "by @skulldagrait",
    ConfigurationSaving = {
       Enabled = false,
    },
    Discord = {
       Enabled = true,
       Invite = "wUtef63fms",
       RememberJoins = true
    },
    KeySystem = false,
})

local Tab = Window:CreateTab("AI", 4483362458)
local Section = Tab:CreateSection("AI Controls")

--// Variables
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local backpack = player:WaitForChild("Backpack")
local cropsThreshold = 20
local AIEnabled = false

local buySeedRemote = RS.GameEvents.BuySeedStock
local buyGearRemote = RS.GameEvents.BuyGearStock
local sellInventoryRemote = RS.GameEvents.Sell_Inventory

local seeds = require(RS.Data.SeedData)
local gears = require(RS.Data.GearData)

local seedShopUI = player.PlayerGui.Seed_Shop.Frame.ScrollingFrame
local gearShopUI = player.PlayerGui.Gear_Shop.Frame.ScrollingFrame

--// Anti-AFK
for i,v in pairs(getconnections(player.Idled)) do
    v:Disable()
end
task.spawn(function()
    while true do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        wait(300)
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Jump = true end
    end
end)

--// Functions
local function getStockAmount(shopUI, itemName)
    for _, frame in ipairs(shopUI:GetChildren()) do
        if frame.Name == itemName then
            local stockText = frame:FindFirstChild("Main_Frame") and frame.Main_Frame:FindFirstChild("Stock_Text")
            if stockText then
                local count = tonumber(stockText.Text:match("X(%d+) Stock"))
                return count or 0
            end
        end
    end
    return 0
end

local function buyBestPlant()
    local bestPlant, bestProfit = nil, 0
    for name, data in pairs(seeds) do
        local stock = getStockAmount(seedShopUI, name)
        if stock > 0 and data.sellValue and data.sellValue > bestProfit then
            bestPlant = name
            bestProfit = data.sellValue
        end
    end
    if bestPlant then
        for i=1,getStockAmount(seedShopUI, bestPlant) do
            buySeedRemote:FireServer(bestPlant)
            wait()
        end
    end
end

local function buyAllGear()
    for gearName, data in pairs(gears) do
        local stock = getStockAmount(gearShopUI, gearName)
        if stock > 0 then
            for i=1,stock do
                buyGearRemote:FireServer(gearName)
                wait()
            end
        end
    end
end

local function plantAllSeeds()
    local farm = workspace.Farm:FindFirstChild(player.Name)
    if not farm then return end
    local plantLocations = farm.Important.Plant_Locations:GetChildren()
    for _, location in ipairs(plantLocations) do
        for _, seed in ipairs(backpack:GetChildren()) do
            if seed:IsA("Tool") and seed:FindFirstChild("Plant_Name") then
                buySeedRemote:FireServer(location.Position, seed.Name)
                wait(0.1)
            end
        end
    end
end

local function harvestAllCrops()
    local farm = workspace.Farm:FindFirstChild(player.Name)
    if not farm then return end
    local plants = farm.Important.Plants_Physical:GetChildren()
    for _, plant in ipairs(plants) do
        local prompt = plant:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and prompt.Enabled then
            fireproximityprompt(prompt)
            wait(0.05)
        end
    end
end

local function sellCrops()
    local crops = 0
    for _, item in ipairs(backpack:GetChildren()) do
        if item:FindFirstChild("Item_String") then
            crops = crops + 1
        end
    end
    if crops >= cropsThreshold then
        sellInventoryRemote:FireServer()
    end
end

--// AI Loop
task.spawn(function()
    while true do
        if AIEnabled then
            buyBestPlant()
            wait(1)
            buyAllGear()
            wait(1)
            plantAllSeeds()
            wait(1)
            harvestAllCrops()
            wait(1)
            sellCrops()
            wait(10)
        end
        wait(1)
    end
end)

--// Rayfield Toggle
Tab:CreateToggle({
    Name = "Enable AI Mode",
    CurrentValue = false,
    Callback = function(Value)
        AIEnabled = Value
    end,
})

--// Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({Title = "Credits", Content = "Made by @skulldagrait\nYouTube: youtube.com/@skulldagrait\nDiscord: skulldagrait\nGitHub: github.com/skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"})

Rayfield:Notify({
    Title = "Grow A Garden AI Loaded",
    Content = "Script by skulldagrait | AI Mode Ready.",
    Duration = 6.5,
    Image = 4483362458,
})
