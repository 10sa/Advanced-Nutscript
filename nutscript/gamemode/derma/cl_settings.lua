local PANEL = {}
function PANEL:Init()
	self:AddTitle(nut.lang.Get("settings"));
	self:SetPos(AdvNut.util.GetCurrentMenuPos())
	self:SetSize(AdvNut.util.GetCurrentMenuSize());
	self:MakePopup()
	
	self.list = self:Add("AdvNut_ScrollPanel")
	self.list:Dock(FILL)
	self.list:SetDrawBackground(true)
	self.list:DockPadding(10, 10, 10, 10)

	self.list.Paint = function(panel, w, h)
		surface.SetDrawColor(0, 0, 0, 0);
		surface.DrawRect(0, 0, w, h);
	end
	
	local notice = self:Add("nut_NoticePanel")
	notice:Dock(TOP)
	notice:DockMargin(5, 5, 5, 0)
	notice:SetType(4)
	notice:SetText(nut.lang.Get("settings_tip"))
	
	self.category = {}
	self.options = {}

	hook.Run("AddSettingOptions", self)
end

function PANEL:AddCategory(name)
	local category = self.list:Add("AdvNut_CategoryList")
	category:Dock(TOP)
	category:SetLabel(name)
	category:SetExpanded(true)
	category:DockMargin(5, 5, 5, 5)

	local list = vgui.Create("DPanelList")
	list:SetSpacing(5)
	list:SetAutoSize(true)
	list:EnableVerticalScrollbar(true)
	
	category:SetContents(list)
	category:InvalidateLayout(true)
	category.list = list

	self.category[#self.category] = category

	return category
end

function PANEL:AddSlider(category, name, min, max, var, demc, prefixID)
	if (!category or !name or !min or !max or !var) then
		return
	end

	local slider = vgui.Create("DNumSlider")
	slider:Dock(TOP)
	slider:SetText(name)
	slider.Label:SetTextColor(Color(22, 22, 22))
	slider:SetMin(min)                
	slider:SetMax(max)
	slider:SetDecimals(demc or 0)
	slider:DockMargin(10, 2, 0, 2)
	
	if (prefixID) then
		if (!nut.config[prefixID]) then
			nut.config[prefixID] = {};
		else
			slider:SetValue(nut.config[prefixID][var] or 0);
		end;
	else
		slider:SetValue(nut.config[var] or 0);
	end;

	function slider:OnValueChanged(value)
		if (prefixID != nil) then
			nut.config[prefixID][var] = value
		else
			nut.config[var] = value;
		end;
	end

	category.list:AddItem(slider)

	self.options[#self.options] = slider
end

function PANEL:AddChecker(category, name, var, prefixID)
	if (!category or !name or !var) then
		return
	end
	local checkerPanel = vgui.Create("DPanel");
	checkerPanel:Dock(TOP);
	checkerPanel:SetDrawBackground(false);
	
	local checker = vgui.Create("DCheckBoxLabel", checkerPanel);
	checker:Dock(TOP)
	checker:SetText(name)
	checker:SetTextColor(Color(22, 22, 22))
	checker:DockMargin(5, 5, 0, 0)
	checker:SetTall(17)

	if (prefixID) then
		if (!nut.config[prefixID]) then
			nut.config[prefixID] = {};
		else
			checker:SetValue(nut.config[prefixID][var] or 0);
		end;
	else
		checker:SetValue(nut.config[var] or 0);
	end;
	
	function checker:OnChange(value)
		if (prefixID != nil) then
			nut.config[prefixID][var] = value
		else
			nut.config[var] = value;
		end;
	end

	category.list:AddItem(checkerPanel);

	self.options[#self.options] = checker
end

function PANEL:SyncContents()
end

function PANEL:Think()
end
vgui.Register("nut_Settings", PANEL, "AdvNut_BaseForm")
