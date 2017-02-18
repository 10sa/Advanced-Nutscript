local PLUGIN = PLUGIN
PLUGIN.name = "저장고 (Storage)"
PLUGIN.author = "Chessnut and rebel1324 / 번역자 : Tensa"
PLUGIN.desc = "저장고를 추가시켜 줍니다."

-- Black Tea added few lines.

nut.util.Include("cl_storage.lua")

if (SERVER) then
	local PLUGIN = PLUGIN

	function PLUGIN:SaveData()
		local data = {}

		for k, v in pairs(ents.FindByClass("nut_container")) do
			if v.generated then continue end
			if (v.itemID) then
				local inventory = v:GetNetVar("inv")

				data[#data + 1] = {
					position = v:GetPos(),
					angles = v:GetAngles(),
					inv = inventory,
					world = v.world,
					lock = v.lock,
					classic = v.classic,
					uniqueID = v.itemID,
					type = v.type
				}
			end
		end

		self:WriteTable(data)
	end

	timer.Create("nut_SaveContainers", 600, 0, function()
		PLUGIN:SaveData()
	end)

	function PLUGIN:LoadData()
		local storage = self:ReadTable()

		if (storage) then
			for k, v in pairs(storage) do
				local inventory = v.inv
				local position = v.position
				local angles = v.angles
				local itemTable = nut.item.Get(v.uniqueID)
				
				local amt = 0
				for _, __ in pairs( inventory ) do
					amt = amt + 1
				end

				if ( amt == 0 && !v.world && !v.lock ) then continue end

				if (itemTable) then
					local entity = ents.Create("nut_container")
					entity:SetPos(position)
					entity:SetAngles(angles)
					entity:Spawn()
					entity:Activate()
					entity:SetNetVar("inv", inventory)
					entity:SetNetVar("name", itemTable.name)

					local weight, max = entity:GetInvWeight()
					entity:SetNetVar("weight", math.ceil((weight / max) * 100))
					
					entity.itemID = v.uniqueID
					entity.lock = v.lock
					entity.classic = v.classic
					if entity.lock then
						entity:SetNetVar( "locked", true )
					end
					entity.world = v.world
					entity.type = v.type
					entity:SetModel(itemTable.model)
					entity:PhysicsInit(SOLID_VPHYSICS)
					if (itemTable.maxWeight) then
						entity:SetNetVar("max", itemTable.maxWeight)
					end
					if v.world then
						local phys = entity:GetPhysicsObject()
						if phys and phys:IsValid() then
							phys:EnableMotion(false)
						end
					end
				end
			end
		end
	end
else
	
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
	end)
		
	netstream.Hook("nut_RequestPassword", function(entity)
		Derma_StringRequest( nut.lang.Get("sr_d_locker_name"), nut.lang.Get("sr_enter_password"), "", function(str) 
			entity.lock = str // Storing correct password in client. You can't send malicious net-message to the server without setting the password via this menu.

			netstream.Start("nut_VerifyPassword", {entity, str})
		end)
	end)
		
end


nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_bool"),
	onRun = function(client, arguments)

		local dat = {}
		dat.start = client:GetShootPos()
		dat.endpos = dat.start + client:GetAimVector() * 96
		dat.filter = client
		local trace = util.TraceLine(dat)
		local entity = trace.Entity
		
		if (entity and entity:IsValid()) then
			if (entity:GetClass() == "nut_container") then
				if (arguments[1]) then
					if (arguments[1] == "true" or arguments[1] == "false") then
						if (arguments[1] == "true") then
							entity.world = true
						else
							entity.world = false
						end
					else
						nut.util.Notify(nut.lang.Get("missing_arg", 1), client)	
						return
					end
				else
					entity.world = !entity.world
				end

				if entity.world then
					nut.util.Notify(nut.lang.Get("sr_world_container"), client)		
				else
					nut.util.Notify(nut.lang.Get("sr_user_container"), client)		
				end	
			else
				nut.util.Notify(nut.lang.Get("sr_notstorage"), client)			
			end
		else
			nut.util.Notify(nut.lang.Get("sr_notstorage"), client)
		end
		
	end
}, "setworldcontainer")


nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_password"),
	onRun = function(client, arguments)

		local dat = {}
		dat.start = client:GetShootPos()
		dat.endpos = dat.start + client:GetAimVector() * 96
		dat.filter = client
		local trace = util.TraceLine(dat)
		local entity = trace.Entity
		
		if (entity and entity:IsValid()) then
			if (entity:GetClass() == "nut_container") then
				if (arguments[1]) then
					entity.classic = false
					entity.lock = arguments[1]
					entity:SetNetVar( "locked", true )

					nut.util.Notify(nut.lang.Get("sr_set_password", entity.lock), client)		
				else
					entity.classic = nil
					entity.lock = nil
					entity:SetNetVar( "locked", false )

					nut.util.Notify(nut.lang.Get("sr_lock_unlocked"), client)		
				end
			else
				nut.util.Notify(nut.lang.Get("sr_lock_itsworld"), client)			
			end
		else
			nut.util.Notify(nut.lang.Get("sr_notstorage"), client)
		end
		
	end
}, "setcontainerlock")


nut.command.Register({
	adminOnly = true,
	syntax = "",
	onRun = function(client, arguments)
		local dat = {}
		dat.start = client:GetShootPos()
		dat.endpos = dat.start + client:GetAimVector() * 96
		dat.filter = client
		local trace = util.TraceLine(dat)
		local entity = trace.Entity
		
		if (entity and entity:IsValid()) then
			if (entity:GetClass() == "nut_container") then
				if entity.world then
					nut.util.Notify(nut.lang.Get("sr_world_container"), client)		
				else
					nut.util.Notify(nut.lang.Get("sr_user_container"), client)		
				end			
			else
				nut.util.Notify(nut.lang.Get("sr_notstorage"), client)			
			end
		else
			nut.util.Notify(nut.lang.Get("sr_notstorage"), client)
		end
		
	end
}, "isworldcontainer")
