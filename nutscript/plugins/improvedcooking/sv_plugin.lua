local PLUGIN = PLUGIN or { };

HUNGER_MAX = 100;
THIRST_MAX = 100;
local HUNGER_RATE = CurTime();
local THIRST_RATE = CurTime();
local hunger_curtime = 0;
local thirst_curtime = 0;

function PLUGIN:PlayerSpawn(client)
	client.character:SetVar("hunger", client.character:GetData("hunger") or HUNGER_MAX);
	client.character:SetVar("thirst", client.character:GetData("thirst") or THIRST_MAX);
end
	
function PLUGIN:CharacterSave(client)
	client.character:SetData("hunger", client.character:GetVar("hunger", HUNGER_MAX));
	client.character:SetData("thirst", client.character:GetVar("thirst", HUNGER_MAX));
end;
	
local playerMeta = FindMetaTable("Player")
function playerMeta:SolveHunger( intAmount, intHealth )
	local hunger = self.character:GetVar("hunger", 0)
	local hp = self:Health()
	local multp = .01
	self.character:SetVar("hunger", math.Clamp( hunger + intAmount, 0, HUNGER_MAX ))
	if !intHealth or !intHealth == 0 then
		self:SetHealth( math.Clamp( hp + intAmount * multp, 0, self:GetMaxHealth() ) )
	end
end

function playerMeta:SolveThirst( intAmount, intHealth )
	local hunger = self.character:GetVar("thirst", 0)
	local stamina = self.character:GetVar("stamina", 0)
	local multp = .5
	self.character:SetVar("thirst", math.Clamp( hunger + intAmount, 0, THIRST_MAX ))
	self.character:SetVar("stamina", math.Clamp( stamina + intAmount * multp, 0, 100 ))
end

local math_Clamp = math.Clamp

function PLUGIN:Think()
	
	local curTime = CurTime()

	if HUNGER_RATE < curTime then
		for _, player in pairs( player.GetAll() ) do
			local character = player.characterlocal hunger_curtime = 0;
local thirst_curtime = 0;

			if character then
				local hunger = character:GetVar("hunger", 0)
				if(math.random(1, 50) <= 1) then
					continue
				end
					
				character:SetVar("hunger", math_Clamp( hunger - math.random(1, 3), 0, HUNGER_MAX ))
					
				-------------------------------------------------------------------------------
				-------------------------------------------------------------------------------
				if(player:Health() > 0) then
					nut.schema.Call("PlayerHunger", player) -- MAKE THIS HOOK IF YOU WANT TO ADD SOME EFFECTS.
				end
				-- THIS FUNCTION WILL CALL ALL " PLUGIN:PlayerHunger( player ) " IN ANY PLUGIN FOLDER.
				-------------------------------------------------------------------------------
				-------------------------------------------------------------------------------
					
			end
		end
		
		HUNGER_RATE = curTime + self.hungerSpeed
	end

	if THIRST_RATE < curTime then
		for _, player in pairs( player.GetAll() ) do
			local character = player.character

			if character then
				local thirst = character:GetVar("thirst", 0)
				if(math.random(1, 50) <= 1) then
					continue
				end
					
				character:SetVar("thirst", math.Clamp( thirst - math.random(1, 3), 0, THIRST_MAX ))
				
				-------------------------------------------------------------------------------
				-------------------------------------------------------------------------------
				if(player:Health() > 0) then
					nut.schema.Call("PlayerThirst", player) -- MAKE THIS HOOK IF YOU WANT TO ADD SOME EFFECTS.
				end
				-- THIS FUNCTION WILL CALL ALL " PLUGIN:PlayerHunger( player ) " IN ANY PLUGIN FOLDER.
				-------------------------------------------------------------------------------
				-------------------------------------------------------------------------------
					
			end
		end
		THIRST_RATE = curTime + self.thirstSpeed
	end	
end

function PLUGIN:PlayerHunger( player )
	local character = player.character
	local hunger = character:GetVar("hunger", 0)
	hunger_curtime = hunger_curtime + 1
		
	if hunger <= 0 then
		character:SetVar("thirst", THIRST_MAX);
		character:SetVar("hunger", HUNGER_MAX);
			
		character:SetData("thirst", THIRST_MAX);
		character:SetData("hunger", HUNGER_MAX);
		
		player:ConCommand(PLUGIN:GetPluginLanguage("die_hungry", "say /me"));
		player:Kill();
	end
end
	
function PLUGIN:PlayerThirst( player ) 
	local character = player.character
	local thirst = character:GetVar("thirst", 0)
	thirst_curtime = thirst_curtime + 1
		
	if thirst <= 0 then 
		character:SetVar("thirst", THIRST_MAX);
		character:SetVar("hunger", HUNGER_MAX);
			
		character:SetData("thirst", THIRST_MAX);
		character:SetData("hunger", HUNGER_MAX);
			
		player:ConCommand(PLUGIN:GetPluginLanguage("die_thirst", "say /me"));
		player:Kill();
	end
end

PLUGIN.tableStove = {
	"nut_stove",
	"nut_barrel",
	"nut_bucket",
}
	
function PLUGIN:LoadData()
	local restored = nut.util.ReadTable("stoves")
	if (restored) then
		for class, data in pairs(restored) do
			for k, v in pairs( data ) do
				local position = v.position
				local angles = v.angles
				local active = v.active

				local entity = ents.Create( class )
				entity:SetPos(position)
				entity:SetAngles(angles)
				entity:Spawn()
				entity:Activate()
				entity:SetNetVar("active", active)
				local phys = entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:EnableMotion(false)
				end
			end
		end
	end
end

function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs( ents.GetAll() ) do
		if table.HasValue( self.tableStove, v:GetClass() ) then
			data[v:GetClass()] = data[v:GetClass()] or {}
			data[v:GetClass()][ #data[v:GetClass()] + 1 ] = {
				position = v:GetPos(),
				angles = v:GetAngles(),
				active = v:GetNetVar("active")
			}
		end
	end
		
	nut.util.WriteTable("stoves", data)
end