local PLAYER = FindMetaTable("Player")

util.AddNetworkString( "firesttt_broadcastall" )
util.AddNetworkString( "firesttt_broadcastsingle" )

function BroadcastMsg(...)
	local args = {...}
	net.Start("firesttt_broadcastall")
	net.WriteTable(args)
	net.Broadcast()
end

function PLAYER:PlayerMsg(...)
	local args = {...}
	net.Start("firesttt_broadcastsingle")
	net.WriteTable(args)
	net.Send(self)
end

function FindActivityById(activity_type, id)
	if activity_type == 0 then
		for _,v in pairs(EndRoundGame.Gamemodes) do
			if v.Id == id then
				return v
			end
		end
	end
	if activity_type == 1 then
		for _,v in pairs(EndRoundGame.Modifiers) do
			print(v.Id)
			print(id)
			print("--")
			if v.Id == id then
				return v
			end
		end
	end
	if activity_type > 1 then
		ErrorNoHalt("Incorrect activity type passed to FindActivityById/n")
	end
	return nil
end