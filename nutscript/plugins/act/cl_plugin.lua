local PLUGIN = PLUGIN or { };

PLUGIN.AngMod = Angle( 0, 0, 0 )
PLUGIN.MouseSensitive = 20

function PLUGIN:InputMouseApply( cmd, x, y, ang )
	if LocalPlayer():GetOverrideSeq() then
		self.AngMod = self.AngMod - Angle( -y/self.MouseSensitive, x/self.MouseSensitive, 0 )
		self.AngMod.p = math.Clamp( self.AngMod.p, -80, 80 )
	else
		self.AngMod = Angle( 0, 0, 0 )
	end
end
	
function PLUGIN:PlayerBindPress(client, bind, pressed)
	if (client:GetOverrideSeq() and !string.find(bind, "messagemode")) then
		if (client:GetNutVar("leavingAct")) then
			client:SetNutVar("leavingAct", false)
		else
			client:SetNutVar("leavingAct", true)
			timer.Simple(0.1, function()
				RunConsoleCommand("nut_leaveact")
			end)
		end

		return true
	end;
end

function PLUGIN:CalcView(client, origin, angles, fov)
	if (client:GetViewEntity() == client and client:GetOverrideSeq() and client:GetNetVar("seqCam")) then
		local view = {}
		local at = client:LookupAttachment( "eyes" )
		if at == 0 then at = client:LookupAttachment( "eye" ) end
		local att = client:GetAttachment( at ) 
			
		local ang = Angle( 0, client:GetAngles().y, 0 ) + self.AngMod
		local data = {
			start = att.Pos,
			endpos = att.Pos + ang:Forward() * -80 + ang:Up() * 20 + ang:Right() * 0
		}
		local trace = util.TraceLine(data)
		local position = trace.HitPos + trace.HitNormal*4

		view.origin = position
		view.angles = angNCS

		return view
			
	end
end

function PLUGIN:ShouldDrawLocalPlayer()
	if (LocalPlayer():GetOverrideSeq() and LocalPlayer():GetNetVar("seqCam")) then
		return true;
	end
end

function PLUGIN:AddCharInfoDermaTab(panel)
	local class = nut.anim.GetClass(string.lower(LocalPlayer():GetModel()))
	local list = self.sequences[class];
	if (list) then
		local actList = panel:AddSubMenu(PLUGIN:GetPluginLanguage("act_menu"), function() end);
		for uid, actdata in SortedPairs(list) do
			if (list) then
				actList:AddOption((actdata.name or uid), function()
					LocalPlayer():ConCommand(Format("say /act%s", uid));
				end);
			end;
		end;
	end;
end;