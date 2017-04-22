-- ALl of this just for hands that match the player model.
-- And we'll include some misc. player stuff too.

if (CLIENT) then
   	CreateConVar("cl_weaponcolor", "0.30 1.80 2.10", {FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD}, "The value is a Vector - so between 0-1 - not between 0-255")
end

local PLAYER = {}
PLAYER.DisplayName = "Nutscript Player"

local modelList = {}

for k, v in pairs(player_manager.AllValidModels()) do
	modelList[string.lower(v)] = k
end

function PLAYER:Loadout()
	local color = self.Player:GetInfo("cl_weaponcolor")

    self.Player:SetWeaponColor(Vector(color))
    self.Player:SetupHands()

    return
end

function PLAYER:GetHandsModel()
	local hands = AdvNut.hook.Run("PlayerGetHandsModel", self.Player)

	if (hands) then
		return hands
	end

	local model = string.lower(self.Player:GetModel())

	if (model:find("police")) then
		model = "combine"
	else
		local niceName = string.gsub(model, "_", "")

		for k, v in pairs(modelList) do
			if (nut.util.StringMatches(niceName, v)) then
				model = v

				break
			end
		end
	end

	return player_manager.TranslatePlayerHands(model)
end

local playerMeta = FindMetaTable("Player")

-- Weapon raising/lowering stuff.
do
	function playerMeta:WepRaised()
		if (self:GetNetVar("tied")) then
			return false
		end
		
		return self:GetNetVar("wepRaised", false)
	end

	local GetVelocity = FindMetaTable("Entity").GetVelocity
	local Length2D = FindMetaTable("Vector").Length2D

	

	if (SERVER) then
		function playerMeta:SetWepRaised(raised, weapon)
			if (!IsValid(self) or !self.character) then
				return
			end

			weapon = weapon or self:GetActiveWeapon()

			if (IsValid(weapon) and weapon.AlwaysLowered) then
				self:SetNetVar("wepRaised", false)
			else
				self:SetNetVar("wepRaised", raised)
			end
			
			if (IsValid(weapon)) then
				// Legacy //
				if (raised and weapon.OnRaised) then
					weapon:OnRaised();
				elseif (!raised and weapon.OnLowered) then
					weapon:OnLowered();
				end
				// END //
				
				weapon:SetNextPrimaryFire(CurTime() + 1);
				weapon:SetNextSecondaryFire(CurTime() + 1);
			end
		end

		AdvNut.hook.Add("PlayerSwitchWeapon", "nut_AutoLower", function(client, oldWeapon, newWeapon)
			client:DrawViewModel(newWeapon.DrawViewModel != false)

			if (!newWeapon.AlwaysRaised and !nut.config.alwaysRaised[newWeapon:GetClass()]) then
				client:SetWepRaised(false, newWeapon)

				-- Need this some some SWEPs can override the first time we set it to false.
				timer.Simple(0.5, function()
					if (!IsValid(client)) then
						return
					end

					client:SetWepRaised(false, newWeapon)
				end)
			else
				client:SetWepRaised(true, newWeapon)
			end
		end)
	end
end


