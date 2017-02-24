nut = nut or GM;
PLUGIN = PLUGIN or {};

function nut.util.BlastDoor(door, direction, time, noCheck)
	if (!door:IsDoor()) then
		return
	end

	if (IsValid(door.dummy)) then
		door.dummy:Remove()
	end

	if (!noCheck) then
		for k, v in pairs(ents.FindInSphere(door:GetPos(), 128)) do
			if (parent != v and v != door and string.find(v:GetClass(), "door")) then
				nut.util.BlastDoor(v, direction, time, true)
			end
		end
	end

	direction = direction or Vector(0, 0, 0)
	time = time or 180
		
	local position = door:GetPos()
	local angles = door:GetAngles()
	local model = door:GetModel()
	local skin = door:GetSkin()

	local dummy = ents.Create("prop_physics")
	dummy:SetPos(position)
	dummy:SetAngles(angles)
	dummy:SetModel(model)
	dummy:SetSkin(skin or 0)
	dummy:Spawn()
	dummy:Activate()

	timer.Simple(1.5, function()
		if (IsValid(dummy)) then
			dummy:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end
	end)
		
	local physObj = dummy:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:Wake()
		physObj:SetVelocity(direction)
	end

	door.dummy = dummy
	door:Fire("unlock", "", 0)
	door:Fire("open", "", 0)

	timer.Simple(0, function()
		door:SetNoDraw(true)
		door:SetNotSolid(true)
		door:DrawShadow(false)
		door.NoUse = true
		door:DeleteOnRemove(dummy)

		timer.Create("nut_DoorRestore"..door:EntIndex(), time, 1, function()
			if (IsValid(door)) then
				if (IsValid(dummy)) then
					local uniqueID = "nut_DoorDummyFade"..dummy:EntIndex()
					local alpha = 255

					timer.Create(uniqueID, 0.1, 255, function()
						if (IsValid(dummy)) then
							alpha = alpha - 1

							dummy:SetRenderMode(RENDERMODE_TRANSALPHA)
							dummy:SetColor(Color(255, 255, 255, alpha))

							if (alpha <= 0) then
								if (IsValid(door) and door.dummy and door.dummy == dummy) then
									door.dummy = nil
								end

								dummy:Remove()
							end
						else
							timer.Remove(uniqueID)
						end
					end)
				end

				door:SetNotSolid(false)
				door:SetNoDraw(false)
				door:DrawShadow(true)
				door.NoUse = false
			end
		end)
	end)
end