nut.setting = nut.setting or {}

if (CLIENT) then -- CLIENTSIDE TEST.
	nut.setting.vars = {}
	function nut.setting.Register(data)
		if (!data) then
			return
		end

		if (!table.HasValue(nut.setting.vars, data)) then
			table.insert(nut.setting.vars, data)
		end;
	end
	
	nut.setting.Register({
		name = nut.lang.Get("settings_crosshair"),
		var = "crosshair",
		type = "checker",
		category = nut.lang.Get("settings_category_framework")
	})
	
	nut.setting.Register({
		name = nut.lang.Get("settings_crosshair_size"),
		var = "crossSize",
		type = "slider",
		min = 0,
		max = 5,
		category = nut.lang.Get("settings_category_framework")
	})
	
	nut.setting.Register({
		name = nut.lang.Get("settings_crosshair_spacing"),
		var = "crossSpacing",
		type = "slider",
		min = 0,
		max = 20,
		category = nut.lang.Get("settings_category_framework")
	})

	nut.setting.Register({
		name = nut.lang.Get("settings_crosshair_alpha"),
		var = "crossAlpha",
		type = "slider",
		min = 0,
		max = 255,
		category = nut.lang.Get("settings_category_framework")
	})	

	AdvNut.hook.Add("SchemaInitialized", "ClientSettingLoad", function()
		local contents 
		local decoded

		if (file.Exists("advnutscript/settings.txt", "DATA")) then
			contents = file.Read("advnutscript/settings.txt", "DATA")
		end

		if (contents) then
			decoded = pon.decode(contents)
		end

		local customSettings = {}
		if decoded then
			customSettings = decoded
		end

		for k, v in pairs(customSettings) do
			nut.config[k] = v
		end
	end)

	AdvNut.hook.Add("ShutDown", "ClientSettingLoad", function()
		local customSettings = {}
		for k, v in pairs(nut.setting.vars) do
			customSettings[v.var] = nut.config[v.var]
		end

		local encoded = pon.encode(customSettings)
		file.CreateDir("advnutscript/")
		file.Write("advnutscript/settings.txt", encoded)
	end)

	function GM:AddSettingOptions(panel)
		for k, v in pairs(nut.setting.vars) do
			if (!panel.category[v.category]) then
				local category = panel:AddCategory( v.category )

				panel.category[v.category] = category
			end

			local category = panel.category[v.category]

			if (category) then
				if (v.type == "checker") then
					panel:AddChecker(category, v.name, v.var, v.prefixID);
				elseif (v.type == "slider") then
					panel:AddSlider(category, v.name, v.min, v.max, v.var, v.demical or 0, v.prefixID);
				end
			end
		end
	end

end