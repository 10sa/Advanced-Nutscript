local PLUGIN = PLUGIN or { };

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_string")..nut.lang.Get("syntax_scale"),
	onRun = function(client, arguments)
		if (!arguments[1] or #arguments[1] < 1) then
			nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

			return
		end

		PLUGIN:AddText(client, arguments[1], tonumber(arguments[2]))
		nut.util.Notify(nut.lang.Get("3dt_addtext"), client)
	end
}, "textadd")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_radius"),
	onRun = function(client, arguments)
		local radius = tonumber(arguments[1]) or 256
		local count = PLUGIN:Remove(client:GetShootPos(), radius)
		nut.util.Notify(nut.lang.Get("3dt_removetext", count), client)
	end
}, "textremove")