-- Player ragdoll.
do
	function playerMeta:IsPenetrating()
		if (!self:IsInWorld()) then
			return false
		end
		
		local physicsObject = self:GetPhysicsObject()
		local position = self:GetPos()
		local entities = ents.FindInBox(position + Vector(-32, -32, 0), position + Vector(32, 32, 84))

		for k, v in pairs(entities) do
			if ((self.ragdoll and self.ragdoll == v) or v == self) then
				continue
			end
			
			if (string.find(v:GetClass(), "prop_") or v:IsPlayer() or v:IsNPC()) then
				return true
			end
		end

		if (IsValid(physicsObject)) then
			return physicsObject:IsPenetrating()
		end

		return true
	end

	function playerMeta:IsRagdolled()
		local index = self:GetNetVar("ragdoll", -1)
		local entity = Entity(index)

		if (SERVER) then
			return IsValid(entity), entity
		end

		return IsValid(entity) or index > 0, entity
	end


	if (SERVER) then
		function playerMeta:ForceRagdoll()
			self.ragdoll = ents.Create("prop_ragdoll")
			self.ragdoll:SetModel(self:GetModel())
			self.ragdoll:SetPos(self:GetPos())
			self.ragdoll:SetAngles(self:GetAngles())
			self.ragdoll:SetSkin(self:GetSkin())
			self.ragdoll:SetColor(self:GetColor())
			self.ragdoll:Spawn()
			self.ragdoll:Activate()
			self.ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			self.ragdoll.player = self
			self.ragdoll:SetNetVar("player", self)
			self.ragdoll:CallOnRemove("RestorePlayer", function()
				if (IsValid(self)) then
					self:UnRagdoll()
				end
			end)
			self.ragdoll.grace = CurTime() + 0.5

			for i = 0, self.ragdoll:GetPhysicsObjectCount() do
				local physicsObject = self.ragdoll:GetPhysicsObjectNum(i)

				if (IsValid(physicsObject)) then
					physicsObject:SetVelocity(self:GetVelocity() * 1.25)
				end
			end

			local weapons = {}

			for k, v in pairs(self:GetWeapons()) do
				weapons[#weapons + 1] = v:GetClass()
			end

			self:SetNutVar("weapons", weapons)
			self:StripWeapons()
			self:Freeze(true)
			self:SetNetVar("ragdoll", self.ragdoll:EntIndex())
			self:SetNoDraw(true)
			self:SetNotSolid(true)

			local uniqueID = "nut_RagSafePos"..self:EntIndex()

			timer.Create(uniqueID, 0.33, 0, function()
				if (!IsValid(self) or !IsValid(self.ragdoll)) then
					if (IsValid(self.ragdoll)) then
						self.ragdoll:Remove()
					end

					timer.Remove(uniqueID)

					return
				end

				local position = self:GetPos()

				if (self:GetNutVar("lastPos",position) != position and !self:IsPenetrating() and self:IsInWorld()) then
					self:SetNutVar("lastPos", position)
				end

				self:SetPos(self.ragdoll:GetPos())
			end)
		end

		function playerMeta:UnRagdoll(samePos)
			if (!self:IsRagdolled()) then
				return
			end
			
			local isValid = IsValid(self.ragdoll)
			local position = self:GetNutVar("lastPos")

			if (samePos and isValid) then
				self:SetPos(self.ragdoll:GetPos())
			elseif (position) then
				self:SetPos(position)
			end

			self:SetMoveType(MOVETYPE_WALK)
			self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			self:Freeze(false)
			self:SetNoDraw(false)
			self:SetNetVar("ragdoll", 0)
			self:DropToFloor()
			self:SetMainBar()
			self:SetNotSolid(false)
			self:SetNutVar("lastPos", nil)

			if (isValid) then
				local physicsObject = self.ragdoll:GetPhysicsObject()

				if (IsValid(physicsObject)) then
					self:SetVelocity(physicsObject:GetVelocity())
				end
			end

			for k, v in pairs(self:GetNutVar("weapons", {})) do
				self:Give(v)
			end

			self:SetNutVar("weapons", nil)

			if (isValid) then
				self.ragdoll:Remove()
			end

			timer.Remove("nut_RagTime"..self:EntIndex())
		end

		function playerMeta:SetTimedRagdoll(time, noGetUp)
			self:ForceRagdoll()

			if (time > 0) then
				self:SetNutVar("noGetUp", noGetUp)
				self:SetMainBar("You are regaining conciousness.", time)

				local time2 = 0

				timer.Create("nut_RagTime"..self:EntIndex(), 1, 0, function()
					if (IsValid(self)) then
						local ragdoll = self.ragdoll

						if (ragdoll:GetVelocity():Length2D() >= 4 and ragdoll.grace <= CurTime()) then
							if (!ragdoll.paused) then
								ragdoll.paused = true
								self:SetMainBar()
							end

							return
						elseif (ragdoll.paused) then
							self:SetMainBar("You are regaining conciousness.", time, time2)
							ragdoll.paused = nil
						end

						time2 = time2 + 1

						if (time2 >= time) then
							self:UnRagdoll()
							self:SetNutVar("noGetUp", nil)
							timer.Remove("nut_RagTime"..self:EntIndex())
						end
					end
				end)
			end
		end

		AdvNut.hook.Add("PlayerDeath", "nut_UnRagdoll", function(client)
			client:UnRagdoll(true)
		end)

		AdvNut.hook.Add("EntityTakeDamage", "nut_FallenOver", function(entity, damageInfo)
			if (IsValid(entity.player) and (entity.grace or 0) < CurTime()) then
				damageInfo:ScaleDamage(0.1);

				if (damageInfo:IsDamageType(DMG_CRUSH)) then
					entity.grace = CurTime() + 0.5

					if (damageInfo:GetDamage() <= 10) then
						damageInfo:SetDamage(0)
					end
				end

				entity.player:TakeDamageInfo(damageInfo)
			end
		end)
	else
		AdvNut.hook.Add("CalcView", "nut_RagdollView", function(client, origin, angles, fov)
			local ragdolled, entity = client:IsRagdolled()

			if (ragdolled and IsValid(entity)) then
				local index = entity:LookupAttachment("eyes")
				local attachment = entity:GetAttachment(index)

				local view = {}
					view.origin = attachment.Pos
					view.angles = attachment.Ang
				return view
			end
		end)
	end
end

-- Player nut variable accessors.
do
	local entityMeta = FindMetaTable("Entity")

	function entityMeta:SetNutVar(key, value)
		self.nut = self.nut or {}
		self.nut[key] = value
	end

	function entityMeta:GetNutVar(key, default)
		self.nut = self.nut or {}

		return self.nut[key] or default
	end
end

-- Advanced Nutscript Util Metadata Function.
do
	 function playerMeta:IsRunning()
		if (self:KeyDown(IN_SPEED) and self:Alive() and !self:Crouching() and !self:InVehicle() and !self:IsNoClipping()) then
			return self:GetVelocity():Length() >= self:GetWalkSpeed();
		end;
	end;
	
	// Middle-Method //
	function playerMeta:IsWalking()
		if(!self:IsRunning() and self:Alive() and !self:Crouching() and !self:InVehicle() and !self:IsNoClipping()) then
			 return self:GetVelocity():Length() > 0;
		end;
	end;
	
	function playerMeta:IsNoClipping()
		if(self:GetMoveType() == MOVETYPE_NOCLIP and !self:InVehicle()) then
			return true;
		else
			return false;
		end;
	end;
end

player_manager.RegisterClass("player_nut", PLAYER, "player_default")