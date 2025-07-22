local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "Stellar Hub | Made by Skulldagrait",
    LoadingTitle = "Stellar Hub",
    LoadingSubtitle = "by Skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "StellarHub",
        FileName = "stellar"
    },
    Discord = {
        Enabled = true,
        Invite = "FmMuvkaWvG",
        RememberJoins = true
    },
    KeySystem = false
})

local Main = Window:CreateTab("Main", 4483362458)
local Server = Window:CreateTab("Server", 4483362458)
local Settings = Window:CreateTab("Settings", 4483362458)

local player = game.Players.LocalPlayer
local shop = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("CoinsShop")

local plotName
for _, plot in ipairs(workspace.Plots:GetChildren()) do
    if plot:FindFirstChild("YourBase", true).Enabled then
        plotName = plot.Name
        break
    end
end

local remainingTime = workspace.Plots[plotName].Purchases.PlotBlock.Main.BillboardGui.RemainingTime

Main:CreateParagraph({Title = "Lock Time: " .. remainingTime.Text})

task.spawn(function()
    while true do
        Main:CreateParagraph({Title = "Lock Time: " .. remainingTime.Text})
        task.wait(0.25)
    end
end)

Main:CreateButton({
    Name = "Steal",
    Callback = function()
        local pos = CFrame.new(0, -500, 0)
        local startT = os.clock()
        while os.clock() - startT < 1 do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = pos
            end
            task.wait()
        end
    end
})

local currentSpeed = 0
Main:CreateSlider({
    Name = "Speed Boost",
    Range = {0, 6},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        currentSpeed = tonumber(Value) or 0
    end
})

local function sSpeed(character)
    local hum = character:WaitForChild("Humanoid")
    local hb = game:GetService("RunService").Heartbeat
    task.spawn(function()
        while character and hum and hum.Parent do
            if currentSpeed > 0 and hum.MoveDirection.Magnitude > 0 then
                character:TranslateBy(hum.MoveDirection * currentSpeed * hb:Wait() * 10)
            end
            task.wait()
        end
    end)
end

player.CharacterAdded:Connect(sSpeed)
if player.Character then sSpeed(player.Character) end

Main:CreateButton({
    Name = "Invisible",
    Callback = function()
        local cloak = player.Character:FindFirstChild("Invisibility Cloak")
        if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
            cloak.Parent = workspace
        end
    end
})

Main:CreateKeybind({
    Name = "Steal Keybind",
    CurrentKeybind = "G",
    HoldToInteract = false,
    Callback = function()
        local pos = CFrame.new(0, -500, 0)
        local startT = os.clock()
        while os.clock() - startT < 1 do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = pos
            end
            task.wait()
        end
    end
})

Main:CreateKeybind({
    Name = "Shop Toggle",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Callback = function()
        shop.Visible = not shop.Visible
        shop.Position = shop.Visible and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 1.5, 0)
    end
})

Server:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local PlaceID = game.PlaceId
        local AllIDs = {}
        local actualHour = os.date("!*t").hour
        local Deleted = false
        local File = pcall(function()
            AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
        end)
        if not File then
            table.insert(AllIDs, actualHour)
            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
        end
        function TPReturner()
            local Site
            if foundAnything == "" then
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
            else
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
            end
            local ID = ""
            if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                foundAnything = Site.nextPageCursor
            end
            local num = 0
            for _, v in pairs(Site.data) do
                local Possible = true
                ID = tostring(v.id)
                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                    for _, Existing in pairs(AllIDs) do
                        if num ~= 0 then
                            if ID == tostring(Existing) then
                                Possible = false
                            end
                        else
                            if tonumber(actualHour) ~= tonumber(Existing) then
                                local delFile = pcall(function()
                                    delfile("NotSameServers.json")
                                    AllIDs = {}
                                    table.insert(AllIDs, actualHour)
                                end)
                            end
                        end
                        num = num + 1
                    end
                    if Possible == true then
                        table.insert(AllIDs, ID)
                        task.wait()
                        pcall(function()
                            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                            task.wait()
                            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                        end)
                        task.wait(4)
                    end
                end
            end
        end
        function Teleport()
            while task.wait() do
                pcall(function()
                    TPReturner()
                    if foundAnything ~= "" then
                        TPReturner()
                    end
                end)
            end
        end
        Teleport()
    end
})

Server:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Settings:CreateParagraph({Title = "Made by Skulldagrait"})
