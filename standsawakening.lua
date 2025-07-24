-- Simple GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleStatusGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 100)
Frame.Position = UDim2.new(0.5, -150, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(0, 102, 204) -- blue
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(0, 0, 0) -- black
TextLabel.TextStrokeTransparency = 0
TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 24
TextLabel.Text = "Script is running"
TextLabel.Parent = Frame

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Rare items to pick up
local rareItemNames = {
    "uncanney key",
    "Uncanney Key",
    "Uncanny Key",
    "UncanneyKey", -- just in case
    -- add more rare item names here if you want
}

-- Keep track of visited servers to avoid repeats
local visitedServersKey = "VisitedServers"
local visitedServers = {}

-- Load visited servers list from saved file or initialize
local function loadVisitedServers()
    local success, data = pcall(function()
        return readfile and readfile("visitedServers.txt") or nil
    end)
    if success and data then
        visitedServers = HttpService:JSONDecode(data)
    else
        visitedServers = {}
    end
end

-- Save visited servers list
local function saveVisitedServers()
    if writefile then
        writefile("visitedServers.txt", HttpService:JSONEncode(visitedServers))
    end
end

loadVisitedServers()

-- Add current server to visited list
local currentServerId = game.JobId or "unknownServer"
if not table.find(visitedServers, currentServerId) then
    table.insert(visitedServers, currentServerId)
    saveVisitedServers()
end

-- Function to find rare items in workspace
local function findRareItems()
    local foundItems = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local nameLower = obj.Name:lower()
            for _, rareName in pairs(rareItemNames) do
                if nameLower == rareName:lower() then
                    table.insert(foundItems, obj)
                end
            end
        end
    end
    return foundItems
end

-- Function to pickup item (simulate touch or call pickup remote)
local function pickupItem(item)
    if not item or not item:IsDescendantOf(workspace) then return end

    -- Try to move character to item and simulate pickup
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart

    -- Teleport close to the item
    hrp.CFrame = item:IsA("BasePart") and item.CFrame + Vector3.new(0, 3, 0) or item:GetModelCFrame() + Vector3.new(0, 3, 0)

    wait(0.5) -- wait to trigger touch or pickup event

    -- If there's a remote event for pickup, you'd call it here (game-specific)
    -- Example:
    -- local pickupRemote = game:GetService("ReplicatedStorage"):WaitForChild("PickupItem")
    -- pickupRemote:FireServer(item)

    -- Alternatively, touching the part might trigger pickup automatically

end

-- Function to open Bank GUI and store item
local function storeItem()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local bankGui = playerGui:FindFirstChild("BankGui") or playerGui:FindFirstChild("Bank")
    if not bankGui then
        -- Try to open bank UI if there's a button
        local bankButton = playerGui:FindFirstChild("BankButton") or playerGui:FindFirstChild("S") -- sometimes 'S' key
        if bankButton and bankButton:IsA("GuiButton") then
            bankButton.MouseButton1Click:Fire()
            wait(1)
            bankGui = playerGui:FindFirstChild("BankGui") or playerGui:FindFirstChild("Bank")
        end
    end

    if not bankGui then return end

    -- Find empty slot
    local emptySlot
    for _, slot in pairs(bankGui:GetDescendants()) do
        if slot:IsA("ImageButton") and slot.Name == "Slot" then
            if not slot:FindFirstChild("Item") then
                emptySlot = slot
                break
            end
        end
    end

    if not emptySlot then return end

    -- Simulate storing the item by clicking slot and pressing store button
    -- This part depends on the game's implementation of storing items.
    -- Usually, you might have to:
    -- 1. Select the item in your inventory
    -- 2. Click the empty slot in BankGui
    -- 3. Click the store button

    -- Since this varies, here is a placeholder:
    -- local storeButton = bankGui:FindFirstChild("StoreButton")
    -- if storeButton and storeButton:IsA("GuiButton") then
    --     emptySlot.MouseButton1Click:Fire()
    --     wait(0.3)
    --     storeButton.MouseButton1Click:Fire()
    -- end
end

-- Function to server hop
local function serverHop()
    local success, servers = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if not success or not servers or not servers.data then return end

    for _, server in pairs(servers.data) do
        local serverId = server.id
        local playerCount = server.playing
        if playerCount < server.maxPlayers and not table.find(visitedServers, serverId) then
            table.insert(visitedServers, serverId)
            saveVisitedServers()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
            return
        end
    end
    -- If no suitable server found, retry after delay
    wait(30)
    serverHop()
end

-- Main loop
spawn(function()
    while true do
        local rareItems = findRareItems()
        for _, item in pairs(rareItems) do
            pickupItem(item)
            wait(1)
            storeItem()
        end
        wait(5)
        serverHop()
    end
end)
