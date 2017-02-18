PLUGIN.name = "개선된 영구 저장 (Improved Persistent)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "엔티티 저장에 대한 유효성 검사와 명령어를 추가시키고 임시 버퍼를 만듭니다."

if (SERVER) then
	function PLUGIN:LoadData()
		local contents = nut.util.ReadTable("persist");
		if (contents) then
			local entities, constraints = duplicator.Paste(nil, contents.Entities or {}, contents.Contraints or {});
			for k, v in pairs(entities) do
				v:SetNutVar("persist", true);
				v:SetPersistent(true);
			end;
		end
		
		for k, v in pairs(ents.GetAll()) do
			if(v:GetPersistent()) then
				v:SetNutVar("persist", true);
			end;
		end;
	end

	function PLUGIN:SaveData()
		local data = {}
		for k, v in pairs(ents.GetAll()) do
			if (v:GetNutVar("persist") and !v:GetPersistent() and v.PersistentSave != false) then
				data[#data + 1] = v
			end
		end
		
		nut.util.WriteTable("persist", duplicator.CopyEnts(data));
	end
	
	function PLUGIN:PersistentSave()
		for k, v in pairs(ents.GetAll()) do
			if(v:GetPersistent() or v:GetNutVar("persist") and v:IsWorld()) then
				v:SetPersistent(false);
				v:SetNutVar("persist", false);
			end;
		end;
	end;
end

local PLUGIN = PLUGIN

nut.command.Register({
	syntax = nut.lang.Get("syntax_bool"),
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor();
		local entity = trace.Entity;

		if (IsValid(entity)) then
			if (!entity:IsWorld()) then
				entity:SetNutVar("persist", util.tobool(arguments[1]));

				if (entity:GetNutVar("persist")) then
					nut.util.Notify(nut.lang.Get("ps_saved"), client);
				else
					nut.util.Notify(nut.lang.Get("ps_unsaved"), client);
				end
			else
				nut.util.Notify(nut.lang.Get("ps_isworldentity"), client);
			end
		else
			nut.util.Notify(nut.lang.Get("ps_isworldentity"), client);
		end
	end
}, "setpersist")
