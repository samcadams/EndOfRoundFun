local CATEGORY_NAME = "End Round Fun"


ulx.target_gamemode = {}
table.insert(ulx.target_gamemode,"sleeper")
table.insert(ulx.target_gamemode,"deathmatch")
table.insert(ulx.target_gamemode,"bunnyhop")
table.insert(ulx.target_gamemode,"juggernaut")
table.insert(ulx.target_gamemode,"infection")


function ulx.forcecustomround( calling_ply, should_cancel )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		
		EndRoundGame.NextRoundCustom = not should_cancel
		
		if should_cancel then
			ulx.fancyLogAdmin( calling_ply, true, "#A canceled the next custom round.")
		else
			ulx.fancyLogAdmin( calling_ply, true, "#A forced the next round to be custom.")
		end
	end
end
local forcecustomround = ulx.command( CATEGORY_NAME, "ulx forcecustomround", ulx.forcecustomround, "!forcecustomround" )
forcecustomround:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forcecustomround:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcecustomround:setOpposite( "ulx unforcecustomround", {_, true}, "!unforcecustomround", true )
forcecustomround:help( "Forces the next ingame round to be a custom gamemode round." )


function ulx.forcecustomroundgamemode( calling_ply, target_gamemode, should_silent )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		if EndRoundGame.Gamemodes[target_gamemode] == nil then
			ULib.tsayError( calling_ply, "Gamemode provided returns nil", true )
			return
		end
		EndRoundGame.NextGamemode = EndRoundGame.Gamemodes[target_gamemode]
	    ulx.fancyLogAdmin( calling_ply, true, "#A forced the next custom gamemode to be `"..target_gamemode.."`")
	end
end
local forcecustomroundgamemode = ulx.command( CATEGORY_NAME, "ulx forcecustomroundgamemode", ulx.forcecustomroundgamemode, "!forcecustomroundgamemode" )
forcecustomroundgamemode:addParam{ type=ULib.cmds.StringArg, completes=ulx.target_gamemode, hint="infection" }
forcecustomroundgamemode:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forcecustomroundgamemode:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcecustomroundgamemode:help( "Force the next custom round to be a certain gamemode" )


function ulx.customvote( calling_ply)
	if SERVER then
		calling_ply:SendLua("ShowVotingFrame()")
	end
end
local forcecustomroundgamemode = ulx.command( CATEGORY_NAME, "ulx customvote", ulx.customvote, "!customvote" )
forcecustomroundgamemode:defaultAccess( ULib.ACCESS_ALL )
forcecustomroundgamemode:help( "Opens the voting menu for custom rounds" )

function ulx.getvotingpercentage( calling_ply)
	local ratio = GetVotingRatio() * 100
	calling_ply:PlayerMsg(Color(255,0,0), "[CUSTOM ROUNDS] ", Color(255,255,255), "Current Vote Percent is: ", Color(255,0,0), tostring(ratio), "% ", Color(255,255,255), "'Yes'.")
end
local forcecustomroundgamemode = ulx.command( CATEGORY_NAME, "ulx getvotingpercentage", ulx.getvotingpercentage, "!getvotingpercentage" )
forcecustomroundgamemode:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcecustomroundgamemode:help( "Gets the currently set voting percentage" )