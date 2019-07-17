util.AddNetworkString("firesttt_csaycustomround")
util.AddNetworkString("firesttt_votecustomround")

EndRoundGame = {}
EndRoundGame.IsActive = false
EndRoundGame.ActiveGamemode = nil
EndRoundGame.CurrentModifier = nil
EndRoundGame.NextRoundCustom = false
EndRoundGame.NextRoundModifier = false
EndRoundGame.NextGamemode = nil
EndRoundGame.NextModifier = nil

EndRoundGame.Gamemodes = {}
EndRoundGame.Modifiers = {}

ACTIVITY_GAMEMODE = 0
ACTIVITY_MODIFIER = 1
ACTIVITY_UNKNOWN = 2
ACTIVITY_BOTH = 3

local Activity_Meta = {
	Id = "activity_id",
	Name = "Activity Name",
	Description = "Activity Description",
	ActivityType = ACTIVITY_UNKNOWN,
	GamemodeBlacklist = {}, -- Only use in _MODIFIER or _BOTH
	
	Initialize = function(self) end,
	RoundPreparing = function(self) end,
	RoundStart = function(self) end,
	RoundEnd = function(self) end,
	Cleanup = function(self) end,
}
Activity_Meta.__index = Activity_Meta
function LoadActivity(activity)
	setmetatable(activity, Activity_Meta)
	if activity.ActivityType == 2 then
		ErrorNoHalt("Activity: "..tostring(activity.Id)..". Missing `ActivityType`. Skipping...\n")
		return
	end
	if activity.ActivityType == 3 then
		table.insert(EndRoundGame.Gamemodes, activity)
		table.insert(EndRoundGame.Modifiers, activity)
	end
	if activity.ActivityType == 1 then
		table.insert(EndRoundGame.Modifiers, activity)
	end
	if activity.ActivityType == 0 then
		table.insert(EndRoundGame.Gamemodes, activity)
	end
	activity:Initialize()
end



print("[CUSTOM ROUNDS] Loading files....")
--Load gamemodes and modifiers
local files, directories = file.Find( "addons/endroundfun/lua/autorun/server/activities" .. "/*", "GAME" )
local counter = 0
for _,v in pairs(files) do
	include("activities/"..v)
	counter = counter + 1
	print("[CUSTOM ROUNDS] Loaded "..counter.." end round activities...."..v)
end
print("[CUSTOM ROUNDS] Loaded files!")

local recentlyvoted = {}

-- VOTING
function GetVotingRatio()
	local votedyes = 0
	local votedno = 0
	for _,v in pairs(player.GetAll()) do
		if v:GetNWBool("customroundvote") then
			votedyes = votedyes + 1
		else
			votedno = votedno + 1
		end
	end
	return {(votedyes / (votedno + votedyes)), votedyes, votedno}
end


--Determines if ratio of Yes/No beats the target percentage.
function ShouldCustomRoundHappen(perc)
	return (GetVotingRatio()[1] >= perc)
end

--Wipes votes off everyone
function ResetVotes()
	for _,v in pairs(player.GetAll()) do
		v:SetNWBool("customroundvote", false)
		v:SetNWBool("shownvote", false)
	end
end

net.Receive("firesttt_votecustomround", function(len, ply)
	local castedvote = net.ReadBool()
	local died = net.ReadBool()
	ply:SetNWBool("customroundvote", castedvote)
	ply:SetNWBool("shownvote", true)
	print("[CUSTOM ROUND] Received vote from "..ply:Name().." vote content: "..tostring(castedvote))
	if not table.contains(recentlyvoted, ply) then
		table.insert(recentlyvoted, ply)
		local ratio = GetVotingRatio()[1] * 100
		ratio = math.Clamp(ratio, 0, 100)
		ratio = math.floor(ratio + 0.5)
		if not died then
			BroadcastMsg(Color(255,0,0), "[CUSTOM ROUNDS] ", Color(255,255,255), "The Current Vote Percentage is ", Color(255,0,0), tostring(ratio), "% ", Color(255,255,255), "'Yes'. Vote now with ", Color(255,0,0), "!customvote", Color(255,255,255), ".")
		end
		timer.Simple(120, function()
			table.remove(recentlyvoted, table.find(recentlyvoted, ply))
		end)
	end
end)

hook.Add("PlayerDeath", "handlevoting", function(v, inf, at)
	local rounds_left = GetGlobalInt("ttt_rounds_left")
	local shouldshow = (math.random(rounds_left-1) == 1) --Increases chance as game gets closer.
	if shouldshow and not v:GetNWBool("shownvote") then
		v:SendLua("ShowVotingFrame(true)")
		v:SetNWBool("shownvote", true)
	end
end)

