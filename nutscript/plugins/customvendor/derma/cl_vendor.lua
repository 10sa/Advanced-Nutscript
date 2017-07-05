local PLUGIN = PLUGIN;

local PANEL = {}
	function PANEL:Init()
		self:SetSize(ScrW() * 0.7, ScrH() * 0.7)
		self:MakePopup();
		self:Center();
		self:SetTitle(PLUGIN:GetPluginLanguage("vd_vendor"));
		self.property = self:Add("DPropertySheet")
		self.property:Dock(FILL)
		self.property:DockMargin(5, 5, 5, 5);
		self.property.Paint = function(client, w, h)
			surface.SetDrawColor(color_black);
			surface.DrawOutlinedRect(0, 25, w, h - 25);
		end;
	end

	function PANEL:SetEntity(entity)
		self.vendorentity = entity
		local vendorAction = entity:GetNetVar("vendoraction", { sell = true, buy = false })
		
		if (vendorAction.sell) then
			if (self.selling == nil) then
				self.selling = vgui.Create("nut_VendorMenu");
				self.sellingTab = self.property:AddSheet(PLUGIN:GetPluginLanguage("vd_sell"), self.selling, "icon16/coins_delete.png")
			end;
			
			self.selling:SetEntity(entity, false)
		end
		
		if vendorAction.buy then
			if (self.buying == nil) then
				self.buying = vgui.Create("nut_VendorMenu");
				self.buyingTab = self.property:AddSheet(PLUGIN:GetPluginLanguage("vd_buy"), self.buying, "icon16/coins_add.png")
			end;
			
			self.buying:SetEntity(entity, true)
		end
		
		if (LocalPlayer():IsAdmin() and self.admin == nil) then
			self.admin = vgui.Create("nut_VendorAdminMenu");
			self.admin:SetEntity(entity);
			self.property:AddSheet(PLUGIN:GetPluginLanguage("vd_admin"), self.admin, "icon16/star.png");
		end
	end
vgui.Register("nut_Vendor", PANEL, "DFrame");

netstream.Hook("nut_CashUpdate", function( data )
	local v = nut.gui.vendor
	if v then
		if v.buying then
			v.buying.money.desc:SetText( PLUGIN:GetPluginLanguage( "vendor_cash", nut.currency.GetName( v.vendorentity:GetNetVar("money", 0) ) ) )
		end
		if v.selling then
			v.selling.money.desc:SetText( PLUGIN:GetPluginLanguage( "vendor_cash", nut.currency.GetName( v.vendorentity:GetNetVar("money", 0) ) ) )
		end
	end
end)

