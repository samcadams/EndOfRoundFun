hook.Add("TTTPlayerSpeedModifier", "firesttt_infectionspeed", function(ply, slowed, mv)
	if ply:GetNWBool("infected", false) then
		return 1.5
	end
end)