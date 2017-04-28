local PANEL = {};	
function PANEL:Init()
	self.Paint = function(panel, w, h)
		draw.RoundedBox(6, 0, 0, w, h, color_black);
		draw.RoundedBox(6, 1, 1, w-2, h-2, nut.config.panelBackgroundColor);
	end
end

function PANEL:AddCloseButton()
	self:CreateButtonBase();
	self.buttonBase.CloseButton = vgui.Create("DButton", self.buttonBase);
	self.buttonBase.CloseButton:SetSize(30, 20);
	self.buttonBase.CloseButton:DockMargin(5, 5, 5, 2);
	self.buttonBase.CloseButton:SetText("X");
	self.buttonBase.CloseButton:Dock(RIGHT);
	self.buttonBase.CloseButton.DoClick = function()
		if(IsValid(self.Close)) then
			self:Close();
		else
			self:Remove();
		end;
	end;
	
	self.buttonBase.CloseButton.Paint = function(panel, w, h)
		draw.RoundedBox(5, 0, 0, w, h, color_black);
		draw.RoundedBox(5, 1, 1, w-2, h-2, color_white);
	end;
end;

function PANEL:AddTitle(title, color)
	self:CreateButtonBase();
	self.buttonBase.title = vgui.Create("DLabel", self.buttonBase);
	self.buttonBase.title:SetWide(self:GetWide() * 5);
	self.buttonBase.title:DockMargin(5, 5, 5, 5);
	self.buttonBase.title:Dock(LEFT);
	
	self:SetTitle(title, color);
	return;
end;

function PANEL:SetTitle(title, color)
	if(IsValid(color)) then
		self.buttonBase.title:SetColor(color);
	else
		self.buttonBase.title:SetColor(color_black);
	end;
	
	self.buttonBase.title:SetFont("nut_MediumFont");
	self.buttonBase.title:SetText(title);
	return;
end;

function PANEL:GetTitle()
	return self.buttonBase.title:GetText();
end;

function PANEL:CreateButtonBase()
	if (IsValid(self.buttonBase)) then
		return;
	end;

	self.buttonBase = vgui.Create("DPanel", self);
	self.buttonBase:SetTall(30);
	self.buttonBase:Dock(TOP);
	self.buttonBase:DockMargin(5, 0, 2, 0);
	self.buttonBase:SetDrawBackground(false);
	self.buttonBase.Paint = function(panel, w, h)
		surface.SetDrawColor(color_black);
		surface.DrawRect(2, h-1, w-10, h);
	end;
	
	return;
end;

function PANEL:SetBackgroundColor(color)
	self.Paint = function(panel, w, h)
		surface.SetDrawColor(color);
		surface.DrawRect(0, 0, w, h);
	end
end

function PANEL:SetBarColor(color, pointer)
	self.bar[pointer].Paint = function(panel, w, h)
		surface.SetDrawColor(color);
		surface.DrawRect(0, 0, w, h);
	end
end

// For Override //
function PANEL:Close()
	self:Remove();
end

vgui.Register("AdvNut_BaseForm", PANEL, "DPanel");