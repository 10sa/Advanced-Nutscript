nut.command.Register({
	onRun = function(client, arguments)
		if (client:GetNutVar("nextRaise", 0) < CurTime()) then
			local weapon = client:GetActiveWeapon()

			if (!IsValid(weapon)) then
				return
			end

			if (weapon.AlwaysRaised or nut.config.alwaysRaised[weapon:GetClass()]) then
				return
			end

			client:SetWepRaised(!client:WepRaised())
			client:SetNutVar("nextRaise", CurTime() + 0.6)
		end
	end
}, "toggleraise")

nut.command.Register({
	onRun = function(client, arguments)
		math.randomseed(CurTime())

		local roll = math.random(1, 100)
		roll = AdvNut.hook.Run("GetRollAmount", client, roll) or roll

		nut.chat.Send(client, "roll", nut.lang.Get("rollcube", client:Name(), roll))
	end
}, "roll")

nut.command.Register({
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_string"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (target) then
			table.remove(arguments, 1)
			local text = table.concat(arguments, " ")

			if (!text or #text < 1) then
				nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

				return
			end

			local voiceMail = target.character:GetData("voicemail")

			if (voiceMail) then
				nut.chat.Send(client, "pm", target:Name()..": "..voiceMail)

				return
			end
			
			local message = client:Name()..": "..text

			nut.chat.Send(client, "pm", message)
			nut.chat.Send(target, "pm", message)
		end
	end
}, "pm")

nut.command.Register({
	allowDead = true,
	syntax = nut.lang.Get("syntax_string"),
	onRun = function(client, arguments)
		local message = table.concat(arguments, " ")
		local delete = false

		if (!string.find(message, "%S")) then
			client.character:SetData("voicemail", nil)
			nut.util.Notify(nut.lang.Get("delete_voicemail_done"), client)
		else
			client.character:SetData("voicemail", message)
			nut.util.Notify(nut.lang.Get("change_voicemail_done"), client)
		end
	end
}, "setvoicemail")

nut.command.Register({
	syntax = nut.lang.Get("syntax_amount"),
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		if (IsValid(entity) and entity:IsPlayer() and entity.character) then
			local amount = tonumber(arguments[1])

			if (!amount) then
				nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

				return
			end

			if (amount < 5) then
				nut.util.Notify(nut.lang.Get("min_give_money", nut.currency.GetName(5)), client)

				return
			end

			if (client:GetMoney() - amount < 0) then
				nut.util.Notify(nut.lang.Get("no_money"), client)

				return
			end

			entity:GiveMoney(amount)
			client:TakeMoney(amount)
		else
			nut.util.Notify(nut.lang.Get("no_play"), client)
		end
	end
}, "givemoney")

nut.command.Register({
	syntax = nut.lang.Get("syntax_amount"),
	onRun = function(client, arguments)
		local amount = tonumber(arguments[1])

		if (!amount) then
			nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

			return
		end

		if (amount < 5) then
			nut.util.Notify(nut.lang.Get("min_drop_money", nut.currency.GetName(5)), client)

			return
		end

		if (client:GetMoney() - amount < 0) then
			nut.util.Notify(nut.lang.Get("no_money"), client)

			return
		end

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*54
			data.filter = client
		local trace = util.TraceLine(data)
		local position = trace.HitPos

		if (position) then
			local entity = nut.currency.Spawn(amount, position + Vector(0, 0, 16), nil, client)

			if (IsValid(entity)) then
				client:TakeMoney(amount)
			end
		end
	end
}, "dropmoney")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_flags"),
	onRun = function(client, arguments, starArgs)
		local flags = table.concat(arguments, " ", 2)
		local bufferFlags = nut.command.GetBufferFlags()
		
		local function handleStarArgsAndGive(player)
			if (starArgs[2]) then
				player:GiveFlag(bufferFlags)

				nut.util.Notify(nut.lang.Get("flags_give", client:Name(), bufferFlags, player:Name()))
			else
				player:GiveFlag(flags)

				nut.util.Notify(nut.lang.Get("flags_give", client:Name(), flags, player:Name()))
			end
		end

		if (starArgs[1]) then
			for k, v in pairs(player.GetAll()) do
				handleStarArgsAndGive(v)
			end
		else
			local target = nut.command.FindPlayer(client, arguments[1])
			if (IsValid(target)) then
				if (!arguments[2]) then
					nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

					return
				end

				handleStarArgsAndGive(target)
			end
		end
	end
}, "flaggive")

