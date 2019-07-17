activity = {
	Id = "deathmatch",
	Name = "Traitors vs. Detectives",
	Description = "It is a simple gamemode, Use your role's equipment against other team to win the round. It's simple, find a player, kill a player.",
	ActivityType = ACTIVITY_GAMEMODE,
}


function activity:RoundStart()
	local tick = 0
		for k,v in pairs(player.GetAll()) do
			tick = tick + 1
			local team = tick % 2
			if team == 1 then
				v:SetRole(ROLE_TRAITOR)
				net.Start("TTT_Role")
				net.WriteUInt(v:GetRole(), 2)
				net.Send(v)
			else
				v:SetRole(ROLE_DETECTIVE)
				net.Start("TTT_Role")
				net.WriteUInt(v:GetRole(), 2)
				net.Send(v)
			end
			v:SetCredits(1)
			net.Start("TTT_Credits")
			net.WriteUInt(v:GetCredits(), 8)
			net.Send(v)
		end
end
LoadActivity(activity)
