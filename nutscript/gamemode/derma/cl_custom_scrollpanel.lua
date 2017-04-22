local PANEL = {};

function PANEL:Init()
	self:IsVisibleScrollBar();
end;

function PANEL:IsVisibleScrollBar()
	if (!AdvNut.hook.Run("IsUsingScrollBar")) then
		local bar = self:GetVBar()
		bar:SetAlpha(0);
		bar:SetWide(0);
	end;
end;
vgui.Register("AdvNut_ScrollPanel", PANEL, "DScrollPanel");