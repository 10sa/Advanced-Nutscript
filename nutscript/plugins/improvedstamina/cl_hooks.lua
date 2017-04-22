local PLUGIN = PLUGIN;

function PLUGIN:AddCharInfoData(panel)
	PLUGIN.staminastatusbar = panel:AddStatusBar(LocalPlayer().character:GetVar("stamina", 0), 100, Color(100, 255, 100, 255));
end

function PLUGIN:ThinkCharInfo(panel)
	PLUGIN.staminastatusbar:RefreshBar(LocalPlayer().character:GetVar("stamina", 0));
end