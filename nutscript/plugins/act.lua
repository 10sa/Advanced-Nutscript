local PLUGIN = PLUGIN
PLUGIN.name = "플레이어 동작 (Player Acts)"
PLUGIN.author = "Chessnut and rebel1324 / 번역자 : Tensa and Renée"
PLUGIN.desc = "플레이어의 행동을 추가시켜 줍니다."
PLUGIN.sequences = {}

local function lean(client)
	local data = {
		start = client:GetPos(),
		endpos = client:GetPos() - client:GetForward()*54,
		filter = client
	}
	local trace = util.TraceLine(data)

	if (!trace.HitWorld) then
		nut.util.Notify(nut.lang.Get("act_closewall"), client)

		return false
	end
end

local sequences = {}
PLUGIN.sequences["metrocop"] = {
	["threat"] = {"plazathreat1", name = "진압봉 두드리기 (Melee Threat)"},
	["lean"] = {"plazalean", true, lean, name = "벽에 기대어 서기 (Lean Back)"},
	["crossarms"] = {"plazathreat2", false, name = "팔짱 끼고 서기 (Cross Arms)"},
	["point"] = {"point", name = "손 끝으로 가르키기 (Point)"},
	["block"] = {"blockentry", false, lean, name = "길 막기 (Block Entry)"},
	["startle"] = {"canal5breact1", name = "놀라 막기 (Startle)"},
	["warn"] = {"luggagewarn", name = "경고 주기 (Warning)"},
	["moleft"] = {"motionleft", name = "좌측 수신호 (Motion Left)"},
	["moright"] = {"motionright", name = "우측 수신호 (Motion Right)"}
}
PLUGIN.sequences["overwatch"] = {
	["type"] = {"console_type_loop", true, name = "콘솔 사용 (Type Console)"},
	["sigadv"] = {"signal_advance", name = "전진 수신호 (Advance)"},
	["sigfor"] = {"signal_forward", name = "전방 가르키기 (Forward)"},
	["siggroup"] = {"signal_group", name = "집결 수신호 (Regroup)"},
	["sighalt"] = {"signal_halt", name = "정지 수신호 (Halt)"},
	["sigleft"] = {"signal_left", name = "좌측 가르키기 (Left)"},
	["sigright"] = {"signal_right", name = "우측 가르키기 (Right)"},
	["sigcover"] = {"signal_takecover", name = "엄폐 수신호 (Cover)"}
}
PLUGIN.sequences["citizen_male"] = {
	["arrestlow"] = {"arrestidle", true, name = "머리 손 하고 엎드리기 (Arrest Idle)"},
	["cheer"] = {"cheer1", name = "응원하기 (Cheer)"},
	["clap"] = {"cheer2", name = "박수치기 (Clap)"},
	["sitwall"] = {"plazaidle4", true, lean, name = "벽에 기대어 앉기 (Sit Wall)"},
	["stand"] = {"d1_t01_breakroom_watchclock", name = "팔짱 끼고 서기 (Stand)"},
	["standpockets"] = {"d1_t02_playground_cit2_pockets", true, name = "주머니에 손 넣고 서기 (Stand Pockets)"},
	["showid"] = {"d1_t02_plaza_scan_id", name = "손 들기 (Show ID)"},
	["pant"] = {"d2_coast03_postbattle_idle02", true, name = "숨 고르기 (Pant)"},
	["leanback"] = {"lean_back", true, lean, name = "벽에 기대어 서기 (Lean Back)"},
	["sit"] = {"sit_ground", true, name = "자리에 앉기 (Sit)"},
	["lying"] = {"Lying_Down", true, name = "자리에 눕기 (Lying)"},
	["examineground"] = {"d1_town05_Daniels_Kneel_Idle", true, name = "물건 줍기 (Examine Ground)"},
	["injured2"] = {"d1_town05_Wounded_Idle_1", true, name = "부상을 입고 눕기 (Injured 1)"},
	["injured3"] = {"d1_town05_Wounded_Idle_2", true, name = "부상을 입고 눕기 (Injured 2)"},
	["injuredwall"] = {"injured1", true, lean, name = "벽에 기대어 눕기 (Injured Wall)"},
}
PLUGIN.sequences["citizen_female"] = table.Copy(PLUGIN.sequences["citizen_male"])
local notsupported = {
	"injured3",
	"injured4",
	"injured1",
	"examineground",
	"standpockets",
}
for _, str in pairs( notsupported ) do
	PLUGIN.sequences["citizen_female"][ str ] = nil
end

if (SERVER) then
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
else
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
			view.angles = ang

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
			local actList = panel:AddSubMenu(nut.lang.Get("act_menu"), function() end);
			for uid, actdata in SortedPairs(list) do
				if (list) then
					actList:AddOption((actdata.name or uid), function()
						LocalPlayer():ConCommand(Format("say /act%s", uid));
					end);
				end;
			end;
		end;
	end;
end;

for k, v in pairs(PLUGIN.sequences) do
	for k2, v2 in pairs(v) do
		nut.command.Register({
			onRun = function(client, arguments)
				PLUGIN:PlayerStartSeq(client, k2)
			end
		}, "act"..k2)
	end
end
