-- v2.0 Stands Awakening Hub by skulldagrait
repeat task.wait() until game:IsLoaded()

-- Setup & GUI
local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({Name="SA Hub v2.0", LoadingTitle="SA Hub Loading...", ConfigurationSaving={Enabled=true,FolderName="SA_Hub",FileName="Config"}})

local tabs = {Main=Window:CreateTab("Main",4483362458), Stand=Window:CreateTab("Stand",4483362458),
              Boss=Window:CreateTab("Boss",4483362458), Items=Window:CreateTab("Items",4483362458),
              Movement=Window:CreateTab("Movement",4483362458), Visual=Window:CreateTab("Visuals",4483362458),
              Teleport=Window:CreateTab("Teleport",4483362458), Misc=Window:CreateTab("Misc",4483362458),
              Credits=Window:CreateTab("Credits",4483362458)}

local function showVersion(tab) tab:CreateParagraph({Title="Version",Content="v2.0"}) end

-- Main Tab
tabs.Main:CreateButton({Name="InfiniteYield",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})
showVersion(tabs.Main)

-- Stand Reroll Tab
local standNames = {"The World","Star Platinum","Crazy Diamond","King Crimson","Gold Experience","Stone Free","Silver Chariot","Hierophant Green","Magician's Red","Hermit Purple"} -- etc full list as needed
local selectedStand = standNames[1]
tabs.Stand:CreateDropdown({Name="Select Stand",Options=standNames,CurrentOption=selectedStand,Callback=function(v) selectedStand=v end})
local autoReroll = false
tabs.Stand:CreateToggle({Name="Auto Stand Reroll",CurrentValue=false,Callback=function(v)
    autoReroll = v
    spawn(function()
        while autoReroll do
            -- spam arrow
            game.ReplicatedStorage.Events.ThrowArrow:FireServer()
            -- spam rokaka
            game.ReplicatedStorage.Events.ThrowRokaka:FireServer()
            -- check current stand
            local stand = LocalPlayer:FindFirstChild("Stand")
            if stand and stand.Value == selectedStand then
                Rayfield:Notify({Title="Success",Content="Got "..selectedStand})
                autoReroll = false
                break
            end
            task.wait(0.1)
        end
    end)
end})
tabs.Stand:CreateButton({Name="Teleport to Safe Zone",Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0,10003,0) end
end})
showVersion(tabs.Stand)

-- Boss Tab
local bossEnabled=false
local bossConn1, bossConn2
tabs.Boss:CreateToggle({Name="AutoBoss",CurrentValue=false,Callback=function(v)
    bossEnabled=v
    if v then
        for _,c in pairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
        local ws=game.Workspace; local chr=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp=chr:WaitForChild("HumanoidRootPart"); local humanoid=chr:WaitForChild("Humanoid")
        local dead=ws:WaitForChild("Dead"); local obby=ws:WaitForChild("ObbyW")
        local phase=ws:WaitForChild("BossPhase"); local health=ws:WaitForChild("TrollHealth")
        local sword
        local function prep()
            sword = chr:FindFirstChild("KnightsSword") or LocalPlayer.Backpack:FindFirstChild("KnightsSword")
            if sword then sword.Parent=chr; local h=sword.Handle; h.Size=Vector3.new(20,20,500); h.Massless=true; if not h:FindFirstChild("SB") then Instance.new("SelectionBox",h).Name="SB" end end
        end
        prep()
        bossConn1 = RunService.RenderStepped:Connect(function()
            if not bossEnabled or dead.Value then bossConn1:Disconnect(); return end
            if obby.Value then hrp.CFrame = CFrame.new(20.45,113.24,196.61)
            elseif phase.Value=="None" then hrp.CFrame=CFrame.new(-5.47,-4.45,248.20)
            else hrp.CFrame=CFrame.new(-19.89,-4.77,142.49) end
        end)
        bossConn2 = RunService.RenderStepped:Connect(function()
            if not bossEnabled or dead.Value then bossConn2:Disconnect(); return end
            if sword then sword:Activate() end
        end)
    else
        if bossConn1 then bossConn1:Disconnect() end
        if bossConn2 then bossConn2:Disconnect() end
    end
end})
showVersion(tabs.Boss)

