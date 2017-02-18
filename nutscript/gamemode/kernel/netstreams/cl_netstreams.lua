netstream.Hook("nut_CurTime", function(data)
	nut.curTime = data
end)

netstream.Hook("nut_LoadingData", function(data)
	if (data == "") then
		nut.loadingText = {}

		return
	end

	table.insert(nut.loadingText, 1, data)

	if (#nut.loadingText > 4) then
		table.remove(nut.loadingText, 5)
	end
end)

netstream.Hook("clSetConfigs", function(data)
	local key = data.key;
	local var = data.var;
	
	if (nut.config[key] != nil) then
		nut.config[key] = var;
	end;
end);

// TO DO : Change To Configs //
// local FADE_TIME = 7

netstream.Hook("nut_FadeIntro", function(data)
	nut.fadeStart = CurTime()
	nut.fadeFinish = CurTime() + 7

	nut.fadeColorStart = CurTime() + 7 + 5
	nut.fadeColorFinish = CurTime() + 7 + 10

	hook.Run("DoSchemaIntro")
end)