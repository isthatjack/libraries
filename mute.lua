local RunService = game:GetService("RunService")

--[[
    notes
    when using mute/unmute, make sure the value is a player
    example: library:mute(game.Players.dot_mp4)
]]

local library = {}
library.muted = {}

function library:mute(plr)
    if not library.muted[plr.Name] then
        table.insert(library.muted, plr)
    end
end

function library:unmute(plr)
    for i = 1, #library.muted do
        if library.muted[i] == plr then
            table.remove(library.muted,i)
        end
    end
end

RunService.Heartbeat:Connect(function()
    for _, plr in pairs(library.muted) do
        if plr.Character then
            for _, Sound in pairs(plr.Character:GetDescendants()) do
                if Sound.ClassName == "Sound" and Sound.IsPlaying then
                    Sound.Playing = false
                end
            end
        end
    end
end)

return library
