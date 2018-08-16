local PLUGIN = PLUGIN;

PLUGIN.onPlayerSpawnLoaded = false;
function PLUGIN:PlayerLoadout(client)
	client:Give("nut_keys")
end

function PLUGIN:OnReloaded()
	if (self.data) then
		self:LoadData();
	end
end

function PLUGIN:PlayerSpawn()
	if (!self.onPlayerSpawnLoaded) then
		for k, v in pairs(self.data) do
			PrintTable(v);
			if (v.locked) then
				self:LockDoor(ents.GetByIndex(v.index));
			end
		end
		
		self.onPlayerSpawnLoaded = true;
	end
end

function PLUGIN:OnCharChanged(client)
	for k, v in pairs(ents.GetAll()) do
		if (v:GetNetVar("owner") == client) then
			v:SetNetVar("title", PLUGIN:GetPluginLanguage("doors_can_buy"))
			v:SetNetVar("owner", NULL)
		end
	end
end

function PLUGIN:DoorSetUnownable(entity)
	entity:SetNetVar("unownable", true)
	self:SaveData()
end

function PLUGIN:LockDoor(entity)
	if (entity.locked) then
		return
	end

	entity:Fire("Close")
	entity:Fire("Lock");
	entity.locked = true
end

function PLUGIN:UnlockDoor(entity)
	if (!entity.locked) then
		return
	end

	entity:Fire("Unlock")
	entity.locked = false
end 
 
function PLUGIN:DoorSetOwnable(entity)
	entity:SetNetVar("unownable", nil)
	self:SaveData()
end

function PLUGIN:DoorSetHidden(entity, hidden)
	entity:SetNetVar("hidden", hidden)
	self:SaveData()
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
					entity = v2

					break
				end
			end
		end
		
		if (entity.locked) then
			entity.locked = nil;
		end
		
		if (IsValid(entity)) then
			entity:SetNetVar("title", v.title);
			entity:SetNetVar("desc", v.desc);
			entity:SetNetVar("unownable", v.ownable);
			entity:SetNetVar("owner", v.owner); 
			
			if (v.hidden) then
				entity:SetNetVar("hidden", true)
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
				local owner;
				if (v:GetNetVar("owner") == nil) then
					owner = nil;
				else
					owner = v:GetNetVar("owner");
				end;
				
				data[#data + 1] = {
					index = nut.util.GetCreationID(v),
					title = v:GetNetVar("title"),
					desc = v:GetNetVar("desc"),
					ownable = v:GetNetVar("unownable"),
					owner = owner,
					hidden = v:GetNetVar("hidden", false),
					locked = v.locked or false
				}
			end
		end
	end

	self:WriteTable(data)
end