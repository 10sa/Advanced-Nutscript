local PLUGIN = PLUGIN;

local PANEL = {}
function PANEL:Init()
	self:AddTitle("");
	self:AddCloseButton();
	
	local width = ScrW() * nut.config.menuWidth

	self:SetSize(width, ScrH() * nut.config.menuHeight)
	self:MakePopup()
	self:SetTitle(nut.lang.Get("inventory"))
	self:Center()

	self.list = vgui.Create("AdvNut_ScrollPanel", self);
	self.list:DockMargin(5, 5, 5, 5);
	self.list:Dock(LEFT)
	self.list:SetWide(width / 2 - 7)
	self.list:SetDrawBackground(false)

	self.storageTitle = self.list:Add("DLabel")
	self.storageTitle:SetText(PLUGIN:GetPluginLanguage("sr_storage"))
	self.storageTitle:DockMargin(3, 3, 3, 3)
	self.storageTitle:Dock(TOP)
	self.storageTitle:SetTextColor(Color(60, 60, 60))
	self.storageTitle:SetFont("nut_ScoreTeamFont")
	self.storageTitle:SizeToContents()

	self.weight = self:DrawWeightBar(self.list, 0, 0);

	self.inv = self:Add("AdvNut_ScrollPanel")
	self.inv:Dock(RIGHT)
	self.inv:DockMargin(5, 5, 5, 5);
	self.inv:SetWide(width / 2 - 7)
	self.inv:SetDrawBackground(false);

	self.invTitle = self.inv:Add("DLabel")
	self.invTitle:SetText(nut.lang.Get("inventory"))
	self.invTitle:DockMargin(3, 3, 3, 3)
	self.invTitle:Dock(TOP)
	self.invTitle:SetTextColor(Color(60, 60, 60))
	self.invTitle:SetFont("nut_ScoreTeamFont")
	self.invTitle:SizeToContents()

	self.weight2 = self:DrawWeightBar(self.inv, 0, 0);

	local transfer

	self.money2 = self.inv:Add("DTextEntry")
	self.money2:DockMargin(3, 3, 3, 3)
	self.money2:Dock(TOP)
	self.money2:SetNumeric(true)
	self.money2:SetText(LocalPlayer():GetMoney())
	self.money2.OnEnter = function(panel)
		transfer:DoClick()
	end

	transfer = self.money2:Add("DButton")
	transfer:Dock(RIGHT)
	transfer:SetText(PLUGIN:GetPluginLanguage("sr_move"))
	transfer.DoClick = function(panel)
		local value = tonumber(self.money2:GetText()) or 0

		if (value and value <= LocalPlayer():GetMoney() and value > 0) then
			netstream.Start("nut_TransferMoney", {self.entity, math.abs(value)})
		else
			self.money2:SetText(LocalPlayer():GetMoney())
		end
	end

	self.categories = {}
	self.invCategories = {}
end

function PANEL:GetEntity()
	return self.entity
end

function PANEL:OnClose()
	netstream.Start("nut_ContainerClosed")
end

function PANEL:SetEntity(entity)
	self.entity = entity
	self:SetupInv()

	self:SetTitle(entity:GetNetVar("name", PLUGIN:GetPluginLanguage("sr_storage")))
	self:RefreshWeightBar(self.list, entity:GetNetVar("weight"), entity:GetNetVar("maxWeight"));

	local transfer

	self.money = self.list:Add("DTextEntry")
	self.money:DockMargin(3, 3, 3, 3)
	self.money:Dock(TOP)
	self.money:SetNumeric(true)
	self.money:SetText(entity:GetNetVar("money", 0))
	self.money.OnEnter = function(panel)
		transfer:DoClick()
	end

	transfer = self.money:Add("DButton")
	transfer:Dock(RIGHT)
	transfer:SetText(PLUGIN:GetPluginLanguage("sr_move"))
	transfer.DoClick = function(panel)
		local value = tonumber(self.money:GetText()) or 0

		if (value and value <= entity:GetNetVar("money", 0) and value > 0) then
			netstream.Start("nut_TransferMoney", {entity, -math.abs(value)})
		else
			self.money:SetText(entity:GetNetVar("money", 0))
		end
	end

	for class, items in pairs(entity:GetNetVar("inv")) do
		local itemTable = nut.item.Get(class)

		if (itemTable) then
			local category = itemTable.category
			local category2 = string.lower(category)

			if (!self.categories[category2]) then
				local category3 = self.list:Add("AdvNut_CategoryList")
				category3:Dock(TOP)
				category3:SetLabel(category)
				category3:DockMargin(5, 5, 5, 5)
				category3:SetPadding(5)

				local list = vgui.Create("DIconLayout")
				category3:SetContents(list)
				category3:InvalidateLayout(true)

				self.categories[category2] = {list = list, category = category3, panel = panel}
			end

			local list = self.categories[category2].list

			for k, v in SortedPairs(items) do
				local icon = list:Add("SpawnIcon")
				icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)

				local label = icon:Add("DLabel")
				label:SetPos(8, 3)
				label:SetWide(64)
				label:SetText(v.quantity)
				label:SetFont("DermaDefaultBold")
				label:SetDark(true)
				label:SetExpensiveShadow(1, Color(240, 240, 240))

				icon:SetToolTip(nut.lang.Get("item_info", itemTable.name, itemTable:GetDesc(v.data)))
				icon.DoClick = function(icon)
					netstream.Start("nut_StorageUpdate", {entity, class, -1, v.data or {}, self.entity.lock})
				end
			end
		end
	end
