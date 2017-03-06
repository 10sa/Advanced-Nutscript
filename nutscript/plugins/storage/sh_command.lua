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
