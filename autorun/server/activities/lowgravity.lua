activity = {
	Id = "lowgravity",
	Name = "Low Gravity",
	Description = "We're...on the moon?",
	ActivityType = ACTIVITY_BOTH,
}

function activity:RoundPreparing()
	RunConsoleCommand("sv_gravity","200")
end
function activity:Cleanup()
	RunConsoleCommand("sv_gravity","600")
end

LoadActivity(activity)
