-- Stands Awakening Hub – by skulldagrait
-- Version v1.6

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
  Name = "Stands Awakening Hub – by skulldagrait",
  LoadingTitle = "Loading...",
  LoadingSubtitle = "By skulldagrait",
  ConfigurationSaving = { Enabled = true, FolderName = "SA_Hub", FileName = "Config" },
  Discord = { Enabled = false },
  KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

-- Rare item lists
local rareItems = {["Camera"]=true,["Pot"]=true,["Dio's Skull"]=true,["Uncanny Key"]=true,["Samurai Diary"]=true}
local veryRareItems = {["Canny Key"]=true}

-- Utility function
local function updateHumanoid()
  if LocalPlayer.Character then
    Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
  end
end
LocalPlayer.CharacterAdded:Connect(function() wait(1); updateHumanoid() end)

-- Show version
local function showVersion(tab)
  tab:CreateParagraph({ Title = "Version", Content = "v1.6" })
end

-- Teleport tab
local TeleportTab = Window:CreateTab("Teleport",4483362458)
local teleports = {
  {"Timmy NPC", Vector3.new(1394,584,-219)},
  {"Tim NPC",   Vector3.new(1399,584,-216)},
  {"Tom NPC",   Vector3.new(1343,587,-554)},
  {"Sans NPC",  Vector3.new(1045,583,-442)},
  {"Donation Leaderboard",Vector3.new(1670,583,-506)},
  {"Waterfall (Key spawn)",Vector3.new(1625,578,-747)},
  {"Doghouse (Key spawn)",Vector3.new(1033,583,-178)},
  {"Arena",Vector3.new(1248,583,-280)},
  {"Key Portal",Vector3.new(1093,583,-699)},
  {"Stand/Arrow Farm",Vector3.new(-339,461,-1514)},
  {"Main Area",Vector3.new(1341,583,-482)},
  {"D4C Location",Vector3.new(-3070,464,-421)}
}
for _,tp in ipairs(teleports) do
  TeleportTab:CreateButton({
    Name=tp[1], Callback=function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tp[2])
      end
    end
  })
end
showVersion(TeleportTab)

-- Boss tab
local BossTab = Window:CreateTab("Boss",4483362458)
getgenv().AutoBoss = false

BossTab:CreateToggle({
  Name = "AutoBoss (loop)",
  CurrentValue = false,
  Callback = function(v)
    getgenv().AutoBoss = v
    task.spawn(function()
      while getgenv().AutoBoss do
        task.wait(0.5)
        for _,mob in ipairs(workspace:GetChildren()) do
          local h = mob:FindFirstChildOfClass("Humanoid")
          if h and mob.Name:match("Boss") then
            h.Health = 0
          end
        end
      end
    end)
  end
})

BossTab:CreateButton({
  Name = "Kill Nearest Boss",
  Callback = function()
    for _,mob in ipairs(workspace:GetChildren()) do
      local h = mob:FindFirstChildOfClass("Humanoid")
      if h and mob.Name:match("Boss") then
        h.Health = 0
        break
      end
    end
  end
})

showVersion(BossTab)

-- Items tab (AutoFarm + Banknote + rare detection)
local ItemsTab = Window:CreateTab("Items",4483362458)
local ignoredPos = Vector3.new(-225,461,-1396)

ItemsTab:CreateToggle({
  Name = "AutoFarm All Items",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoFarmItems = v
    task.spawn(function()
      while getgenv().AutoFarmItems do
        task.wait(0.5)
        for _,item in ipairs(workspace:GetChildren()) do
          if item:IsA("Tool") and item:FindFirstChild("Handle")
            and (item.Handle.Position-ignoredPos).Magnitude>15 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame
          end
        end
      end
    end)
  end
})

ItemsTab:CreateToggle({
  Name = "Auto Collect Banknote",
  CurrentValue = true,
  Callback = function(v)
    getgenv().AutoBanknote = v
    task.spawn(function()
      while getgenv().AutoBanknote do
        task.wait(1)
        for _,c in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
          if c then
            for _,tool in ipairs(c:GetChildren()) do
              if tool:IsA("Tool") and tool.Name=="Banknote" then
                Humanoid:EquipTool(tool)
                task.wait(0.2)
                pcall(tool.Activate,tool)
                break
              end
            end
          end
        end
      end
    end)
  end
})

