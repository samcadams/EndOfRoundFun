activity = {
	Id = "specialequip_spawns",
	Name = "Special Equipment Spawns",
	Description = "Traitor and Detective store items are available as random spawns.",
	ActivityType = ACTIVITY_BOTH,
	wepwhitelist = {},
}

function activity:RoundPreparing()
	for _,v in pairs( weapons.GetList()) do
		if v.CanBuy ~= nil then
			if table.contains(v.CanBuy, ROLE_TRAITOR) or table.contains(v.CanBuy, ROLE_DETECTIVE) then
				table.insert(self.wepwhitelist, v.ClassName)
			end
		end
	end

	local weapons = ents.FindByClass("weapon_*")
	for _,v in pairs(weapons) do
		if (math.random(5) == 2) then
			local pos = v:GetPos()
			local angle = v:GetAngles()
			local newweapon = ents.Create(math.randomchoice(self.wepwhitelist))
			newweapon:SetPos(pos)
			newweapon:SetAngles(angle)
			newweapon.AllowDrop = true
			v:Remove()
			newweapon:Spawn()
		end
	end
end

LoadActivity(activity)
