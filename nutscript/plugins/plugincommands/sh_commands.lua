local PLUGIN = PLUGIN

PLUGIN.CommandTemplate = function(client, arguments, minArgCount, doWork, isTraceEntity)
	if(doWork == nil) then
		return;
	end;
	
	if (#arguments < minArgCount) then
		if (isTraceEntity) then
			local entity = AdvNut.util.GetPlayerTraceEntity(client);
			
			if (entity and entity:IsPlayer()) then
				doWork(entity, arguments);
			else
				nut.util.Notify(PLUGIN:GetPluginLanguage("trace_not_player"));
			end;
		else
			nut.util.Notify(PLUGIN:GetPluginLanguage("wrong_arg"));
		end;
	else
		local target = nut.command.FindPlayer(client, arguments[1]);
			
		if (target) then
			doWork(target, arguments);
		else
			nut.util.Notify(PLUGIN:GetPluginLanguage("no_ply"), client);
		end;
	end;
end;

local charSpawn = {
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name"),
	onRun = function(client, arguments)
		PLUGIN.CommandTemplate(client, arguments, 1, function(target)
			target:Spawn();
			nut.util.Notify(PLUGIN:GetPluginLanguage("plugin_pc_spawn", client:Name(), target:Name()));
		end, true);
	end
}
nut.command.Register(charSpawn, "charspawn");


local setRank = {
	superAdminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name").." "..nut.lang.Get("syntax_rank"),
	onRun = function(client, arguments)
		PLUGIN.CommandTemplate(client, arguments, 2, function(target, arguments)
			target:SetUserGroup(arguments[2]);
			nut.util.Notify(PLUGIN:GetPluginLanguage("plugin_pc_spawn", client:Name(), target:Name()));
		end, false);
	end
}
nut.command.Register(setRank, "setrank");


local plyKick = {
	adminOnly = true,
	allowDead = true,
	syntax = PLUGIN:GetPluginLanguage("syntax_name").." "..PLUGIN:GetPluginLanguage("plugin_pc_syntax_reason"),
	onRun = function(client, arguments)
		PLUGIN.CommandTemplate(client, arguments, 1, function(target)
			target:Kick(arguments[2] or "No Reason");
			nut.util.Notify(PLUGIN:GetPluginLanguage("plugin_pc_kick", client:Name(), target:Name()));
		end, true);
	end
}
nut.command.Register(plyKick, "plykick");

local plyBan = {
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name").." "..nut.lang.Get("syntax_time"),
	onRun = function(client, arguments)
		PLUGIN.CommandTemplate(client, arguments, 2, function(target)
			local time = tonumber(arguments[2]);
			if (time) then
				target:Ban(time, true);
				nut.util.Notify(PLUGIN:GetPluginLanguage("plugin_pc_ban", client:Name(), target:Name(), time));
			else
				nut.util.Notify(PLUGIN:GetPluginLanguage("wrong_arg"));
			end;
		end, true);
	end
}
nut.command.Register(plyBan, "plyban");