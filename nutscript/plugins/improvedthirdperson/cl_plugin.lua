local PLUGIN = PLUGIN or {};

PLUGIN:SetPluginConfig("distance", 0);
PLUGIN:SetPluginConfig("sensitive", .05);
PLUGIN:SetPluginConfig("changedir", false);
PLUGIN:SetPluginConfig("classic", false);
PLUGIN:SetPluginConfig("maxdistance", 100);

local mc = math.Clamp	
local playerMeta = FindMetaTable("Player")
local GetVelocity = FindMetaTable("Entity").GetVelocity
local Length2D = FindMetaTable("Vector").Length2D

function PLUGIN:SchemaInitialized()
	local data = AdvNut.util.clReadTable(self.uniqueID);
	for key, data in pairs(data) do
		self:SetPluginConfig(key, data);
	end;
	
	self:SettingsInit()
end

function PLUGIN:ShutDown()
	local data = {
		distance = PLUGIN:GetPluginConfig("distance"),
		sensitive = PLUGIN:GetPluginConfig("sensitive"),
		changedir = PLUGIN:GetPluginConfig("changedir"),
		classic = PLUGIN:GetPluginConfig("classic")
	}
	
	AdvNut.util.clWriteTable(self.uniqueID, data);
end

function playerMeta:CanOverrideView()
	return ( 
		self:IsValid() && // If player is available.
		self:Alive() && // If player is alive.
		self.character && // If player's character is valid.
		!self:GetOverrideSeq()  && // If player is not in acting sequence.
		!self:IsRagdolled() && // If player is not ragdolled/fallover'd
		!self:IsNoClipping() && // If player is not noclipping.
		PLUGIN:GetPluginConfig("distance", 0) > 0 // If player enabled the thirdperson.
	)
end

local function ffr()
	return mc(FrameTime(), 1/60,1)
end
	
local nobob = {
	"weapon_physgun",
	"gmod_tool",
}


	
function PLUGIN:DistPerc()
	return mc(PLUGIN:GetPluginConfig("distance", 0) / PLUGIN:GetPluginConfig("maxdistance", 100), 0, 1)
end

function PLUGIN:SettingsInit()
	local categoryName = PLUGIN:GetPluginLanguage("tp_name")
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("tp_setting"),
		var = "distance",
		type = "slider",
		min = 0,
		max = PLUGIN:GetPluginConfig("maxdistance", 100),
		category = categoryName,
		prefixID = self.uniqueID
	});
		
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("tp_mousedpi"),
		var = "sensitive",
		type = "slider",
		min = 0,
		demical = 1,
		max = 1,
		category = categoryName,
		prefixID = self.uniqueID
	});
		
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("tp_lefthand"),
		var = "changedir",
		type = "checker",
		category = categoryName,
		prefixID = self.uniqueID
	});
		
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("tp_clasic"),
		var ="classic",
		type = "checker",
		category = categoryName,
		prefixID = self.uniqueID
	});
end

function PLUGIN:ShouldDrawLocalPlayer()
	if ( LocalPlayer():Alive() && LocalPlayer().character ) then
		if ( LocalPlayer():GetOverrideSeq() or LocalPlayer():IsRagdolled() ) then
			return true
		end

		if PLUGIN:GetPluginConfig("distance", 0) > 0 then
			return true
		end
	end
	return false
end
	
local class
local camang = Angle(0, 0, 0)
local addpos = Vector(0, 0, 0)
local finaladdpos = addpos
local finalang = camang
local camx, camy = 0, 0

local lastaim = Angle(0, 0, 0)
if LocalPlayer() and LocalPlayer():IsValid() and LocalPlayer().character then
	lastaim = LocalPlayer():EyeAngles()
	camang = LocalPlayer():EyeAngles()
end

local movetrig = false;

function PLUGIN:CreateMove( cmd )
	local ply = LocalPlayer()
	local vel = math.floor( Length2D(GetVelocity(ply)) )

	if ply:CanOverrideView() and !PLUGIN:GetPluginConfig("classic", false) then
		if (vel < 5 and !ply:WepRaised()) then
			cmd:SetViewAngles(lastaim)
			movetrig = true
		else
			if movetrig then
				cmd:SetViewAngles(camang)
				movetrig = false
			end
			lastaim = ply:EyeAngles()
		end
	end
end

function PLUGIN:InputMouseApply( cmd, x, y, ang ) // :C
	local ply = LocalPlayer()
	local vel = math.floor(Length2D(GetVelocity(ply)))

	camx = x * - PLUGIN:GetPluginConfig("sensitive", .05);
	camy = y * PLUGIN:GetPluginConfig("sensitive", .05);

	if (vel < 5 and !ply:WepRaised() and !PLUGIN:GetPluginConfig("classic", false)) then
		camang = camang + Angle(camy, camx, 0)
		camang.p = mc(camang.p, -90, 90)
		addpos = camang:Up()*math.abs(camang.p*.1)
	end
end

local nodesync = false
function PLUGIN:CalcView( ply, pos, ang, fov )
	local rt = RealTime()
	local ft = FrameTime()
	local vel = math.floor( Length2D(GetVelocity(ply)) )
	local runspeed = ply:GetRunSpeed()
	local walkspeed = ply:GetWalkSpeed()
	local wep = ply:GetActiveWeapon()
	if wep and wep:IsValid() then
		class = ply:GetActiveWeapon():GetClass()
	else
		class = ""
	end
	local v = {}
	if 
		ply:CanOverrideView()
	then
		if !(vel < 5 and !ply:WepRaised()) or PLUGIN:GetPluginConfig("classic", false) then
			camang = ang
			addpos = ang:Up()*mc(self:DistPerc()*PLUGIN:GetPluginConfig("distance", 0)*.3, 10, PLUGIN:GetPluginConfig("maxdistance", 100))
			if ply:WepRaised() then
				local difac = 1
				if PLUGIN:GetPluginConfig("changedir", false) then
					difac = -1
				end

				addpos = addpos + difac * ang:Right() * mc(self:DistPerc() * PLUGIN:GetPluginConfig("distance", 0) * .8, 20, PLUGIN:GetPluginConfig("maxdistance", 100))
			end
		end

		local data = {}
		data.start = pos
		data.endpos = data.start - finalang:Forward() * PLUGIN:GetPluginConfig("distance", 0) + finaladdpos
		data.filter = ply
		local trace = util.TraceLine(data)
		
		if FrameTime() < 1/10 then
			finalang = LerpAngle(ffr()*15, finalang, camang)
			finaladdpos = LerpVector(ffr()*15, finaladdpos, addpos)
		else
			finalang = camang
			finaladdpos = addpos
		end

		v.angles = finalang
		v.angles.r = 0
		v.origin = trace.HitPos + trace.HitNormal * 10
		v.fov = fov
			
		return GAMEMODE:CalcView(ply, v.origin, v.angles, v.fov)
	end;
end
