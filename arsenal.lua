-- Arsenal | by skulldagrait
-- Load with:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/skulldagrait/Roblox-scripts/main/arsenal.lua"))()

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ESPEnabled, TracersEnabled, HealthEnabled = false, false, false
local SilentAimEnabled, NoRecoilEnabled, NoSpreadEnabled, NoDelayEnabled = false, false, false, false

-- GUI Setup
local Window = Rayfield:CreateWindow({
    Name = "Arsenal | by skulldagrait",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateToggle({ Name = "Silent Aim", CurrentValue = false, Callback = function(v) SilentAimEnabled = v end })
CombatTab:CreateToggle({ Name = "No Recoil", CurrentValue = false, Callback = function(v) NoRecoilEnabled = v end })
CombatTab:CreateToggle({ Name = "No Spread", CurrentValue = false, Callback = function(v) NoSpreadEnabled = v end })
CombatTab:CreateToggle({ Name = "No Fire Delay", CurrentValue = false, Callback = function(v) NoDelayEnabled = v end })

local ESPTab = Window:CreateTab("ESP")
ESPTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Callback = function(v) ESPEnabled = v end })
ESPTab:CreateToggle({ Name = "Enable Tracers", CurrentValue = false, Callback = function(v) TracersEnabled = v end })
ESPTab:CreateToggle({ Name = "Show Health Bars", CurrentValue = false, Callback = function(v) HealthEnabled = v end })

-- Silent Aim Hook
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if SilentAimEnabled and tostring(self) == "FireServer" and (method == "FireServer" or method == "InvokeServer") then
        local closest, dist = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onscreen = cam:WorldToViewportPoint(plr.Character.Head.Position)
                if onscreen then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)).Magnitude
                    if d < dist then
                        closest, dist = plr, d
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            args[2] = closest.Character.Head.Position
        end
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Recoil / Spread / Fire Delay Patches
local function patch()
    local lpchar = LocalPlayer.Character
    if not lpchar then return end
    for _, tool in pairs(lpchar:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            if NoRecoilEnabled then
                if tool:FindFirstChild("RecoilMax") then tool.RecoilMax.Value = 0 end
                if tool:FindFirstChild("RecoilMin") then tool.RecoilMin.Value = 0 end
            end
            if NoSpreadEnabled then
                if tool:FindFirstChild("SpreadMax") then tool.SpreadMax.Value = 0 end
                if tool:FindFirstChild("SpreadMin") then tool.SpreadMin.Value = 0 end
            end
            if NoDelayEnabled then
                if tool:FindFirstChild("FireRate") then tool.FireRate.Value = 100 end
            end
        end
    end
end
RunService.Heartbeat:Connect(patch)

-- ESP Implementation
local DrawingNew = Drawing.new
local espBoxes, espTracers, espHealthBars = {}, {}, {}

RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
            local root = plr.Character.HumanoidRootPart
            local pos, onScreen = cam:WorldToViewportPoint(root.Position)
            if ESPEnabled and onScreen then
                local size = 1000 / root.Position.Z
                if not espBoxes[plr] then
                    espBoxes[plr] = DrawingNew("Square")
                    espBoxes[plr].Color = Color3.new(1, 0, 0)
                    espBoxes[plr].Thickness = 1
                    espBoxes[plr].Filled = false
                end
                espBoxes[plr].Position = Vector2.new(pos.X - size / 2, pos.Y - size / 2)
                espBoxes[plr].Size = Vector2.new(size, size)
                espBoxes[plr].Visible = true
            elseif espBoxes[plr] then
                espBoxes[plr].Visible = false
            end

            if ESPEnabled and TracersEnabled and onScreen then
                if not espTracers[plr] then
                    espTracers[plr] = DrawingNew("Line")
                    espTracers[plr].Color = Color3.new(1, 1, 1)
                    espTracers[plr].Thickness = 1
                end
                espTracers[plr].From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                espTracers[plr].To = Vector2.new(pos.X, pos.Y)
                espTracers[plr].Visible = true
            elseif espTracers[plr] then
                espTracers[plr].Visible = false
            end

            if ESPEnabled and HealthEnabled and onScreen then
                local hum = plr.Character.Humanoid
                if not espHealthBars[plr] then
                    espHealthBars[plr] = DrawingNew("Line")
                    espHealthBars[plr].Color = Color3.new(0, 1, 0)
                    espHealthBars[plr].Thickness = 2
                end
                local healthPct = hum.Health / hum.MaxHealth
                local barLength = 50 * healthPct
                espHealthBars[plr].From = Vector2.new(pos.X - 25, pos.Y + 30)
                espHealthBars[plr].To = Vector2.new(pos.X - 25 + barLength, pos.Y + 30)
                espHealthBars[plr].Visible = true
            elseif espHealthBars[plr] then
                espHealthBars[plr].Visible = false
            end
        end
    end
end)

print("Arsenal script loaded by @skulldagrait")
