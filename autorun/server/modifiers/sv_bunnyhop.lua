EndRoundGame.Modifiers["bunnyhop"] = 
{
	id = "bhop_mod",
	name = "Bunnyhop",
	gamemodeBlacklist = {
	"bhop_gm"
	},
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