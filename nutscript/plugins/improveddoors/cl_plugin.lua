local PLUGIN = PLUGIN;

function PLUGIN:DrawDoor(entity, eyePos)
	local posData = self:GetDoorDrawPosition(entity);
	
	if (self:IsDoor(entity) and !posData.hitWorld) then
		if (entity:GetNetVar("hidden")) then return; end;
		
		local alpha = self:GetAlphaFromDistance(256, eyePos, entity:GetPos())
		if(alpha <= 0 or entity:IsEffectActive(EF_NODRAW)) then return end;
		
		local owner = entity:GetNetVar("owner");
		local title = entity:GetNetVar("title", PLUGIN:GetPluginLanguage("doors_can_buy"));
		local desc = PLUGIN:GetPluginLanguage("doors_buy_desc");
		
		local lastY = -30;
		local panelAlpha = math.min(alpha + 10, 200);
		local textAlpha = math.min(alpha + 50, 255);
		
		local doorDesc = entity:GetNetVar("desc");
		if (doorDesc) then
			desc = doorDesc;
		else
			if (entity:GetNetVar("unownable")) then
				title = entity:GetNetVar("title") or PLUGIN:GetPluginLanguage("doors_cant_buy");
				desc = entity:GetNetVar("desc") or PLUGIN:GetPluginLanguage("doors_cant_buy");
			end
		end;

		local titleWidth, titleHeight = AdvNut.util.GetTextSize("AdvNut_3D2DTitleFont", title or "");
		local descWidth, descHeight = AdvNut.util.GetTextSize("AdvNut_3D2DDescFont", desc or "");
		local largeWidth = titleWidth;
		
		if (descWidth > largeWidth) then
			largeWidth = descWidth;
		end;
				
		local scale = math.abs((posData.width * 0.75) / largeWidth);
		local titleScale = math.min(scale, 0.05);
		local descScale = math.min(scale, 0.03);
		local longHeight = (titleHeight + descHeight + 10) * 1.5
		
		cam.Start3D2D(posData.forwardPos, posData.forwardAngle, titleScale)
			AdvNut.util.DrawCenterGradient(-(largeWidth / 2) - 128, lastY - longHeight * 0.25, largeWidth + 256, longHeight, Color(100, 100, 100, panelAlpha));
			nut.util.DrawText(0, lastY, title, Color(120, 120, 120, textAlpha), "AdvNut_3D2DTitleFont");
			nut.util.DrawText(0, lastY + descHeight + 8, desc, Color(120, 120, 120, textAlpha), "AdvNut_3D2DDescFont");
		cam.End3D2D();
		
		cam.Start3D2D(posData.backPos, posData.backAngle, titleScale)
			AdvNut.util.DrawCenterGradient(-(largeWidth / 2) - 128, lastY - longHeight * 0.25, largeWidth + 256, longHeight, Color(100, 100, 100, panelAlpha));
			nut.util.DrawText(0, lastY, title, Color(120, 120, 120, textAlpha), "AdvNut_3D2DTitleFont");
			nut.util.DrawText(0, lastY + descHeight + 8, desc, Color(120, 120, 120, textAlpha), "AdvNut_3D2DDescFont");
		cam.End3D2D();
	end
end

function PLUGIN:GetDoorDrawPosition(door, reversed)
	local traceData = {};
	local obbCenter = door:OBBCenter();
	local obbMaxs = door:OBBMaxs();
	local obbMins = door:OBBMins();
		
	traceData.endpos = door:LocalToWorld(obbCenter);
	traceData.filter = ents.FindInSphere(traceData.endpos, 20);
		
	for k, v in pairs(traceData.filter) do
		if (v == door) then
			traceData.filter[k] = nil;
		end;
	end;
		
	local length = 0;
	local width = 0;
	local size = obbMins - obbMaxs;
		
	size.x = math.abs(size.x);
	size.y = math.abs(size.y);
	size.z = math.abs(size.z);
		
	if (size.z < size.x and size.z < size.y) then
		length = size.z;
		width = size.y;
			
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetUp() * length);
		else
			traceData.start = traceData.endpos + (door:GetUp() * length);
		end;
	elseif (size.x < size.y) then
		length = size.x;
		width = size.y;
			
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetForward() * length);
		else
			traceData.start = traceData.endpos + (door:GetForward() * length);
		end;
	elseif (size.y < size.x) then
		length = size.y;
		width = size.x;
			
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetRight() * length);
		else
			traceData.start = traceData.endpos + (door:GetRight() * length);
		end;
	end;

	local trace = util.TraceLine(traceData);
	local forwardAngle = trace.HitNormal:Angle();
		
	if (trace.HitWorld and !reversed) then
		return self:GetDoorDrawPosition(door, true);
	end;
		
	forwardAngle:RotateAroundAxis(forwardAngle:Forward(), 90);
	forwardAngle:RotateAroundAxis(forwardAngle:Right(), 90);
		
	local forwardPos = trace.HitPos - (((traceData.endpos - trace.HitPos):Length() * 2) + 2) * trace.HitNormal;
	local backAngle = trace.HitNormal:Angle();
	local backPos = trace.HitPos + (trace.HitNormal * 2);
		
	backAngle:RotateAroundAxis(backAngle:Forward(), 90);
	backAngle:RotateAroundAxis(backAngle:Right(), -90);
		
	return {
		backPos = backPos,
		backAngle = backAngle,
		forwardPos = forwardPos,
		hitWorld = trace.HitWorld,
			forwardAngle = forwardAngle,
		width = math.abs(width)
	};
end;
	
function PLUGIN:PostDrawTranslucentRenderables(drawingDepth, drawingSkybox)
	local eyeAngles = EyeAngles();
	local eyePos = EyePos();
		
	cam.Start3D(eyePos, eyeAngles);
		local entities = ents.FindInSphere(eyePos, 256);
	
		for k, v in pairs(entities) do
			if (IsValid(v) and self:IsDoor(v)) then
				self:DrawDoor(v, eyePos);
			end;
		end;
	cam.End3D();
end;
	
function PLUGIN:GetAlphaFromDistance(maximum, start, finish)
	if (type(start) == "Player") then
		start = start:GetShootPos();
	elseif (type(start) == "Entity") then
		start = start:GetPos();
	end;
		
	if (type(finish) == "Player") then
		finish = finish:GetShootPos();
	elseif (type(finish) == "Entity") then
		finish = finish:GetPos();
	end;
		
	return math.Clamp(255 - ((255 / maximum) * (start:Distance(finish))), 0, 255);
end;


function PLUGIN:PlayerBindPress(bind, pressed)
	if (bind == "gm_showteam") then
		local client = LocalPlayer();
		local entity = AdvNut.util.GetPlayerTraceEntity(client);
		
		if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
			if (!PLUGIN:IsDoorOwned(entity)) then
				client:ConCommand("nut doorbuy");
			elseif (PLUGIN:GetDoorOwner(entity) == client) then
				client:ConCommand("nut doorsell");
			end
		end
	end;
end
AdvNut.hook.Add("PlayerBindPress", "DoorBindPress", PLUGIN.PlayerBindPress);

function PLUGIN:PlayerCanOpenQuickRecognitionMenu()
	local entity = AdvNut.util.GetPlayerTraceEntity(LocalPlayer());	
	
	if (IsValid(entity) and PLUGIN:IsDoor(entity)) then
		return false;
	else
		return true;
	end;
end;