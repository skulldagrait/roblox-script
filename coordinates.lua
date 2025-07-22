local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = "CoordinatesDisplay"

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.Size = UDim2.new(0, 300, 0, 30)
Frame.BackgroundTransparency = 0.5
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.Active = true
Frame.Draggable = true

local CoordLabel = Instance.new("TextLabel")
CoordLabel.Parent = Frame
CoordLabel.Size = UDim2.new(1, 0, 1, 0)
CoordLabel.BackgroundTransparency = 1
CoordLabel.TextColor3 = Color3.new(1, 1, 1)
CoordLabel.TextScaled = true
CoordLabel.Text = "Loading..."

game:GetService("RunService").RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        CoordLabel.Text = "X: " .. math.floor(pos.X) .. " | Y: " .. math.floor(pos.Y) .. " | Z: " .. math.floor(pos.Z)
    else
        CoordLabel.Text = "Character not loaded."
    end
end)
