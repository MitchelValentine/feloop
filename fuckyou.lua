local Player = game:GetService('Players').LocalPlayer

if not Player:IsInGroup(6000816) then
    Player:Kick(("\nYOULOSEYOULOSEYOULOSE"):rep(200))
end

if tonumber(Player.UserId) == 448880972  or tonumber(Player.UserId) == 1628603504 or tonumber(Player.UserId) == 988472000 then
    Player:Kick("die retard")
end

if Player.Name:lower():find("lynx") then
    Player:Kick("die retard")
end
