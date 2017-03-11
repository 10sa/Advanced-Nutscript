local PLUGIN = PLUGIN or { };

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_url")..nut.lang.Get("syntax_width")..nut.lang.Get("syntax_height")..nut.lang.Get("syntax_scale"),
	onRun = function(client, arguments)
		if (!arguments[1] or #arguments[1] < 1) then
			nut.util.Notify(nut.lang.Get("missing_arg", 1), client)
			return
		end

		PLUGIN:AddPanel(client, arguments[1], tonumber(arguments[2]) or 128, tonumber(arguments[3]) or 128, tonumber(arguments[4]))
		nut.util.Notify(PLUGIN:GetPluginLanguage("3dp_addpanel"), client)
	end
}, "paneladd")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_radius"),
	onRun = function(client, arguments)
		local radius = tonumber(arguments[1]) or 256
		local count = PLUGIN:Remove(client:GetShootPos(), radius)

		nut.util.Notify(nut.lang.Get("3dp_removepanel", count), client)
	end
}, "panelremove")