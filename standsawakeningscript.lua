
-- Stands Awakening Hub – by skulldagrait
-- Version: v2.1

-- Main loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/skulldagrait/roblox-script/main/standsawakeningscript.lua"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Stands Awakening Hub",
    LoadingTitle = "Stands Awakening Hub",
    LoadingSubtitle = "by skulldagrait",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "StandsAwakeningHub", 
       FileName = "v2.1"
    },
    Discord = {
       Enabled = true,
       Invite = "",
       RememberJoins = true 
    },
    KeySystem = false,
})

-- [UI Tabs and Logic - OMITTED HERE FOR BREVITY]
-- Assume tabs: Visuals, Movement, Items, Teleport (with original teleport coords), Boss, Misc, Credits

-- AutoBoss Enhancements
repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local Time = true
local Attacking = game:GetService("Workspace"):WaitForChild("Dead")
local Obby = game:GetService("Workspace"):WaitForChild("ObbyW")
local Phase = game:GetService("Workspace"):WaitForChild("BossPhase")
local Health = game:GetService("Workspace"):WaitForChild("TrollHealth")

if game:GetService("Workspace"):FindFirstChild("Effects") then
    game:GetService("Workspace").Effects:Destroy()
end

if game:GetService("Workspace").Map:FindFirstChild("ThunderParts") then
    game:GetService("Workspace").Map.ThunderParts:Destroy()
end

local function setupSword()
    local sword = Character:FindFirstChild("KnightsSword") 
               or LocalPlayer.Backpack:FindFirstChild("KnightsSword")
               or game:GetService("Workspace"):FindFirstChild("KnightsSword")

    if sword then
        if sword.Parent ~= Character then
            sword.Parent = LocalPlayer.Backpack
            Humanoid:UnequipTools()
            sword.Parent = Character
        end

        if sword:FindFirstChild("Handle") then
            if not sword.Handle:FindFirstChild("SelectionBoxCreated") then
                local Box = Instance.new("SelectionBox")
                Box.Name = "SelectionBoxCreated"
                Box.Parent = sword.Handle
                Box.Adornee = sword.Handle
            end

            sword.Handle.Massless = true
            sword.GripPos = Vector3.new(0, 0, 0)
            sword.Handle.Size = Vector3.new(20, 20, 500)
        end
    else
        warn("KnightsSword not found")
    end
end

local function swordCheck()
    while true do
        setupSword()
        task.wait(5)
    end
end

task.spawn(swordCheck)

task.spawn(function()
    while true do
        if Attacking.Value == false then
            if Obby.Value == true then
                HumanoidRootPart.CFrame = CFrame.new(20.45, 113.24, 196.61)
            else
                if Phase.Value == "None" then
                    HumanoidRootPart.CFrame = CFrame.new(-5.47, -4.45, 248.21)
                else
                    HumanoidRootPart.CFrame = CFrame.new(-19.89, -4.77, 142.49)
                end
            end
        end
        task.wait()
    end
end)

task.spawn(function()
    while true do
        if Attacking.Value == false and Obby.Value == false then
            if Character:FindFirstChild("KnightsSword") then
                Character.KnightsSword:Activate()
            end
        end
        task.wait(0.1)
    end
end)

-- [Dupe Button Placeholder Logic Here: executes !trade {LocalPlayer.Name} automatically]



local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local canAttack = true
local ATTACK_COOLDOWN = 5 -- seconds

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getAnimator(humanoid)
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    return animator
end

local function playAttackAnimation(humanoid)
    local animator = getAnimator(humanoid)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://5940026539"

    local track = animator:LoadAnimation(anim)
    track:Play()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode ~= Enum.KeyCode.Y then return end
    if not canAttack then return end -- cooldown check

    canAttack = false -- start cooldown

    local character = getCharacter()
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    playAttackAnimation(humanoid)

    local ATTACK_RANGE = 5

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherHumanoid = otherChar:FindFirstChild("Humanoid")
            local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")

            if otherHumanoid and otherRoot then
                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                if distance <= ATTACK_RANGE then
                    local args1 = {
                        [1] = "Damage",
                        [2] = "Freeze",
                        [4] = true,
                        [5] = otherHumanoid
                    }
                    ReplicatedStorage.Main.Input:FireServer(unpack(args1))
                end
            end
        end
    end

    task.delay(ATTACK_COOLDOWN, function()
        canAttack = true
    end)
end)
