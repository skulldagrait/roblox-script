local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
    conn:Disable()
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == LocalPlayer then
        return warn("Kick prevented")
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
