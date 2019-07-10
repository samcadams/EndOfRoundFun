local CATEGORY_NAME = "End Round Fun"


ulx.target_gamemode = {}
table.insert(ulx.target_gamemode,"sleeper")
table.insert(ulx.target_gamemode,"deathmatch")
table.insert(ulx.target_gamemode,"bunnyhop")


function ulx.forcecustomround( calling_ply, should_cancel )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		
		EndRoundGame.NextRoundCustom = not should_cancel
		
		if should_cancel then
			ulx.fancyLogAdmin( calling_ply, "#A canceled the next custom round.")
		else
			ulx.fancyLogAdmin( calling_ply, "#A forced the next round to be custom.")
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
	    ulx.fancyLogAdmin( calling_ply, true, "#A forced the next custom gamemode to be %s", target_gamemode)
	end
end
local forcecustomroundgamemode = ulx.command( CATEGORY_NAME, "ulx forcecustomroundgamemode", ulx.forcecustomroundgamemode, "!forcecustomroundgamemode" )
forcecustomroundgamemode:addParam{ type=ULib.cmds.StringArg, completes=ulx.target_gamemode, hint="Gamemode" }
forcecustomroundgamemode:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forcecustomroundgamemode:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcecustomroundgamemode:help( "Force the next custom round to be a certain gamemode" )