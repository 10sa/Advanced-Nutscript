local size = 16
local border = 4
local distance = size + border

local PANEL = {}
function PANEL:Init()
	self:SetPos(ScrW() * 0.375, ScrH() * 0.125);
	self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight);
	self:MakePopup();
	
	self.activeEntity = nil;
end

function PANEL:SetEntity(entity, title, isAddCloseButton)
	self:SetupFrame(title, isAddCloseButton);
	local noticePanel = self:Add("nut_NoticePanel");
	noticePanel:Dock(TOP);
	noticePanel:DockMargin(5, 5, 5, 0);
	noticePanel:SetType(7);
	noticePanel:SetText(nut.lang.Get("craft_menu_tip1"));
		
	local noticePanel = self:Add("nut_NoticePanel");
	noticePanel:Dock(TOP);
	noticePanel:DockMargin(5, 5, 5, 0);
	noticePanel:SetType(4);
	noticePanel:SetText(nut.lang.Get("craft_menu_tip2"));

	self.list = vgui.Create("AdvNut_ScrollPanel", self);
	self.list:Dock(FILL);
	self.list:DockMargin(10, 0, 10, 10);
	self.list:SetDrawBackground(false);

	self.categories = {}
	self.nextBuy = 0

	self:SetActiveEntity(entity);
	self:BuildItems();
end;

function PANEL:SetupFrame(title, isAddCloseButton)
	if(title) then
		self:AddTitle(nut.lang.Get("crafting").." - "..title);
	else
		self:AddTitle(nut.lang.Get("crafting"));
	end;
	
	if(isAddCloseButton) then
		self:AddCloseButton();
	end;
end;

function PANEL:BuildItems()
	nut.schema.Call("CraftingPrePopulateItems", self);
	self.list:Clear();
	
	local canCraftingRecipes = {};
	for class, recipe in SortedPairs(RECIPES:GetAll()) do
		if(RECIPES:HaveRecipe(LocalPlayer(), class) and recipe.workbenchType == self.activeEntity) then
			canCraftingRecipes[class] = recipe;
		end;
	end;
	
	if (table.Count(canCraftingRecipes) <= 0) then
		local label = vgui.Create("DLabel", self);
		label:Dock(FILL);
		label:SetText(nut.lang.Get("norecipes"));
		label:SetColor(color_black);
		label:SetFont("nut_TargetFont");
		label:SetContentAlignment(5);
	else
		for class, recipe in SortedPairs(canCraftingRecipes) do
			local category = recipe.category
			local category2 = string.lower(category)

			if (!self.categories[category2]) then
				local category3 = vgui.Create("AdvNut_CategoryList", self.list);
				category3:Dock(TOP)
				category3:SetLabel(category)
				category3:DockMargin(5, 5, 5, 5)
				category3:SetPadding(5)
				category3:InvalidateLayout(true);
				
				local list = vgui.Create("DIconLayout")
				category3:SetContents(list);
				list:SetSpaceX(5);
				list:SetSpaceY(5);
				list.Paint = function(list, w, h)
					surface.SetDrawColor(0, 0, 0, 0)
					surface.DrawRect(0, 0, w, h)
				end;
				
				self:CreateItemIcon(list, recipe, class);
				nut.schema.Call("CraftingCategoryCreated", category3)
				self.categories[category2] = {list = list, category = category3, panel = panel}
			else
				self:CreateItemIcon(self.categories[category2].list, recipe, class);
				nut.schema.Call("CraftingItemCreated", recipe, icon);
			end;
		end
	end;
	

	nut.schema.Call("CraftingPostPopulateItems", self)
end;
	
function PANEL:CreateItemIcon(panel, recipe, class)
	local icon = vgui.Create("SpawnIcon", panel);
	local isCraft = RECIPES:CanCraft(LocalPlayer(), class);
	icon:SetSize(nut.config.iconSize * 0.8, nut.config.iconSize * 0.8);
	icon:SetModel(recipe.model or "models/props_lab/box01a.mdl")		
	icon.PaintOver = function(icon, w, h)
		if (isCraft) then
			AdvNut.util.DrawOutline(icon, 1, Color(10, 10, 10, 255));
		else
			AdvNut.util.DrawOutline(icon, 1, Color(255, 10, 10, 255));
		end;
	end;

	local function RecipeTableParsing(recipe)
		local parsingString = "";
		for itemID, count in SortedPairsByValue(recipe) do
			local itemTable = nut.item.Get(itemID)
			if(count <= 0) then
				parsingString = string.format(parsingString.." - %s - %d\n");
			else
				if (itemTable) then
					parsingString = string.format(parsingString.."  * %s - %dx\n", itemTable.name, count);
				else
					parsingString = string.format(parsingString.."  * %s - %dx\n", nut.lang.Get("notexist", itemID), count);
				end;
			end;
		end;
		
		return parsingString;
	end;
	
	local request = RecipeTableParsing(recipe.items);
	local result = RecipeTableParsing(recipe.result);
	icon:SetToolTip(nut.lang.Get("crft_text", recipe.name, recipe.desc, request, result));
	if(isCraft) then
		icon.DoClick = function(panel)
			if (icon.disabled) then
				return;
			end
		
			net.Start("nut_CraftItem")
			net.WriteString(class)
			net.SendToServer()
			icon.disabled = true
			icon:SetAlpha(70)
			timer.Simple(nut.config.buyDelay, function()
				if (IsValid(icon)) then
					icon.disabled = false;
					icon:SetAlpha(255);
				end
			end);
		end
	end;
end;

function PANEL:SetActiveEntity(entity)
	if(entity) then
		self.activeEntity = entity:GetClass();
	else
		self.activeEntity = nil;
	end;
end;
vgui.Register("nut_Crafting", PANEL, "AdvNut_BaseForm");

local PLUGIN = PLUGIN;
function PLUGIN:CreateMenuButtons(menu, addButton)
	if (self.menuEnabled) then
		addButton("crafting", nut.lang.Get("crafting"), function()
			nut.gui.crafting = vgui.Create("nut_Crafting", menu)
			nut.gui.crafting:SetSize(AdvNut.util.GetCurrentMenuSize());
			nut.gui.crafting:SetPos(AdvNut.util.GetCurrentMenuPos());
			nut.gui.crafting:SetEntity();
			
			menu:SetCurrentMenu(nut.gui.crafting);
		end)
	end
end
