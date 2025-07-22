-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Stands Awakening Utilities",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By YourNameHere",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SA_Utilities",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Teleport to Uncanny Boss Button
MainTab:CreateButton({
    Name = "Teleport to Uncanny Boss",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(11423379012)
        Rayfield:Notify({
            Title = "Teleport",
            Content = "Teleporting to Uncanny Boss...",
            Duration = 5,
        })
    end,
})

-- Fullbright Button
MainTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(1,1,1)
        lighting.Brightness = 10
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false

        Rayfield:Notify({
            Title = "Fullbright",
            Content = "Fullbright enabled!",
            Duration = 5,
        })
    end,
})

-- UI Loaded Notification
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Stands Awakening Utilities GUI loaded successfully.",
    Duration = 6.5,
})
