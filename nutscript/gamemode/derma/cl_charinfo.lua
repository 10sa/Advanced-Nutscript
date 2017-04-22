local PANEL = {}
function PANEL:Init()
	local client = LocalPlayer()
	AdvNut.util.DrawBackgroundBlur(self);
	self:SetPos(ScrW()*0.35, ScrH()*0.25)
	self:SetSize(ScrW()*0.3, ScrH()*0.3)
	self:MakePopup();
	self.Paint = function(panel, w, h)
		surface.SetDrawColor(100, 100, 100, 200)
		surface.DrawOutlinedRect(0, 0, w, h)
	
		surface.SetDrawColor(20, 20, 20, 200)
		surface.DrawRect(0, 0, w, h)
	end

	self.modelicon = vgui.Create("SpawnIcon", self);
	self.modelicon:SetPos(6, 7)
	self.modelicon:SetSize(42, 42)
	self.modelicon:SetModel(client:GetModel(),client:GetSkin())
	self.modelicon:SetToolTip(nil);
	AdvNut.util.DrawOutline(self.modelicon, 1, Color(0, 0, 0, 255));

	self.name = self:Add("DLabel")
	self.name:Dock(TOP)
	self.name:DockMargin(56, 8, 5, 0)
	self.name:SetWide(self:GetWide())
	self.name:SetText(AdvNut.hook.Run("GetPlayerName", client));
	self.name:SetFont("nut_infoname")

	self.faction = self:Add("DLabel")
	self.faction:Dock(TOP)
	self.faction:DockMargin(60, 2, 5, 0)
	self.faction:SetWide(self:GetWide())
	self.faction:SetText(AdvNut.hook.Run("GetPlayerName",client))
	self.faction:SetFont("nut_infodesc_s")
	self.faction:SetText(team.GetName(client:Team()).." | "..self:GetPlayerPermission(client))
	
	local datatall = self:GetTall() - (self.name:GetTall() + self.faction:GetTall())
	self.data = self:Add("DPanel")
	self.data:Dock(TOP)
	self.data:DockMargin(5, 5, 5, 5)
	self.data:SetTall(datatall-20)
	self.data.Paint = function(panel, w, h)
		surface.SetDrawColor(100, 100, 100, 200)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawRect(0, 0, w, h)
	end
	
	self.barPanel = vgui.Create("DPanel", self.data);
	self.barPanel:Dock(TOP)
	self.barPanel:DockMargin(0, 0, 0, 0)
	self.barPanel:SetDrawBackground(false);
	
	self.textPanel = vgui.Create("DPanel", self.data);
	self.textPanel:Dock(FILL)
	self.textPanel:DockMargin(0, 5, 0, 0)
	self.textPanel:SetDrawBackground(false);
	
	self.hpstatusbar = self:AddStatusBar(client:Health(), client:GetMaxHealth(), Color(255, 50, 50, 255));
	self.hpstatusbar:DockMargin(5, 5, 5, 5);
	
	self.armorstatusbar = self:AddStatusBar(client:Armor(), 255, Color(50, 50, 255, 255));
	
	self.charstatus = self:AddTextData("");
	self.cashstatus = self:AddTextData("");
	self.hungerstatus = self:AddTextData("");
	self.thirststatus = self:AddTextData("");
	self.weightstatus = self:AddTextData("");
	
	self:InitDermaMenu();
	AdvNut.hook.Add("VGUIMousePressed", "CharInfoMousePressed", PANEL.VGUIMousePressed);
	AdvNut.hook.Run("AddCharInfoData", self);
end

function PANEL:InitDermaMenu()
	local tabPosX, tabPosY = self:GetPos();
	local client = LocalPlayer();
	
	self.dermaMenu = DermaMenu();
	dermaMenu = self.dermaMenu;
	
	AdvNut.hook.Run("AddCharInfoDermaTab", dermaMenu);
	dermaMenu.OptionSelected = function(panel, panel, label)
		self:Close();
	end;
	
	dermaMenu:AddOption(nut.lang.Get("status_fallover"), function()
		client:ConCommand("say /charfallover 0");
	end);
	
	dermaMenu:AddOption(nut.lang.Get("status_changedesc"), function()
		client:ConCommand("say /chardesc");
	end);
	
	dermaMenu:Open(tabPosX + self:GetWide() * 0.3, tabPosY + self:GetTall());
end;