task.spawn(function()
  while true do
    task.wait(5)
    local t = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if t then
      if rareItems[t.Name] then
        Rayfield:Notify({Title="Rare Item!",Content=t.Name.." is rare. Store it!"})
      elseif veryRareItems[t.Name] then
        Rayfield:Notify({Title="VERY RARE!",Content=t.Name.." is VERY RARE. Store it ASAP!"})
      end
    end
  end
end)

showVersion(ItemsTab)

-- Visual tab
local VisualTab = Window:CreateTab("Visual",4483362458)
VisualTab:CreateButton({Name="Enable Fullbright",Callback=function()
  Lighting.Ambient,Lighting.Brightness,Lighting.ClockTime,Lighting.FogEnd,Lighting.GlobalShadows =
  Color3.new(1,1,1),3,12,10000,false
end})
VisualTab:CreateButton({Name="FPS Booster",Callback=function()
  for _,v in ipairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Smoke")or v:IsA("Fire") then
      v.Enabled=false
    elseif v:IsA("Decal")or v:IsA("Texture") then
      v.Transparency=1
    elseif v:IsA("BasePart")then
      v.Material=Enum.Material.SmoothPlastic
      v.Reflectance=0
    end
  end
end})
showVersion(VisualTab)

-- Movement tab
local MoveTab = Window:CreateTab("Movement",4483362458)

MoveTab:CreateToggle({Name="Speed Boost",CurrentValue=false,Callback=function(v)
  updateHumanoid()
  if Humanoid then Humanoid.WalkSpeed=v and 75 or 16 end
end})

MoveTab:CreateToggle({Name="Jump Boost",CurrentValue=false,Callback=function(v)
  updateHumanoid()
  if Humanoid then Humanoid.JumpPower=v and 150 or 50 end
end})

getgenv().InfJump=false
MoveTab:CreateToggle({Name="Infinite Jump",CurrentValue=false,Callback=function(v)
  getgenv().InfJump=v
end})
UserInputService.JumpRequest:Connect(function()
  if getgenv().InfJump and Humanoid then
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end)

getgenv().FlyEnabled=false
MoveTab:CreateToggle({Name="Fly (mobile)",CurrentValue=false,Callback=function(v)
  getgenv().FlyEnabled=v
  local char=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
  local hrp=char:WaitForChild("HumanoidRootPart")
  if v then
    local bg=Instance.new("BodyGyro",hrp)
    bg.P, bg.MaxTorque=9e4,Vector3.new(9e9,9e9,9e9)
    local bv=Instance.new("BodyVelocity",hrp)
    bv.MaxForce=Vector3.new(9e9,9e9,9e9)
    local conn
    conn=RunService.RenderStepped:Connect(function()
      if not getgenv().FlyEnabled then
        conn:Disconnect(); bg:Destroy(); bv:Destroy()
        return
      end
      local mv=Vector3.zero
      if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv+=Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv-=Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv-=Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv+=Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv+=Vector3.new(0,1,0) end
      if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv-=Vector3.new(0,1,0) end
      bg.CFrame=Camera.CFrame
      bv.Velocity=mv.Unit*75
    end)
  end
end})
showVersion(MoveTab)

-- Misc tab
local MiscTab = Window:CreateTab("Misc",4483362458)
MiscTab:CreateButton({Name="Anti-AFK",Callback=function()
  local vu=game:service("VirtualUser")
  Players.LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1); vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
  end)
end})
showVersion(MiscTab)

-- Credits tab
local CreditsTab = Window:CreateTab("Credits",4483362458)
CreditsTab:CreateParagraph({
  Title="By skulldagrait",
  Content="YouTube: youtube.com/@skulldagrait\nGitHub: github.com/skulldagrait\nDiscord: discord.gg/wUtef63fms"
})
showVersion(CreditsTab)
