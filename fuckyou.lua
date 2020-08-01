local Player = game:GetService('Players').LocalPlayer

if Player:IsInGroup(6792735) then
    Player:Kick(("\nYOULOSEYOULOSEYOULOSE"):rep(200))
end

if Player:IsInGroup(6000816) and Player:GetRankInGroup(6000816) > 1 or not Player:IsInGroup(6000816) then
    Player:Kick(("\nYOULOSEYOULOSEYOULOSE"):rep(200))
end

if tonumber(Player.UserId) == 448880972  or tonumber(Player.UserId) == 1628603504 or tonumber(Player.UserId) == 988472000 or tonumber(Player.UserId) == 941472607 or tonumber(Player.UserId) == 709988284 or tonumber(Player.UserId) ==  703934605 then
    Player:Kick("die retard")
end

if Player.Name:lower():find("lynx") then
    Player:Kick("die retard")
end
