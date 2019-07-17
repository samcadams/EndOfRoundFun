AddCSLuaFile()

SWEP.HoldType                = "melee"

if CLIENT then
   SWEP.PrintName            = "Infector"
   SWEP.Slot                 = 1

   SWEP.DrawCrosshair        = false
   SWEP.ViewModelFlip        = false
   SWEP.ViewModelFOV         = 54

   SWEP.Icon                 = "vgui/ttt/icon_cbar"
end

SWEP.Base                    = "weapon_tttbase"

SWEP.UseHands                = true
SWEP.ViewModel               = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel              = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Damage          = 1
SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip     = -1
SWEP.Primary.Automatic       = true
SWEP.Primary.Delay           = 0.5
SWEP.Primary.Ammo            = "none"

SWEP.Kind                    = WEAPON_MELEE
SWEP.WeaponID                = AMMO_INECTOR

SWEP.NoSights                = true
SWEP.IsSilent                = true

SWEP.Weight                  = 5
SWEP.AutoSpawnable           = false

SWEP.AllowDelete             = false -- never removed for weapon reduction
SWEP.AllowDrop               = false

local sound_single = Sound("Weapon_Crowbar.Single")

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not IsValid(self:GetOwner()) then return end

   if self:GetOwner().LagCompensation then -- for some reason not always true
      self:GetOwner():LagCompensation(true)
   end

   local spos = self:GetOwner():GetShootPos()
   local sdest = spos + (self:GetOwner():GetAimVector() * 70)

   local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
   local hitEnt = tr_main.Entity

   self.Weapon:EmitSound(sound_single)

   if IsValid(hitEnt) or tr_main.HitWorld then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      if not (CLIENT and (not IsFirstTimePredicted())) then
         local edata = EffectData()
         edata:SetStart(spos)
         edata:SetOrigin(tr_main.HitPos)
         edata:SetNormal(tr_main.Normal)
         edata:SetSurfaceProp(tr_main.SurfaceProps)
         edata:SetHitBox(tr_main.HitBox)
         --edata:SetDamageType(DMG_CLUB)
         edata:SetEntity(hitEnt)
		 
		 
		 
			if SERVER then
			 if hitEnt:IsPlayer() then
				util.Effect("BloodImpact", edata)
				self:GetOwner():LagCompensation(false)
				self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
				
				if EndRoundGame.ActiveGamemode ~= nil then
					EndRoundGame.ActiveGamemode.AddZombie(EndRoundGame.ActiveGamemode, hitEnt)
				end
			end
			
			
			
			
         else
            util.Effect("Impact", edata)
         end
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end


   if SERVER then
      local tr_all = nil
      tr_all = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner()})
      
      self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

      if hitEnt and hitEnt:IsValid() then

         local dmg = DamageInfo()
         dmg:SetDamage(self.Primary.Damage)
         dmg:SetAttacker(self:GetOwner())
         dmg:SetInflictor(self.Weapon)
         dmg:SetDamageForce(self:GetOwner():GetAimVector() * 1500)
         dmg:SetDamagePosition(self:GetOwner():GetPos())
         dmg:SetDamageType(DMG_CLUB)

         hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
      end
   end

   if self:GetOwner().LagCompensation then
      self:GetOwner():LagCompensation(false)
   end
end

function SWEP:Think()
	--Thank you jmoak3 for this snippet from the bioball because im stupid as shit
	--[[if (table.Count(self.Owner:GetWeapons()) > 1 && SERVER) then
		self.Owner:StripAll()
		self.Owner:SetMaxHealth(self.Owner:GetMaxHealth()+1)
		self.Owner:SetHealth(self.Owner:Health() + 1)
		self.Owner:Give("ttt_infector")
		self.Owner:SelectWeapon("ttt_infector")
	end]]
end


function SWEP:SecondaryAttack()
end

function SWEP:GetClass()
	return "ttt_infector"
end

function SWEP:OnDrop()
	self:Remove()
end
