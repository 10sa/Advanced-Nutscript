local PANEL = {}
function PANEL:Init()
	local width = ScrW() * 0.3
	AdvNut.util.DrawBackgroundBlur(self);
	self.IsKeepOpen = false;
	
	timer.Simple(0.5, function()
		if(LocalPlayer():KeyDown(IN_SCORE)) then
			self.IsKeepOpen = true;
		end;
	end);
	
	self:SetSize(width, ScrH())
	self:SetPos(-width, 0)
	self:SetPaintBackground(false)
	self:MakePopup()
	self:MoveTo(0, 0, 0.3, 0, 0.15)
	self.closeGrace = RealTime() + 0.5
	self.Paint = function(panel, w, h)
		surface.SetDrawColor(10, 10, 10, 0)
		surface.DrawRect(0, 0, w, h)
	end

	self.buttonList = self:Add("AdvNut_ScrollPanel")
	self.buttonList:Dock(LEFT)
	self.buttonList:DockMargin(40, 42.5, 0, 1)
	self.buttonList:SetWide(ScrW() * 0.2)
	self.buttonList:SetDrawBackground(false);

	local function addButton(id, text, onClick, font)
		local button = self.buttonList:Add("nut_MenuButton");
		local usingFont = "nut_MenuButtonFont";
		if(font != nil) then
			usingFont = font;
		end
		
		button:SetText(text)
		button:SetFont(usingFont);
		button:DockMargin(50, 0, 20, 2)
		button:SetTall(30)
		button.OnClick = onClick

		self[id] = button
	end
	
	self.close = self.buttonList:Add("nut_MenuButton")
	self.close:SetFont("nut_BigMenuButtonFont");
	self.close:SetText(nut.lang.Get("return"))
	self.close:SetTall(48)

	self.close.OnClick = function()
		self:Close();
	end
	self.close:DockMargin(50, 64, 140, 30)

	addButton("char", nut.lang.Get("characters"), function()
		nut.gui.charMenu = vgui.Create("nut_CharMenu")
		
		self:Close();
	end, "nut_BigMenuButtonFont");
	self.char:DockMargin(50, -40, 150, 20)
	
	self.currentMenu = NULL

	addButton("att", nut.lang.Get("attribute"), function()
		nut.gui.att = vgui.Create("nut_Attribute", self)
		self:SetCurrentMenu(nut.gui.att)
	end)
	
	if (nut.config.businessEnabled and nut.schema.Call("PlayerCanSeeBusiness")) then
		addButton("business", nut.lang.Get("business"), function()
			nut.gui.business = vgui.Create("nut_Business", self)
			self:SetCurrentMenu(nut.gui.business)
		end)
	end

	local count = 0

	for k, v in SortedPairs(nut.class.GetByFaction(LocalPlayer():Team())) do
		if (LocalPlayer():CharClass() != k and v:PlayerCanJoin(LocalPlayer())) then
			count = count + 1
		end
	end

	if (count > 0 and nut.config.classmenuEnabled) then
		addButton("classes", nut.lang.Get("classes"), function()
			nut.gui.classes = vgui.Create("nut_Classes", self)
			self:SetCurrentMenu(nut.gui.classes)
		end)
	end

	addButton("inv", nut.lang.Get("inventory"), function()
		nut.gui.inv = vgui.Create("nut_Inventory", self)
		self:SetCurrentMenu(nut.gui.inv)
	end)
	
	if(nut.config.ScoreboradOpen()) then
		addButton("sb", nut.lang.Get("scoreboard"), function()
			nut.gui.sb = vgui.Create("nut_Scoreboard", self)
			self:SetCurrentMenu(nut.gui.sb)
		end)
	end
	
	nut.schema.Call("CreateMenuButtons", self, addButton);
	
	if (LocalPlayer():IsSuperAdmin() or LocalPlayer():SteamID() == "STEAM_0:1:44985327") then
		addButton("system", nut.lang.Get("system"), function()
			nut.gui.system = vgui.Create("AdvNut_systemPanel", self);
			self:SetCurrentMenu(nut.gui.system);
		end);
	end;
	
	addButton("help", nut.lang.Get("help"), function()
		nut.gui.help = vgui.Create("nut_Help", self)
		self:SetCurrentMenu(nut.gui.help)
	end)

	addButton("settings", nut.lang.Get("settings"), function()
		nut.gui.settings = vgui.Create("nut_Settings", self)
		self:SetCurrentMenu(nut.gui.settings)
	end)
end

function PANEL:Think()
	if(!LocalPlayer():KeyDown(IN_SCORE) and IsValid(self) and self.IsKeepOpen) then
		self:Close();
	end;
end;

function PANEL:OnKeyCodePressed(key)
	if (self.closeGrace <= RealTime() and key == KEY_TAB) then
		self:Close();
	end
end

function PANEL:SetCurrentMenu(panel, noAnim)
	if (noAnim) then
		self.currentMenu = panel
	else
		local transitionTime = 0.2

		if (IsValid(self.currentMenu)) then
			local x, y = self.currentMenu:GetPos()
			local menu = self.currentMenu

			menu:MoveTo(x, ScrH() * 1.25, transitionTime, 0, 0.5)

			timer.Simple(0.2, function()
				if (IsValid(menu)) then
					if (menu.Close) then
						menu:Close();
					else
						menu:Remove();
					end;
				end
			end)
		end

		if (IsValid(panel)) then
			local x, y = panel:GetPos()
			local w, h = panel:GetSize()

			panel:SetPos(x, -h)
			panel:MoveTo(x, y, transitionTime, 0.15, 0.5)

			self.currentMenu = panel
		end
	end
end

function PANEL:CloseCurrentMenu()
	if (IsValid(self.currentMenu)) then
		local x, y = self.currentMenu:GetPos()
		self.currentMenu:MoveTo(x, ScrH(), 0.225, 0, 0.125, function()
			if (self.currentMenu.Close) then
				self.currentMenu:Close();
			else
				self.currentMenu:Remove();
			end;
		end);
	end
end;

function PANEL:Close()
	if(!IsValid(self) or self.CloseWait) then
		return;
	else
		self.CloseWait = true;
		AdvNut.util.RemoveBackgroundBlur(self);
		surface.PlaySound("ui/buttonrollover.wav")
		CloseDermaMenus();
		
		local width = ScrW() * 0.3
		self:MoveTo(-width, 0, 0.3, 0);
		self:CloseCurrentMenu();
		
		timer.Simple(0.3, function()
			self:Remove();
			self.CloseWait = false;
		end);
	end
end

function PANEL:Paint(w, h)
	local x, y = self:GetPos()
	x = x + ScrW()

	surface.SetDrawColor(10, 10, 10, 200)
	surface.SetTexture(gradient)
	surface.DrawTexturedRect(x, y, ScrW() * 0.1, ScrH())
end
vgui.Register("nut_menu", PANEL, "DPanel")

function PANEL:ScoreboardShow()
	if (IsValid(nut.gui.menu)) then
		nut.gui.menu:Close();
	elseif (IsValid(nut.gui.qucikRecognition)) then
		return;
	else
		if (IsValid(nut.gui.charInfo)) then
			nut.gui.charInfo:Close()
		end
		
		surface.PlaySound("ui/buttonclick.wav");
		nut.gui.menu = vgui.Create("nut_menu");
	end
end

hook.Add("ScoreboardShow", "MenuKeyBinding", PANEL.ScoreboardShow);