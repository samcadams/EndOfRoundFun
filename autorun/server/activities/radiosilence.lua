resource.AddSingleFile("sound/endroundfun/radio.wav") --just to make sure

activity = {
	Id = "radiosilence",
	Name = "Radio Silence",
	Description = "Strange electricity bursts have turned off all radios, you can only communicate within talking distance!",
	ActivityType = ACTIVITY_BOTH,
	GamemodeBlacklist = {"bhop"}
}


function activity:RoundStart()
	hook.Add("PlayerSay", "firesttt_radiochatblocker", function(ply, text, team)
		ply:ChatPrint("Your radio no longer works!")
		return ""
	end)

	RunConsoleCommand("ttt_locational_voice", "1")
	hook.Add("TTTPlayerRadioCommand", "firesttt_blocked", function(ply, cmd_name, cmd_target)
		ply:ChatPrint("Your radio no longer works!")
		return true
	end)
	for _,v in pairs(player.GetAll()) do
		v:SendLua('surface.PlaySound("endroundfun/radio.wav")')
	end
end


function activity:Cleanup()
	RunConsoleCommand("ttt_locational_voice", "0")
	hook.Remove("TTTPlayerRadioCommand", "firesttt_blocked")
end

LoadActivity(activity)
