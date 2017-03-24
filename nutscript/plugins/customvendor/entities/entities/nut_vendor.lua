AddCSLuaFile()

local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "상인"
ENT.Author = "Chessnut"
ENT.Spawnable = false
ENT.Category = "Nutscript"
ENT.PersistentSave = false;

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/mossman.mdl")
		self:DrawShadow(true);
		self:SetSolid(SOLID_BBOX);
		self:PhysicsInit(SOLID_BBOX);
		self:SetMoveType(MOVETYPE_NONE);
		self:SetUseType(SIMPLE_USE);
		
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
		end
	end

	self:SetAnim()
end

function ENT:DrawTargetID(x, y, alpha)
	local mainColor = nut.config.mainColor
	local color = Color(mainColor.r, mainColor.g, mainColor.b, alpha)

	nut.util.DrawText(x, y, self:GetNetVar("name", PLUGIN:GetPluginLanguage("no_desc")), color, "AdvNut_EntityTitle");
	y = y + nut.config.targetTall
	nut.util.DrawText(x, y, self:GetNetVar("desc", PLUGIN:GetPluginLanguage("no_desc")), Color(255, 255, 255, alpha), "AdvNut_EntityDesc");
end

function ENT:SetAnim()
	for k, v in pairs(self:GetSequenceList()) do
		if (string.find(string.lower(v), "idle")) then
			if (v != "idlenoise") then
				self:ResetSequence(k)

				return
			end
		end
	end

	self:ResetSequence(4)
end

if (CLIENT) then
	netstream.Hook("nut_Vendor", function(data)
		if (IsValid(nut.gui.vendor)) then
			nut.gui.vendor:Remove()

			return
		end

		nut.gui.vendor = vgui.Create("nut_Vendor")
		nut.gui.vendor:SetEntity(data)
	end)
else
	function ENT:Use(activator)
		netstream.Start(activator, "nut_Vendor", self)
	end

	netstream.Hook("nut_VendorData", function(client, data)
		if (!client:IsAdmin()) then
			return
		end

		local entity = data[1]
		local itemData = data[2]
		local vendorAction = data[3]
		local cashadjustment = data[4]
		local money = data[5]
		local factionData = data[6]
		local classData = data[7]
		local name = data[8]
		local desc = data[9]
		local model = data[10]
		
		if (IsValid(entity)) then
			entity:SetNetVar("data", itemData)
			entity:SetNetVar("vendoraction", vendorAction)
			entity:SetNetVar("buyadjustment", cashadjustment)
			entity:SetNetVar("money", money)
			entity:SetNetVar("factiondata", factionData)
			entity:SetNetVar("classdata", classData)
			entity:SetNetVar("name", name)
			entity:SetNetVar("desc", desc)
			entity:SetModel(model or entity:GetModel())
			entity:SetAnim()

			PLUGIN:SaveData()
			nut.util.Notify("성공적으로 상인의 데이터를 재설정하였습니다.", client)
		end
		
		netstream.Start(client, "nut_VendorDataCallback");
	end)
-------------------------------------
	netstream.Hook("nut_VendorBuy", function(client, data)
		local entity = data[1]
		local class = data[2]
		local itemTable = nut.item.Get(class)
		local classData = entity:GetNetVar("classdata", {})
		local price = itemTable.price or 0

		local isValidEntity = (!IsValid(entity) or entity:GetPos():Distance(client:GetPos()) > 128 or !itemTable);
		local isValidFaction = (!entity:GetNetVar("factiondata", {})[client:Team()]);
		local isValidClassData = (table.Count(classData) > 0 and !classData[client:CharClass()] and (!data[class] or !data[class].selling));
		if (isValidEntity and isValidFaction and isValidClassData) then
			return;
		end;

		local data = entity:GetNetVar("data", {})
		if (data[class] and data[class].price) then
			price = data[class].price
		end

		if (client:CanAfford(price)) then
			if(!client:HasInvSpace(itemTable)) then
				return;
			else
				client:UpdateInv(class);
				client:TakeMoney(price);
				entity:SetNetVar("money", entity:GetNetVar( "money", 0 ) + price);
				netstream.Start(client, "nut_CashUpdate");
				nut.util.Notify(nut.lang.Get("purchased_for", itemTable.name, nut.currency.GetName(price)), client);
			end;
		else
			nut.util.Notify(nut.lang.Get("no_afford"), client);
		end
	end)
	---------------------------
	netstream.Hook("nut_VendorSell", function(client, data)
		local entity = data[1]
		local class = data[2]
		local itemTable = nut.item.Get(class)

		local factionData = entity:GetNetVar("factiondata", {})
		local classData = entity:GetNetVar("classdata", {})
		local data = entity:GetNetVar("data", {})
		
		local isValidEntity = (!IsValid(entity) or entity:GetPos():Distance(client:GetPos()) > 128 or !itemTable);
		local isValidFaction = (!entity:GetNetVar("factiondata", {})[client:Team()]);
		local isValidClassData = (table.Count(classData) > 0 and !classData[client:CharClass()] and (!data[class] or !data[class].buying));
		if (isValidEntity and isValidFaction and isValidClassData) then
			return;
		end

		local adj = entity:GetNetVar("buyadjustment", .5)
		local price = math.Round( itemTable.price * adj ) or 0
		
		if (data[class] and data[class].price) then
			price = math.Round( data[class].price * adj );
		end
		
		if (tonumber( entity:GetNetVar( "money", 0 ) ) < price) then
			nut.util.Notify(PLUGIN:GetPluginLanguage("vendor_no_afford"), client)
			return
		end
		local inv = client:GetInventory();
		if (inv[class]) then
			for key, dataTable in SortedPairs(inv[class]) do
				local data = dataTable.data;
				if (!data.Equipped or data.Equipped == nil) then
					client:UpdateInv(class, -1, data);
					client:GiveMoney(price);
					entity:SetNetVar("money", entity:GetNetVar( "money", 0 ) - price);
					netstream.Start(client, "nut_CashUpdate");
					nut.util.Notify(nut.lang.Get("sold", itemTable.name, nut.currency.GetName(price)), client);
				
					return;
				end;
			end;
			
			nut.util.Notify(nut.lang.Get("notenoughitem", itemTable.name), client);
		else
			nut.util.Notify(nut.lang.Get("notenoughitem", itemTable.name), client);
		end;
	end)
end