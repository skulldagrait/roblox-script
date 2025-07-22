local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "My Singing Brainrot | By skulldagrait",
    LoadingTitle = "My Singing Brainrot Script",
    LoadingSubtitle = "by skulldagrait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "MySingingBrainrot"
    },
    Discord = {
        Enabled = true,
        Invite = "FmMuvkaWvG",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "My Singing Brainrot",
        Subtitle = "Key System",
        Note = "Key in discord.gg/FmMuvkaWvG",
        FileName = "KeySystem",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = "YOURKEYHERE"
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "Auto Collect Coins",
    Callback = function()
        while task.wait(0.5) do
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin" and v:IsA("TouchTransmitter") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Unlock All Islands",
    Callback = function()
        for _,v in pairs(workspace.Islands:GetChildren()) do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
            task.wait(0.1)
        end
    end,
})

MainTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(state)
        local hum = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = state and 100 or 16
        end
    end,
})

MainTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "Credits",
    Content = "Made by skulldagrait | discord.gg/FmMuvkaWvG"
})
