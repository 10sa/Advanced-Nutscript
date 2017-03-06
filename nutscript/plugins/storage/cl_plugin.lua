local PLUGIN = PLUGIN or { };

local locks = {
	"classic_locker_1",
	"digital_locker_1",
}
	
local function lck1(entity)
	if (!LocalPlayer():HasItem("classic_locker_1")) then 
		nut.util.Notify(nut.lang.Get("sr_lock_noitem"), client)

		return false
	end

	netstream.Start("nut_RequestLock", {entity, true, ""})
end
	
local function lck2(entity)
	if (!LocalPlayer():HasItem("digital_locker_1")) then
		nut.util.Notify(nut.lang.Get("sr_lock_noitem"), client)

		return false
	end

	Derma_StringRequest( nut.lang.Get("sr_d_locker_name"), nut.lang.Get("sr_enter_password"), "", function( pas ) 
		netstream.Start("nut_RequestLock", {entity, false, pas})
	end)
end
	
local storfuncs = {
	aopen = {
		icon = "icon16/star.png",
		name = nut.lang.Get("sr_admin_open"),
		tip = nut.lang.Get("sr_admin_open_desc"),
		cond = function(entity)
			return LocalPlayer():IsAdmin()
		end,
		
		func = function(entity)
			netstream.Start("nut_Storage", entity)
		end,
	},

	open = {
		name = nut.lang.Get("open"),
		tip = nut.lang.Get("sr_open_desc"),
		cond = function(entity)
			return true
		end,
		
		func = function(entity)
			netstream.Start("nut_RequestStorageMenu", entity)
		end,
	},

	pick = {
		name = "Force Unlock",
		cond = function(entity)
			return false
		end,
		
		func = function(entity)
		end,
	},

	lock = {
		icon = "icon16/key.png",
		name = nut.lang.Get("lock"),
		tip = nut.lang.Get("sr_lock_desc"),
		cond = function(entity)
			for _, item in pairs( locks ) do
				if LocalPlayer():HasItem( item ) then
					return !entity:GetNetVar( "locked" )
				end
			end
			
			return false
		end,
		
		func = function(entity)
			Derma_Query( nut.lang.Get("sr_lock_type"), nut.lang.Get("sr_confirmation"), nut.lang.Get("sr_c_locker_name"), function() lck1(entity) end, nut.lang.Get("sr_d_locker_name"), function() lck2(entity) end, nut.lang.Get("cancel"), function() end )
		end,
	},
}
	
function PLUGIN:ShowStorageMenu( entity )
	if (!IsValid(entity) or !IsValid(LocalPlayer():GetEyeTrace().Entity) or LocalPlayer():GetEyeTrace().Entity != entity) then
		return
	end

	local menu = DermaMenu()
		for k, v in SortedPairs( storfuncs ) do
				
			if v.cond and !v.cond( entity ) then continue end
				
			local material = v.icon or "icon16/briefcase.png"

			local option = menu:AddOption(v.name or k, function()
				if (v.func) then
					if v.func then
						v.func( entity )
					end
				end
			end)
			option:SetImage(material)

			if (v.tip) then
				option:SetToolTip(v.tip)
			end
				
		end
			
	menu:Open()
	menu:Center()
end

netstream.Hook("nut_ShowStorageMenu", function(entity)
	PLUGIN:ShowStorageMenu(entity)
end);
		
netstream.Hook("nut_RequestPassword", function(entity)
	Derma_StringRequest( nut.lang.Get("sr_d_locker_name"), nut.lang.Get("sr_enter_password"), "", function(str) 
		entity.lock = str // Storing correct password in client. You can't send malicious net-message to the server without setting the password via this menu.

		netstream.Start("nut_VerifyPassword", {entity, str})
	end)
end);