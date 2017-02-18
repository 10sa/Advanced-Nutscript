local PANEL = {};

function PANEL:Init()
	self:AddTitle("");
	self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight * 0.5);
	self:SetPos(AdvNut.util.GetPanelScreenCenterPosition(self, nil, 0.4));
	self:SetVisible(false);
	
	self.noticebar = vgui.Create("nut_NoticePanel", self);
	self.noticebar:Dock(TOP);
	self.noticebar:DockMargin(10, 5, 10, 5);
	self.noticebar:SetType(4);
	self.noticebar:SetText("");
	
	self.editablePanel = vgui.Create("EditablePanel", self);
	self.editablePanel:Dock(FILL);
	self.editablePanel:DockMargin(5, 5, 5, 5);
	self.editablePanel.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 0));
		surface.DrawRect(0, 0, w, h);
	end;
end;

function PANEL:SetText(text)
	self.noticebar:SetText(text);
end;

function PANEL:SetType(type)
	self.noticebar:SetType(type);
end;

function PANEL:Next(prevPanel)
	local x, y = self:GetPos();
	local panel = self;
	
	if(prevPanel != nil) then
		prevPanel:Prev();
		timer.Simple(0.2, function()
			panel:Next();
			return;
		end);
	else
		self:SetPos(ScrW(), y);
		self:SetVisible(true);
		self:MoveTo((ScrW() - self:GetWide()) * 0.5, y, 0.5);
	end;
end;

function PANEL:Prev()
	local x, y = self:GetPos();
	self:MoveTo(self:GetWide() * -1, y, 0.5, 0, -1, function()
		self:SetVisible(false);
	end);
end;

// For Override //
function PANEL:NextCallback()

end;

function PANEL:GetData()

end;

function PANEL:ValidCheck()

end;
vgui.Register("AdvNut_charCreateBase", PANEL, "AdvNut_BaseForm")


local PANEL = {};

function PANEL:Init()
	self:SetTitle(nut.lang.Get("faction_select"));
	self:SetText(nut.lang.Get("faction_select_desc"));

	self.factionComboBox = vgui.Create("DComboBox", self.editablePanel);
	self.factionComboBox:Dock(TOP);
	self.factionComboBox:DockMargin(10, 0, 10, 0);
	self.factionComboBox.OnSelect = self.OnSelect;
	self.factionComboBox:SetValue(nut.lang.Get("request_select_faction"));
	
	self.factionImage = vgui.Create("DPanel", self.editablePanel);
	self.factionImage:Dock(FILL);
	self.factionImage:DockMargin(5, 5, 5, 5);
	self.factionImage:SetDrawBackground(false);
	self.factionImage.Paint = function(panel, w, h)
		AdvNut.util.DrawOutline(self.factionImage, 1, color_black);
	end;
end;

function PANEL:AddFactionChoice(faction, factionInfo)
	self.factionComboBox:AddChoice(faction, factionInfo);
end;

function PANEL:OnSelect(index, value, factionInfo)
	if(IsValid(factionInfo.image)) then
		self.factionImage.Paint = function(panel, w, h)
			surface.SetTexture(factionInfo.image);
			surface.SetDrawColor(Color(0, 0, 0, 255));
			surface.DrawTexturedRect(0, 0, w, h);
		end;
	end;
end;

function PANEL:NextCallback(data)
	for k, v in ipairs(data) do
		self:AddFactionChoice(v.name, {
			image = v.image,
			faction = v
	}); end;
end

function PANEL:GetData()
	local index = self.factionComboBox:GetSelectedID();
	local factionData = self.factionComboBox:GetOptionData(index);
	return {
		faction = factionData.faction.index, 
		arg = factionData
	};
end;

function PANEL:ValidCheck()
	if(self.factionComboBox:GetSelected() == nil) then
		self:SetText(nut.lang.Get("not_select_faction"));
		self:SetType(5);
	
		return false;
	else
		self:SetType(4);
		self:SetText(nut.lang.Get("faction_select_desc"));
	end;
