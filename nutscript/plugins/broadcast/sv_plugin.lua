function PLUGIN:LoadData()
	local restored = nut.util.ReadTable("bdcast");

	if (restored) then
		for k, v in pairs(restored) do
			local position = v.position;
			local angles = v.angles;
			local frequency  = v.freq;
			local active = v.active;

			local entity = ents.Create("nut_bdcast");
			entity:SetPos(position);
			entity:SetAngles(angles);
			entity:Spawn();
			entity:Activate();
			entity:SetNetVar("active", active);
		end
	end
end

function PLUGIN:SaveData()
	local data = {};
	for k, v in pairs(ents.FindByClass("nut_bdcast")) do
		data[#data + 1] = {
			position = v:GetPos(),
			angles = v:GetAngles(),
			active = v:GetNetVar("active")
		};
	end;
	
	nut.util.WriteTable("bdcast", data);
end;