end

function PANEL:SetupInv()
	local weight, max = LocalPlayer():GetInvWeight();
	self:RefreshWeightBar(self.inv, weight, max);
		
	for class, items in pairs(LocalPlayer():GetInventory()) do
		local itemTable = nut.item.Get(class)

		if (itemTable) then
			local category = itemTable.category
			local category2 = string.lower(category)

			if (!self.invCategories[category2]) then
				local category3 = self.inv:Add("AdvNut_CategoryList")
				category3:Dock(TOP)
				category3:SetLabel(category)
				category3:DockMargin(5, 5, 5, 5)
				category3:SetPadding(5)

				local list = vgui.Create("DIconLayout")
				category3:SetContents(list)
				category3:InvalidateLayout(true)

				self.invCategories[category2] = {list = list, category = category3, panel = panel}
			end

			local list = self.invCategories[category2].list

			for k, v in SortedPairs(items) do
				local icon = list:Add("SpawnIcon")
				icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)
				
				local label = icon:Add("DLabel")
				label:SetPos(8, 3)
				label:SetWide(64)
				label:SetText(v.quantity)
				label:SetFont("DermaDefaultBold")
				label:SetDark(true)
				label:SetExpensiveShadow(1, Color(240, 240, 240))

				icon:SetToolTip(nut.lang.Get("item_info", itemTable.name, itemTable:GetDesc(v.data)))
				icon.DoClick = function(icon)
					if (itemTable.CanTransfer and itemTable:CanTransfer(LocalPlayer(), v.data) == false) then
						return false
					end
					netstream.Start("nut_StorageUpdate", {self.entity, class, 1, v.data or {}, self.entity.lock})
				end
			end
		end
	end
end

function PANEL:Reload()
	local panel = self:GetParent()
	local entity = self:GetEntity()
	local x, y = self:GetPos()

	self:Remove()

	nut.gui.storage = vgui.Create("nut_Storage", panel)
	nut.gui.storage:SetPos(x, y)

	if (IsValid(entity)) then
		nut.gui.storage:SetEntity(entity)
	end
end
	
function PANEL:DrawWeightBar(panel, weight, maxWeight)
	local weight_tail = 25;
	panel.weightBar = vgui.Create("DPanel", panel);
	panel.weightBar:Dock(TOP);
	panel.weightBar:SetTall(weight_tail);
	panel.weightBar:DockMargin(5, 2, 5, 5);
	panel.weightBar:SetDrawBackground(true);
	panel.weightBar.Paint = function(panel2, w, h)
		local width = panel.weightValue or 0;
		local color = nut.config.mainColor;
		
		surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		surface.SetDrawColor(0, 0, 0, 200);
		surface.DrawTexturedRect(0, 0, w, h);
		
		surface.SetDrawColor(132, 184, 112, 190);
		surface.DrawRect(0, 0, w * width, h);

		surface.SetDrawColor(145, 145, 145, 190);
		surface.DrawRect(w-(w-(w * width)), 0, w * (18 + width), h);
		
		AdvNut.util.DrawOutline(panel.weightBar, 1, color_black);
	end;
	
	panel.weightBar.weightValue = weight / maxWeight;
	
	panel.weightText = vgui.Create("DLabel", panel.weightBar);
	panel.weightText:Dock(FILL);
	panel.weightText:SetExpensiveShadow(1, color_black);
	panel.weightText:SetTextColor(color_white);
	panel.weightText:SetContentAlignment(5);
	panel.weightText:SetText(weight.."kg".." / "..maxWeight.."kg");
end;

function PANEL:RefreshWeightBar(panel, weight, maxWeight)
	panel.weightBar.Paint = function(panel2, w, h)
		local width = panel.weightBar.weightValue or 0;
		local color = nut.config.mainColor;
		
		surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		surface.SetDrawColor(0, 0, 0, 200);
		surface.DrawTexturedRect(0, 0, w, h);
		
		surface.SetDrawColor(132, 184, 112, 190);
		surface.DrawRect(0, 0, w * width, h);

		surface.SetDrawColor(145, 145, 145, 190);
		surface.DrawRect(w-(w-(w * width)), 0, w * (18 + width), h);
		
		AdvNut.util.DrawOutline(panel.weightBar, 1, color_black);
	end;
	
	panel.weightBar.weightValue = weight / maxWeight;
	panel.weightText:SetText(weight.."kg".." / "..maxWeight.."kg");
end

vgui.Register("nut_Storage", PANEL, "AdvNut_BaseForm")

function PLUGIN:ShouldDrawTargetEntity(entity)
	if (entity:GetClass() == "nut_container") then
		return true
	end
end

function PLUGIN:DrawTargetID(entity, x, y, alpha)
	if (entity:GetClass() == "nut_container") then
		local mainColor = nut.config.mainColor
		local color = Color(mainColor.r, mainColor.g, mainColor.b, alpha)

		nut.util.DrawText(x, y, entity:GetNetVar("name", "Storage"), color)
			y = y + nut.config.targetTall
		nut.util.DrawText(x, y, PLUGIN:GetPluginLanguage("sr_usespace", entity:GetNetVar("weight", 0)), Color(255, 255, 255, alpha), "AdvNut_EntityDesc")

		if (entity:GetNetVar("locked", false)) then
			nut.util.DrawText(x, y + 16, PLUGIN:GetPluginLanguage("sr_locked"), Color(255, 30, 30, alpha), "nut_TargetFontSmall")
		end
	end
end
