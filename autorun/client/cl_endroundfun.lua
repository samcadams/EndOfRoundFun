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
