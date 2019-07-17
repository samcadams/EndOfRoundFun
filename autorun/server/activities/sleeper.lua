util.AddNetworkString("firesttt_sleepy")

activity = {
	Id = "sleeper",
	Name = "Sleeping Traitors",
	Description = "Regular round however if all traitors die a random innocent will switch roles, continuing the round.",
	ActivityType = ACTIVITY_GAMEMODE,
	sleeper_count = 0,
	sleeper_max = math.random(1,4),
	sleepers = {},
}

function activity:RoundStart()
	hook.Add("PostPlayerDeath", "firestttsleepdeath", function(ply)
		updateSleeper(EndRoundGame.ActiveGamemode)
	end)
	hook.Add("TTTCheckForWin", "firestttsleepercheck", function()
	if GetConVar("ttt_debug_preventwin"):GetBool() then return WIN_NONE end
	   if GAMEMODE.MapWin == WIN_TRAITOR or GAMEMODE.MapWin == WIN_INNOCENT then
		  local mw = GAMEMODE.MapWin
		  GAMEMODE.MapWin = WIN_NONE
		  return mw
	   end

	   local traitor_alive = false
	   local innocent_alive = false
	   for k,v in pairs(player.GetAll()) do
		  if v:Alive() and v:IsTerror() then
			 if v:GetTraitor() then
				traitor_alive = true
			 else
				innocent_alive = true
			 end
		  end

		  if traitor_alive and innocent_alive then
			 return WIN_NONE --early out
		  end
	   end

	   if traitor_alive and not innocent_alive then
		  return WIN_TRAITOR
	   elseif not traitor_alive and innocent_alive and (self.sleeper_count > 0) then --suspicion it wont work
		  return WIN_INNOCENT
	   elseif not innocent_alive then
		  return WIN_TRAITOR
	   end

	   return WIN_NONE
	end)
	hook.Add("PlayerDisconnected", "firestttsleeperdisconnect", function(ply) updateSleeper(EndRoundGame.ActiveGamemode) end)
end

function activity:Cleanup()
	hook.Remove("PostPlayerDeath", "firestttsleepdeath")
	hook.Remove("TTTCheckForWin", "firestttsleepercheck")
	hook.Remove("PlayerDisconnected", "firestttsleeperdisconnect")
end

function updateSleeper(self)
	alive_traitors = {}
	for _,v in pairs(player.GetAll()) do
		if v:Alive() and v:IsTraitor() then table.insert(alive_traitors, v) end
	end
	if #alive_traitors == 0 and (self.sleeper_count < self.sleeper_max) then
		local candidates = {}
		for _,ply in pairs(player.GetAll()) do
			if not ply:IsTraitor() and not ply:IsDetective() and ply:Alive() and not ply:IsSpec() then table.insert(candidates, ply) end
		end
		if #candidates > 1 then
		
			local ply = math.randomchoice(candidates)
			print("[CUSTOM ROUNDS] "..ply:GetName().." is now the sleeper")
			self.sleepers = {}
			table.insert(self.sleepers, ply)
			self.sleeper_count = self.sleeper_count + 1
			self.sleeper_active = true
			
			--Change sleepers role.
			ply:SetRole(ROLE_TRAITOR)
			net.Start("TTT_Role")
            net.WriteUInt(ply:GetRole(), 2)
            net.Send(ply)
			--Tell them
			net.Start("firesttt_sleepy")
            net.WriteEntity(ply)
            net.Send(ply)
			
		end
	end
end

LoadActivity(activity)