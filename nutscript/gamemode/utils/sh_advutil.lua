// Advanced Nutscript Util Function Define Part //
// Created By Tensa 							//

AdvNut.util = nut.util;

function AdvNut.util.GetPlayerTraceEntity(client)
	local dat = {};
	dat.start = client:GetShootPos()
	dat.endpos = dat.start + client:GetAimVector() * 96
	dat.filter = client
	
	return util.TraceLine(dat).Entity;
end;
	
function AdvNut.util.CreateIdentifier(subIdentifier, caller)
	if (Caller) then
		if (Caller == CLIENT) then
			return "AdvNut.Client."..subIdentifier;
		elseif (Caller = SERVER) then
			return "AdvNut.Server."..subIdentifier;
		else
			error("Wrong Caller.");
		end;
	else
		return "AdvNut.Share."..subIdentifier;
	end;
end;
			

function AdvNut.util.LoadCachedConfigs()
	if(AdvNut.cachedConfig != nil) then
		nut.config = table.Copy(AdvNut.cachedConfig);
	end;
end;

function AdvNut.util.DrawOutline(panel, th, color)
	panel.PaintOver = function(panel, w, h)
		surface.SetDrawColor(color);
		for i=0, th-1 do
			surface.DrawOutlinedRect(0 + i, 0 + i, w - i * 2 , h - i * 2);
		end
	end
end

function AdvNut.util.DrawBackgroundBlur(panel)
	if (panel.advnut_bgblur or !hook.Run("IsCanDrawingBackgroundBlur")) then
		return;
	end;
	
	panel.advnut_bgblur = vgui.Create("DPanel");
	panel.advnut_bgblur:SetPos(0, 0);
	panel.advnut_bgblur:SetSize(ScrW(), ScrH());
	panel.advnut_bgblur:SetAlpha(0);
	panel.advnut_bgblur.Paint = function (panel, w, h)
		local blur = Material("pp/blurscreen");
		surface.SetMaterial(blur);
		surface.SetDrawColor(255, 255, 255, 255);
		
		surface.SetMaterial(blur);
		
		for i = 1, 3, 1 do
			blur:SetFloat("$blur", i * 2);
			blur:Recompute();
			
			render.UpdateScreenEffectTexture();
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH());
		end
		
		surface.SetDrawColor(10, 10, 10, 190);
		surface.DrawRect(0, 0, ScrW(), ScrH());
	end
	
	local bgblur = panel.advnut_bgblur;
	local timerIdf = string.format("%s.%s.%s", tostring(panel), "BackgroundBlurDraw", tostring(CurTime()));
	
	local i = 0;
	timer.Create(timerIdf, 0.01, 10, function()
		if (bgblur == nil) then return end;
		
		bgblur:SetAlpha(i);
		i = i + 20;
	end);
end;

function AdvNut.util.RemoveBackgroundBlur(panel)
	local bgblur = panel.advnut_bgblur;
	if (!bgblur) then
		return;
	end;
	
	local timerIdf = string.format("%s.%s.%s", tostring(panel), "BackgroundBlurDraw", tostring(CurTime()));
	
	local i = 200;
	timer.Create(timerIdf, 0.01, 10, function()
		if (bgblur == nil) then return; end;
		
		bgblur:SetAlpha(i);
		i = i - 20;
		
		if (i <= 0) then
			bgblur:Remove();
		end;
	end);
end;

function AdvNut.util.GetScreenScaleFontSize(fontSize)
	return ScreenScale(fontSize);
end;

function AdvNut.util.DrawRoundedBox(panel, corner, x, y, w, h)
	panel.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 0));
		surface.DrawRect(0, 0, 0, 0);
		
		draw.RoundedBox(6, 0, 0, w, h, color_black);
		draw.RoundedBox(6, 1, 1, w-2, h-2, nut.config.panelBackgroundColor);
	end;
end;

function AdvNut.util.PluginIncludeDir(directory, uniqueID, isBasePlugin)
	local pluginPath = ((!isBasePlugin and SCHEMA.folderName) or "nutscript").."/plugins/"..uniqueID.."/"..directory;
	
	for k, v in pairs(file.Find(pluginPath.."/*.lua", "LUA")) do
		nut.util.Include(pluginPath.."/"..v);
	end
end

function AdvNut.util.GetCurrentMenuSize()
	return (ScrW() * nut.config.menuWidth), (ScrH() * nut.config.menuHeight);
end;

function AdvNut.util.GetCurrentMenuPos()
	return (ScrW() * 0.225), (ScrH() * 0.125);
end;

function AdvNut.util.GetPanelScreenCenterPosition(panel, width, height)
	return (ScrW() - panel:GetWide()) * (width or 0.5), (ScrH() - panel:GetTall()) * (height or 0.5);
end;

function AdvNut.util.DrawCenterGradient(x, y, w, h, color)
	surface.SetDrawColor(color.r, color.g, color.b, color.a);
	surface.SetTexture(surface.GetTextureID("gui/center_gradient"));
	surface.DrawTexturedRect(x, y, w, h);
end;

function AdvNut.util.Draw3DText(text, font, x, y, color, alignX, alignY)
	local realX = math.abs(x);
	local realY = math.abs(y);
	
	draw.SimpleText(text, font, realX, realY, color, alignX, alignY);
end;

function AdvNut.util.GetTextSize(font, text)
	surface.SetFont(font);
	return surface.GetTextSize(text);
end;
