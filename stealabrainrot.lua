local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Steal A Brainrot - Made by skulldagrait",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "StealABrainrot",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function createESP(pet)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = pet.PrimaryPart or pet:FindFirstChildWhichIsA("BasePart")
    billboard.AlwaysOnTop = true
    billboard.Parent = pet

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.Font = Enum.Font.SourceSansBold
    label.Text = pet.Name

    local rarity = pet:FindFirstChild("Rarity", true)
    if rarity then
        if rarity.Value == "Mythic" then
            label.TextColor3 = Color3.fromRGB(0,255,255)
        elseif rarity.Value == "Brainrot God" then
            label.TextColor3 = Color3.fromRGB(255,0,255)
        elseif rarity.Value == "Secret" then
            label.TextColor3 = Color3.fromRGB(255,255,0)
        else
            label.TextColor3 = Color3.fromRGB(255,255,255)
        end
    end

    label.Parent = billboard
end

local function initESP()
    for _,plot in ipairs(Workspace.Plots:GetChildren()) do
        if plot.Name ~= LocalPlayer.Name then
            for _,pet in ipairs(plot:GetDescendants()) do
                local rarity = pet:FindFirstChild("Rarity", true)
                if rarity and (rarity.Value == "Mythic" or rarity.Value == "Brainrot God" or rarity.Value == "Secret") then
                    if pet:IsA("Model") and not pet:FindFirstChild("ESP") then
                        createESP(pet)
                    end
                end
            end
        end
    end
end

local function getBestPet()
    local bestPet = nil
    local highestCPS = 0

    for _,plot in ipairs(Workspace.Plots:GetChildren()) do
        if plot.Name ~= LocalPlayer.Name then
            for _,pet in ipairs(plot:GetDescendants()) do
                local cps = pet:FindFirstChild("CashPerSecond", true)
                if cps and tonumber(cps.Value) and tonumber(cps.Value) > highestCPS then
                    highestCPS = tonumber(cps.Value)
                    bestPet = pet
                end
            end
        end
    end

    return bestPet
end

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "Steal Best Pet",
    Callback = function()
        local pet = getBestPet()
        if pet and pet.PrimaryPart then
            LocalPlayer.Character.HumanoidRootPart.CFrame = pet.PrimaryPart.CFrame + Vector3.new(0,3,0)
        end
    end,
})

initESP()

local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
