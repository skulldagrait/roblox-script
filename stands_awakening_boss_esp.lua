
-- Auto-execute ESP + draggable GUI text only (for boss fireball item drop detection)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Mini GUI (movable)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemESPStatus"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 40)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "GUI is running"
label.TextColor3 = Color3.new(0, 0, 0)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Parent = frame

-- Function to create ESP for a part
local function createESP(part, labelText)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = labelText
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Parent = billboard

    billboard.Parent = CoreGui
end

-- Boss Fireball Item ESP
RunService.RenderStepped:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name == "Fireball" and not v:FindFirstChild("ESPAttached") then
            local tag = Instance.new("BoolValue")
            tag.Name = "ESPAttached"
            tag.Parent = v

            createESP(v, "[Boss Item?]")
        end
    end
end)
