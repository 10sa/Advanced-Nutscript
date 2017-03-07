local gradient = surface.GetTextureID("gui/gradient")
local surface = surface

local PANEL = {}
function PANEL:Init()
	self:AddTitle(nut.lang.Get("inventory"));
	self:SetSize(AdvNut.util.GetCurrentMenuSize());
	self:SetPos(AdvNut.util.GetCurrentMenuPos())
	self:MakePopup()

	self.colmunSheet = vgui.Create("DColumnSheet", self);
	self.colmunSheet:Dock(FILL);
	self.colmunSheet:DockMargin(5, 5, 5, 5);
	self.colmunSheet.Navigation:SetWide(self:GetWide() * 0.175);
	
	self.inventory = vgui.Create("AdvNut_inventroyPanel", self.colmunSheet);
	self.inventory:AddNoticeBar(nut.lang.Get("inv_tip"), 4);
	self.inventory:AddWeightBar();
	self.inventory:Dock(FILL);
	self.colmunSheet:AddSheet(nut.lang.Get("inventory"), self.inventory, "icon16/box.png");
	
	self.equippedInventory = vgui.Create("AdvNut_inventroyPanel", self.colmunSheet);
	self.equippedInventory:Dock(FILL);
	self.colmunSheet:AddSheet(nut.lang.Get("equippedinventory"), self.equippedInventory, "icon16/briefcase.png");
	
	self:LoadItems();
end

function PANEL:LoadItems()
	local inventoryItems = {};
	local equippedItems = {};
	local playerInventoryItems = LocalPlayer():GetInventory();
	
	for k, v in pairs(playerInventoryItems) do
		local itemTable = nut.item.Get(k)
		local data;
		
		for d, item in pairs(v) do
			data = item.data
			if (itemTable) then
				if(data != nil and data.Equipped) then
					if(equippedItems[itemTable.category] == nil) then
						equippedItems[itemTable.category] = {};
					end;
					
					table.insert(equippedItems[itemTable.category], {class = k, item = {item}, name = itemTable.name, index = d});
				else
					if(inventoryItems[itemTable.category] == nil) then
						inventoryItems[itemTable.category] = {};
					end;
					
					table.insert(inventoryItems[itemTable.category], {class = k, item = {item}, name = itemTable.name, index = d});
				end;
			end;
		end;
	end;
	
	self:CreateItems(self.inventory, inventoryItems);
	self:CreateItems(self.equippedInventory, equippedItems);
end;

function PANEL:CreateItems(panel, items)
	panel.categories = {};
	for _, itemsTable in SortedPairs(items) do
		for _, data in SortedPairsByMemberValue(itemsTable, 3) do
			local class = data.class;
			local items = data.item
			local index = data.index;
			local itemTable = nut.item.Get(class);

			if (itemTable and table.Count(items) > 0) then
				local categoryName = string.lower(itemTable.category);

				if (!panel.categories[categoryName]) then
					local categoryPanel = vgui.Create("AdvNut_CategoryList", panel.list);
					categoryPanel:Dock(TOP);
					categoryPanel:SetLabel(itemTable.category);
					categoryPanel:DockMargin(5, 5, 5, 5);

					local list = vgui.Create("DIconLayout");
					list.Paint = function(panel, w, h)
						surface.SetDrawColor(Color(0, 0, 0, 0));
						surface.DrawRect(0, 0, w, h);
					end;
					
					categoryPanel:SetContents(list);
					categoryPanel:InvalidateLayout(true);

					panel.categories[categoryName] = {list = list, category = categoryPanel, panel = panel};
				end

				local list = panel.categories[categoryName].list;
				for k, v in SortedPairs(items) do
					local icon = list:Add("SpawnIcon");
					icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin);
					icon:SetSize(nut.config.iconSize, nut.config.iconSize);
					icon:SetToolTip(nut.lang.Get("item_info", itemTable.name, itemTable:GetDesc(v.data)));
					icon.DoClick = function(icon)
						nut.item.OpenMenu(itemTable, v, index);
					end;
					
					if (itemTable.bodygroup) then
						for k, v in pairs(itemTable.bodygroup) do
							icon:SetBodyGroup( k, v );
						end
					end
					
					if (itemTable.stackable) then
						local label = icon:Add("DLabel");
						label:SetPos(8, 3);
						label:SetWide(64);
						label:SetText(v.quantity);
						label:SetFont("DermaDefaultBold");
						label:SetDark(true);
						label:SetExpensiveShadow(1, Color(240, 240, 240))
					else
						for i = 2, v.quantity do
							local icon = list:Add("SpawnIcon");
							icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin);
							icon:SetSize(nut.config.iconSize, nut.config.iconSize);
							
							icon:SetToolTip(nut.lang.Get("item_info", itemTable.name, itemTable:GetDesc(v.data)));
							icon.DoClick = function(icon)
								nut.item.OpenMenu(itemTable, v, index);
							end;
						end;
					end;
				end;
			elseif (table.Count(items) == 0) then
				LocalPlayer():GetInventory()[class] = nil;
			end
		end
	end
end;

nut.char.HookVar("inv", "refreshInv", function(character)
	if (IsValid(nut.gui.inv)) then
		nut.gui.inv:Reload()
	end
end)

function PANEL:Reload()
	local parent = self:GetParent()

	self:Remove()

	nut.gui.inv = vgui.Create("nut_Inventory", parent)
	nut.gui.menu:SetCurrentMenu(nut.gui.inv, true)
end
vgui.Register("nut_Inventory", PANEL, "AdvNut_BaseForm")


local PANEL = {};

function PANEL:Init()
	self:SetBackgroundColor(Color(0, 0, 0, 0));
	
	self.list = vgui.Create("AdvNut_ScrollPanel", self);
	self.list:SetDrawBackground(false);
	self.list:Dock(FILL);
end;

function PANEL:AddWeightBar()
	local weight_tail = 25;
	self.weight = vgui.Create("DPanel", self);
	self.weight:Dock(TOP);
	self.weight:SetTall(weight_tail);
	self.weight:DockMargin(5, 2, 5, 5);
	self.weight:SetDrawBackground(true);
	self.weight.Paint = function(panel, w, h)
		local width = self.weightValue or 0;
		local color = nut.config.mainColor;
		
		surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		surface.SetDrawColor(0, 0, 0, 200);
		surface.DrawTexturedRect(0, 0, w, h);
		
		surface.SetDrawColor(132, 184, 112, 190);
		surface.DrawRect(0, 0, w * width, h);

		surface.SetDrawColor(145, 145, 145, 190);
		surface.DrawRect(w-(w-(w * width)), 0, w * (18 + width), h);
		
		AdvNut.util.DrawOutline(self.weight, 1, color_black);
	end;

	local weight, maxWeight = LocalPlayer():GetInvWeight();
	self.weightValue = weight / maxWeight;
		
	self.weightText = vgui.Create("DLabel", self.weight);
	self.weightText:Dock(FILL);
	self.weightText:SetExpensiveShadow(1, color_black);
	self.weightText:SetTextColor(color_white);
	self.weightText:SetContentAlignment(5);
	self.weightText:SetText(weight.."kg".." / "..maxWeight.."kg");
end;

function PANEL:AddNoticeBar(desc, barType)
	self.bar = self:Add("nut_NoticePanel");
	self.bar:Dock(TOP);
	self.bar:DockMargin(5, 5, 5, 0);
	self.bar:SetType(barType);
	self.bar:SetText(desc);
end;
vgui.Register("AdvNut_inventroyPanel", PANEL, "AdvNut_BaseForm");