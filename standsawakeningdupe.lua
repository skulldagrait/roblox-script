
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local dupableItems = {
    "Pumpkin",
    "Ice Shard",
    "Skull",
    "Bloodied Bandages",
    "Awakened Scroll",
    "DIO's Skull"
}

local selectedItem = dupableItems[1]
local started = false

local Window = Rayfield:CreateWindow({
    Name = "Stands Awakening Dupe",
    LoadingTitle = "Dupe Hub by skulldagrait",
    LoadingSubtitle = "powered by Rayfield",
    ConfigurationSaving = {
       Enabled = false
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Dupe", 4483362458)

Tab:CreateDropdown({
    Name = "Select Item to Dupe",
    Options = dupableItems,
    CurrentOption = selectedItem,
    Callback = function(Value)
        selectedItem = Value
    end,
})

Tab:CreateButton({
    Name = "Start Dupe",
    Callback = function()
        if started then return end
        started = true

        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local StarterGui = game:GetService("StarterGui")

        local function notify(text)
            StarterGui:SetCore("SendNotification", {
                Title = "Dupe Script",
                Text = text,
                Duration = 6
            })
        end

        notify("Send trade using !trade {username}")
        notify("Waiting for Trade UI...")

        local function waitForTradeUI()
            repeat task.wait(0.5) until LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("TradeUI")
        end

        local function withdrawItem()
            local bankGui = LocalPlayer.PlayerGui:WaitForChild("BankUI", 10)
            if not bankGui then
                notify("BankUI not found.")
                return false
            end

            local slots = bankGui:FindFirstChild("Main") and bankGui.Main:FindFirstChild("Items")
            if not slots then
                notify("Could not find item slots.")
                return false
            end

            for _, slot in pairs(slots:GetChildren()) do
                if slot:IsA("ImageButton") and slot:FindFirstChild("ItemName") then
                    if slot.ItemName.Text == selectedItem then
                        fireclickdetector(slot:FindFirstChildWhichIsA("ClickDetector") or slot)
                        task.wait(0.5)
                        if bankGui.Main:FindFirstChild("Withdraw") then
                            bankGui.Main.Withdraw:FireServer(selectedItem, 1)
                            notify("Item withdrawn: " .. selectedItem)
                            return true
                        end
                    end
                end
            end

            notify("Item not found in bank.")
            return false
        end

        local function storeBack()
            local bankGui = LocalPlayer.PlayerGui:WaitForChild("BankUI", 10)
            if not bankGui then return end

            local slots = bankGui:FindFirstChild("Main") and bankGui.Main:FindFirstChild("Items")
            if not slots then return end

            for _, slot in pairs(slots:GetChildren()) do
                if slot:IsA("ImageButton") and not slot:FindFirstChild("ItemName") then
                    fireclickdetector(slot:FindFirstChildWhichIsA("ClickDetector") or slot)
                    task.wait(0.5)
                    if bankGui.Main:FindFirstChild("Store") then
                        bankGui.Main.Store:FireServer(selectedItem, 1)
                        notify("Stored back item: " .. selectedItem)
                        return true
                    end
                end
            end
        end

        task.spawn(function()
            waitForTradeUI()
            if withdrawItem() then
                task.wait(2)
                storeBack()
                notify("Dupe attempt completed.")
            else
                notify("Withdraw failed.")
            end
        end)
    end,
})
