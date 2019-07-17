activity = {
	Id = "scopedweps_only",
	Name = "Scoped Weapons Only",
	Description = "Ironsights are out the door, we're only available weapons that have scopes.",
	ActivityType = ACTIVITY_BOTH,
	wepwhitelist = {
		"weapon_ttt_aug",
		"weapon_ttt_sg550",
		"weapon_ttt_sg552",
		"weapon_zm_rifle",
		"weapon_ttt_vss",
		"weapon_ttt_awp",
	},
	ammowhitelist = {
		"item_ammo_smg1_ttt",
		"item_ammo_357_ttt"
	},
	ammoblacklist = {
		"item_box_buckshot_ttt",
		"item_ammo_pistol_ttt",
		"item_ammo_revolver_ttt",
	},
}

function activity:RoundPreparing()
	local weapons = ents.FindByClass("weapon_*")
	for _,v in pairs(weapons) do
		if IsValid(v) then
			local pos = v:GetPos()
			local angle = v:GetAngles()
			local newweapon = ents.Create(math.randomchoice(self.wepwhitelist))
			if IsValid(newweapon) then
				newweapon:SetPos(pos)
				newweapon:SetAngles(angle)
				v:Remove()
				newweapon:Spawn()
			end
		end
	end
	for _,v in pairs(ents.GetAll()) do
		if table.contains(self.ammoblacklist, v:GetClass()) then
			local pos = v:GetPos()
			local angle = v:GetAngles()
			local newammo = ents.Create(math.randomchoice(self.ammowhitelist))
			newammo:SetPos(pos)
			newammo:SetAngles(angle)
			v:Remove()
			newammo:Spawn()
		end
	end
end

LoadActivity(activity)
