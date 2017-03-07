local PLUGIN = PLUGIN;

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local position = client:GetEyeTraceNoCursor().HitPos
		local angles = client:EyeAngles()
		angles.p = 0
		angles.y = angles.y - 180

		local entity = ents.Create("nut_vendor");
		entity:SetPos(position);
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();

		PLUGIN:SaveData();

		nut.util.Notify(PLUGIN:GetPluginLanguage("created_vendor"), client);
	end
}, "vendoradd")


nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor();
		local entity = trace.Entity;

		if (IsValid(entity) and entity:GetClass() == "nut_vendor") then
			entity:Remove();

			PLUGIN:SaveData();

			nut.util.Notify(PLUGIN:GetPluginLanguage("removed_vendor"), client);
		else
			nut.util.Notify(PLUGIN:GetPluginLanguage("not_trace_vendor"), client);
		end
	end
}, "vendorremove")
