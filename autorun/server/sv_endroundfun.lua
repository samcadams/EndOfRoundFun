util.AddNetworkString("firesttt_csaycustomround")
util.AddNetworkString("firesttt_votecustomround")

EndRoundGame = {}
EndRoundGame.IsActive = false
EndRoundGame.ActiveGamemode = nil
EndRoundGame.CurrentModifier = nil
EndRoundGame.NextRoundCustom = false
EndRoundGame.NextGamemode = nil

EndRoundGame.Gamemodes = {}
EndRoundGame.Modifiers = {}

print("[CUSTOM ROUNDS] Loading files....")
--Load gamemodes and modifiers
local files, directories = file.Find( "addons/endroundfun/lua/autorun/server/games" .. "/*", "GAME" )
local counter = 0
for _,v in pairs(files) do
	include("games/"..v)
	counter = counter + 1
	print("[CUSTOM ROUNDS] Loaded "..counter.." end round gamemodes...."..v)
end
--Load gamemodes and modifiers
local files, directories = file.Find( "addons/endroundfun/lua/autorun/server/modifiers" .. "/*", "GAME" )
local counter = 0
for _,v in pairs(files) do
	include("modifiers/"..v)
	counter = counter + 1
	print("[CUSTOM ROUNDS] Loaded "..counter.." end round modifiers...."..v)
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
	return votedyes / votedno
end


--Determines if ratio of Yes/No beats the target percentage.
function ShouldCustomRoundHappen(perc)
	return (GetVotingRatio() >= perc)
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
	print("[CUSTOM ROUND] Received vote from "..ply:Name().." vote content: "..tostring(castedvote))
	if not table.contains(recentlyvoted, ply) then
		table.insert(recentlyvoted, ply)
		local ratio = GetVotingRatio() * 100
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
	EndRoundGame.CurrentModifier = nil--debug purposes
	SetGlobalBool("EndRoundGameIsActive", EndRoundGame.IsActive)
	local rounds_left = GetGlobalInt("ttt_rounds_left")
	
	--Check if its last round, if we have enough votes or if it was admin forced.
	if rounds_left ~= 1 and not ShouldCustomRoundHappen(0.5) and not EndRoundGame.NextRoundCustom then return end
	
	--If admin forced, reset variable
	if EndRoundGame.NextRoundCustom then
		EndRoundGame.NextRoundCustom = false
	end
	
	local haveModifier = (math.random(2) == 1)
	if haveModifier then
		EndRoundGame.CurrentModifier = math.randomchoice(EndRoundGame.Modifiers)
	end
	
	--Enable end round game
	SetGlobalBool("EndRoundGameIsActive", true)
	
	
	--Decide which game to use if one is not already selected
	if EndRoundGame.NextGamemode ~= nil then
		EndRoundGame.ActiveGamemode = EndRoundGame.NextGamemode
		EndRoundGame.NextGamemode = nil
	else
		local goodtogo = false
		while goodtogo == false do
			EndRoundGame.ActiveGamemode = math.randomchoice(EndRoundGame.Gamemodes)
			if EndRoundGame.CurrentModifier != nil then
				if EndRoundGame.CurrentModifier.gamemodeBlacklist ~= nil then
					if table.contains(EndRoundGame.CurrentModifier.gamemodeBlacklist, EndRoundGame.ActiveGamemode.id) then
						print("[CUSTOM ROUNDS] picked gamemode on blacklist")
					else
						goodtogo = true
						break
					end
				else
					goodtogo = true
					break
				end
			else
				goodtogo = true
				break
			end
		end
	end
	
	local gm = EndRoundGame.ActiveGamemode
	net.Start("firesttt_csaycustomround")
		net.WriteString(gm.name)
		net.WriteString(gm.description)
		if EndRoundGame.CurrentModifier then
			net.WriteString(EndRoundGame.CurrentModifier.name)
		else
			net.WriteString("none_included")
		end
	net.Broadcast()
	if EndRoundGame.CurrentModifier ~= nil then
		EndRoundGame.CurrentModifier.roundPreparing()
	end
	gm.roundPreparing()
end)

hook.Add("TTTBeginRound", "firesbeginEndRoundGame", function(result)
	if GetGlobalBool("EndRoundGameIsActive") and EndRoundGame.ActiveGamemode ~= nil then
		EndRoundGame.ActiveGamemode.roundStart()
		if EndRoundGame.CurrentModifier ~= nil then
			EndRoundGame.CurrentModifier.roundStart()
		end
		--Hook Karma blocker so no one will get penalized if they kill a friendly
		hook.Add("TTTKarmaGivePenalty", "EndRoundGamefunkarma", function(ply, penalty, victim)
			return true
		end)
	end
end)

hook.Add("TTTEndRound", "firesdisableEndRoundGame", function(result)
	if GetGlobalBool("EndRoundGameIsActive") and EndRoundGame.ActiveGamemode ~= nil then
		EndRoundGame.ActiveGamemode.roundEnd()
		if EndRoundGame.CurrentModifier ~= nil then
			EndRoundGame.CurrentModifier.roundEnd()
		end
		SetGlobalBool("EndRoundGameIsActive", false)
		EndRoundGame.ActiveGamemode = nil
		EndRoundGame.CurrentModifier = nil
		ResetVotes()
		--Remove hook so regular rounds work again with Karma.
		hook.Remove("TTTKarmaGivePenalty", "EndRoundGamefunkarma")
	end
end)
