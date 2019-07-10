net.Receive("firesttt_csaycustomround", function()
	local name = net.ReadString()
	local description = net.ReadString()
	ULib.csayDraw("CUSTOM ROUND - "..name, Color(255, 0, 0, 255), 10, 0.7 )
	chat.AddText(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), name.." - "..description)
end)

function Draw()
   if not GetGlobalBool("EndRoundGameIsActive") then return end
   surface.SetFont("TabLarge")
   surface.SetTextColor(255, 0, 0, 230)
   local text = "Round is currently a custom gamemode."
   local w, h = surface.GetTextSize(text)

   surface.SetTextPos(30, ScrH() - 200 - h)
   surface.DrawText(text)
end

hook.Add("HUDPaint", "hudpaintdrawathing", function()
   if hook.Call( "HUDShouldDraw", GAMEMODE, "tttnotdisguise" ) then
       Draw(LocalPlayer())
   end
end)


--Custom Gamemode Messages

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