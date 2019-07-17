activity = {
	Id = "konly",
	Name = "Knives Only",
	Description = "Instead of guns, the idiot managing the armory bought knives...",
	ActivityType = ACTIVITY_BOTH,
	GamemodeBlacklist = {"infection", "konly"}
}


function activity:RoundPreparing()
	local weapons = ents.FindByClass("weapon_*")
	for _,v in pairs(weapons) do
		v:Remove()
	end
	timer.Simple(0.1, function()
		for _,ply in pairs(player.GetAll()) do
			print("stripping players")
			ply:StripWeapons()
			ply:StripAmmo()
			ply:Give("weapon_ttt_knife")
		end
	end)
end

function activity:RoundStart()
	for _,v in pairs(player.GetAll()) do
		v:StripWeapons()
		v:StripAmmo()
		v:Give("weapon_ttt_knife")
	end
		
	timer.Create("firesttt_knivesonlyrestock", 0.5, 0, function() 
		for _,v in pairs(player.GetAll()) do
			if not v:HasWeapon("weapon_ttt_knife") then
				v:StripWeapons()
				v:StripAmmo()
				v:Give("weapon_ttt_knife")
			end
		end
	end)
end


function activity:Cleanup()
	timer.Remove("firesttt_knivesonlyrestock")
end

LoadActivity(activity)
