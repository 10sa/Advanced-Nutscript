local PLUGIN = PLUGIN
local GetVelocity = FindMetaTable("Entity").GetVelocity
local Length2D = FindMetaTable("Vector").Length2D

function PLUGIN:PlayerLoadedChar(client)
	local uniqueID = "nut_Stamina"..client:SteamID()
	local regenerationValue;
	local defaultRegenerationValue = nut.config.staminaRestore + (client:GetAttrib(ATTRIB_END, 1) * 0.005);
	
	timer.Remove(uniqueID)
	timer.Create(uniqueID, 1, 0, function()
		if (!IsValid(client)) then
			timer.Remove(uniqueID)
			return
		end
		
		if (!client:IsNoClipping()) then
			if (client:IsRunning()) then
				client.character:SetVar("stamina", math.Max(client.character:GetVar("stamina") - (nut.config.staminaValue - (client:GetAttrib(ATTRIB_END, 1) * 0.01)), 0));				
				client:UpdateAttrib(ATTRIB_END, 0.001);
				client:UpdateAttrib(ATTRIB_SPD, 0.0001);
			elseif (client:IsWalking()) then
				client.character:SetVar("stamina", math.Max(client.character:GetVar("stamina") - ((nut.config.staminaValue * 0.025) - client:GetAttrib(ATTRIB_END, 1) * 0.005), 0));
				client:UpdateAttrib(ATTRIB_END, 0.0005);
				client:UpdateAttrib(ATTRIB_SPD, 0.00005);
			elseif (client:GetVelocity():Length() == 0) then
				if (client:Crouching()) then
					regenerationValue = defaultRegenerationValue * 1.5;
				else
					regenerationValue = defaultRegenerationValue;
				end;
			
				if(regenerationValue > 0) then
					client.character:SetVar("stamina", math.Min(client.character:GetVar("stamina") + regenerationValue, 100));
				end;
			end;
		end;

		client:SetRunSpeed(math.Max(nut.config.walkSpeed / 2, (nut.config.runSpeed * 1.25) + (client:GetAttrib(ATTRIB_SPD, 1) * 0.25) - (100 / (math.Max(client.character:GetVar("stamina"), 1) * 0.5))));
		client:SetWalkSpeed(math.Max(nut.config.walkSpeed / 2, (nut.config.walkSpeed * 1.25) + (client:GetAttrib(ATTRIB_SPD, 1) * 0.05) - (100 / (math.Max(client.character:GetVar("stamina"), 1) * 0.5))));
	end);
end

function PLUGIN:PlayerSpawn(client)
	if (client.character) then
		client.character:SetVar("stamina", client.character:GetData("stamina") or 100);
	end
end