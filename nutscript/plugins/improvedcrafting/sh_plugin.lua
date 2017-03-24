local PLUGIN = PLUGIN
PLUGIN.name = "개선된 제작 (Improved Crafting)"
PLUGIN.author = "Tensa / Black Tea"
PLUGIN.desc = "아이템을 제작할 수 있는 기능을 추가합니다."

PLUGIN.base = true;
PLUGIN.menuEnabled = true;
PLUGIN.reqireBlueprint = true;

PLUGIN:IncludeDir("language");

// 저장될 작업대 엔티티 이름(클래스) //
PLUGIN.craftingTables = 
{
	"nut_craftingtable"
}

RECIPES = {}
RECIPES.recipes = {}
function RECIPES:Register(tbl)

	if (!tbl.CanCraft) then
		function tbl:CanCraft(client)
			for k, v in pairs( self.items ) do
				if (!client:HasItem( k, v )) then
					return false;
				end
			end
			
			return true;
		end
	end
	
	if !tbl.ProcessCraftItems then
		function tbl:ProcessCraftItems( client )
			local function cancarry()
				for k, v in pairs( self.result ) do
					local itemTable = nut.item.Get( k )
					if (!client:HasInvSpace(itemTable, v, false, true)) then
						return false;
					end
				end
				
				return true;
			end

			if (cancarry()) then
				for k, v in pairs( self.items ) do
					client:UpdateInv(k, -v);
				end
				
				for k, v in pairs( self.result ) do
					client:UpdateInv( k, v );
				end
			else
				nut.util.Notify( PLUGIN:GetPluginLanguage("no_invspace"), client )
			end

		end
	end
	self.recipes[ tbl.recipeID ] = tbl
end

PLUGIN:IncludeDir("recipes");
PLUGIN:IncludeDir("derma");


function RECIPES:Get(name)
	return self.recipes[name];
end

function RECIPES:GetAll()
	return self.recipes;
end

function RECIPES:GetItem(item)
	return self:Get(item).items;
end

function RECIPES:GetResult( item )
	return self:Get(item).result;
end

function RECIPES:HaveRecipe(client, item)
	local recipe = RECIPES:Get(item);
	if (recipe.blueprint != nil) then
		if (client:HasItem(recipe.blueprint)) then
			return true;
		else
			return false;
		end;
	else
		return true;
	end;
end

function RECIPES:CanCraft(client, item )
	if (self:Get(item):CanCraft(client)) then
		return true;
	else
		return false;
	end;
end

local entityMeta = FindMetaTable("Entity")
function entityMeta:IsCraftingTable()
	return self:GetClass() == "nut_craftingtable"	
end

if CLIENT then return end
util.AddNetworkString("nut_CraftItem")
net.Receive("nut_CraftItem", function (length, client)
	local item = net.ReadString();
	local tblRecipe = RECIPES:Get(item);
	
	if (RECIPES:CanCraft(client, item)) then
		tblRecipe:ProcessCraftItems(client)
	end
end)

function PLUGIN:LoadData()
	for k, v in pairs(nut.util.ReadTable("craftingtables")) do
		local entity = ents.Create(v.entity);
		entity:SetPos(v.pos);
		entity:SetAngles(v.angles);
		entity:Spawn();
		entity:Activate();
		local phys = entity:GetPhysicsObject();
		if phys and phys:IsValid() then
			phys:EnableMotion(false);
		end
	end
end

function PLUGIN:SaveData()
	local entitys = ents.GetAll();
	local data = {};
	for k, v in pairs(entitys) do
		for index, class in pairs(PLUGIN.craftingTables) do
			if (v:GetClass() == class) then
				data[#data + 1] = {
					entity = v:GetClass(),
					pos = v:GetPos(),
					angles = v:GetAngles()
				};
			end;
		end;
	end;
	
	nut.util.WriteTable("craftingtables", data)
end
