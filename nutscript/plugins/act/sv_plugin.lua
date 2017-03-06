local PLUGIN = PLUGIN or { };

function PLUGIN:CanFallOver( client )
	if (client:GetOverrideSeq()) then
		nut.util.Notify(nut.lang.Get("act_cant_fallover"), client)
		return false
	end
end
	
function PLUGIN:PlayerStartSeq(client, sequence)
	if (client:GetNutVar("nextAct", 0) >= CurTime()) then
		nut.util.Notify(nut.lang.Get("act_veryfast"), client)

		return
	end

	local data = {}
	data.start = client:GetPos()
	data.endpos = data.start - Vector(0, 0, 1)
	data.filter = client
	data.mins = Vector(-16, -16, 0)
	data.maxs = Vector(16, 16, 16)
	local trace = util.TraceHull(data)

	if (!trace.Hit) then
		nut.util.Notify(nut.lang.Get("act_invoid"), client)

		return
	end

	if (hook.Run("CanStartSeq", client) == false) then
		return
	end

	local override = client:GetOverrideSeq()
	local class = nut.anim.GetClass(string.lower(client:GetModel()))
	local list = self.sequences[class]

	if (class and list) then
		if (override) then
			for k, v in pairs(list) do
				if (v[1] == override and v[2] == true) then
					self:PlayerExitSeq(client)

					return
				end
			end
		end

		local act = list[sequence]
		
		if (act) then
			if (act[3] and act[3](client) == false) then
				return
			end

			local time

			if (act[2] == true) then
				time = 0
			end

			time = client:SetOverrideSeq(act[1], time, function()
				client:Freeze(true)
				client:SetNetVar("seqCam", true)
			end, function()
				client:Freeze(false)
				client:SetNetVar("seqCam", nil)
			end)

			if (time and time > 0) then
				client:SetNutVar("nextAct", CurTime() + time + 1)
			end

			client:SetNutVar("inAct", true)
		else
			nut.util.Notify(nut.lang.Get("act_cant_model"), client)
		end
	else
		nut.util.Notify(nut.lang.Get("act_cant_model"), client)
	end
end

function PLUGIN:PlayerExitSeq(client)
	client:SetNutVar("nextAct", CurTime() + 1)
	client:ResetOverrideSeq()
	client:Freeze(false)
	client:SetNutVar("inAct", false)
end
	
function PLUGIN:PlayerDeath(client)
	self:PlayerExitSeq(client)
end

function PLUGIN:PlayerSpawn(client)
	self:PlayerExitSeq(client)
end

concommand.Add("nut_leaveact", function(client, command, arguments)
	if (IsValid(client) and client:GetNutVar("inAct") and CurTime() >= client:GetNutVar("nextAct", 0)) then
		PLUGIN:PlayerExitSeq(client)
	end
end)