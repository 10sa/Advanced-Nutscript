local gradient = surface.GetTextureID("gui/gradient")
local surface = surface

local PANEL = {}
function PANEL:Init()
	self:AddTitle(nut.lang.Get("scoreboard"));
	self:SetSize(AdvNut.util.GetCurrentMenuSize());
	self:SetPos(ScrW() * 0.225, ScrH() * 0.125)
	self:MakePopup()
	self:SetDrawBackground(false)
	
	local p = self:Add( "nut_NoticePanel" )
	p:Dock( TOP )
	p:DockMargin( 5, 5, 5, 0 )
	p:SetType( 4 )
	p:SetText( nut.lang.Get("sb_tip") )
	
	self.list = self:Add("AdvNut_ScrollPanel")
	self.list:Dock(FILL)
	self.list:DockMargin(8, 8, 8, 8)
	self.list:DockPadding(4, 4, 4, 4)

	self.lastUpdate = 0
	self.lastCount = #player.GetAll()
	
	self:PopulateList()
end

function PANEL:PopulateList()
	self.teamList = {}
	
	local players = player.GetAll()
	
	table.sort(players, function(a, b)
		return a:Team() > b:Team()
	end)
				
	for k, v in ipairs(players) do
		if (v.character) then
			local customClass = v:GetNetVar("customClass")

			if (customClass == "") then
				customClass = nil
			end

			local teamName = customClass or team.GetName(v:Team())
			
			if (table.HasValue(nut.config.dontshowfactions, v:Team())) then
				continue
			end
			
			if (!self.teamList[teamName]) then
				self.teamList[teamName] = self.list:Add("AdvNut_CategoryList")
				self.teamList[teamName]:Dock(TOP)
				self.teamList[teamName]:DockMargin(0, 1, 0, 10);
				self.teamList[teamName]:SetDrawBackground(false)
				self.teamList[teamName]:SetLabel(teamName);
				self.teamList[teamName]:SetTall(self.teamList[teamName]:GetTall() + 70)

				self.teamList[teamName].scollPanel = vgui.Create("AdvNut_ScrollPanel");
				self.teamList[teamName]:SetContents(self.teamList[teamName].scollPanel);
				self.teamList[teamName].scollPanel:SizeToContents();
				
				local userData = vgui.Create("nut_playerdata");
				userData:SetPlayer(v);
				userData:DockMargin(4, 0, 4, 0)
				userData:Dock(TOP)
				
				self.teamList[teamName].scollPanel:AddItem(userData);
				
				continue;
			end
			
			local titleData = self.teamList[teamName]

			if (titleData) then
				local userData = vgui.Create("nut_playerdata");
				userData:DockMargin(4, 0, 4, 1)
				userData:Dock(TOP)
				userData:SetPlayer(v)
				self.teamList[teamName].scollPanel:AddItem(userData);
			end
		end
	end
end
	
