EndRoundGame.Modifiers["se_only"] = 
{
	id = "seonly_mod",
	name = "Special-Equipment Spawns",
	description = "nothing goes here",
	wepwhitelist = {},
	roundPreparing = function()
		for _,v in pairs( weapons.GetList()) do
			if v.CanBuy ~= nil then
				if table.contains(v.CanBuy, ROLE_TRAITOR) or table.contains(v.CanBuy, ROLE_DETECTIVE) then
					table.insert(EndRoundGame.CurrentModifier.wepwhitelist, v.ClassName)
				end
			end
		end

		local weapons = ents.FindByClass("weapon_*")
		for _,v in pairs(weapons) do
			if (math.random(6) == 2) then
				local pos = v:GetPos()
				local angle = v:GetAngles()
				local newweapon = ents.Create(math.randomchoice(EndRoundGame.CurrentModifier.wepwhitelist))
				newweapon:SetPos(pos)
				newweapon:SetAngles(angle)
				newweapon.AllowDrop = true
				v:Remove()
				newweapon:Spawn()
			end
		end
	end,
	roundStart = function()
	end,
	roundEnd = function()
	end,
}