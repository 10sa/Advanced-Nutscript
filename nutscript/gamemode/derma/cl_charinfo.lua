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
	self.name:SetText(hook.Run("GetPlayerName", client));
	self.name:SetFont("nut_infoname")

	self.faction = self:Add("DLabel")
	self.faction:Dock(TOP)
	self.faction:DockMargin(60, 2, 5, 0)
	self.faction:SetWide(self:GetWide())
	self.faction:SetText(hook.Run("GetPlayerName",client))
	self.faction:SetFont("nut_infodesc_s")
	self.faction:SetText(team.GetName(client:Team()).." | "..self:GetPlayerPermission(client))
	
	local datatall = self:GetTall() - (self.name:GetTall() + self.faction:GetTall())
	self.data = self:Add("DPanel")
	self.data:Dock(TOP)
	self.data:DockMargin(5, 3, 5, 5)
	self.data:SetTall(datatall-20)
	self.data.Paint = function(panel, w, h)
		surface.SetDrawColor(100, 100, 100, 200)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawRect(0, 0, w, h)
	end
	
	local bartall = 10
	
	hpstatusbar = self.data:Add("DPanel")
	hpstatusbar:Dock(TOP)
	hpstatusbar:SetWide(self.data:GetWide())
	hpstatusbar:SetTall(bartall)
	hpstatusbar:DockMargin(5, 5, 5, 5)
	hpstatusbar:SetDrawBackground(true)
	AdvNut.util.DrawOutline(hpstatusbar, 1, color_black);
	
	armorstatusbar = self.data:Add("DPanel")
	armorstatusbar:Dock(TOP)
	armorstatusbar:SetWide(self.data:GetWide())
	armorstatusbar:SetTall(bartall)
	armorstatusbar:DockMargin(5, 0, 5, 5)
	armorstatusbar:SetDrawBackground(true)
	AdvNut.util.DrawOutline(armorstatusbar, 1, color_black);
	
	staminastatusbar = self.data:Add("DPanel")
	staminastatusbar:Dock(TOP)
	staminastatusbar:SetWide(self.data:GetWide())
	staminastatusbar:SetTall(bartall)
	staminastatusbar:DockMargin(5, 0, 5, 5)
	staminastatusbar:SetDrawBackground(true)
	AdvNut.util.DrawOutline(staminastatusbar, 1, color_black);
	
	charstatus = self.data:Add("DLabel")
	charstatus:Dock(TOP)
	charstatus:DockMargin(10, 3, 5, 0)
	charstatus:SetTall(self.data:GetTall()*0.15)
	charstatus:SetWide(self.data:GetWide())
	charstatus:SetText("")
	charstatus:SetFont("nut_infodesc_s")
	charstatus:SetContentAlignment(7)

	cashstatus = self.data:Add("DLabel")
	cashstatus:Dock(TOP)
	cashstatus:DockMargin(10, 0, 2, 0)
	cashstatus:SetWide(self.data:GetWide())
	cashstatus:SetText("")
	cashstatus:SetFont("nut_infodesc_s")
	cashstatus:SetContentAlignment(7)
	
	hungerstatus = self.data:Add("DLabel")
	hungerstatus:Dock(TOP)
	hungerstatus:DockMargin(10, 0, 2, 0)
	hungerstatus:SetWide(self.data:GetWide())
	hungerstatus:SetText("")
	hungerstatus:SetFont("nut_infodesc_s")
	hungerstatus:SetContentAlignment(7)
	
	thirststatus = self.data:Add("DLabel")
	thirststatus:Dock(TOP)
	thirststatus:DockMargin(10, 0, 5, 0)
	thirststatus:SetWide(self.data:GetWide())
	thirststatus:SetText("")
	thirststatus:SetFont("nut_infodesc_s")
	thirststatus:SetContentAlignment(7)
	
	weightstatus = self.data:Add("DLabel")
	weightstatus:Dock(TOP)
	weightstatus:DockMargin(10, 0, 5, 0)
	weightstatus:SetWide(self.data:GetWide())
	weightstatus:SetText("")
	weightstatus:SetFont("nut_infodesc_s")
	weightstatus:SetContentAlignment(7)
	
	hook.Run("AddCharInfoData", self.data);
	
	self:InitDermaMenu()
	hook.Add("VGUIMousePressed", "CharInfoMousePressed", PANEL.VGUIMousePressed);
end

function PANEL:InitDermaMenu()
	local tabPosX, tabPosY = self:GetPos();
	local client = LocalPlayer();
	
	self.dermaMenu = DermaMenu();
	dermaMenu = self.dermaMenu;
	
	hook.Run("AddCharInfoDermaTab", dermaMenu);
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
	local client = LocalPlayer()
	local weight, maxweight = client:GetInvWeight()
	self:SetStatusBarData(client);
	
	cashstatus:SetText(nut.lang.Get("status_money")..nut.currency.GetName(client:GetMoney()))
	hungerstatus:SetText(nut.lang.Get("status_hunger")..client.character:GetVar("hunger").."%")
	thirststatus:SetText(nut.lang.Get("status_thirst")..client.character:GetVar("thirst").."%")
	weightstatus:SetText(nut.lang.Get("status_inv")..math.ceil((weight / maxweight)* 100).."%")
	
	local synt_status = nut.lang.Get("synt_fine")
	
	if(client.character:GetVar("hunger") <= 15 or client.character:GetVar("thirst") <= 15 or client:Health() <= 30) then
		synt_status = nut.lang.Get("synt_die")
	elseif (client.character:GetVar("hunger") <= 30) then
		synt_status = nut.lang.Get("synt_hunger")
	elseif (client.character:GetVar("thirst") <= 30) then
		synt_status = nut.lang.Get("synt_thirst")
	end
	
	charstatus:SetText(nut.lang.Get("status_synt")..synt_status);
	if (!input.IsKeyDown(KEY_F1) and IsValid(self)) then
		self:Close();
	end;
end

function PANEL:SetStatusBarData(client)
	hpstatusbar.Paint = function(panel, w, h)
		local hp = client:Health();

		surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		
		surface.SetDrawColor(225, 50, 50, 255)
		surface.DrawTexturedRect(0, 0, (w * hp / 100), h)

		surface.SetDrawColor(25, 25, 25, 255)
		surface.DrawTexturedRect((w * hp / 100), 0, w, h)
	end
	
	armorstatusbar.Paint = function(panel, w, h)
		local armor = client:Armor();

		surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		
		surface.SetDrawColor(50, 50, 255, 255)
		surface.DrawTexturedRect(0, 0, (w * armor / 100), h)

		surface.SetDrawColor(25, 25, 25, 255)
		surface.DrawTexturedRect((w * armor / 100), 0, w, h)
	end;
	
	staminastatusbar.Paint = function(panel, w, h)
		local stamina = client.character:GetVar("stamina", 0);
		
		surface.SetTexture(surface.GetTextureID("gui/gradient_up"));
		
		surface.SetDrawColor(100, 255, 100, 255)
		surface.DrawTexturedRect(0, 0, (w * stamina / 100), h)
		
		surface.SetDrawColor(25, 25, 25, 255)
		surface.DrawTexturedRect((w * stamina / 100), 0, w, h)
	end;
end;

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
hook.Add("PlayerBindPress", "CharInfoKeyBinding", PANEL.PlayerBindPress);

netstream.Hook( "nut_Showcharinfotab", function()
	if (IsValid(nut.gui.charInfo)) then
		nut.gui.menu:Close();
	end
	
	surface.PlaySound("ui/buttonclick.wav");
	nut.gui.charInfo = vgui.Create( "nut_charInfo" )
end )
