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

netstream.Hook(AdvNut.util.CreateIdentifier("SetConfigs", CLIENT), function(data)
	local key = data.key;
	local var = data.var;
	
	if (nut.config[key] != nil) then
		nut.config[key] = var;
	end;
end);

netstream.Hook("nut_FadeIntro", function(data)
	nut.fadeStart = CurTime();
	nut.fadeFinish = CurTime() + nut.config.introFadeTime;

	nut.fadeColorStart = CurTime() + nut.config.introFadeTime + 5;
	nut.fadeColorFinish = CurTime() + nut.config.introFadeTime + 10;

	AdvNut.hook.Run("DoSchemaIntro")
end)