nut.command.Register({
	allowDead = true,
	adminOnly = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_flags"),
	onRun = function(client, arguments, starArgs)
		local flags = table.concat(arguments, " ", 2)
		local bufferFlags = nut.command.GetBufferFlags()

		local function handleStarArgsAndTake(player)
			if (starArgs[2]) then
				player:TakeFlag(bufferFlags)

				nut.util.Notify(nut.lang.Get("flags_take", client:Name(), bufferFlags, player:Name()))
			else
				player:TakeFlag(flags)
				
				nut.util.Notify(nut.lang.Get("flags_take", client:Name(), flags, player:Name()))
			end
		end

		local function takeFlag()
			if (starArgs[1]) then
				for k, v in pairs(player.GetAll()) do
					handleStarArgsAndTake(v)
				end
			else
				local target = nut.command.FindPlayer(client, arguments[1])
				if (IsValid(target)) then
					if (!flags) then
						nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

						return
					end

					handleStarArgsAndTake(target)
				end
			end
		end

		if (!string.find(flags, "%S")) then
			client:StringRequest("Take Flags", "Enter the flag(s) to take from the player.", function(text)
				flags = text
				takeFlag()
			end, nil, target:GetFlagString())
		else
			takeFlag()
		end
	end
}, "flagtake")

nut.command.Register({
	superAdminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_faction"),
		onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (IsValid(target)) then
			if (!arguments[2]) then
				nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

				return
			end

			local faction

			for k, v in pairs(nut.faction.GetAll()) do
				if (arguments[2] == v.factionID or nut.util.StringMatches(arguments[2], v.name)) then
					faction = v

					break
				end
			end

			if (faction) then
				if (nut.faction.CanBe(target, faction.index)) then
					nut.util.Notify(nut.lang.Get("already_whitelisted"), target)

					return
				end

				target:GiveWhitelist(faction.index)

				nut.util.Notify(nut.lang.Get("whitelisted", client:Name(), target:Name(), faction.name))
			else
				nut.util.Notify(nut.lang.Get("invalid_faction"), client)
			end
		end
	end
}, "plywhitelist")

nut.command.Register({
	superAdminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_faction"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (IsValid(target)) then
			if (!arguments[2]) then
				nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

				return
			end

			local faction

			for k, v in pairs(nut.faction.GetAll()) do
				if (arguments[2] == v.factionID) then
					faction = v

					break
				end
			end

			if (faction) then
				if (!nut.faction.CanBe(target, faction.index)) then
					nut.util.Notify(nut.lang.Get("not_whitelisted"), target)

					return
				end

				target:TakeWhitelist(faction.index)

				nut.util.Notify(nut.lang.Get("blacklisted", client:Name(), target:Name(), faction.name))
			else
				nut.util.Notify(nut.lang.Get("invalid_faction"), client)
			end
		end
	end
}, "plyunwhitelist")

local function sameSchema() 
	return " AND rpschema = '"..SCHEMA.uniqueID.."'"
