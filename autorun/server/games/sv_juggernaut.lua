util.AddNetworkString("firesttt_juggernaut")

EndRoundGame.Gamemodes["juggernaut"] = {
name = "Juggernaut",
description = "A traitor has broken into the armory and geared up, prepare yourself and get ready to take down a stronger, super-traitor.",
juggernaut = nil,

roundPreparing = function()
	EndRoundGame.ActiveGamemode.juggernaut = table.Random(player.GetAll())
	print("jug should be above")
	net.Start("firesttt_juggernaut")
        net.WriteEntity(EndRoundGame.ActiveGamemode.juggernaut)
    net.Send(EndRoundGame.ActiveGamemode.juggernaut)
end,

roundStart = function()
	for k,v in pairs(player.GetAll()) do
		if v == EndRoundGame.ActiveGamemode.juggernaut then
			v:SetRole(ROLE_TRAITOR)
			net.Start("TTT_Role")
            net.WriteUInt(v:GetRole(), 2)
            net.Send(v)
			
			v:SetCredits(3)
			net.Start("TTT_Credits")
				net.WriteUInt(v:GetCredits(), 8)
			net.Send(v)
			print("[CUSTOM ROUNDS] "..v:Name().." is the juggernaut")
		else
			v:SetRole(ROLE_INNOCENT)
			net.Start("TTT_Role")
            net.WriteUInt(v:GetRole(), 2)
            net.Send(v)
		end
	end
	SendFullStateUpdate()
	EndRoundGame.ActiveGamemode.juggernaut:SetModel("models/player/riot.mdl")
	local hp = 100 + (#player.GetAll() * 35)
	EndRoundGame.ActiveGamemode.juggernaut:SetMaxHealth(hp)
	print("Launched the juggernaut with "..hp.." health")
	EndRoundGame.ActiveGamemode.juggernaut:SetHealth(hp)
	BroadcastMsg(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), EndRoundGame.ActiveGamemode.juggernaut:Name().." has become the Juggernaut! Kill them!")
end,

roundEnd = function()
end,

}