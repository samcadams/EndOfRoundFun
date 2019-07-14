net.Receive("firesttt_csaycustomround", function()
	local name = net.ReadString()
	local description = net.ReadString()
	local modifier = net.ReadString()
	if modifier == "none_included" then
		ULib.csayDraw("CUSTOM ROUND - "..name, Color(255, 0, 0, 255), 10, 0.7 )
		chat.AddText(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), name.." - "..description)
	else	
		ULib.csayDraw("CUSTOM ROUND - "..name.."\nModifier - "..modifier, Color(255, 0, 0, 255), 10, 0.7 )
		chat.AddText(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), name.." - "..description)
		chat.AddText(Color(255,0,0), "[CUSTOM ROUND] ", Color(255,255,255), "Modifier -"..modifier)
	end
end)

function DrawEndround()
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
       DrawEndround(LocalPlayer())
   end
end)

function ShowVotingFrame(died)
	died = died or false
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW() * 400/1920, ScrH() * 150/1080 )
	frame:SetTitle( "Custom Rounds Voting" )
	frame:Center()
	frame:SetVisible( true )
	frame:SetDraggable( false )
	frame:MakePopup()
	
	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock(FILL)
	local onvote = true
	function sheet:OnActiveTabChanged(old, new)
		if onvote == true then
			new:SizeTo(500,500, 1)
			onvote = false
		else
			new:SizeTo(250,250, 1)
			onvote = true 
		end
	end
	
	local panel1 = vgui.Create( "DPanel", sheet )
	
	local ques = vgui.Create("DLabel", panel1)
	ques:SetText("Would you like a Custom Round before the map changes?")
	ques:SetFont("DermaDefaultBold")
	ques:SizeToContents()
	ques:SetColor(Color(0,0,0))
	ques:SetPos(ScrW() * 20 / 1920, ScrH() * 10 / 1080)
	
	local voteyes = vgui.Create( "DCheckBox", panel1 ) 
	voteyes:SetPos(ScrW() *20/1920,ScrH() *30/1080)
	local vylabel = vgui.Create("DLabel", panel1)
	vylabel:SetText("Yes")
	vylabel:SetColor(Color(0,0,0))
	vylabel:SizeToContents()
	vylabel:SetPos(ScrW() *40/1920, ScrH() *30/1080)
	
	local voteno = vgui.Create( "DCheckBox", panel1 ) 
	voteno:SetPos(ScrW() *20/1920,ScrH() *50/1080)
	local vnlabel = vgui.Create("DLabel", panel1)
	vnlabel:SetText("No")
	vnlabel:SetColor(Color(0,0,0))
	vnlabel:SizeToContents()
	vnlabel:SetPos(ScrW() * 40 / 1920, ScrH() * 50 / 1080)
	
	if LocalPlayer():GetNWBool("customroundvote") then
		voteyes:SetValue(1)
		voteno:SetValue(0)
	else
		voteyes:SetValue(0)
		voteno:SetValue(1)
	end
	
	function voteno:OnChange()
		voteyes:SetChecked(not voteno:GetChecked())
		net.Start("firesttt_votecustomround")
			net.WriteBool(voteyes:GetChecked())
			net.WriteBool(died)
		net.SendToServer()
	end
	
	function voteyes:OnChange()
		voteno:SetChecked(not voteyes:GetChecked())
		net.Start("firesttt_votecustomround")
			net.WriteBool(voteyes:GetChecked())
			net.WriteBool(died)
		net.SendToServer()
	end
	
	function frame:OnClose()
		net.Start("firesttt_votecustomround")
			net.WriteBool(voteyes:GetChecked())
			net.WriteBool(died)
		net.SendToServer()
	end
	
	sheet:AddSheet( "Vote", panel1, "icon16/page.png" )

	local panel2 = vgui.Create( "DPanel", sheet )
	panel2:SetContentAlignment(8) --centers everything
	
	local DermaButton = vgui.Create( "DButton", panel2 ) 
	DermaButton:SetText( "Open Explanation" )					
	DermaButton:Center()			
	DermaButton:SetSize( ScrW() * 372/1920, ScrH() * 75/1080 )					
	DermaButton.DoClick = function()				
		gui.OpenURL("https://www.zzzzz.dev/ttt/ttt-custom-round-explanation.html")			
	end
	
	sheet:AddSheet( "Explanation", panel2, "icon16/help.png" )

end