end

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (target) then

			local index = target.character.index or nil	
			local charname = target.character:GetVar("charname")

			if (index and target.characters and table.HasValue(target.characters, index)) then
				for k, v in pairs(target.characters) do
					if (v == index) then
						target.characters[k] = nil
					end
				end

				nut.db.Query("DELETE FROM "..nut.config.dbTable.." WHERE steamid = "..(target:SteamID64() or 0).." AND id = "..nut.db.Escape(index)..sameSchema(), function(data)
					if (IsValid(target) and target.character and target.character.index == index) then
						if (target.nut_CachedChars) then
							target.nut_CachedChars[target.character.index] = nil
						end
						
						target.character = nil
						target:KillSilent()

						timer.Simple(0, function()
							netstream.Start(target, "nut_CharMenu", {true, true, index})
						end)
					end

					nut.util.AddLog( client:Name().." Deleted character #"..index..", "..charname.."("..target:Name()..").", LOG_FILTER_MAJOR)
				end)
			else
				ErrorNoHalt("Attempt to delete invalid character! ("..index..")")
			end

			nut.util.Notify(nut.lang.Get("char_deleted", client:Name(), charname))
		end
	end
}, "chardelete")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_amount"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (target) then
			local amount = tonumber(arguments[2])

			if (!amount) then
				nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

				return
			end

			target:GiveMoney(amount)
			nut.util.Notify(nut.lang.Get("give_money", client:Name(), nut.currency.GetName(amount), target:Name()))
		end
	end
}, "chargivemoney")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_amount"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (target) then
			local amount = tonumber(arguments[2])

			if (!amount) then
				nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

				return
			end

			target:GiveMoney(-amount)
			nut.util.Notify(nut.lang.Get("take_money", client:Name(), nut.currency.GetName(amount), target:Name()))
		end
	end
}, "chartakemoney")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_amount"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (target) then
			local amount = tonumber(arguments[2])

			if (!amount) then
				nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

				return
			end

			target:SetMoney(amount)
			nut.util.Notify(nut.lang.Get("set_money", client:Name(), target:Name(), nut.currency.GetName(amount)))
		end
	end
}, "charsetmoney")

nut.command.Register({
	allowDead = true,
	onRun = function(client, arguments)
		local text = table.concat(arguments, " ")
		local function changeDesc()
			if (!text) then
				nut.util.Notify(nut.lang.Get("wrong_arg"), client)
				
				return
			end

			if (#text < nut.config.descMinChars) then
				nut.util.Notify(nut.lang.Get("char_min_desc", nut.config.descMinChars), client)

				return
			end

			local description = client.character:GetVar("description", "")
			
			if (string.lower(description) == string.lower(text)) then
				nut.util.Notify(nut.lang.Get("char_set_baddesc"), client)
				
				return
			end
			
			client.character:SetVar("description", text)
			nut.util.Notify(nut.lang.Get("char_set_desc"), client)
		end

		if (!string.find(text, "%S")) then
			client:StringRequest(nut.lang.Get("char_desc_change"), nut.lang.Get("char_desc_change_desc"), function(text2)
				text = text2
				changeDesc()
			end, nil, client.character:GetVar("description", ""))
		else
			changeDesc()
		end
	end
}, "chardesc")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_model")..nut.lang.Get("syntax_skin"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (IsValid(target)) then
			if (!arguments[2]) then
				nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

				return
			end

			local model = string.lower(arguments[2])

			target:SetModel(model)
			target:SetSkin(tonumber(arguments[3]) or 0)
			target.character.model = model
			target:UpdateCharInfo()

			AdvNut.hook.Run("PlayerSetHandsModel", target, target:GetHands())
			
			nut.util.Notify(nut.lang.Get("char_set_model", client:Name(), target:Name(), arguments[2]))
		end
	end
}, "charsetmodel")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_customclass"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (IsValid(target)) then
			table.remove(arguments, 1)
			local customClass = table.concat(arguments, " ")

			if (customClass == "") then
				customClass = nil
			end

			target:SetNetVar("customClass", customClass)
			nut.util.Notify(nut.lang.Get("char_set_customclass", client:Name(), target:Name(), (customClass or nut.lang.Get("unknown"))))
		end
	end	
}, "charsetcustomclass")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_name"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (IsValid(target)) then
			table.remove(arguments, 1)

			local name = table.concat(arguments, " ")
			local function changeName(text)
				if (!IsValid(target) or !IsValid(client)) then
					return
				end

				if (name and string.find(name, "%S")) then
					local oldName = target:Name()
					target.character:SetVar("charname", name)

					nut.util.Notify(nut.lang.Get("char_set_name", client:Name(), oldName, name))
				else
					nut.util.Notify(nut.lang.Get("char_bad_name"), client)
				end
			end

			if (!string.find(name, "%S")) then
				client:StringRequest(nut.lang.Get("char_change_name"), nut.lang.Get("char_change_name_desc"), function(text)
					name = text
					changeName()
				end, nil, target:Name())
			else
				changeName()
			end
		end
	end
}, "charsetname")

