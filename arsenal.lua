--// Arsenal | by skulldagrait
-- File: arsenal.lua
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
local Window = Rayfield:CreateWindow({ Name = "Arsenal | by skulldagrait", ConfigurationSaving = { Enabled = false }, Discord = { Enabled = false }, KeySystem = false })
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
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local name = getnamecallmethod()
    if SilentAimEnabled and tostring(self) == "FireServer" and (name == "FireServer" or name == "InvokeServer") then
        local args = {...}
        local closest, dist = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onscreen = cam:WorldToViewportPoint(plr.Character.Head.Position)
                if onscreen then
                    local d = (Vector2.new(pos.X, pos.Y)-Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)).Magnitude
                    if d < dist then closest, dist = plr, d end
                end
            end
        end
        if closest and closest.Character:FindFirstChild("Head") then
            args[2] = closest.Character.Head.Position
        end
        return old(self, unpack(args))
    end
    return old(self, ...)
end
setreadonly(mt, true)

-- Recoil / Spread / Fire Delay Patches
hookfunction(game.Lighting.Changed, function() end) -- dummy to allow hooking
local function patch()
    local lpchar = LocalPlayer.Character
    if not lpchar then return end
    for _, tool in pairs(lpchar:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            if NoRecoilEnabled then
                tool.RecoilMax = 0
                tool.RecoilMin = 0
            end
            if NoSpreadEnabled then
                tool.SpreadMin = 0
                tool.SpreadMax = 0
            end
            if NoDelayEnabled then
                tool.FireRate = 1
            end
        end
    end
end

RunService.Heartbeat:Connect(patch)

-- ESP Setup
local DrawingNew = Drawing.new
local espBox, espTracer, espHealthBar = {}, {}, {}

RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local pos, onScreen = cam:WorldToViewportPoint(root.Position)
            if ESPEnabled and onScreen then
                if not espBox[plr] then
                    espBox[plr] = DrawingNew("Square")
                    espBox[plr].Color = Color3.new(1,0,0)
                    espBox[plr].Thickness = 1
                end
                local size = (2000/root.Position.Z)
                espBox[plr].Position = Vector2.new(pos.X-size/2, pos.Y-size/2)
                espBox[plr].Size = Vector2.new(size, size)
                espBox[plr].Visible = true
            elseif espBox[plr] then espBox[plr].Visible = false end

            if ESPEnabled and TracersEnabled and onScreen then
                if not espTracer[plr] then espTracer[plr] = DrawingNew("Line"); espTracer[plr].Color=Color3.new(1,1,1); espTracer[plr].Thickness=1 end
                espTracer[plr].From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                espTracer[plr].To = Vector2.new(pos.X, pos.Y)
                espTracer[plr].Visible = true
            elseif espTracer[plr] then espTracer[plr].Visible = false end

            if ESPEnabled and HealthEnabled and onScreen then
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hum then
                    if not espHealthBar[plr] then espHealthBar[plr] = DrawingNew("Bar"); espHealthBar[plr].Color = Color3.new(0,1,0); espHealthBar[plr].Thickness = 1 end
                    local healthPct = hum.Health / hum.MaxHealth
                    espHealthBar[plr].From = Vector2.new(pos.X-12, pos.Y+size/4)
                    espHealthBar[plr].To = Vector2.new(pos.X-12 + size * healthPct / 2, pos.Y+size/4)
                    espHealthBar[plr].Visible = true
                end
            elseif espHealthBar[plr] then espHealthBar[plr].Visible = false end
        end
    end
end)

print("Arsenal script loaded: Silent Aim, ESP, gun mods by skulldagrait")
