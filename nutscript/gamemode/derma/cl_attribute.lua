local PANEL = {}
function PANEL:Init()
	self:AddTitle(nut.lang.Get("attribute"));
	self:SetPos(ScrW() * 0.225, ScrH() * 0.125)
	self:SetSize(AdvNut.util.GetCurrentMenuSize());
	self:MakePopup()
	
	local noticePanel = self:Add( "nut_NoticePanel" )
	noticePanel:Dock( TOP )
	noticePanel:DockMargin( 4, 5, 5, 5 )
	noticePanel:SetType( 4 )
	noticePanel:SetText( nut.lang.Get("attribute_tip") )
	
	local noticePanel = self:Add( "nut_NoticePanel" )
	noticePanel:Dock( TOP )
	noticePanel:DockMargin( 5, 0, 5, 4 )
	noticePanel:SetType( 4 )
	noticePanel:SetText( nut.lang.Get("attribute_tip2") )

	self.list = self:Add("AdvNut_ScrollPanel")
	self.list:Dock(FILL)
	self.list:SetDrawBackground(false);
	
	self.bars = {}

	for k, attribute in ipairs(nut.attribs.GetAll()) do
		local level = LocalPlayer():GetAttrib(k, 0)
		local bar = self.list:Add("nut_AttribBarVisOnly")
		bar:Dock(TOP)
		bar:SetTall(25);
		bar:DockMargin( 8, 10, 8, 0 )
		bar:SetMax(nut.config.startingPoints)
		bar:SetText(attribute.name)
		bar:SetToolTip(attribute.desc)
		bar:SetValue( level )
		bar:SetMax( nut.config.maximumPoints )
		self.bars[k] = bar
	end

end

function PANEL:Think()
end

function PANEL:Reload()
	local parent = self:GetParent()
	self:Remove()
	nut.gui.att = vgui.Create("nut_Attribute", parent)
	nut.gui.menu:SetCurrentMenu(nut.gui.att, true)
end
vgui.Register("nut_Attribute", PANEL, "AdvNut_BaseForm")