local PLUGIN = PLUGIN or { };

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_faction")..nut.lang.Get("syntax_class"),
	onRun = function(client, arguments)
		local faction = arguments[1] or ""
		local class = arguments[2] or ""
		local factionIndex
		local factionTable
		local classID
		local classTable

		if (faction != "") then
			for k, v in pairs(nut.faction.GetAll()) do
				if (faction == v.factionID or  nut.util.StringMatches(faction, v.name)) then
					factionIndex = k
					factionTable = v

					break
				end
			end
		end

		if (class != "" and factionIndex) then
			for k, v in pairs(nut.class.GetByFaction(factionIndex)) do
				if (nut.util.StringMatches(class, v.name)) then
					classID = k
					classTable = v

					break
				end
			end
		end

		local position = client:GetPos() + Vector(0, 0, 8)
		local angles = client:EyeAngles()

		PLUGIN.points[#PLUGIN.points + 1] = {pos = position, ang = angles, faction = factionIndex, class = classID}

		if (classTable) then
			nut.util.Notify(PLUGIN:GetPluginLanguage("sp_add_class", (factionTable and factionTable.name or PLUGIN:GetPluginLanguage("sp_default")), classTable.name), client)
		else
			nut.util.Notify(PLUGIN:GetPluginLanguage("sp_add_faction", (factionTable and factionTable.name or PLUGIN:GetPluginLanguage("sp_default"))), client)
		end

		PLUGIN:SaveData()
	end
}, "spawnadd")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_radius"),
	onRun = function(client, arguments)
		local radius = math.max(tonumber(arguments[1] or "") or 128, 8)
		local i = 0
		local position = client:GetPos()

		for k, v in pairs(PLUGIN.points) do
			if (v.pos:Distance(position) <= radius) then
				i = i + 1
				PLUGIN.points[k] = nil
			end
		end

		nut.util.Notify(PLUGIN:GetPluginLanguage("sp_remove", i), client)
		PLUGIN:SaveData()
	end
}, "spawnremove")