end;
vgui.Register("AdvNut_charCreateFactionSelect", PANEL, "AdvNut_charCreateBase");


local PANEL = {};

function PANEL:Init()
	self:SetTitle(nut.lang.Get("charinfo_select"));
	self:SetText(nut.lang.Get("charinfo_select_desc"));
	self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight * 0.65);
	self:SetPos((ScrW() - self:GetWide()) * 0.5, ScrH() * 0.2);
	
	self.nameEntry = self:CreateTextEntry(self.editablePanel, nut.lang.Get("name"), nut.config.nameMinChars, nut.config.maxNameLength);
	self.descEntry = self:CreateTextEntry(self.editablePanel, nut.lang.Get("desc"), nut.config.descMinChars, nut.config.maxDescLength);
	
	self.modelPanel = vgui.Create("DModelPanel", self);
	self.modelPanel:Dock(RIGHT);
	self.modelPanel:SetFOV(72);
	self.modelPanel:SetCursor("none")
	self.modelPanel:SetWide(self:GetWide() * 0.4);
	self.modelPanel.OnMouseEntered = function() end;
	self.modelPanel.OnMousePressed = function() end;
	self.modelPanel.LayoutEntity = function(panel, entity)
		entity:SetAngles(Angle(0, 45, 0));
		entity:SetIK(false)

		panel:RunAnimation()
	end;
	
	self.modelLayout = vgui.Create("DIconLayout");
	self.modelLayout:SetSpaceX(2);
	self.modelLayout:SetSpaceY(2);
	self.modelLayout:SetDrawBackground(false);
	
	self.modelListScroll = vgui.Create("AdvNut_ScrollPanel", self.editablePanel);
	self.modelListScroll:Dock(FILL);
	self.modelListScroll:DockMargin(5, 5, 5, 5);
	
	self.modelList = vgui.Create("AdvNut_CategoryList", self.modelListScroll);
	self.modelList:SetContents(self.modelLayout);
	self.modelList:InvalidateLayout(true);
	self.modelList:SetLabel(nut.lang.Get("model"));
	self.modelList:Dock(FILL);
end;

function PANEL:AddCharacterModel(model, gender)
	local modelIcon = self.modelLayout:Add("SpawnIcon");
	modelIcon:SetModel(model);
	modelIcon:SetTooltip(nil);
	modelIcon:SetSize(nut.config.iconSize, nut.config.iconSize);
	modelIcon.gender = gender;
	modelIcon.DoClick = function(panel)
		self.selectedModel = {model = model, gender = gender};
		self:SetModel(model);
	end;
end;

function PANEL:SetModel(entity)
	self.modelPanel:SetModel(entity);
	local entity = self.modelPanel.Entity;
	local sequence = entity:LookupSequence("idle")

	if (sequence <= 0) then
		sequence = entity:LookupSequence("idle_subtle")
	end

	if (sequence <= 0) then
		sequence = entity:LookupSequence("batonidle2")
	end

	if (sequence <= 0) then
		sequence = entity:LookupSequence("idle_unarmed")
	end

	if (sequence <= 0) then
		sequence = entity:LookupSequence("idle01")
	end

	if (sequence > 0) then
		entity:ResetSequence(sequence)
	end
end;

