net.Receive("firesttt_bunnyhop", function()
	local toggle = net.ReadBool()
	if toggle then
		hook.Add("Think", "firestttbhop", function()
			if input.IsKeyDown(KEY_SPACE) then
				if LocalPlayer():IsOnGround() then
					RunConsoleCommand("+jump")
					timer.Create("Bhop", 0, 0.01, function()
						RunConsoleCommand("-jump")
					end)
				end
			end
		end)
	else
		hook.Remove("Think", "firestttbhop")
	end
end)

net.Receive("firesttt_sleepy", function()
	chat.AddText(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), "You're the Sleeper Traitor. Betray those who are innocent.")
end)

net.Receive("firesttt_juggernaut", function()
	chat.AddText(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), "You're going to be the Juggernaut this round, Get armed and ready.")
end)


net.Receive("firesttt_broadcastall",function(len) 
		local msg = net.ReadTable()
		chat.AddText(unpack(msg))
		chat.PlaySound()
end)