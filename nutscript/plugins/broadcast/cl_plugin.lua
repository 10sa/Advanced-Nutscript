local PLUGIN = PLUGIN;

surface.CreateFont("nut_ChatFontRadio", {
	font = mainfont,
	size = AdvNut.util.GetScreenScaleFontSize(7.5),
	weight = 500,
	antialias = true
});

function PLUGIN:ShouldDrawTargetEntity(entity)
	if (entity:GetClass() == "nut_bdcast") then
		return true;
	end;
end;

function PLUGIN:DrawTargetID(entity, x, y, alpha)
	if (entity:GetClass() == "nut_bdcast") then
		local mainColor = nut.config.mainColor;
		local color = Color(mainColor.r, mainColor.g, mainColor.b, alpha);

		nut.util.DrawText(x, y, PLUGIN:GetPluginLanguage("bc_machine"), color);
		y = y + nut.config.Get("targetTall");
		local text = PLUGIN:GetPluginLanguage("bc_machine_desc");
		nut.util.DrawText(x, y, text, Color(255, 255, 255, alpha));
	end
end;