nut.command.Register({
	syntax = nut.lang.Get("syntax_time"),
	onRun = function(client, arguments)
		local time

		if (arguments[1] and arguments[1] == "0") then
			time = 0
		else
			time = math.max(tonumber(arguments[1] or "") or 5, 5)
		end
		
		if (AdvNut.hook.Run("CanFallOver", client) == false) then return end
		
		if (!client:IsRagdolled()) then
			client:SetTimedRagdoll(time)
			client:SetNutVar("fallGrace", CurTime() + 5)
		else
			nut.util.Notify(nut.lang.Get("fallover"), client)
		end
	end
}, "charfallover")

nut.command.Register({
	onRun = function(client, arguments)
		if (client:GetNutVar("noGetUp")) then
			return
		end

		if (client:GetNutVar("fallGrace", 0) >= CurTime()) then
			nut.util.Notify(nut.lang.Get("getupstatus"), client)

			return
		end

		local ragdolled, entity = client:IsRagdolled()

		if (IsValid(entity) and ragdolled and !client:GetNetVar("gettingUp")) then
			local velocity = entity:GetVelocity():Length2D()

			if (velocity <= 8) then
				client:SetMainBar(nut.lang.Get("gettingup"), 5)
				client:SetNetVar("gettingUp", true)

				timer.Create("nut_CharGetUp"..client:UniqueID(), 5, 1, function()
					if (IsValid(client)) then
						client:UnRagdoll()
						client:SetNetVar("gettingUp", false)
					end
				end)
			else
				nut.util.Notify(nut.lang.Get("movebody"), client)
			end
		else
			nut.util.Notify(nut.lang.Get("donotfallover"), client)
		end
	end
}, "chargetup")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_itemID")..nut.lang.Get("syntax_amount"),
	onRun = function(client, arguments)
		local name = arguments[1] or ""
		local find = arguments[2] or ""
		local amount = math.max(tonumber(arguments[3] or "") or 1, 1)
		local target = nut.command.FindPlayer(client, name)

		if (IsValid(target)) then
			for k, v in SortedPairs(nut.item.GetAll()) do
				if (find == v.uniqueID) then
					target:UpdateInv(v.uniqueID, amount, nil, true)

					nut.util.Notify(nut.lang.Get("c_giveitem", target:Name(), amount, v.name), client)
					nut.util.Notify(nut.lang.Get("t_giveitem", target:Name(), amount, v.name), target)

					return
				end
			end

			for k, v in SortedPairs(nut.item.GetAll()) do
				if (nut.util.StringMatches(find, v.name)) then
					target:UpdateInv(v.uniqueID, amount, nil, true)

					nut.util.Notify(nut.lang.Get("c_giveitem", target:Name(), amount, v.name), client)
					nut.util.Notify(nut.lang.Get("t_giveitem", target:Name(), amount, v.name), target)

					return
				end
			end

			nut.util.Notify(nut.lang.Get("bad_item_id"), client)
		end
	end
}, "chargiveitem")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_name")..nut.lang.Get("syntax_bodygroup")..nut.lang.Get("syntax_skin"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, arguments[1])

		if (!IsValid(target)) then
			return
		end

		local group = arguments[2]
		local active = tonumber(arguments[3]) or 0

		if (!group) then
			nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

			return
		end

		for k, v in pairs(target:GetBodyGroups()) do
			local groups = target.character:GetData("groups", {})

			if (v.id > 0 and (tostring(v.id) == group or nut.util.StringMatches(group, v.name))) then
				if (active) then
					target:SetBodygroup(v.id, active)
					groups[v.id] = active
					target.character:SetData("groups", groups, nil, true)

					return nut.util.Notify(nut.lang.Get("char_set_bodygroup", client:Name(), target:Name(), v.name, active))
				end
			end
		end

		nut.util.Notify(nut.lang.Get("char_bad_bodygroup"), client)
	end
}, "charsetbodygroup")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_name"),
	onRun = function(client, arguments)
		local target = nut.command.FindPlayer(client, table.concat(arguments, " "))

		if (target) then
			target:KillSilent()
			target.character:SetData("banned", true)
			target:UpdateCharInfo()

			nut.char.Save(target)

			timer.Simple(0, function()
				if (IsValid(target)) then
					netstream.Start(target, "nut_CharMenu", true)
				end
			end)

			nut.util.Notify(nut.lang.Get("char_ban", client:Name(), target:Name()))
		end
	end
}, "charban")

