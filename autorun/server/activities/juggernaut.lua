activity = {
	Id = "juggernaut",
	Name = "Juggernaut",
	Description = "A traitor has broken into the armory and geared up, prepare yourself and get ready to take down a stronger, super-traitor.",
	ActivityType = ACTIVITY_GAMEMODE,
	juggernaut = nil,
}


function activity:RoundPreparing()
	self.juggernaut = table.Random(player.GetAll())
	self.juggernaut:PlayerMsg(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), "You're going to be the Juggernaut this round, Get armed and ready.")
end

function activity:RoundStart()
	for k,v in pairs(player.GetAll()) do
		if v == self.juggernaut then
			v:SetRole(ROLE_TRAITOR)
			net.Start("TTT_Role")
			net.WriteUInt(v:GetRole(), 2)
			net.Send(v)
			
			v:SetCredits(4)
			net.Start("TTT_Credits")
				net.WriteUInt(v:GetCredits(), 8)
			net.Send(v)
			print("[CUSTOM ROUNDS] "..v:Name().." is the juggernaut.")
		else
			v:SetRole(ROLE_INNOCENT)
			net.Start("TTT_Role")
			net.WriteUInt(v:GetRole(), 2)
			net.Send(v)
		end
	end
	SendFullStateUpdate()
	self.juggernaut:SetModel("models/player/riot.mdl")
	local hp = 100 + (#player.GetAll() * 35)
	self.juggernaut:SetMaxHealth(hp)
	print("[CUSTOM ROUNDS] Launched the juggernaut with "..hp.." health")
	self.juggernaut:SetHealth(hp)
	BroadcastMsg(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), self.juggernaut:Name().." has become the Juggernaut!")
end

LoadActivity(activity)