--ROUND MANAGEMENT
math.randomseed(os.time())
hook.Add("TTTPrepareRound", "firespossiblyenable", function()
	EndRoundGame.Cleanup()
	
	SetGlobalBool("EndRoundGameIsActive", EndRoundGame.IsActive)
	local rounds_left = GetGlobalInt("ttt_rounds_left")
	
	--Check if its last round, if we have enough votes or if it was admin forced.
	if rounds_left ~= 1 and not EndRoundGame.NextRoundCustom then return end
	if ShouldCustomRoundHappen(.6) or EndRoundGame.NextRoundCustom then 
		--If admin forced, reset variable
		if EndRoundGame.NextRoundCustom then
			EndRoundGame.NextRoundCustom = false
		end
		--Enable usage with forced commands
		local haveModifier = (math.random(2) == 1) or EndRoundGame.NextRoundModifier
		if haveModifier then
			if EndRoundGame.NextModifier == nil then
				EndRoundGame.CurrentModifier = math.randomchoice(EndRoundGame.Modifiers)
			else
				EndRoundGame.CurrentModifier = EndRoundGame.NextModifier
				EndRoundGame.NextModifier = nil
			end
		end
		--Enable end round game
		SetGlobalBool("EndRoundGameIsActive", true)
		
	
		
		if EndRoundGame.NextGamemode ~= nil then
			EndRoundGame.ActiveGamemode = EndRoundGame.NextGamemode
			EndRoundGame.NextGamemode = nil
			if EndRoundGame.CurrentModifier ~= nil then
					local mod = EndRoundGame.CurrentModifier
					if #mod.GamemodeBlacklist >= 0 then
						if table.contains(mod.GamemodeBlacklist, EndRoundGame.ActiveGamemode.Id) then
							EndRoundGame.CurrentModifier = nil
						end
					end
			end
		else
			local counter = 0 -- Anti overflow crash protection
			
			while EndRoundGame.ActiveGamemode == nil do
				counter = counter + 1
				local candidate = math.randomchoice(EndRoundGame.Gamemodes)
				if EndRoundGame.CurrentModifier ~= nil then
					local mod = EndRoundGame.CurrentModifier
					if mod.GamemodeBlacklist ~= nil then
						if not table.contains(mod.GamemodeBlacklist, candidate.id) then
							EndRoundGame.ActiveGamemode = candidate
						end
					end
				else
					EndRoundGame.ActiveGamemode = candidate
				end
				--Anti overflow crash protection
				if counter >= 200 then
					ErrorNoHalt("[CUSTOM ROUNDS] CRASH STOPPED: Infinite loop detected in gamemode picker, double check your blacklists.\n")
					EndRoundGame.ActiveGamemode = candidate
					ErrorNoHalt("[CUSTOM ROUNDS] Responsible Modifier: "..EndRoundGame.CurrentModifier.Id)
					EndRoundGame.CurrentModifier = nil
				end
			end
		end
		
		
		local gm = EndRoundGame.ActiveGamemode
		net.Start("firesttt_csaycustomround")
			net.WriteString(gm.Name)
			net.WriteString(gm.Description)
			if EndRoundGame.CurrentModifier then
				net.WriteString(EndRoundGame.CurrentModifier.Name)
			else
				net.WriteString("none_included")
			end
		net.Broadcast()
		if EndRoundGame.CurrentModifier ~= nil then
			EndRoundGame.CurrentModifier:RoundPreparing()
		end
		gm:RoundPreparing()
	end
end)

hook.Add("TTTBeginRound", "firesbeginEndRoundGame", function(result)
	if GetGlobalBool("EndRoundGameIsActive") and EndRoundGame.ActiveGamemode ~= nil then
		EndRoundGame.ActiveGamemode:RoundStart()
		if EndRoundGame.CurrentModifier ~= nil then
			EndRoundGame.CurrentModifier:RoundStart()
		end
		--Hook Karma blocker so no one will get penalized if they kill a friendly
		hook.Add("TTTKarmaGivePenalty", "EndRoundGamefunkarma", function(ply, penalty, victim)
			return true
		end)
	end
end)

hook.Add("TTTEndRound", "firesdisableEndRoundGame", function(result)
	if GetGlobalBool("EndRoundGameIsActive") and EndRoundGame.ActiveGamemode ~= nil then
		EndRoundGame.ActiveGamemode:RoundEnd()
		if EndRoundGame.CurrentModifier ~= nil then
			EndRoundGame.CurrentModifier:RoundEnd()
		end
		SetGlobalBool("EndRoundGameIsActive", false)
	end
end)

function EndRoundGame.Cleanup()
	EndRoundGame.ActiveGamemode = nil
	EndRoundGame.CurrentModifier = nil
	hook.Remove("TTTKarmaGivePenalty", "EndRoundGamefunkarma")
	for _,v in pairs(EndRoundGame.Gamemodes) do
		v:Cleanup()
	end
	for _,v in pairs(EndRoundGame.Modifiers) do
		v:Cleanup()
	end
end
