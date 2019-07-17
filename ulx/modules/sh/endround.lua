local CATEGORY_NAME = "End Round Fun"

ulx.target_gamemode = {"deathmatch","infection", "juggernaut", "bunnyhop", "sleeper", "radiosilence_gm", "konly_gm"}
ulx.target_modifier = {"bunnyhop", "konly_mod", "scopedonly", "se_spawns", "radiosilence_mod"}

function ulx.forceround( calling_ply, should_cancel )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		
		EndRoundGame.NextRoundCustom = not should_cancel
		
		if should_cancel then
			ulx.fancyLogAdmin( calling_ply, true, "#A canceled the next custom round.")
		else
			ulx.fancyLogAdmin( calling_ply, true, "#A forced the next round to be custom.")
		end
	end
end
local forceround = ulx.command( CATEGORY_NAME, "ulx forceround", ulx.forceround, "!forceround" )
forceround:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forceround:defaultAccess( ULib.ACCESS_SUPERADMIN )
forceround:setOpposite( "ulx unforceround", {_, true}, "!unforceround", true )
forceround:help( "Forces the next ingame round to be a custom gamemode round." )

function ulx.forceroundtype( calling_ply, target_gamemode, should_silent )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		if FindActivityById(ACTIVITY_GAMEMODE, target_gamemode) == nil then
			ULib.tsayError( calling_ply, "Gamemode provided returns nil", true )
			return
		end
		EndRoundGame.NextGamemode = FindActivityById(ACTIVITY_GAMEMODE, target_gamemode)
	    ulx.fancyLogAdmin( calling_ply, true, "#A forced the next custom gamemode to be `"..target_gamemode.."`")
	end
end
local forceroundtype = ulx.command( CATEGORY_NAME, "ulx forceroundtype", ulx.forceroundtype, "!forceroundtype" )
forceroundtype:addParam{ type=ULib.cmds.StringArg, completes=ulx.target_gamemode, hint="deathmatch" }
forceroundtype:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forceroundtype:defaultAccess( ULib.ACCESS_SUPERADMIN )
forceroundtype:help( "Force the next custom round to be a certain gamemode" )

function ulx.forcemodifier( calling_ply, should_cancel )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		
		EndRoundGame.NextRoundModifier = not should_cancel
		
		if should_cancel then
			ulx.fancyLogAdmin( calling_ply, true, "#A canceled the next forced modifier.")
		else
			ulx.fancyLogAdmin( calling_ply, true, "#A forced the next round to have a modifier.")
		end
	end
end
local forcemodifier = ulx.command( CATEGORY_NAME, "ulx forcemodifier", ulx.forcemodifier, "!forcemodifier" )
forcemodifier:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forcemodifier:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcemodifier:setOpposite( "ulx unforcemodifier", {_, true}, "!unforcemodifier", true )
forcemodifier:help( "Forces the next custom round to have a modifier." )



function ulx.forcemodifiertype( calling_ply, target_modifier, should_silent )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, "This isn't TTT, son.", true ) else
		if FindActivityById(ACTIVITY_MODIFIER, target_modifier) == nil then
			ULib.tsayError( calling_ply, "Modifier provided returns nil", true )
			return
		end
		EndRoundGame.NextModifier = FindActivityById(ACTIVITY_MODIFIER, target_modifier)
	    ulx.fancyLogAdmin( calling_ply, true, "#A forced the next custom modifier to be `"..target_modifier.."`")
	end
end
local forcemodifiertype = ulx.command( CATEGORY_NAME, "ulx forcemodifiertype", ulx.forcemodifiertype, "!forcemodifiertype" )
forcemodifiertype:addParam{ type=ULib.cmds.StringArg, completes=ulx.target_modifier, hint="bhop_mod" }
forcemodifiertype:addParam{ type=ULib.cmds.BoolArg, invisible=true }
forcemodifiertype:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcemodifiertype:help( "Force the next modifier round to be a specific modifier" )


function ulx.customvote( calling_ply)
	if SERVER then
		calling_ply:SendLua("ShowVotingFrame()")
	end
end
local customvote = ulx.command( CATEGORY_NAME, "ulx customvote", ulx.customvote, "!customvote" )
customvote:defaultAccess( ULib.ACCESS_ALL )
customvote:help( "Opens the voting menu for custom rounds" )

function ulx.checkvote( calling_ply)
	local ratio = GetVotingRatio()
	local actual = ratio[1]*100
	local y = ratio[2]
	local n =ratio[3]
	actual = math.Clamp(actual, 0, 100)
	actual = math.floor(actual + 0.5)
	calling_ply:PlayerMsg(Color(255,0,0), "[CUSTOM ROUNDS] ", Color(255,255,255), "Current Vote Percent is: ", Color(255,0,0), tostring(actual), "% ", Color(255,255,255), "(", Color(0,255,0), y.." yes",Color(255,255,255)," to ",Color(255,0,0), n.." no", Color(255,255,255),")")
end
local checkvote = ulx.command( CATEGORY_NAME, "ulx checkvote", ulx.checkvote, "!checkvote" )
checkvote:defaultAccess( ULib.ACCESS_SUPERADMIN )
checkvote:help( "Gets the currently set voting percentage" )