function PANEL:CreateTextEntry(panel, entryName, minChars, maxChars)
	if(!IsValid(panel.TextEntry)) then
		panel.TextEntry = {};
	end;
	
	panel.TextEntry = vgui.Create("DPanel", panel);
	panel.TextEntry:Dock(TOP);
	panel.TextEntry:SetDrawBackground(false);
	
	panel.TextEntry.TextEntyLabel = vgui.Create("DLabel", panel.TextEntry);
	panel.TextEntry.TextEntyLabel:Dock(TOP);
	panel.TextEntry.TextEntyLabel:DockMargin(10, 0, 10, 5);
	panel.TextEntry.TextEntyLabel:SetText(entryName);
	panel.TextEntry.TextEntyLabel:SetColor(color_black);
	panel.TextEntry.TextEntyLabel:SetFont("nut_MediumFont");
	
	panel.TextEntry.EntryPanel = vgui.Create("DPanel", panel.TextEntry);
	panel.TextEntry.EntryPanel:Dock(TOP);
	panel.TextEntry.EntryPanel:SetDrawBackground(false);
	
	panel.TextEntry.Entry = vgui.Create("DTextEntry", panel.TextEntry.EntryPanel);
	panel.TextEntry.Entry:Dock(FILL);
	panel.TextEntry.Entry:DockMargin(5, 0, 0, 5);
	
	// Entry Functions //
	panel.TextEntry.SetEditable = function (panel, editable)
		panel.Entry:SetEditable(editable);
	end;
	
	panel.TextEntry.SetEntryValue = function (panel, value)
		panel.Entry:SetValue(value);
		if (minChars != nil and maxChars != nil) then
			panel.EntryLabel:SetText(minChars.."/"..string.len(value).."/"..maxChars);
		end;
	end;
	// END //
	
	if(minChars != nil and maxChars != nil) then
		panel.TextEntry.EntryLabel = vgui.Create("DLabel", panel.TextEntry.EntryPanel);
		panel.TextEntry.EntryLabel:Dock(RIGHT);
		panel.TextEntry.EntryLabel:DockMargin(5, 0, 50, 5);
		panel.TextEntry.EntryLabel:SetColor(color_black);
		panel.TextEntry.EntryLabel:SetFont("nut_SmallFont");
		panel.TextEntry.EntryLabel:SetText(minChars.."/".."0".."/"..maxChars);
		
		local EntryLabel = panel.TextEntry.EntryLabel;
		panel.TextEntry.Entry.OnChange = function(panel)
			EntryLabel:SetText(minChars.."/"..string.len(panel:GetValue()).."/"..maxChars);
		end;
	end;
	
	panel.TextEntry:SetTall(panel.TextEntry.TextEntyLabel:GetTall() + panel.TextEntry.Entry:GetTall() + 10);
	return panel.TextEntry;
end;

function PANEL:NextCallback(data)
	self.nameEntry:SetEditable(true);
	self.nameEntry:SetEntryValue("");
	self.modelLayout:Clear();
	
	if (data["arg"]["faction"].GetDefaultName) then
		local prefix, editable = data["arg"]["faction"]:GetDefaultName(self.nameEntry);
		self.nameEntry:SetEditable(editable or false);
		self.nameEntry:SetEntryValue(prefix);
	end;
	
	local maleModels = {};
	for k, v in pairs(data.arg.faction.maleModels) do
		self:AddCharacterModel(v, "male");
		table.Add(maleModels, {v});
	end;
	
	local femaleModels = {};
	for k, v in pairs(data.arg.faction.femaleModels) do
		self:AddCharacterModel(v, "female");
		table.Add(femaleModels, {v});
	end;
	
	if (self.selectedModel != nil and self.modelPanel:GetModel() != nil) then
		local gender = self.selectedModel.gender;
		if (gender == "male") then
			if (!table.HasValue(maleModels, self.selectedModel.model)) then
				self.modelPanel:SetModel("");
				self.selectedModel = nil;
			end;
		elseif (gender == "female") then
			if (!table.HasValue(femaleModels, self.selectedModel.model)) then
				self.modelPanel:SetModel("");
				self.selectedModel = nil;
			end;
		end;
	end;
end;

function PANEL:GetData()
	local data = {
		name = self.nameEntry.Entry:GetValue(), 
		desc = self.descEntry.Entry:GetValue(), 
		model = self.selectedModel.model,
		gender = self.selectedModel.gender
	};
	return data;
end;

