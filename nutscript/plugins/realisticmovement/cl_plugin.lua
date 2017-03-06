local PLUGIN = PLUGIN or {};

PLUGIN:SetPluginConfig("isUseRealistic", PLUGIN:GetPluginConfig("isUseRealistic") or true);
PLUGIN:SetPluginConfig("realisticScale", PLUGIN:GetPluginConfig("realisticScale") or 1);
PLUGIN:SetPluginConfig("realisticMaxScale", 3);

PLUGIN.currAng = PLUGIN.currAng or Angle( 0, 0, 0 )
PLUGIN.currPos = PLUGIN.currPos or Vector( 0, 0, 0 )
PLUGIN.targetAng = PLUGIN.targetAng or Angle( 0, 0, 0 )
PLUGIN.targetPos = PLUGIN.targetPos or Vector( 0, 0, 0 )
PLUGIN.resultAng = PLUGIN.resultAng or Angle( 0, 0, 0 )

PLUGIN.nobob = {
	"weapon_physgun",
	"gmod_tool",
}

function PLUGIN:SchemaInitialized()
	local data = AdvNut.util.clReadTable(self.uniqueID);
	for key, data in pairs(data) do
		self:SetPluginConfig(key, data);
	end;
	
	self:SettingsInit()
end

function PLUGIN:ShutDown()
	local data = {
		isUseRealistic = PLUGIN:GetPluginConfig("isUseRealistic", false),
		realisticScale = PLUGIN:GetPluginConfig("realisticScale")
	}
	
	AdvNut.util.clWriteTable(self.uniqueID, data);
end

function PLUGIN:SettingsInit()
	local categoryName = PLUGIN:GetPluginLanguage("rm_category");
	
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("rm_scale"),
		var = "realisticScale",
		type = "slider",
		min = 1,
		max = PLUGIN:GetPluginConfig("realisticMaxScale", 3),
		category = categoryName,
		prefixID = self.uniqueID
	});
		
	nut.setting.Register({
		name = PLUGIN:GetPluginLanguage("rm_isUsing"),
		var ="isUseRealistic",
		type = "checker",
		category = categoryName,
		prefixID = self.uniqueID
	});
end

function PLUGIN:CalcView(client, pos, ang, fov)
	local velo = FindMetaTable("Entity").GetVelocity;
	local twoD = FindMetaTable("Vector").Length2D;
	
	if (!PLUGIN:GetPluginConfig("isUseRealistic")) then return end
	if (client:CanOverrideView( ) or client:GetViewEntity() != client ) then return end
	
	local wep = client:GetActiveWeapon();
	if (IsValid(wep)) then
		if (table.HasValue(PLUGIN.nobob, wep:GetClass())) then
			return
		end
	end
	
	local mouseSmoothingScale = 13 + (PLUGIN:GetPluginConfig("realisticScale", 1) * 3);
	
	local realTime = RealTime();
	local frameTime = FrameTime();
	local vel = math.floor(twoD(velo(client)));
	
	if (client:OnGround()) then
		local walkSpeed = client:GetWalkSpeed();
		
		if (vel > walkSpeed + 5) then
			local runSpeed = client:GetRunSpeed();
			
			local perc = math.Clamp(vel / runSpeed * 100, 0.5, 5);
			self.targetAng = Angle(math.abs(math.cos(realTime * (runSpeed / 33)) * 0.4 * perc), math.sin( realTime * ( runSpeed / 29 ) ) * 0.5 * perc, 0 )
			self.targetPos = Vector(0, 0, math.sin(realTime * (runSpeed / 30)) * 0.4 * perc);
		else
			local perc = math.Clamp((vel / walkSpeed * 100) / 30, 0, 4);
			self.targetAng = Angle(math.cos(realTime * (walkSpeed / 8)) * 0.2 * perc, 0, 0);
			self.targetPos = Vector(0, 0, (math.sin(realTime * (walkSpeed / 8)) * 0.5) * perc);
		end
	else
		if (client:IsNoClipping() or !client:OnGround()) then
			self.targetPos = Vector( 0, 0, 0 )
			self.targetAng = Angle( 0, 0, 0 )
		else
			if (client:WaterLevel( ) >= 2) then
				self.targetPos = Vector( 0, 0, 0 )
				self.targetAng = Angle( 0, 0, 0 )
			else
				vel = math.abs(client:GetVelocity( ).z )
				local af = 0
				local perc = math_Clamp( vel / 200, 0.1, 8)
				
				if ( perc > 1 ) then
					af = perc
				end
				
				self.targetAng = Angle(math.cos(realTime * 15) * 2 * perc + math.Rand(-af * 2, af * 2 ), math.sin(realTime * 15) * 2 * perc + math.Rand(-af * 2, af * 2) ,math.Rand(-af * 5, af * 5))
				self.targetPos = Vector(math.cos(realTime * 15) * 0.5 * perc, math.sin(realTime * 15) * 0.5 * perc, 0)
			end
		end
	end
	
	if (mouseSmoothingScale >= 1) then
		self.resultAng = LerpAngle(math.Clamp(math.Clamp(frameTime, 1 / 120, 1) * mouseSmoothingScale, 0, 5), self.resultAng, ang);
	else
		self.resultAng = ang;
	end
	
	self.currAng = LerpAngle(frameTime * 10, self.currAng, self.targetAng);
	self.currPos = LerpVector(frameTime * 10, self.currPos, self.targetPos);
	
	return {
		origin = pos + self.currPos,
		angles = self.resultAng + self.currAng,
		fov = fov
	};
end