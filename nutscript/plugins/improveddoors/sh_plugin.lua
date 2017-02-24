PLUGIN.name = "개선된 도어 시스템 (Improved Door System)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "기존 도어 플러그인을 개선한 도어 플러그인입니다."

nut.config.doorCost = 50
nut.config.doorSellAmount = 25

function PLUGIN:IsDoor(entity)
	local class = string.lower(entity:GetClass() or "");
	
	if (class and (class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating")) then
		return true;
	else
		return false;
	end;
end
// Plugin Metafunction Addtion.
AdvNut.util.IsDoor = PLUGIN.IsDoor;

local entityMeta = FindMetaTable("Entity")
function entityMeta:IsDoor()
	local class = string.lower(self:GetClass() or "");
	
	if (class and (class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating")) then
		return true;
	else
		return false;
	end;
end; 

function PLUGIN:IsDoorOwned(entity)
	if (entity:GetNetVar("owner") != nil) then
		return true
	else
		return false;
	end;
end

function PLUGIN:GetDoorOwner(entity)
	return entity:GetNetVar("owner")
end

function PLUGIN:EqualDoorOwner(client, entity)
	if (client:SteamID() == entity:GetNetVar("owner")) then
		return true;
	else
		return false;
	end;
end;

function PLUGIN:SetDoorOwner(entity, client)
	if (client) then
		entity:SetNetVar("owner", client:SteamID());
	else
		entity:SetNetVar("owner", nil);
	end;
end;

nut.util.Include("sh_commands.lua");
nut.util.Include("cl_plugin.lua");
nut.util.Include("sv_plugin.lua");
nut.util.Include("sh_util.lua");
