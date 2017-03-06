local PLUGIN = PLUGIN
local recognizeCommand = {
	syntax = PLUGIN:GetPluginLanguage("rg_syntax"),
	prefix = "/인식",
	onRun = function(client, arguments)
		local mode = arguments[1]

		if (mode) then
			mode = mode:lower()
		end

		if (mode and mode:find("aim")) then
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*128
				data.filter = client
			local trace = util.TraceLine(data)
			local entity = trace.Entity

			if (IsValid(entity)) then
				PLUGIN:SetRecognized(client, entity)

				nut.util.Notify(PLUGIN:GetPluginLanguage("rg_recongitioned_aim"), client)
			else
				nut.util.Notify(PLUGIN:GetPluginLanguage("rg_not_player"), client)
			end
		else
			local range = nut.config.chatRange
			local text = PLUGIN:GetPluginLanguage("rg_normal")

			if (mode and mode:find("whisper")) then
				range = nut.config.whisperRange
				text = PLUGIN:GetPluginLanguage("rg_whisper")
			elseif (mode and mode:find("yell")) then
				range = nut.config.yellRange
				text = PLUGIN:GetPluginLanguage("rg_yell")
			end

			for k, v in pairs(player.GetAll()) do
				if (v:GetPos():Distance(client:GetPos()) <= range) then
					PLUGIN:SetRecognized(client, v)
				end
			end

			nut.util.Notify(PLUGIN:GetPluginLanguage("rg_recongitioned", text), client)
		end
	end
}

nut.command.Register(recognizeCommand, "recognition")
