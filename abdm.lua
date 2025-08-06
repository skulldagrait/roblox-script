local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Event = ReplicatedStorage:WaitForChild("AnubisDamage2")
local PlaceId = game.PlaceId
local hopping = false

local staffList = {
    [1534146802] = true,
    [724026832]  = true,
    [1484252645] = true,
    [2938109169] = true,
    [1552962633] = true,
}

local function hopToNewServer()
    if hopping then return end
    hopping = true
    local servers = {}
    local req = syn and syn.request or (http and http.request or http_request)
    local success, result = pcall(function()
        return req({
            Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PlaceId),
            Method = "GET"
        })
    end)

    if success and result and result.StatusCode == 200 then
        local data = HttpService:JSONDecode(result.Body)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(PlaceId)
        end
    else
        TeleportService:Teleport(PlaceId)
    end
end

local function checkForStaff(player)
    if staffList[player.UserId] then
        hopToNewServer()
    end
end

-- Initial check
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        checkForStaff(player)
    end
end

-- Future joins
Players.PlayerAdded:Connect(checkForStaff)

-- Kill All Loop
while true do
    if not hopping then
        for _, child in ipairs(Workspace:GetChildren()) do
            local humanoid = child:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                Event:FireServer(humanoid, 90.5, 0.25, Vector3.new(18.503566741943, 27.499996185303, 46.450168609619))
            end
        end
    end
    task.wait(0.2)
end
