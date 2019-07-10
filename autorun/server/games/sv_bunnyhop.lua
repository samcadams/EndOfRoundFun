util.AddNetworkString("firesttt_bunnyhop")

EndRoundGame.Gamemodes["bunnyhop"] = 
{
	name = "Bunnyhop",
	description = "Regular round but with Bunnyhop enabled, hold space!",
	roundPreparing = function()
	end,
	roundStart = function()
		RunConsoleCommand("sv_airaccelerate", "4000")
		net.Start("firesttt_bunnyhop")
			net.WriteBool(true)
		net.Broadcast()
	end,
	roundEnd = function()
		RunConsoleCommand("sv_airaccelerate", "10")
		net.Start("firesttt_bunnyhop")
			net.WriteBool(false)
		net.Broadcast()
	end,
}