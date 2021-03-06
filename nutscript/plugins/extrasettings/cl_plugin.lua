local PLUGIN = PLUGIN or {};

PLUGIN:SetPluginConfig(PLUGIN:GetPluginConfig("isDrawVignette", true));
PLUGIN:SetPluginConfig(PLUGIN:GetPluginConfig("isDrawBackgroundBlur", true));
PLUGIN:SetPluginConfig(PLUGIN:GetPluginConfig("isUsingScrollBar", false));

function PLUGIN:SchemaInitialized()
	local data = AdvNut.util.ReadTable(self.uniqueID);
	for key, data in pairs(data) do
		self:SetPluginConfig(key, data);
	end;
	
	self:InitSettingOptions();
end

function PLUGIN:ShutDown()
	local data = {
		isDrawVignette = PLUGIN:GetPluginConfig("isDrawVignette", false);
		isDrawBackgroundBlur = PLUGIN:GetPluginConfig("isDrawBackgroundBlur", false);
		isUsingScrollBar = PLUGIN:GetPluginConfig("isUsingScrollBar", false);
	}
	
	AdvNut.util.WriteTable(self.uniqueID, data);
end


function PLUGIN:InitSettingOptions()
	local categoryName = PLUGIN:GetPluginLanguage("plugin_es_category")
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("plugin_es_drawVignette"),
		var = "isDrawVignette",
		type = "checker",
		category = categoryName,
		prefixID = self.uniqueID
	});
	
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("plugin_es_drawBackgroundBlur"),
		var = "isDrawBackgroundBlur",
		type = "checker",
		category = categoryName,
		prefixID = self.uniqueID
	});
	
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("plugin_es_usingScrollbar"),
		var = "isUsingScrollBar",
		type = "checker",
		category = categoryName,
		prefixID = self.uniqueID
	});
end

function PLUGIN:IsCanDrawingVignette()
	return PLUGIN:GetPluginConfig("isDrawVignette", false);
end;

function PLUGIN:IsCanDrawingBackgroundBlur()
	return PLUGIN:GetPluginConfig("isDrawBackgroundBlur", false);
end;

function GM:IsUsingScrollBar()
	return PLUGIN:GetPluginConfig("isUsingScrollBar", false);
end;
