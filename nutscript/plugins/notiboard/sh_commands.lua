nut.command.Register({
	syntax = nut.lang.Get("syntax_groupnumber"),
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 450
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity
		local gp = arguments[1] or ""

		if (IsValid(entity) and entity:GetClass() == "nut_notiboard") then
			entity.group = gp
			nut.util.Notify(PLUGIN:GetPluginLanguage("nb_set_group", gp), client)
		else
			nut.util.Notify(PLUGIN:GetPluginLanguage("nb_not_notiborad"), client)
		end
	end
}, "notisetgroup")

nut.command.Register({
	syntax = nut.lang.Get("syntax_groupnumber")..nut.lang.Get("syntax_string"),
	adminOnly = true,
	onRun = function(client, arguments)
		if #arguments < 2 then 
			nut.util.Notify(PLUGIN:GetPluginLanguage("missing_arg", 2), client)
			return
		end
		local gp = arguments[1] or ""
		table.remove(arguments, 1)
		local text = table.concat(arguments, " ")
		local count = 0
		for k, v in pairs(ents.FindByClass("nut_notiboard")) do
			if v.group == gp then
				v:SetNetVar("text", text)
				count = count + 1
			end
		end
		nut.util.Notify(PLUGIN:GetPluginLanguage("nb_set_group_text", gp, count, text), client)
	end
}, "notisetgrouptext")