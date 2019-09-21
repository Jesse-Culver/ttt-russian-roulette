
AddCSLuaFile()



SWEP.PrintName          = "Russian Roulette"
SWEP.Slot               = 7

SWEP.ViewModelFOV       = 54
SWEP.ViewModelFlip      = false
SWEP.HoldType              = "normal"
SWEP.EquipMenuData = {
type = "BLANK Russian Roulette",
desc = "Always misses"
};

SWEP.Icon               = "vgui/ttt/icon_russianroulette_nonlethal"


SWEP.Base                  = "weapon_tttbase"

-- if I run out of ammo types, this weapon is one I could move to a custom ammo
-- handling strategy, because you never need to pick up ammo for it
SWEP.Primary.Ammo          = "none"
SWEP.Primary.Recoil        = 0
SWEP.Primary.Damage        = 0
SWEP.Primary.Delay         = 5.0
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Sound         = Sound( "Weapon_357.Single" )

SWEP.Kind                  = WEAPON_EQUIP2
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock          = true -- only buyable once

SWEP.Tracer                = "AR2Tracer"

SWEP.UseHands              = false
SWEP.ViewModel             = Model("models/weapons/fa_sw686/v_fa_sw686.mdl")
SWEP.WorldModel            = Model("models/weapons/w_357.mdl")

local inUse = false

function SWEP:PullTrigger()

end

function SWEP:CanPrimaryAttack()
  return true;
end

function SWEP:PrimaryAttack()
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  
  if not self:CanPrimaryAttack() then return end
  inUse = true
if SERVER then
  
  local response_table = {
    Sound( "npc_citizen.answer04"),
    Sound( "npc_citizen.answer05"),
    Sound( "npc_citizen.answer12"),
    Sound( "npc_citizen.answer17"),
    Sound( "npc_citizen.answer23"),
    Sound( "npc_citizen.answer22"),
    Sound( "npc_citizen.answer27"),
    Sound( "npc_citizen.die"),
    Sound( "npc_citizen.finally"),
    Sound( "npc_citizen.gethellout"),
    Sound( "npc_citizen.goodgod"),
    Sound( "npc_citizen.gordead_ans04"),
    Sound( "npc_citizen.gordead_ans05"),
    Sound( "npc_citizen.gordead_ans06"),
    Sound( "npc_citizen.gordead_ans10"),
    Sound( "npc_citizen.gordead_ans11"),
    Sound( "npc_citizen.gordead_ans12"),
    Sound( "npc_citizen.gordead_ans13"),
    Sound( "npc_citizen.gordead_ques02"),
    Sound( "npc_citizen.letsgo02"),
    Sound( "npc_citizen.ohno"),
    Sound( "npc_citizen.okimready03"),
    Sound( "npc_citizen.outofyourway02"),
    Sound( "npc_citizen.question03"),
    Sound( "npc_citizen.question02"),
    Sound( "npc_citizen.question07"),
    Sound( "npc_citizen.question10"),
    Sound( "npc_citizen.question13"),
    Sound( "npc_citizen.question18"),
    Sound( "npc_citizen.question21"),
    Sound( "npc_citizen.question30"),
    Sound( "npc_citizen.uhoh")
  };
  local ply = self:GetOwner()
  local gun = self
  sound.Play(table.Random(response_table), ply:GetPos())
  timer.Simple(3,function()
    self.Weapon:SendWeaponAnim(ACT_VM_DRYFIRE_SILENCED)
    sound.Play("weapons/firearms/fa_sw686/revolver_dryfire1.wav", ply:GetPos())
    inUse = false
  end)
  self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
end

if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
  self:SetNWFloat( "LastShootTime", CurTime() )
end
end

function SWEP:SecondaryAttack()
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  self:EmitSound( "weapons/firearms/fa_sw686/revolver_spincyl.wav" )
end

function SWEP:PreDrop()
  if inUse == true then
    return
  end
  return self.BaseClass.PreDrop(self)
end

function SWEP:Holster()
 if inUse == true then
  return false
 else
  self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
  return true
 end
end

function SWEP:Deploy()
  self:EmitSound( "weapons/firearms/fa_sw686/revolver_spincyl.wav" )
  self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
  return true
end