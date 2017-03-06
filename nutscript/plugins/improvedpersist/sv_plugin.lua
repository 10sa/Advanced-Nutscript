local PLUGIN = PLUGIN or { };

function PLUGIN:LoadData()
	local contents = nut.util.ReadTable("persist");
	if (contents) then
		local entities, constraints = duplicator.Paste(nil, contents.Entities or {}, contents.Contraints or {});
		for k, v in pairs(entities) do
			v:SetNutVar("persist", true);
			v:SetPersistent(true);
		end;
	end
		
	for k, v in pairs(ents.GetAll()) do
		if(v:GetPersistent()) then
			v:SetNutVar("persist", true);
		end;
	end;
end

function PLUGIN:SaveData()
	local data = {}
	for k, v in pairs(ents.GetAll()) do
		if (v:GetNutVar("persist") and !v:GetPersistent() and v.PersistentSave != false) then
			data[#data + 1] = v
		end
	end
	
	nut.util.WriteTable("persist", duplicator.CopyEnts(data));
end
	
function PLUGIN:PersistentSave()
	for k, v in pairs(ents.GetAll()) do
		if(v:GetPersistent() or v:GetNutVar("persist") and v:IsWorld()) then
			v:SetPersistent(false);
			v:SetNutVar("persist", false);
		end;
	end;
end;