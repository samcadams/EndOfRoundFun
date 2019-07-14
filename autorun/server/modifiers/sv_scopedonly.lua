EndRoundGame.Modifiers["scopedonly"] = 
{
	id = "sonly_mod",
	name = "Scoped-Weapons Only",
	description = "nothing goes here",
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
	roundPreparing = function()
		local weapons = ents.FindByClass("weapon_*")
		for _,v in pairs(weapons) do
			local pos = v:GetPos()
			local angle = v:GetAngles()
			local newweapon = ents.Create(math.randomchoice(EndRoundGame.CurrentModifier.wepwhitelist))
			newweapon:SetPos(pos)
			newweapon:SetAngles(angle)
			v:Remove()
			newweapon:Spawn()
		end
		for _,v in pairs(ents.GetAll()) do
			if table.contains(EndRoundGame.CurrentModifier.ammoblacklist, v:GetClass()) then
				local pos = v:GetPos()
				local angle = v:GetAngles()
				local newammo = ents.Create(math.randomchoice(EndRoundGame.CurrentModifier.ammowhitelist))
				newammo:SetPos(pos)
				newammo:SetAngles(angle)
				v:Remove()
				newammo:Spawn()
			end
		end
	end,
	roundStart = function()
	end,
	roundEnd = function()
	end,
}