function PANEL:Think()
	if (self.lastUpdate < CurTime()) then
		self.lastUpdate = CurTime() + 1

		if (self.lastCount != #player.GetAll()) then
			self.list:Clear(true)
			self:PopulateList()
		end

		self.lastCount = #player.GetAll()
	end
end
vgui.Register("nut_Scoreboard", PANEL, "AdvNut_BaseForm")


local PANEL = {}
function PANEL:Init()
	local width = ScrW() * nut.config.menuWidth - 20
	self:SetTall(45)
	
	self.avatarIcon = vgui.Create("AvatarImage", self);
	self.avatarIcon:SetPos(45, 2)
	self.avatarIcon:SetSize(40, 40)
	
	self.avatarIconButton = vgui.Create("DButton", self);
	self.avatarIconButton:SetPos(45, 2)
	self.avatarIconButton:SetSize(40, 40);
	self.avatarIconButton:SetText("");
	self.avatarIconButton:SetDrawBackground(false);
	self.avatarIconButton:SetDrawBorder(false);

	AdvNut.util.DrawOutline(self.avatarIcon, 1, color_black);

	self.name = vgui.Create("DLabel", self)
	self.name:SetPos(95, 5)
	self.name:SetText("John Doe")
	self.name:SetTextColor(color_black)
	
	self.desc = vgui.Create("DLabel", self)
	self.desc:SetPos(95, 21)
	self.desc:SetText("...")
	self.desc:SetTextColor(color_black)
	self.desc:SetWrap(true)
	self.desc:SetTall(38)
	self.desc:SetWide(width - 128)
	self.desc:SetContentAlignment(7)
	self.stringRequestPanel = {};
end

function PANEL:SetPlayer(client)
	local recognized = hook.Run("IsPlayerRecognized", client)
	local name = ""
	local description = client.character:GetVar("description")
	local model = ""

	if (recognized) then
		self.model = vgui.Create("SpawnIcon", self);
		self.model:SetModel(client:GetModel(), client:GetSkin());
		name = hook.Run("GetPlayerName", client, "scoreboard");
	else
		self.model = vgui.Create("DImageButton", self);
		self.model.Paint = function(client, w, h)
			surface.SetDrawColor(Color(200, 200, 200, 255));
			surface.DrawRect(0, 0, w, h);
		end;
		
		self.model:SetImage("nutscript/logo.png");
		name = hook.Run("GetUnknownPlayerName", client) or nut.lang.Get("unknown_player");
	end
	
	self.name:SetText(name)
	self.name:SizeToContents()
	AdvNut.util.DrawOutline(self.model, 1, color_black);
	
	self.model:SetPos(2, 2)
	self.model:SetSize(40, 40)
	self.model.client = client;
	if (LocalPlayer():IsAdmin()) then
		self.model.DoClick = function(panel)
			local menu = DermaMenu();
			local target = panel.client;
			local client = LocalPlayer();
		
			menu:AddOption(nut.lang.Get("sb_menu_change_name"), function()
				self.stringRequestPanel.changeName = Derma_StringRequest(nut.lang.Get("sb_menu_change_name"), nut.lang.Get("sb_menu_change_desc"), target:Name(), function(name)
				
					if (name and string.find(name, "%S")) then
						local oldName = target.character:GetVar("charname", "ERROR");
						target.character:SetVar("charname", name);
					
						nut.util.Notify(nut.lang.Get("char_set_name", client:Name(), oldName, name));
					else
						nut.util.Notify(nut.lang.Get("char_bad_name"), client);
					end;
				end);
			end);
		
			// Faction Sub Menu //
			menu.factionMenu = menu:AddSubMenu(nut.lang.Get("faction"));
			menu.factionGiveMenu = menu.factionMenu:AddSubMenu(nut.lang.Get("sb_menu_faction_give"));
			for index, faction in pairs(nut.faction.GetAll()) do
				if (!faction.isDefault) then
					menu.factionGiveMenu:AddOption(faction.name, function()
						netstream.Start("PlayerGiveWhitelist", {factionName = faction.name, factionIndex = faction.index, target = target});
					end);
				end;
			end;
		
			menu.factionTakeMenu = menu.factionMenu:AddSubMenu(nut.lang.Get("sb_menu_faction_take"));
			if (target.whitelists) then
				local whitelists = string.Split(target.whitelists, ",");
				whitelists[#whitelists] = nil;
			
				for index, factionName in pairs(whitelists) do
					local faction = nut.faction.GetByStringID(factionName);
					menu.factionTakeMenu:AddOption(faction.name, function()
						netstream.Start("PlayerTakeWhitelist", {factionName = faction.name, factionIndex = faction.index, target = target});
					end);
				end;
			end;
			// End Faction Sub Menu //
		
			// Flags Sub Menu //
			menu.flagsMenu = menu:AddSubMenu(nut.lang.Get("sb_menu_flags"));
			menu.flagsMenu:AddOption(nut.lang.Get("sb_menu_flags_give"), function()
				self.stringRequestPanel.flagGive = Derma_StringRequest(nut.lang.Get("sb_menu_flags_give"), nut.lang.Get("sb_menu_flags_give_desc"), "", function(flags)
					netstream.Start("PlayerGiveFlags", {flags = flags, target = target});
				end);
			end);
		
			menu.flagsMenu:AddOption(nut.lang.Get("sb_menu_flags_take"), function()
				self.stringRequestPanel.flagTake = Derma_StringRequest(nut.lang.Get("sb_menu_flags_take"), nut.lang.Get("sb_menu_flags_take"), "", function(flags)
					netstream.Start("PlayerTakeFlags", {flags = flags, target = target});
				end);
			end);
			// End Flags Sub Menu //
		
			// Kick Sub Menu //
			menu.kickMenu = menu:AddSubMenu(nut.lang.Get("sb_menu_kick"));
			menu.kickMenu:AddOption(nut.lang.Get("sb_menu_kick"), function()
				netstream.Start("PlayerKick", {reason = "No Reason", target = target});
			end);
			
			menu.kickMenu:AddOption(nut.lang.Get("sb_menu_kick_reason"), function()
				self.stringRequestPanel.kickReason = Derma_StringRequest(nut.lang.Get("sb_menu_kick_reason"), nut.lang.Get("sb_menu_kick_reason_desc"), "", function(reason)
					netstream.Start("PlayerKick", {reason = reason, target = target});
				end);
			end);
			// End Kick Sub Menu //
		
		
			menu:AddOption(nut.lang.Get("sb_menu_ban"), function()
				self.stringRequestPanel.ban = Derma_StringRequest(nut.lang.Get("sb_menu_ban"), nut.lang.Get("sb_menu_ban_desc"), "", function(time)
					if (tonumber(time)) then
						netstream.Start("PlayerBan", {time = tonumber(time), target = target});
					else
						nut.util.Notify(nut.lang.Get("wrong_value"), client);
					end;
				end);
			end);
		
			hook.Run("AddScoreboardModelMenu", menu);
			menu:Open();
		end;
	end;
	
	self.avatarIcon:SetPlayer(client, 45);
	self.avatarIconButton:SetToolTip(nut.lang.Get("sb_avatar_tip", client:RealName(), client:SteamID()));
	self.avatarIconButton.DoClick = function()
		if (IsValid(client)) then
			client:ShowProfile();
		end
	end

	if (description) then
		self.desc:SetText(description)
	end
end

function PANEL:Think()
	self.model:SetToolTip(nut.lang.Get("sb_model_tip", LocalPlayer():Ping()));
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end
vgui.Register("nut_playerdata", PANEL, "DPanel")
