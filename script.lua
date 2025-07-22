local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal A Brainrot MODDED - Made by skulldagrait",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By skulldagrait",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "StealBrainrot_Hub",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local MainTab = Window:CreateTab("Main", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

local function getMyPlot()
    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        if plot:FindFirstChild("YourBase", true) and plot.YourBase.Enabled then
            return plot
        end
    end
    return nil
end

MainTab:CreateButton({
    Name = "Steal Best Brainrot",
    Callback = function()
        local originalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        local best = nil
        local bestCash = 0
        for _, plot in pairs(Workspace.Plots:GetChildren()) do
            local owner = plot:FindFirstChild("PlotSign") and plot.PlotSign.SurfaceGui.Frame.TextLabel.Text or ""
            if not owner:find(LocalPlayer.DisplayName) then
                for _, desc in pairs(plot:GetDescendants()) do
                    if desc.Name == "CashPerSecond" and desc:IsA("TextLabel") then
                        local cashStr = desc.Text:gsub("[^%d]", "")
                        local cash = tonumber(cashStr) or 0
                        if cash > bestCash then
                            bestCash = cash
                            best = desc.Parent.Parent
                        end
                    end
                end
            end
        end
        if best then
            local pos = best.PrimaryPart or best:FindFirstChildWhichIsA("BasePart")
            if pos then
                LocalPlayer.Character.HumanoidRootPart.CFrame = pos.CFrame + Vector3.new(0,2,0)
                task.wait(0.5)
                for _, v in pairs(best:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
                task.wait(0.5)
                local myPlot = getMyPlot()
                if myPlot then
                    local claimBlock = myPlot:FindFirstChild("Purchases", true)
                    if claimBlock then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = claimBlock.CFrame + Vector3.new(0,2,0)
                        task.wait(0.5)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = originalPos
                    end
                end
            end
        else
            Rayfield:Notify({
                Title = "Steal A Brainrot",
                Content = "No brainrot found to steal",
                Duration = 2
            })
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Collect Cash",
    CurrentValue = false,
    Callback = function(enabled)
        task.spawn(function()
            while enabled do
                local myPlot = getMyPlot()
                if myPlot then
                    for _, part in pairs(myPlot:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name == "Collect" then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,2,0)
                            task.wait(0.2)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end,
})

MainTab:CreateToggle({
    Name = "Auto Lock Base",
    CurrentValue = false,
    Callback = function(enabled)
        task.spawn(function()
            while enabled do
                local myPlot = getMyPlot()
                if myPlot then
                    local lockTime = myPlot:FindFirstChild("Purchases", true) and myPlot.Purchases.PlotBlock.Main.BillboardGui.RemainingTime
                    if lockTime then
                        local timeText = lockTime.Text:gsub("[^%d]", "")
                        local seconds = tonumber(timeText) or 0
                        if seconds <= 2 then
                            local originalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                            local lockButton = myPlot:FindFirstChild("Lock", true)
                            if lockButton then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = lockButton.CFrame + Vector3.new(0,2,0)
                                for i = 1,20 do
                                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                    task.wait(0.1)
                                end
                                LocalPlayer.Character.HumanoidRootPart.CFrame = originalPos
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end,
})

VisualTab:CreateButton({
    Name = "Enable ESP",
    Callback = function()
        local rarities = {"Mythic", "Brainrot God", "Secret"}
        for _, plot in pairs(Workspace.Plots:GetChildren()) do
            for _, desc in pairs(plot:GetDescendants()) do
                if desc:IsA("TextLabel") and table.find(rarities, desc.Text) then
                    local parentModel = desc.Parent.Parent
                    if not parentModel:FindFirstChild("ESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP"
                        billboard.Size = UDim2.new(0, 200, 0, 30)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = parentModel.PrimaryPart or parentModel:FindFirstChildWhichIsA("BasePart")
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1,0,1,0)
                        label.BackgroundTransparency = 1
                        label.Text = desc.Text
                        label.TextColor3 = Color3.new(1,1,0)
                        label.TextStrokeTransparency = 0
                        label.TextScaled = true
                        label.Parent = billboard
                        billboard.Parent = parentModel
                    end
                end
            end
        end
    end,
})

VisualTab:CreateButton({
    Name = "Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1,1,1)
        lighting.Brightness = 3
        lighting.ClockTime = 12
        lighting.FogEnd = 10000
        lighting.GlobalShadows = false
    end,
})

local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({
    Title = "Script made by skulldagrait",
    Content = "YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait\nDiscord Server: https://discord.gg/wUtef63fms"
})
