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

function math.randomchoice(t)
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key
    end
    index = keys[math.random(1, #keys)]
    return t[index]
end

function table.contains(t, element)
  for _, value in pairs(t) do
    if value == element then
      return true
    end
  end
  return false
end

function table.find(t, element)
    for index, value in pairs(t) do
        if value == element then
            return index
        end
    end
end