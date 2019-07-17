util.AddNetworkString("firesttt_bunnyhop")

activity = {
	Id = "bhop",
	Name = "Bunnyhop",
	Description = "Regular round but with Bunnyhop enabled, hold space!",
	ActivityType = ACTIVITY_BOTH,
	GamemodeBlacklist = {"bhop"}
}


function activity:RoundPreparing()
	RunConsoleCommand("sv_airaccelerate", "4000")
	net.Start("firesttt_bunnyhop")
		net.WriteBool(true)
	net.Broadcast()
end


function activity:Cleanup()
	RunConsoleCommand("sv_airaccelerate", "10")
	net.Start("firesttt_bunnyhop")
		net.WriteBool(false)
	net.Broadcast()
end

LoadActivity(activity)
