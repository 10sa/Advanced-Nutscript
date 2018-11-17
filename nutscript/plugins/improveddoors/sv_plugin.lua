local PLUGIN = PLUGIN;

PLUGIN.onPlayerSpawnLoaded = false;
function PLUGIN:PlayerLoadout(client)
	client:Give("nut_keys")
end

function PLUGIN:OnCharChanged(client)
	for k, v in pairs(ents.GetAll()) do
		if (v:GetNetVar("owner") == client) then
			v:SetNetVar("title", PLUGIN:GetPluginLanguage("doors_can_buy"));
			v:SetNetVar("owner", NULL);
		end
	end
end

function PLUGIN:DoorSetUnownable(entity)
	entity:SetNetVar("unownable", true);
end

function PLUGIN:LockDoor(entity)
	entity:Fire("Close");
	entity:Fire("Lock", "", 0);
	entity:SetNetVar("locked", true);
end

function PLUGIN:UnlockDoor(entity)
	entity:Fire("Unlock");
	entity:SetNetVar("locked", false);
end 
 
function PLUGIN:DoorSetOwnable(entity)
	entity:SetNetVar("unownable", false);
end

function PLUGIN:DoorSetHidden(entity, hidden)
	entity:SetNetVar("hidden", hidden);
end

function PLUGIN:KeyPress(client, key)
	if (key == IN_USE) then
		local entity = AdvNut.util.GetPlayerTraceEntity(client);
		if (AdvNut.hook.Run("PlayerCanUseDoor", client, entity) == false) then
			return;
		end

		if (IsValid(entity)) then
			return AdvNut.hook.Run("PlayerUseDoor", client, entity);
		else 
			return;
		end;
	end;
end;

function PLUGIN:LoadData()
	self.data = self:ReadTable();
	
	for k, v in pairs(self.data) do
		local entity

		if (v.position) then
			entity = ents.FindInSphere(v.position, 10)[1]
			self.data[k] = entity.EntIndex();
		elseif (v.index) then
			for k2, v2 in pairs(ents.GetAll()) do
				if (nut.util.GetCreationID(v2) == v.index) then
					entity = v2;
					break;
				end
			end
		end
		
		if (IsValid(entity)) then
			entity:SetNetVar("title", v.title);
			entity:SetNetVar("desc", v.desc);
			entity:SetNetVar("unownable", v.ownable);
			entity:SetNetVar("owner", v.owner); 
			entity:SetNetVar("hidden", v.hidden);
			entity:SetNetVar("locked", v.locked);
			
			if (v.locked) then
				self:LockDoor(entity);
			end
		end
	end
end

function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs(ents.GetAll()) do
		if (IsValid(v)) then
			local title = v:GetNetVar("title", "")

			if (PLUGIN:IsDoor(v)) then
				data[#data + 1] = {
					index = nut.util.GetCreationID(v),
					title = v:GetNetVar("title"),
					desc = v:GetNetVar("desc"),
					ownable = v:GetNetVar("unownable"),
					owner = v:GetNetVar("owner", nil),
					hidden = v:GetNetVar("hidden", false),
					locked = v:GetNetVar("locked", false)
				}
			end
		end
	end

	self:WriteTable(data)
end