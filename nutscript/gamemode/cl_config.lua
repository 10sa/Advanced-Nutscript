-- Whether or not the money is shown in the side menu.
nut.config.Register("showMoney", true, CLIENT);

-- Whether or not the time is shown in the side menu.
nut.config.Register("showTime", true, CLIENT);

-- If set to false, then color correction will not be enabled.
nut.config.Register("sadColors", true, CLIENT);

-- Whether or not to enable the crosshair.
nut.config.Register("crosshair", false, CLIENT);

-- The dot size of the crosshair.
nut.config.Register("crossSize", 1, CLIENT);

-- The amount of spacing beween each crosshair dot in pixels.
nut.config.Register("crossSpacing", 6, CLIENT);

-- How 'see-through' the crosshair is from 0-255, where 0 is invisible and 255 is fully
-- visible.
nut.config.Register("crossAlpha", 150, CLIENT);

nut.config.Register("targetTall", 0, CLIENT);

AdvNut.hook.Add("SchemaInitialized", "nut_FontConfig", function()
	surface.SetFont("nut_TargetFontSmall");

	_, tall = surface.GetTextSize("W");
	nut.config.Set("targetTall", tall);

	if (nut.config.Get("targetTall")) then
		nut.config.Set("targetTall", nut.config.Get("targetTall") + 2);
	end

	nut.config.Set("targetTall", nut.config.Get("targetTall") or 10);
end)