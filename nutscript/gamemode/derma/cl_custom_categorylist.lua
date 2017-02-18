local PANEL = {};	

function PANEL:Init()
	self:SetDrawBackground(false);
	self.Paint = function(panel, w, h)
		surface.SetDrawColor(color_black);
		surface.DrawRect(0, 0, w, 20);
	end
end

function PANEL:SetLabel(text)
	self.Header:SetText(text);
	self.Header:SetFont("nut_SmallFont");
end;

// Override Orignal Function. //
function PANEL:SetContents(pContents)
	self.Contents = pContents;
	self.Contents:SetParent(self);
	self.Contents:Dock(FILL);
	self.Contents:DockMargin(2, 0, 2, 0);

	if (!self:GetExpanded()) then
		self.OldHeight = self:GetTall();
	elseif (self:GetExpanded() && IsValid( self.Contents ) && self.Contents:GetTall() < 1) then
		self.Contents:SizeToChildren(false, true);
		self.OldHeight = self.Contents:GetTall();
		self:SetTall(self.OldHeight);
	end

	self:InvalidateLayout(true);
end
vgui.Register("AdvNut_CategoryList", PANEL, "DCollapsibleCategory");