-- Items Tab
tabs.Items:CreateToggle({Name="AutoFarm Items",CurrentValue=false,Callback=function(v)
    getgenv().AutoFarm=v
    spawn(function()
        while getgenv().AutoFarm do
            for _,it in pairs(game.Workspace:GetChildren()) do
                if it:IsA("Tool") and it:FindFirstChild("Handle") and (it.Handle.Position - Vector3.new(-225,461,-1396)).Magnitude>15 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame=it.Handle.CFrame
                end
            end
            task.wait(0.5)
        end
    end)
end})
tabs.Items:CreateToggle({Name="Auto Collect Banknote",CurrentValue=false,Callback=function(v)
    getgenv().AutoBank=v
    spawn(function()
        while getgenv().AutoBank do
            for _,c in pairs({LocalPlayer.Backpack,LocalPlayer.Character}) do
                for _,tool in pairs(c:GetChildren()) do
                    if tool.Name=="Banknote" then
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
                        task.wait(0.25)
                        pcall(tool.Activate,tool)
                    end
                end
            end
            task.wait(1)
        end
    end)
end})
showVersion(tabs.Items)

-- Teleport Tab
local teleports={{"Timmy",1394,584,-219},{"Sans",1045,583,-442},{"Safe Zone",0,10003,0}}
for _,t in ipairs(teleports) do
    tabs.Teleport:CreateButton({Name=t[1],Callback=function()
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame=CFrame.new(t[2],t[3],t[4])
    end})
end
showVersion(tabs.Teleport)

-- Movement Tab
tabs.Movement:CreateToggle({Name="Speed Boost",CurrentValue=false,Callback=function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 75 or 16 end})
tabs.Movement:CreateToggle({Name="Jump Boost",CurrentValue=false,Callback=function(v) LocalPlayer.Character.Humanoid.JumpPower = v and 150 or 50 end})
getgenv().InfJump=false
tabs.Movement:CreateToggle({Name="Infinite Jump",CurrentValue=false,Callback=function(v) getgenv().InfJump=v end})
game:GetService("UserInputService").JumpRequest:Connect(function() if getgenv().InfJump then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
local noclip=false
tabs.Movement:CreateToggle({Name="Noclip",CurrentValue=false,Callback=function(v) noclip=v end})
RunService.Stepped:Connect(function() if noclip then for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
tabs.Movement:CreateToggle({Name="Fly",CurrentValue=false,Callback=function(v)
    getgenv().Fly=v
    local hrp=LocalPlayer.Character.HumanoidRootPart; local cam=workspace.CurrentCamera
    spawn(function()
        local bv, bg
        while getgenv().Fly do
            if not bv then bv=Instance.new("BodyVelocity",hrp); bv.MaxForce=Vector3.new(1e5,1e5,1e5) end
            if not bg then bg=Instance.new("BodyGyro",hrp); bg.MaxTorque=Vector3.new(1e5,1e5,1e5); bg.CFrame=cam.CFrame end
            local mv=Vector3.zero
            local u=game:GetService("UserInputService")
            if u:IsKeyDown(Enum.KeyCode.W) then mv+=cam.CFrame.LookVector end
            if u:IsKeyDown(Enum.KeyCode.S) then mv-=cam.CFrame.LookVector end
            if u:IsKeyDown(Enum.KeyCode.A) then mv-=cam.CFrame.RightVector end
            if u:IsKeyDown(Enum.KeyCode.D) then mv+=cam.CFrame.RightVector end
            if u:IsKeyDown(Enum.KeyCode.Space) then mv+=Vector3.new(0,1,0) end
            if u:IsKeyDown(Enum.KeyCode.LeftControl) then mv-=Vector3.new(0,-1,0) end
            bv.Velocity=mv*75; bg.CFrame=cam.CFrame
            task.wait()
        end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end)
end})
showVersion(tabs.Movement)

-- Visual Tab
tabs.Visual:CreateButton({Name="Fullbright",Callback=function()
    local l=game:GetService("Lighting")
    l.Ambient, l.Brightness, l.ClockTime, l.FogEnd, l.GlobalShadows = Color3.new(1,1,1),3,12,10000,false
end})
tabs.Visual:CreateButton({Name="FPS Booster",Callback=function()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled=false
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("BasePart") then v.Material=Enum.Material.SmoothPlastic; v.Reflectance=0 end
    end
end})
showVersion(tabs.Visual)

-- Misc Tab
tabs.Misc:CreateButton({Name="Anti-AFK",Callback=function()
    local vu=game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end})
showVersion(tabs.Misc)

-- Credits Tab
tabs.Credits:CreateParagraph({Title="Credits",Content="YouTube: skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: skulldagrait"})
showVersion(tabs.Credits)
