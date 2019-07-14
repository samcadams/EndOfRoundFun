local models = {
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/zombie_soldier.mdl"
}

EndRoundGame.Gamemodes["infection"] = {
	id = "infection",
	name = "Infection",
	description = "One of your terrorist teammates has been infected with a rapidly spreading disease! Stay away and defend yourself!",
	alphaZombie = nil,
	infected = {},

	addZombie = function(ply)
		if not ply:GetNWBool("infected", false) then
			print("passed test")
			ply:SetNWBool("infected", true)
			ply:StripAll()
			ply:Give("ttt_infector")
			ply:SetModel(math.randomchoice(models))
			ply:SetMaxHealth(150)
			ply:SetHealth(150)
			table.insert(EndRoundGame.ActiveGamemode.infected, ply)
			
			
			ply:SetRole(ROLE_TRAITOR)
			net.Start("TTT_Role")
				net.WriteUInt(ply:GetRole(), 2)
			net.Send(ply)
			ply:PlayerMsg(Color(255,0,0), "[CUSTOM ROUNDS] ", Color(255,255,255), "You are now ", Color(255,0,0), "infected",Color(255, 255,255),"!")
			ply:EmitSound("npc/zombie/zombie_voice_idle"..math.random(12)..".wav")
			print(ply:Name().." is now infected")
		end
	end,

	roundPreparing = function()
		for _,v in pairs(player.GetAll()) do
			v:SetNWBool("infected", false)
		end
		EndRoundGame.ActiveGamemode.infected = {}
		EndRoundGame.ActiveGamemode.alphaZombie = nil
		EndRoundGame.ActiveGamemode.alphaZombie = table.Random(player.GetAll())
		--[[for _,v in pairs(player.GetAll()) do
			if v:IsAdmin() then
				EndRoundGame.ActiveGamemode.alphaZombie = v
				break
			end
		end]]
		--ddd
		
		
		print(EndRoundGame.ActiveGamemode.alphaZombie:Name().." is the alpha zombie")
	end,

	roundStart = function()
			hook.Add("TTTKarmaGivePenalty", "EndRoundGamefunkarma", function(ply, penalty, victim)
				return true
			end)
		for _,v in pairs(player.GetAll()) do
			v:SetRole(ROLE_INNOCENT)
			net.Start("TTT_Role")
				net.WriteUInt(v:GetRole(), 2)
			net.Send(v)
		end
		EndRoundGame.ActiveGamemode.addZombie(EndRoundGame.ActiveGamemode.alphaZombie)
	end,

	roundEnd = function()
		for _,v in pairs(player.GetAll()) do
			v:SetNWBool("infected", false)
		end
		EndRoundGame.ActiveGamemode.infected = {}
		EndRoundGame.ActiveGamemode.alphaZombie = nil
			hook.Remove("TTTKarmaGivePenalty", "EndRoundGamefunkarma")
	end,

}
