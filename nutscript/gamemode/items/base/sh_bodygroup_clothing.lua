BASE.name = "Base Bodygroup Clothing";
BASE.uniqueID = "base_bodygroup_clothing";
BASE.category = nut.lang.Get("clothing");
BASE.models = {};
BASE.bodygroup = {0, 0};

BASE.data = {
	Equipped = false
}

BASE.functions = {};
BASE.functions.Wear = {
	text = nut.lang.Get("wear"),
	run = function(itemTable, client, data)
		if (SERVER) then
			local WearBodygroupIndexs = {};
			if (!table.HasValue(itemTable.models, client:GetModel()) or client:GetBodygroupCount(itemTable.bodygroup[1]) == nil) then
				nut.util.Notify(nut.lang.Get("wrong_bodygroup_model"), client)
				return false;
			end;
		
			for class, item in pairs(client:GetInventory()) do
				local itemTable = nut.item.Get(class);
				local itemData;
			
				if (itemTable and itemTable.bodygroup) then
					for index, data in SortedPairs(item) do 
						itemData = data.data;
					end;

					if (itemData.Equipped == true) then
						table.insert(WearBodygroupIndexs, itemTable.bodygroup[1]);
					end;
				end;
			end;
			
			if (table.HasValue(WearBodygroupIndexs, itemTable.bodygroup[1])) then
				nut.util.Notify(nut.lang.Get("already_equip_bodygroup"), client);
				return false;
			else
				newData = table.Copy(data);
				newData.Equipped = true;
				newData.OrignalIndex = client:GetBodygroup(itemTable.bodygroup[1]) or 0;
				
				client:SetBodygroup(itemTable.bodygroup[1], itemTable.bodygroup[2]);
				client:UpdateInv(itemTable.uniqueID, 1, newData, true);
			end;
		end;
	end;
	
	shouldDisplay = function(itemTable, data, entity)
		return data.Equipped == false;
	end
}

BASE.functions.Unwear = {
	text = nut.lang.Get("unwear"),
	run = function(itemTable, client, data)
		if (SERVER) then
			client:SetBodygroup(itemTable.bodygroup[1], data.OrignalIndex);
			newData = table.Copy(data);
			newData.Equipped = false
			newData.OrignalIndex = nil;
			
			client:UpdateInv(itemTable.uniqueID, 1, newData, true);
		end;
	end;
	
	shouldDisplay = function(itemTable, data, entity)
		return data.Equipped == true;
	end
}

function BASE:CanTransfer(client, data)
	if (data.Equipped) then
		nut.util.Notify(nut.lang.Get("cant_equip_weapon"), client)
	end

	return !data.Equipped
end