// This commands created for Debug. //
nut.command.Register({
	syntax = nut.lang.Get("syntax_none"),
	superAdminOnly = true,
	onRun = function(client, arguments)
		AdvNut.hook.Run("SaveData");
		nut.util.Notify("DEBUG - End Saved Data", client);
	end
}, "startsavedata")

nut.command.Register({
	syntax = nut.lang.Get("syntax_none"),
	superAdminOnly = true,
	onRun = function(client, arguments)
		AdvNut.hook.Run("LoadData");
		nut.util.Notify("DEBUG - End Loaded Data", client);
	end
}, "startloaddata")

nut.command.Register({
	syntax = nut.lang.Get("syntax_none"),
	superAdminOnly = true,
	onRun = function(client, arguments)
		PrintTable(client:GetInventory());
	end
}, "printplayerinv")

nut.command.Register({
	syntax = nut.lang.Get("syntax_none"),
	superAdminOnly = true,
	onRun = function(client, arguments)
		PrintTable(nut.char.buffer);
	end
}, "printcachedcharlist")
// END //

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_name"),
	onRun = function(client, arguments)
		local name = arguments[1]

		if (!name) then
			return nut.util.Notify(nut.lang.Get("missing_arg", 1), client)
		else
			name = nut.db.Escape("%"..name.."%")
		end

		local ourName = client:Name()

		nut.db.Query("SELECT steamid, id, charname, chardata FROM "..nut.config.dbTable.." WHERE charname LIKE "..name, function(data)
			if (data and data.chardata and data.charname) then
				local decoded = pon.decode(data.chardata)

				if (decoded.banned) then
					decoded.banned = nil

					local found

					for k, v in pairs(player.GetAll()) do
						if (v:SteamID64() == tostring(data.steamid)) then
							found = v
							break
						end
					end

					local function Callback()
						nut.util.Notify(nut.lang.Get("a_char_unban", ourName, data.charname))
					end

					local charID = tonumber(data.id)

					if (IsValid(found) and charID) then
						client.nut_CachedChars[charID] = nil
						netstream.Start(client, "nut_CharInfoVar", {charID, "banned", false})
					end

					nut.db.Query("UPDATE "..nut.config.dbTable.." SET chardata = "..nut.db.Escape(pon.encode(decoded)).." WHERE chardata = "..nut.db.Escape(data.chardata), Callback)
				else
					nut.util.Notify(nut.lang.Get("c_char_unban", data.chardata), client)
				end
			elseif (IsValid(client)) then
				return nut.util.Notify(nut.lang.Get("no_ply"), client)
			end
		end)
	end
}, "charunban")