local PLUGIN = PLUGIN

local PANEL = {}
local ICON_USER = "icon16/user.png"
local ICON_HEART = "icon16/heart.png"
local ICON_WRENCH = "icon16/wrench.png"
local ICON_STAR = "icon16/star.png"
local ICON_SHIELD = "icon16/shield.png"

function PANEL:Init()
	self:SetPos(ScrW() * 0.225, ScrH() * 0.125)
	self:SetSize(AdvNut.util.GetCurrentMenuSize());
	self:MakePopup()
	
	self.list = self:Add("DCategoryList")
	self.list:Dock(FILL)
	self.list:SetDrawBackground(true)

	self.catCommands = self.list:Add(nut.lang.Get("command"))
	self.catCommands:SetExpanded(true)

	for k, v in SortedPairs(PLUGIN.commands) do
		if (!LocalPlayer():Alive() and !v.allowDead) then
			continue
		end

		if (PLUGIN:IsAllowed(LocalPlayer(), v.group)) then
			local button = self.catCommands:Add("DButton")
			button:SetText(v.text or k)
			button:Dock(TOP)
			button:DockMargin(2, 2, 2, 2)
			button.DoClick = function(panel)
				local menu = DermaMenu()
					for _, client in SortedPairs(player.GetAll()) do
						if (PLUGIN:IsAllowed(LocalPlayer(), client)) then
							local icon = ICON_USER

							if (client:IsSuperAdmin()) then
								icon = ICON_SHIELD
							elseif (client:IsAdmin()) then
								icon = ICON_STAR
							elseif (client:IsUserGroup("operator")) then
								icon = ICON_WRENCH
							elseif (client:IsUserGroup("donator")) then
								icon = ICON_HEART
							end
							v.onMenu( menu, icon, client, k )
						end
					end
				menu:Open()
			end
		end
	end

	self.catUsers = self.list:Add("Users")
	self.catUsers:SetExpanded(false)

	self.catBans = self.list:Add("Bans")
	self.catBans:SetExpanded(false)
end
vgui.Register("nut_Moderator", PANEL, "AdvNut_BaseForm")

// Not Now. //
/* function PLUGIN:CreateMenuButtons(menu, addButton)
	if (LocalPlayer():IsAdmin()) then
		addButton("mod", nut.lang.Get("mr_moderator"), function()
			nut.gui.mod = vgui.Create("nut_Moderator", menu)
			menu:SetCurrentMenu(nut.gui.mod)
		end)
		menu.mod:DockMargin(50, -8, 120, 0)
	end
end */