local PANEL = {}
	function PANEL:Init()
		self:SetDrawBackground(false);
		
		self.money = self:Add("DPanel")
		self.money:Dock(TOP)
		self.money:DockMargin(0, 7, 2, 7)
		self.money:SetDrawBackground(false)
		
		self.money.desc = self.money:Add("DLabel")
		self.money.desc:DockMargin(16, 2, 2, 2)
		self.money.desc:Dock(TOP)
		self.money.desc:SetTextColor(Color(60, 60, 60))
		self.money.desc:SetFont("AdvNut_EntityTitle")
		self.money.desc:SizeToContents()
		self.money:Dock(TOP)
		
		self.list = vgui.Create("AdvNut_ScrollPanel", self);
		self.list.Paint = function(client, w, h)
			surface.SetDrawColor(nut.config.panelBackgroundColor);
			surface.DrawRect(0, 0, w, h);
		end;
		self.list:Dock(FILL)
		self.list:SetDrawBackground(true)

		self.categories = {}
		self.nextBuy = 0
	end
	
	function PANEL:SetEntity(entity, boolBuying)
		self.entity = entity

		local data = entity:GetNetVar("data", {})
		self.money.desc:SetText(PLUGIN:GetPluginLanguage("vendor_cash", nut.currency.GetName( entity:GetNetVar("money", 0))));
		
		if (self.categories != nil) then
			for key, category in pairs(self.categories) do
				category.category:Remove();
				self.categories[key] = nil;
			end;
		end;

		for class, itemTable in SortedPairs(nut.item.GetAll()) do
			local factionData = entity:GetNetVar("factiondata", {})

			if (!factionData[LocalPlayer():Team()]) then
				continue
			end

			local classData = entity:GetNetVar("classdata", {})

			if (table.Count(classData) > 0 and LocalPlayer():CharClass() and !classData[LocalPlayer():CharClass()]) then
				continue
			end
			
			if (data[class] and data[class].selling and !boolBuying ) then
				local category = itemTable.category
				local category2 = string.lower(category)

				if (!self.categories[category2]) then
					local category3 = self.list:Add("AdvNut_CategoryList")
					category3:Dock(TOP)
					category3:SetLabel(category)
					category3:DockMargin(5, 5, 5, 5)
					category3:SetPadding(5)

					local list = vgui.Create("DIconLayout")
						list.Paint = function(list, w, h)
							surface.SetDrawColor(0, 0, 0, 0)
							surface.DrawRect(0, 0, w, h)
						end
					category3:SetContents(list)
					category3:InvalidateLayout(true)

					self.categories[category2] = {list = list, category = category3, panel = panel}
				end

				local list = self.categories[category2].list
				local icon = list:Add("SpawnIcon")
				
				icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)
				icon:SetSize(nut.config.iconSize * 0.8, nut.config.iconSize * 0.8);

				local price = itemTable.price or 0
				local cost = nut.lang.Get("item_price", nut.currency.GetName(price))

				if (data[class] and data[class].price and data[class].price >= 0) then
					price = data[class].price
					if (price == 0) then
						cost = nut.lang.Get("item_price", "무료");
					else
						cost = nut.lang.Get("item_price", nut.currency.GetName(price))
					end;
				end;

				icon:SetToolTip(PLUGIN:GetPluginLanguage("vd_sell_desc", itemTable.name, itemTable:GetDesc(), cost))
				icon.DoClick = function(panel)
					if (icon.disabled) then
						return
					end
					
					netstream.Start("nut_VendorBuy", {entity, class})
					timer.Simple(LocalPlayer():Ping() / 500, function()
						if self and self.money and self.money.desc then
							self.money.desc:SetText(PLUGIN:GetPluginLanguage( "vendor_cash", nut.currency.GetName(entity:GetNetVar("money", 0))));
						end
					end)


					icon.disabled = true
					icon:SetAlpha(70)

					timer.Simple(nut.config.buyDelay, function()
						if (IsValid(icon)) then
							icon.disabled = false
							icon:SetAlpha(255)
						end
					end)
				end
			end

			if (data[class] and data[class].buying and boolBuying) then
				local category = itemTable.category
				local category2 = string.lower(category)

				if (!self.categories[category2]) then
					local category3 = self.list:Add("AdvNut_CategoryList")
					category3:Dock(TOP)
					category3:SetLabel(category)
					category3:DockMargin(5, 5, 5, 5)
					category3:SetPadding(5)

					local list = vgui.Create("DIconLayout")
						list.Paint = function(list, w, h)
							surface.SetDrawColor(0, 0, 0, 0)
							surface.DrawRect(0, 0, w, h)
						end
					category3:SetContents(list)
					category3:InvalidateLayout(true)

					self.categories[category2] = {list = list, category = category3, panel = panel}
				end

				local list = self.categories[category2].list
				local icon = list:Add("SpawnIcon")

				icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)
				icon:SetSize(nut.config.iconSize * 0.8, nut.config.iconSize * 0.8);

				local price = itemTable.price or 0
				local cost = nut.lang.Get("item_price", nut.currency.GetName(price))

				if (data[class] and data[class].price and data[class].price >= 0) then
					price = data[class].price
					if (price == 0) then
						cost = nut.lang.Get("item_price", "무료");
					else
						cost = nut.lang.Get("item_price", nut.currency.GetName(math.Round(price * entity:GetNetVar("buyadjustment", .5))));
					end;
				end

				icon:SetToolTip(nut.lang.Get("item_info",itemTable.name, itemTable:GetDesc()).."\n"..cost)
				icon.DoClick = function(panel)
					if (icon.disabled) then
						return
					end
					
					netstream.Start("nut_VendorSell", {entity, class})
					timer.Simple(LocalPlayer():Ping() / 500, function()
						if self and self.money and self.money.desc then
							self.money.desc:SetText(PLUGIN:GetPluginLanguage( "vendor_cash", nut.currency.GetName( entity:GetNetVar("money", 0))))
						end
					end)
					icon.disabled = true
					icon:SetAlpha(70)

					timer.Simple(nut.config.buyDelay, function()
						if (IsValid(icon)) then
							icon.disabled = false
							icon:SetAlpha(255)
						end
					end)
				end
			end

		end
	end

	function PANEL:Reload( boolBuying )
		if (IsValid(self.entity)) then
			self:Clear(true)
			self:Init()
			self:SetEntity(self.entity, boolBuying)
		end
	end
