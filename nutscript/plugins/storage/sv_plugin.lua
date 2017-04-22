local PLUGIN = PLUGIN or { };

function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs(ents.FindByClass("nut_container")) do
		if v.generated then continue end
		if (v.itemID) then
			local inventory = v:GetNetVar("inv")

			data[#data + 1] = {
				position = v:GetPos(),
				angles = v:GetAngles(),
				inv = inventory,
				world = v.world,
				lock = v.lock,
				classic = v.classic,
				uniqueID = v.itemID,
				type = v.type
			}
		end
	end

	self:WriteTable(data)
end

timer.Create("nut_SaveContainers", 600, 0, function()
	PLUGIN:SaveData()
end)

function PLUGIN:LoadData()
	local storage = self:ReadTable()
	if (storage) then
		for k, v in pairs(storage) do
			local inventory = v.inv
			local position = v.position
			local angles = v.angles
			local itemTable = nut.item.Get(v.uniqueID)
				
			local amt = 0
			for _, __ in pairs( inventory ) do
				amt = amt + 1
			end

			if ( amt == 0 && !v.world && !v.lock ) then continue end

			if (itemTable) then
				local entity = ents.Create("nut_container")
				entity:SetPos(position)
				entity:SetAngles(angles)
				entity:Spawn()
				entity:Activate()
				entity:SetNetVar("inv", inventory)
				entity:SetNetVar("name", itemTable.name)

				local weight, max = entity:GetInvWeight()
				entity:SetNetVar("weight", weight);
				entity:SetNetVar("maxWeight", max);
					
				entity.itemID = v.uniqueID
				entity.lock = v.lock
				entity.classic = v.classic
				if entity.lock then
					entity:SetNetVar( "locked", true )
				end
				entity.world = v.world
				entity.type = v.type
				entity:SetModel(itemTable.model)
				entity:PhysicsInit(SOLID_VPHYSICS)
				if (itemTable.maxWeight) then
					entity:SetNetVar("maxWeight", itemTable.maxWeight)
				end
				if v.world then
					local phys = entity:GetPhysicsObject()
					if phys and phys:IsValid() then
						phys:EnableMotion(false)
					end
				end
			end
		end
	end
end