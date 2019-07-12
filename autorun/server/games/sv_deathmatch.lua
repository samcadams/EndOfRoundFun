EndRoundGame.Gamemodes["deathmatch"] = 
{
	name = "Traitors vs. Detectives",
	description = "It is a simple gamemode, Use your role's equipment against other team to win the round. It's simple, find a player, kill a player.",
	roundPreparing = function()
		
	end,
	roundStart = function()
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

		--Hook Karma blocker so no one will get penalized if they kill a friendly
		hook.Add("TTTKarmaGivePenalty", "EndRoundGamefunkarma", function(ply, penalty, victim)
			return true
		end)
	end,
	roundEnd = function()
		--Remove hook so regular rounds work again with Karma.
		hook.Remove("TTTKarmaGivePenalty", "EndRoundGamefunkarma")
	end,
}