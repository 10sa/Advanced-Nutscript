local PLUGIN = PLUGIN or { };

nut.command.Register({
	adminOnly = true,
	syntax = PLUGIN:GetPluginLanguage("syntax_name")..PLUGIN:GetPluginLanguage("syntax_area_showtime"),
	onRun = function(client, arguments)
		local name = arguments[1] or PLUGIN:GetPluginLanguage("area_area")
		local showTime = util.tobool(arguments[2] or "true")

		if (!client:GetNutVar("areaMin")) then
			if (!name) then
				nut.util.Notify(PLUGIN:GetPluginLanguage("missing_arg", 1), client)

				return
			end

			client:SetNutVar("areaMin", client:GetPos())
			client:SetNutVar("areaName", name)
			client:SetNutVar("areaShowTime", showTime)

			nut.util.Notify(PLUGIN:GetPluginLanguage("area_pointstart"), client)
		else
			local data = {}
			data.min = client:GetNutVar("areaMin")
			data.max = client:GetPos()
			data.name = client:GetNutVar("areaName")
			data.showTime = client:GetNutVar("areaShowTime")

			client:SetNutVar("areaMin", nil)
			client:SetNutVar("areaName", nil)
			client:SetNutVar("areaShowTime", nil)

			table.insert(PLUGIN.areas, data)

			nut.util.WriteTable("areas", PLUGIN.areas)
			nut.util.Notify(PLUGIN:GetPluginLanguage("area_add"), client)
		end
	end
}, "areaadd")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local count = 0

		for k, v in pairs(PLUGIN.areas) do
			if (table.HasValue(ents.FindInBox(v.min, v.max), client)) then
				table.remove(PLUGIN.areas, k)

				count = count + 1
			end
		end

		nut.util.WriteTable("areas", PLUGIN.areas)
		nut.util.Notify(PLUGIN:GetPluginLanguage("area_remove", count), client)
	end
}, "arearemove")