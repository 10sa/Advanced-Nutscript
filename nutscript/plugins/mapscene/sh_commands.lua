local PLUGIN = PLUGIN;

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {
			position = client:EyePos(),
			angles = client:EyeAngles()
		}

		table.insert(PLUGIN.positions, data)
		netstream.Start(nil, "nut_MapScenePos", {data.position, data.angles})

		PLUGIN:SaveData()
		nut.util.Notify(PLUGIN:GetPluginLanguage("ms_add"), client)
	end
}, "mapsceneadd")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_radius"),
	onRun = function(client, arguments)
		local range = tonumber(arguments[1] or "160") or 160
		local count = 0

		for k, v in pairs(PLUGIN.positions) do
			if (v.position:Distance(client:GetPos()) <= range) then
				count = count + 1

				table.remove(PLUGIN.positions, k)
			end
		end

		if (count > 0) then
			PLUGIN:SaveData()
		end

		nut.util.Notify(PLUGIN:GetPluginLanguage("ms_remove", range, count), client)
	end
}, "mapsceneremove")