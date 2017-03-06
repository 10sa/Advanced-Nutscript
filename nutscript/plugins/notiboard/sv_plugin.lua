local PLUGIN = PLUGIN or { };

function PLUGIN:LoadData()
	local restored = nut.util.ReadTable("notiboards")

	if (restored) then
		for k, v in pairs(restored) do
			local position = v.position
			local angles = v.angles
			local title  = v.title
			local text = v.text
			local group = v.group

			local entity = ents.Create("nut_notiboard")
			entity:SetPos(position)
			entity:SetAngles(angles)
			entity:Spawn()
			entity:Activate()
			entity:SetNetVar("title", title)
			entity:SetNetVar("text", text)
			entity.group = group

			local physicsObject = entity:GetPhysicsObject();
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
				physicsObject:Sleep();
			end

		end
	end
end

function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs(ents.FindByClass("nut_notiboard")) do
		data[#data + 1] = {
			position = v:GetPos(),
			angles = v:GetAngles(),
			title = v:GetNetVar("title"),
			text = v:GetNetVar("text"),
			group = v.group
		}
	end

	nut.util.WriteTable("notiboards", data)
end