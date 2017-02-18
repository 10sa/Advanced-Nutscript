local PANEL = {}
local width = 64*5+10
local margin = 75

function PANEL:Init()
	self:SetSize(width, 10)
	self:SetDrawBackground(false)
	self:MakePopup();
end

function PANEL:PerformLayout()
	local tall = ScrH() - margin - self:GetTall()
	self:SetPos(margin, tall)
	local x, y = self:ChildrenSize()
	self:SetTall(y)
end

local gradient = surface.GetTextureID("vgui/gradient-r")

vgui.Register("nut_QuickMenu", PANEL, "DPanel")	