netstream.Hook("nut_LocalPlayerValid", function(client)
	if (!client:GetNutVar("validated")) then
		hook.Run("OnLocalPlayerValid", client)
		client:SetNutVar("validated", true)
	end
end)

netstream.Hook("PlayerGiveWhitelist", function(client, data)
	local factionName = data.factionName;
	local factionIndex = data.factionIndex;
	local target = data.target;
	
	if (!nut.faction.CanBe(target, factionIndex)) then
		target:GiveWhitelist(factionIndex);
		nut.util.Notify(nut.lang.Get("whitelisted", client:Name(), target:Name(), factionName))
	else
		nut.util.Notify(nut.lang.Get("already_whitelisted"), client);
	end;
end);

netstream.Hook("PlayerTakeWhitelist", function(client, data)
	local factionName = data.factionName;
	local factionIndex = data.factionIndex;
	local target = data.target;
	
	if (nut.faction.CanBe(target, factionIndex)) then
		target:TakeWhitelist(factionIndex);
		nut.util.Notify(nut.lang.Get("blacklisted", client:Name(), target:Name(), factionName));
	else
		nut.util.Notify(nut.lang.Get("not_whitelisted"), target);
	end;
end);

netstream.Hook("PlayerGiveFlags", function(client, data)
	local flags = data.flags;
	local target = data.target;
	
	target:GiveFlag(flags);
	nut.util.Notify(nut.lang.Get("flags_give", client:Name(), flags, target:Name()));
end);

netstream.Hook("PlayerTakeFlags", function(client, data)
	local flags = data.flags;
	local target = data.target;
	
	target:TakeFlag(flags);
	nut.util.Notify(nut.lang.Get("flags_take", client:Name(), flags, target:Name()));
end);

netstream.Hook("PlayerKick", function(client, data)
	local reason = data.reason;
	local target = data.target;
	
	target:Kick(reason);
end);

netstream.Hook("PlayerBan", function(client, data)
	local time = data.time
	local target = data.target;
	
	target:Ban(time, true);
end);

netstream.Hook("GetServerConfigs", function(client, data)
	local configs = {};
	for key, var in pairs(nut.config) do
		if (type(var) == "function" or type(var) == "table") then
			continue;
		else
			table.insert(configs, {key = key, var = var});
		end;
	end;
	
	netstream.Start(client, "GetServerConfigs", configs);
end);

netstream.Hook("SetServerConfigs", function(client, data)
	local key = data.key;
	local var = data.var 

	nut.config[key] = var;
	AdvNut.cachedConfig = nut.config;
	nut.util.Notify(nut.lang.Get("system_notify", client:Name(), key, var));
	
	for index, _client in pairs(player.GetAll()) do
		netstream.Start(_client, "clSetConfigs", {key = key, var = var});
	end;
end);