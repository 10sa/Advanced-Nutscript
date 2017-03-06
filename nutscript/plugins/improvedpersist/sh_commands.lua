local PLUGIN = PLUGIN or { };

nut.command.Register({
	syntax = PLUGIN:GetPluginLanguage("syntax_bool"),
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor();
		local entity = trace.Entity;

		if (IsValid(entity)) then
			if (!entity:IsWorld()) then
				entity:SetNutVar("persist", util.tobool(arguments[1]));

				if (entity:GetNutVar("persist")) then
					nut.util.Notify(PLUGIN:GetPluginLanguage("ps_saved"), client);
				else
					nut.util.Notify(PLUGIN:GetPluginLanguage("ps_unsaved"), client);
				end
			else
				nut.util.Notify(PLUGIN:GetPluginLanguage("ps_isworldentity"), client);
			end
		else
			nut.util.Notify(PLUGIN:GetPluginLanguage("ps_isworldentity"), client);
		end
	end
}, "setpersist")