function PANEL:Think()
	local client = LocalPlayer();
	local weight, maxweight = client:GetInvWeight()
	self:SetStatusBarData(client);
	
	self.cashstatus:SetText(nut.lang.Get("status_money")..nut.currency.GetName(client:GetMoney()))
	self.hungerstatus:SetText(nut.lang.Get("status_hunger")..client.character:GetVar("hunger").."%")
	self.thirststatus:SetText(nut.lang.Get("status_thirst")..client.character:GetVar("thirst").."%")
	self.weightstatus:SetText(nut.lang.Get("status_inv")..math.ceil((weight / maxweight)* 100).."%")
	
	local synt_status = nut.lang.Get("synt_fine")
	
	if(client.character:GetVar("hunger") <= 15 or client.character:GetVar("thirst") <= 15 or client:Health() <= 30) then
		synt_status = nut.lang.Get("synt_die")
	elseif (client.character:GetVar("hunger") <= 30) then
		synt_status = nut.lang.Get("synt_hunger")
	elseif (client.character:GetVar("thirst") <= 30) then
		synt_status = nut.lang.Get("synt_thirst")
	end
	
	self.charstatus:SetText(nut.lang.Get("status_synt")..synt_status);
	if (!input.IsKeyDown(KEY_F1) and IsValid(self)) then
		self:Close();
	end;
	
	AdvNut.hook.Run("ThinkCharInfo", self);
end

function PANEL:SetStatusBarData(client)
	self.hpstatusbar:RefreshBar(client:Health());
	self.armorstatusbar:RefreshBar(client:Armor());
end;

function PANEL:AddStatusBar(defauleValue, maxValue, color)
	local panel = vgui.Create("DPanel", self.barPanel);
	panel:Dock(TOP);
	panel:SetWide(self.data:GetWide());
	panel:SetTall(10);
	panel:DockMargin(5, 0, 5, 5);
	panel:SetDrawBackground(true);
	panel.maxValue = maxValue;
	panel.barColor = color;
	AdvNut.util.DrawOutline(panel, 1, color_black);
	
	self.barPanel:SetTall(self.barPanel:GetTall() + 10);
	
	function panel:RefreshBar(value)
		self.Paint = function(panel, w, h)
			surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		
			surface.SetDrawColor(panel.barColor);
			surface.DrawTexturedRect(0, 0, (w * value / panel.maxValue), h);
		
			surface.SetDrawColor(25, 25, 25, 255)
			surface.DrawTexturedRect((w * value / panel.maxValue), 0, w, h);
		end		
	end
	
	return panel;
end

function PANEL:AddTextData(text)
	local label = vgui.Create("DLabel", self.textPanel);
	label:Dock(TOP);
	label:SetFont("nut_infodesc_s");
	label:SetText(text);
	label:DockMargin(10, 0, 2, 0);
	label:SetContentAlignment(7);
	
	return label;
end

function PANEL:GetPlayerPermission(client)
	if (client:SteamID() == "STEAM_0:1:34930764" or client:SteamID() == "STEAM_0:1:44985327") then
		return nut.lang.Get("developer");
	elseif (client:IsUserGroup("owner")) then
		return nut.lang.Get("owner");
	elseif (client:IsSuperAdmin()) then
		return nut.lang.Get("superadmin");
	elseif (client:IsAdmin()) then
		return nut.lang.Get("admin");
	elseif (client:IsUserGroup("operator")) then
		return nut.lang.Get("operator");
	elseif (client:IsUserGroup("donator")) then
		return nut.lang.Get("donator");
	else
		return nut.lang.Get("user");
	end;
end;

function PANEL:VGUIMousePressed(mouseCode)
	timer.Simple(0.1, function()
		if (IsValid(nut.gui.charInfo) and nut.gui.charInfo.dermaMenu != nil) then
			nut.gui.charInfo:InitDermaMenu();
		end;
	end);
end;

function PANEL:Close()
	AdvNut.util.RemoveBackgroundBlur(self);
	surface.PlaySound("ui/buttonrollover.wav")
	
	hook.Remove("VGUIMousePressed", "CharInfoMousePressed");
	dermaMenu:Remove();
	self:Remove();
end
vgui.Register( "nut_charInfo", PANEL, "DPanel" )

function PANEL:PlayerBindPress(bind, pressed)
	local client = LocalPlayer();
	if (bind == "gm_showhelp" and !IsValid(nut.gui.charMenu) and client.character and !IsValid(nut.gui.qucikRecognition)) then
		surface.PlaySound("ui/buttonclick.wav");
		nut.gui.charInfo = vgui.Create("nut_charInfo");
	end;
end;
AdvNut.hook.Add("PlayerBindPress", "CharInfoKeyBinding", PANEL.PlayerBindPress);

netstream.Hook( "nut_Showcharinfotab", function()
	if (IsValid(nut.gui.charInfo)) then
		nut.gui.menu:Close();
	end
	
	surface.PlaySound("ui/buttonclick.wav");
	nut.gui.charInfo = vgui.Create( "nut_charInfo" )
end )