function PANEL:ValidCheck()
	local nameLenght = string.len(self.nameEntry.Entry:GetValue());
	local descLenght = string.len(self.descEntry.Entry:GetValue());
	
	if (nameLenght > nut.config.maxNameLength) then
		self:SetText(nut.lang.Get("overflow_name", nut.config.maxNameLength));
		self:SetType(5);
		
		return false;
	elseif (descLenght > nut.config.maxDescLength) then
		self:SetText(nut.lang.Get("overflow_desc", nut.config.maxDescLength));
		self:SetType(5);
		
		return false;
	elseif (nut.config.nameMinChars > nameLenght) then
		self:SetText(nut.lang.Get("not_enough_name", nut.config.nameMinChars));
		self:SetType(5);
		
		return false;
	elseif (nut.config.descMinChars > string.len(self.descEntry.Entry:GetValue())) then
		self:SetText(nut.lang.Get("not_enough_desc", nut.config.descMinChars));
		self:SetType(5);
		
		return false;
	elseif(self.selectedModel == nil) then
		self:SetText(nut.lang.Get("not_select_model"));
		self:SetType(5);
		
		return false;
	else
		self:SetType(4);
		self:SetText(nut.lang.Get("charinfo_select_desc"));
	end;
end;
vgui.Register("AdvNut_charCreateWriteInfo", PANEL, "AdvNut_charCreateBase");


local PANEL = {};

function PANEL:Init()
	self:SetTitle(nut.lang.Get("attribute_setup"));
	self:SetText(nut.lang.Get("attribute_setup_desc"));
	
	self.leftPointsNotice = vgui.Create("nut_NoticePanel", self.editablePanel);
	self.leftPointsNotice:Dock(TOP);
	self.leftPointsNotice:DockMargin(5, 0, 5, 5);
	self.leftPointsNotice:SetType(7);
	self.leftPointsNotice:SetText(nut.lang.Get("points_left", nut.config.startingPoints));
	local leftPoints = nut.config.startingPoints;
	
	self.attribs = {};
	
	for k, v in ipairs(nut.attribs.GetAll()) do
		self.attribs[k] = vgui.Create("nut_attribBar", self.editablePanel);
		local attribsBar = self.attribs[k];
		
		attribsBar:Dock(TOP);
		attribsBar:DockMargin(10, 5, 10, 5);
		attribsBar:SetMax(v.limit);
		attribsBar:SetText(v.name);
		attribsBar:SetTooltip(v.desc);
		attribsBar.OnChanged = function(panel, operator)
			if(operator) then
				leftPoints = leftPoints + 1;
			else
				leftPoints = leftPoints - 1;
			end;
			
			self:SetNoticeValue(leftPoints);
		end;
		
		attribsBar.CanChange = function(panel, operator)
			if (operator) then
				return true;
			else
				return leftPoints > 0;
			end;
		end;
	end;
end;

function PANEL:SetNoticeValue(value)
	self.leftPointsNotice:SetText(nut.lang.Get("points_left", value));
end;

function PANEL:GetData(data)
	local data = {};
	for k, v in pairs(self.attribs) do
		data[k] = v:GetValue();
	end;
	
	return {attribs = data};
end;
vgui.Register("AdvNut_charCreateAttributeSet", PANEL, "AdvNut_charCreateBase");



local PANEL = {};

function PANEL:Init()
	// Remove Notice Bar. //
	self:SetTitle(nut.lang.Get("charcreate_waiting"));
	self.noticebar:Remove();
	
	self.label = vgui.Create("DLabel", self);
	self.label:Dock(FILL);
	self.label:SetFont("nut_MediumFont");
	self.label:SetColor(color_black);
	self.label:SetContentAlignment(5);
	self.label:SetText(nut.lang.Get("charcreate_waiting_desc"));
end;

function PANEL:TimeoutCallBack()
	self.label:SetText(nut.lang.Get("charcreate_timeout"));
end;
vgui.Register("AdvNut_charCreateWait", PANEL, "AdvNut_charCreateBase");