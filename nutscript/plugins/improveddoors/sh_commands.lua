local PLUGIN = PLUGIN

nut.command.Register({
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity) and !entity:GetNetVar("hidden")) then
			if (entity:GetNetVar("unownable")) then
				return
			end

			local cost = nut.config.doorCost

			if (!client:CanAfford(cost)) then
				nut.util.Notify(nut.lang.Get("no_afford"), client)

				return
			end

			if (!PLUGIN:IsDoorOwned(entity)) then
				PLUGIN:SetDoorOwner(entity, client);
				entity:SetNetVar("title", nut.lang.Get("doors_buyed_door"));
				entity:SetNetVar("desc", nut.lang.Get("doors_owner", client:Name()));

				nut.util.Notify(nut.lang.Get("doors_buy_door", nut.currency.GetName(cost)), client)
				client:TakeMoney(cost)
			else
				nut.util.Notify(nut.lang.Get("doors_selled_door"), client)
			end
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorbuy")

nut.command.Register({
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity) and !entity:GetNetVar("hidden")) then
			if (PLUGIN:EqualDoorOwner(entity, client)) then
				PLUGIN:SetDoorOwner(entity, nil);
				entity:SetNetVar("title", nut.lang.Get("doors_can_buy"))

				local amount = nut.config.doorSellAmount

				nut.util.Notify(nut.lang.Get("doors_sell_door", nut.currency.GetName(amount)), client)
				client:GiveMoney(amount)
			else
				nut.util.Notify(nut.lang.Get("doors_not_owner"), client)
			end
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorsell")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity) and !entity:GetNetVar("hidden")) then
			if (!PLUGIN:IsDoorOwned(entity)) then
				nut.util.Notify("이미 구매 가능한 문입니다.", client);
			else
				entity:SetNetVar("owner", nil)
				entity:SetNetVar("title", nut.lang.Get("doors_can_buy"));
				entity:SetNetVar("desc", nut.lang.Get("doors_buy_desc"));
			
				nut.util.Notify("성공적으로 문을 판매하였습니다.", client)
			end;
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorforcesell");

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity
		local title = nut.lang.Get("doors_buyed_door")

		if (#arguments > 0) then
			title = table.concat(arguments, " ")
		end
		
		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			entity:SetNetVar("title", title);
			nut.util.Notify(nut.lang.Get("doors_change_title"), client);
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client);
		end
	end
}, "doorsettitle");

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local entity = AdvNut.util.GetPlayerTraceEntity(client);
		local desc = nut.lang.Get("doors_buyed_door")

		if (#arguments > 0) then
			desc = table.concat(arguments, " ")
		end
		
		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			entity:SetNetVar("desc", desc);
			nut.util.Notify(nut.lang.Get("doors_change_title"), client);
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client);
		end
	end
}, "doorsetdesc");

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			if (PLUGIN:IsDoorOwned(entity)) then
				nut.util.Notify("다른 플레이어가 소유중인 문 입니다.", client);
			else
				local title = nut.lang.Get("doors_cant_buy")

				PLUGIN:DoorSetUnownable(entity)
				
				entity:SetNetVar("title", nut.lang.Get("doors_cant_buy"));
				entity:SetNetVar("desc", nut.lang.Get("doors_cant_buy"));
				nut.util.Notify(nut.lang.Get("doors_change_unownable"), client);
			end;
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorsetunownable")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			local hidden = util.tobool(arguments[1])

			PLUGIN:DoorSetHidden(entity, hidden)
			nut.util.Notify(nut.lang.Get("doors_change_hidden", (hidden and nut.lang.Get("doors_hidden") or nut.lang.Get("doors_show")), client))
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorsethidden")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			if (PLUGIN:IsDoorOwned(entity)) then
				nut.util.Notify("다른 플레이어가 소유중인 문 입니다.", client);
			else
				PLUGIN:DoorSetOwnable(entity);
				
				entity:SetNetVar("title", nut.lang.Get("doors_can_buy"));
				entity:SetNetVar("desc", nut.lang.Get("doors_buy_desc"));
				nut.util.Notify(nut.lang.Get("doors_change_ownable"), client);
			end;
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorsetownable")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			PLUGIN:LockDoor(entity)
			nut.util.Notify(nut.lang.Get("doors_open_door"), client)
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorlock")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 84
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			PLUGIN:UnlockDoor(entity)
			nut.util.Notify(nut.lang.Get("doors_close_door"), client)
		else
			nut.util.Notify(nut.lang.Get("doors_not_door"), client)
		end
	end
}, "doorunlock")
