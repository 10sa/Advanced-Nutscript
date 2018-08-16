local PLUGIN = PLUGIN or { };

nut_Fire_sprite = { };
nut_Fire_sprite.fire = Material("particles/fire1") ;
nut_Fire_sprite.nextFrame = CurTime();
nut_Fire_sprite.curFrame = 0;

function PLUGIN:Think()
		if nut_Fire_sprite.nextFrame < CurTime() then
			nut_Fire_sprite.nextFrame = CurTime() + 0.05 * (1 - FrameTime());
			nut_Fire_sprite.curFrame = nut_Fire_sprite.curFrame + 1;
			nut_Fire_sprite.fire:SetFloat("$frame", nut_Fire_sprite.curFrame % 22 );
		end
end

nut.bar.Add("hunger", {
	getValue = function()
		if (LocalPlayer().character) then
			return LocalPlayer().character:GetVar("hunger", 0);
		else
			return 0;
		end
	end,
	color = Color(188, 255, 122)
});

nut.bar.Add("thirst", {
	getValue = function()
		if (LocalPlayer().character) then
			return LocalPlayer().character:GetVar("thirst", 0)
		else
			return 0
		end
	end,
	color = Color(123, 156, 255)
});

function PLUGIN:ShouldDrawTargetEntity(entity)
	if (entity:GetClass() == "nut_stove") then
		return true;
	end
end

function PLUGIN:DrawTargetID(entity, x, y, alpha)
	if (entity:GetClass() == "nut_stove") then
		local mainColor = nut.config.mainColor
		local color = Color(mainColor.r, mainColor.g, mainColor.b, alpha)
		
		nut.util.DrawText(x, y, PLUGIN:GetPluginLanguage("cook_stove_name"), color, "AdvNut_EntityTitle");
		y = y + nut.config.Get("targetTall")
		local text = PLUGIN:GetPluginLanguage("cook_stove_desc")
		nut.util.DrawText(x, y, text, Color(255, 255, 255, alpha), "AdvNut_EntityDesc");
	end
end

function PLUGIN:AddCharInfoData(panel)
	panel.charstatus = panel:AddTextData("");
	panel.hungerstatus = panel:AddTextData("");
	panel.thirststatus = panel:AddTextData("");
end

function PLUGIN:ThinkCharInfo(panel, client)
	local synt_status = nut.lang.Get("synt_fine")
	
	if(client.character:GetVar("hunger") <= 15 or client.character:GetVar("thirst") <= 15 or client:Health() <= 30) then
		synt_status = nut.lang.Get("synt_die")
	elseif (client.character:GetVar("hunger") <= 30) then
		synt_status = nut.lang.Get("synt_hunger")
	elseif (client.character:GetVar("thirst") <= 30) then
		synt_status = nut.lang.Get("synt_thirst")
	end
	
	panel.charstatus:SetText(nut.lang.Get("status_synt")..synt_status);
	panel.hungerstatus:SetText(nut.lang.Get("status_hunger")..client.character:GetVar("hunger").."%");
	panel.thirststatus:SetText(nut.lang.Get("status_thirst")..client.character:GetVar("thirst").."%");
end