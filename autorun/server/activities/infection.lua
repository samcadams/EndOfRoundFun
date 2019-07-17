local models = {
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/zombie_soldier.mdl"
}
activity = {
	Id = "infection",
	Name = "Infection",
	Description = "One of your terrorist teammates has been infected with a rapidly spreading disease! Stay away and defend yourself!",
	ActivityType = ACTIVITY_GAMEMODE,
	AlphaZombie = {},
	Infected = {},
	AddZombie = function(self, ply)
		if not ply:GetNWBool("infected", false) then
			ply:SetNWBool("infected", true)
			ply:StripAll()
			ply:Give("ttt_infector")
			ply:SetModel(math.randomchoice(models))
			ply:SetMaxHealth(150)
			ply:SetHealth(150)
			table.insert(self.Infected, ply)
			
			
			ply:SetRole(ROLE_TRAITOR)
			net.Start("TTT_Role")
				net.WriteUInt(ply:GetRole(), 2)
			net.Send(ply)
			ply:PlayerMsg(Color(255,0,0), "[CUSTOM ROUNDS] ", Color(255,255,255), "You are now ", Color(0,255,0), "infected",Color(255, 255,255),"!")
			ply:EmitSound("npc/zombie/zombie_voice_idle"..math.random(12)..".wav")
			print(ply:Name().." is now infected")
		end
	end,
}



function activity:RoundPreparing()
	for _,v in pairs(player.GetAll()) do
		v:SetNWBool("infected", false)
	end
	self.Infected = {}
	self.AlphaZombie = nil
	self.AlphaZombie = table.Random(player.GetAll())
	
	--hook.Add("PlayerCanPickupWeapon", "firesttt_disablepickups", function(ply, wep)
	--	if ply:GetNWBool("infected") then
	--		return false
	--	end
	--end)
	
	hook.Add("Think", "firesttt_wipezombieammo", function(ply, wep)
		if ply:GetNWBool("infected", false) then
			ply:StripAmmo()
		end
	end)
	
	for _,v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			self.AlphaZombie = v
			break
		end
	end
	
	print("[CUSTOM ROUNDS] "..self.AlphaZombie:Name().." is the alpha zombie")
end

function activity:RoundStart()
	for _,v in pairs(player.GetAll()) do
		v:SetRole(ROLE_INNOCENT)
		net.Start("TTT_Role")
			net.WriteUInt(v:GetRole(), 2)
		net.Send(v)
	end
	self.AddZombie(self, self.AlphaZombie)
	self.AlphaZombie:SetMaxHealth(300)
	self.AlphaZombie:SetHealth(300)
end

function activity:RoundEnd()
	self.Infected = {}
	self.AlphaZombie = nil
end

function activity:Cleanup()
	for _,v in pairs(player.GetAll()) do
		v:SetNWBool("infected", false)
	end
end


LoadActivity(activity)