vgui.Register("nut_VendorMenu", PANEL, "DPanel")

local PANEL = {}
	function PANEL:Init()
		self:SetDrawBackground(false)
		
		self.info = self:Add("DLabel")
		self.info:Dock(TOP)
		self.info:DockMargin(3, 3, 3, 5)
		self.info:SetText(PLUGIN:GetPluginLanguage("vd_admin_tip"))
		self.info:SetTextColor(color_black);
		self.info:SizeToContents()

		self.scroll = vgui.Create("AdvNut_ScrollPanel", self);
		self.scroll.Paint = function(client, w, h)
			surface.SetDrawColor(nut.config.panelBackgroundColor);
			surface.DrawRect(0, 0, w, h);
			
			surface.SetDrawColor(color_black);
			surface.DrawOutlinedRect(0, 0, w , h);
		end;
		
		self.scroll:Dock(FILL)
		self.scroll:DockMargin(0, 5, 0, 0)
		self.scroll:SetPaintBackground(true)
	end

	function PANEL:SetEntity(entity)
		if (!IsValid(entity)) then
			return
		end

		local data = entity:GetNetVar("data", {})

		self.list = self:Add("DListView")
		self.list:Dock(TOP)
		self.list:SetTall(256)
		self.list:AddColumn(PLUGIN:GetPluginLanguage("vd_name"))
		self.list:AddColumn(PLUGIN:GetPluginLanguage("vd_itemID"))
		self.list:AddColumn(PLUGIN:GetPluginLanguage("vd_sell"))
		self.list:AddColumn(PLUGIN:GetPluginLanguage("vd_buy"))
		self.list:AddColumn(PLUGIN:GetPluginLanguage("vd_price"));
		self.list:AddColumn(PLUGIN:GetPluginLanguage("vd_orignal_price"));
		self.list:SetMultiSelect(false)
		self.list.OnClickLine = function(panel, line, selected)
			if (input.IsMouseDown(MOUSE_LEFT)) then
				local menu = DermaMenu()
				menu:AddOption( PLUGIN:GetPluginLanguage("vd_admin_buying"), function()
					line.buying = !line.buying
					line:SetValue(4, line.buying and "✔" or "")
				end):SetImage("icon16/money_add.png")
				menu:AddOption( PLUGIN:GetPluginLanguage("vd_admin_selling"), function()
					line.selling = !line.selling
					line:SetValue(3, line.selling and "✔" or "")
				end):SetImage("icon16/money_delete.png")
				menu:Open()
			end
		end
		self.list.OnRowRightClick = function(parent, index, line)
			Derma_StringRequest(line.itemTable.name, PLUGIN:GetPluginLanguage("vd_admin_ask_price"), "0", function(text)
				local amount = tonumber(text) or 0

				if (IsValid(line)) then
					line.price = math.max(math.floor(amount), 0)
					line:SetValue(5, line.price)
				end
			end)
		end

		for k, v in SortedPairsByMemberValue(nut.item.GetAll(), "name") do
			local line = self.list:AddLine(v.name, v.uniqueID, "")
			line:SetValue(6, v.price);
			line.itemTable = v
			
			if (v.price and data[v.uniqueID] == nil) then
				line.price = v.price;
				line:SetValue(5, line.price);
			else
				line.price = data[v.uniqueID].price;
				line:SetValue(5, data[v.uniqueID].price);
			end;
				
			if (data[v.uniqueID]) then
				if (data[v.uniqueID].selling) then
					line:SetValue(3, "✔")
					line.selling = true
				end
				
				if (data[v.uniqueID].buying) then
					line:SetValue(4, "✔")
					line.buying = true
				end
			end
		end

		self.factions = {}

		local faction = self.scroll:Add("DLabel")
		faction:SetText(PLUGIN:GetPluginLanguage("vd_admin_faction"))
		faction:DockMargin(3, 3, 3, 3)
		faction:Dock(TOP)
		faction:SetTextColor(Color(60, 60, 60))
		faction:SetFont("nut_ScoreTeamFont")
		faction:SizeToContents()

		local factionData = entity:GetNetVar("factiondata", {})

		for k, v in SortedPairs(nut.faction.GetAll()) do
			local panel = self.scroll:Add("DCheckBoxLabel")
			panel:Dock(TOP)
			panel:SetText(PLUGIN:GetPluginLanguage("vd_admin_faction_desc", v.name))
			panel:SetValue(0)
			panel:DockMargin(12, 3, 3, 3)
			panel:SetDark(true)

			if (factionData[k]) then
				panel:SetChecked(factionData[k])
			end

			self.factions[k] = panel
		end

		local classes = self.scroll:Add("DLabel")
		classes:SetText(PLUGIN:GetPluginLanguage("vd_admin_classes"))
		classes:DockMargin(3, 3, 3, 3)
		classes:Dock(TOP)
		classes:SetTextColor(Color(60, 60, 60))
		classes:SetFont("nut_ScoreTeamFont")
		classes:SizeToContents()

		self.classes = {}

		local classData = entity:GetNetVar("classdata", {})

		for k, v in SortedPairs(nut.class.GetAll()) do
			local panel = self.scroll:Add("DCheckBoxLabel")
			panel:Dock(TOP)
			panel:SetText(PLUGIN:GetPluginLanguage("vd_admin_classes_desc", v.name))
			panel:SetValue(0)
			panel:DockMargin(12, 3, 3, 3)
			panel:SetDark(true)

			if (classData[k]) then
				panel:SetChecked(classData[k])
			end

			self.classes[k] = panel
		end

		local name = self.scroll:Add("DLabel")
		name:SetText(PLUGIN:GetPluginLanguage("vd_admin_name"))
		name:DockMargin(3, 3, 3, 3)
		name:Dock(TOP)
		name:SetTextColor(Color(60, 60, 60))
		name:SetFont("nut_ScoreTeamFont")
		name:SizeToContents()
		
		self.name = vgui.Create("DTextEntry", self.scroll);
		self.name:Dock(TOP)
		self.name:DockMargin(3, 3, 3, 3)
		self.name:SetText(entity:GetNetVar("name", nut.lang.Get("no_desc")));
		
		local action = self.scroll:Add("DLabel")
		action:SetText(PLUGIN:GetPluginLanguage("vd_admin_action"))
		action:DockMargin(3, 3, 3, 3)
		action:Dock(TOP)
		action:SetTextColor(Color(60, 60, 60))
		action:SetFont("nut_ScoreTeamFont")
		action:SizeToContents()
		
		local vendorAction = entity:GetNetVar("vendoraction", { sell = true, buy = false })
		
		self.sell = self.scroll:Add("DCheckBoxLabel")
		self.sell:Dock(TOP)
		self.sell:SetText(PLUGIN:GetPluginLanguage("vd_admin_sell"))
		self.sell:SetValue(0)
		self.sell:DockMargin(12, 3, 3, 3)
		self.sell:SetDark(true)
		if ( vendorAction.sell ) then
			self.sell:SetChecked( vendorAction.sell )
		end
		
		self.buy = self.scroll:Add("DCheckBoxLabel")
		self.buy:Dock(TOP)
		self.buy:SetText(PLUGIN:GetPluginLanguage("vd_admin_buy"))
		self.buy:SetValue(0)
		self.buy:DockMargin(12, 3, 3, 3)
		self.buy:SetDark(true)
		if ( vendorAction.buy ) then
			self.buy:SetChecked( vendorAction.buy )
		end
		
		local adj = self.scroll:Add("DLabel")
		adj:SetText(PLUGIN:GetPluginLanguage("vd_admin_adj"))
		adj:DockMargin(3, 3, 3, 3)
		adj:Dock(TOP)
		adj:SetTextColor(Color(60, 60, 60))
		adj:SetFont("nut_ScoreTeamFont")
		adj:SizeToContents()
		
		self.adj = vgui.Create("DTextEntry", self.scroll);
		self.adj:Dock(TOP)
		self.adj:DockMargin(3, 3, 3, 3)
		self.adj:SetText(entity:GetNetVar("buyadjustment", .5))
		
		local money = self.scroll:Add("DLabel")
		money:SetText(PLUGIN:GetPluginLanguage("vd_admin_money"))
		money:DockMargin(3, 3, 3, 3)
		money:Dock(TOP)
		money:SetTextColor(Color(60, 60, 60))
		money:SetFont("nut_ScoreTeamFont")
		money:SizeToContents()
		
		self.money = vgui.Create("DTextEntry", self.scroll);
		self.money:Dock(TOP)
		self.money:DockMargin(3, 3, 3, 3)
		self.money:SetText(entity:GetNetVar("money", 100))
		
		local desc = self.scroll:Add("DLabel")
		desc:SetText(PLUGIN:GetPluginLanguage("vd_admin_desc"))
		desc:DockMargin(3, 3, 3, 3)
		desc:Dock(TOP)
		desc:SetTextColor(Color(60, 60, 60))
		desc:SetFont("nut_ScoreTeamFont")
		desc:SizeToContents()

		self.desc = vgui.Create("DTextEntry", self.scroll);
		self.desc:Dock(TOP)
		self.desc:DockMargin(3, 3, 3, 3)
		self.desc:SetText(entity:GetNetVar("desc", nut.lang.Get("no_desc")))
	
		local model = self.scroll:Add("DLabel")
		model:SetText(PLUGIN:GetPluginLanguage("vd_admin_model"))
		model:DockMargin(3, 3, 3, 3)
		model:Dock(TOP)
		model:SetTextColor(Color(60, 60, 60))
		model:SetFont("nut_ScoreTeamFont")
		model:SizeToContents()

		self.model = vgui.Create("DTextEntry", self.scroll);
		self.model:Dock(TOP)
		self.model:DockMargin(3, 3, 3, 3)
		self.model:SetText(entity:GetModel())

		self.save = self:Add("DButton")
		self.save:Dock(BOTTOM)
		self.save:DockMargin(0, 5, 0, 0)
		self.save:SetText(PLUGIN:GetPluginLanguage("vd_admin_save"))
		self.save.DoClick = function()
			if (IsValid(entity) and (self.nextSend or 0) < CurTime()) then
				self.nextSend = CurTime() + 1

				local data = {}
				for k, v in pairs(self.list:GetLines()) do
					
					local price
					local selling = v.selling
					local buying = v.buying

					if (selling != true) then
						selling = nil
					end;
					
					if (buying != true) then
						buying = nil
					end;
					
					price = v.price
					if (price != nil and price < 0) then
						price = nil
					end

					local value = { price = price, selling = selling, buying = buying }

					if (table.Count(value) > 0) then
						data[v.itemTable.uniqueID] = value
					end
				end

				local factionData = {}

				for k, v in pairs(self.factions) do
					if (v:GetChecked()) then
						factionData[k] = true
					end
				end

				local classData = {}

				for k, v in pairs(self.classes) do
					if (v:GetChecked()) then
						classData[k] = true
					end
				end
				
				local vendorAction = {}
				vendorAction.buy = self.buy:GetChecked()
				vendorAction.sell = self.sell:GetChecked()
				
				local cashadjustment = self.adj:GetValue()
				local money = self.money:GetValue()
				netstream.Start("nut_VendorData", {entity, data, vendorAction, cashadjustment, money, factionData, classData, self.name:GetText(), self.desc:GetText(), self.model:GetText() or entity:GetModel()})
			end
		end
	end
vgui.Register("nut_VendorAdminMenu", PANEL, "DPanel")

netstream.Hook("nut_VendorDataCallback", function()
	local entity = nut.gui.vendor.vendorentity;
	nut.gui.vendor:SetEntity(entity);	
end);

function PLUGIN:ShouldDrawTargetEntity(entity)
	if (string.lower(entity:GetClass()) == "nut_vendor") then
		return true
	end
end

function PLUGIN:DrawTargetID(entity, x, y, alpha)
	if (string.lower(entity:GetClass()) == "nut_vendor") then
		local mainColor = nut.config.mainColor
		local color = Color(mainColor.r, mainColor.g, mainColor.b, alpha)

		nut.util.DrawText(x, y, entity:GetNetVar("name", nut.lang.Get("no_desc")), color, "AdvNut_EntityTitle");
			y = y + nut.config.Get("targetTall")
		nut.util.DrawText(x, y, entity:GetNetVar("desc", nut.lang.Get("no_desc")), Color(255, 255, 255, alpha), "AdvNut_EntityDesc");
	end
end
