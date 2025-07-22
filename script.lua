MainTab:CreateButton({
    Name = "Steal Best Brainrot",
    Callback = function()
        local originalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        local best = getBestBrainrot()
        if best then
            local pos = best.PrimaryPart or best:FindFirstChildWhichIsA("BasePart")
            if pos then
                -- TP to Brainrot
                LocalPlayer.Character.HumanoidRootPart.CFrame = pos.CFrame + Vector3.new(0,2,0)
                task.wait(0.5)
                -- Steal attempt
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, pos, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, pos, 1)
                task.wait(0.5)
                -- Return to original position
                LocalPlayer.Character.HumanoidRootPart.CFrame = originalPos
            end
        else
            Rayfield:Notify({Title="Steal A Brainrot",Content="No brainrot found to steal",Duration=2})
        end
    end,
})
