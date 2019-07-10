util.AddNetworkString("firesttt_csaycustomround")

--ADD TO UTIL FILE SOMEWHERE AT SOME POINT
function math.randomchoice(t) --Selects a random item from a table
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table
    end
    index = keys[math.random(1, #keys)]
    return t[index]
end


EndRoundGame = {}
EndRoundGame.IsActive = false
EndRoundGame.ActiveGamemode = nil
EndRoundGame.NextRoundCustom = false
EndRoundGame.NextGamemode = nil

EndRoundGame.Gamemodes = {}
--Load gamemodes
local files, directories = file.Find( "addons/endroundfun/lua/autorun/server/games" .. "/*", "GAME" )
local counter = 0
for _,v in pairs(files) do
	include("games/"..v)
	counter = counter + 1
	print("[CUSTOM ROUNDS] Loaded "..counter.." end round gamemodes...."..v)
end


--ROUND MANAGEMENT

hook.Add("TTTPrepareRound", "firespossiblyenable", function()
	SetGlobalBool("EndRoundGameIsActive", EndRoundGame.IsActive)
	
	local rounds_left = GetGlobalInt("ttt_rounds_left")
	
	if rounds_left ~= 1 and not EndRoundGame.NextRoundCustom then return end
	
	if EndRoundGame.NextRoundCustom then
		EndRoundGame.NextRoundCustom = false
	end
	
	--Randomly decide to do an activity, currently will just run one every last map
	
	--Enable end round game
	SetGlobalBool("EndRoundGameIsActive", true)
	
	--Decide which game to use if one is not already selected
	if EndRoundGame.NextGamemode ~= nil then
		EndRoundGame.ActiveGamemode = EndRoundGame.NextGamemode
		EndRoundGame.NextGamemode = nil
	else
		EndRoundGame.ActiveGamemode = math.randomchoice(EndRoundGame.Gamemodes)
	end
	local gm = EndRoundGame.ActiveGamemode

	net.Start("firesttt_csaycustomround")
		net.WriteString(gm.name)
		net.WriteString(gm.description)
	net.Broadcast()
end)

hook.Add("TTTBeginRound", "firesbeginEndRoundGame", function(result)
	if GetGlobalBool("EndRoundGameIsActive") and EndRoundGame.ActiveGamemode ~= nil then
		EndRoundGame.ActiveGamemode.roundStart()
	end
end)

hook.Add("TTTEndRound", "firesdisableEndRoundGame", function(result)
	if GetGlobalBool("EndRoundGameIsActive") and EndRoundGame.ActiveGamemode ~= nil then
		EndRoundGame.ActiveGamemode.roundEnd()
		SetGlobalBool("EndRoundGameIsActive", false)
		EndRoundGame.ActiveGamemode = nil
	end
end)
