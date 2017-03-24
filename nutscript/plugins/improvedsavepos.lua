PLUGIN.name = "개선된 위치 저장 (Improved Save Position)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "기존 플러그인의 버그가 수정된 캐릭터의 위치 저장 플러그인 입니다."
PLUGIN.base = true;

function PLUGIN:CharacterSave(client)
	if (IsValid(client)) then
		client.character:SetData("pos", {client:GetPos(), client:EyeAngles(), game.GetMap()}, nil, true); 
	end
end

function PLUGIN:PlayerCharacterLoaded(client, character)
	timer.Simple(0.1, function()
		if (IsValid(client)) then
			local data = character:GetData("pos")
			if (data) then
				if (data[3] and data[3]:lower()  == game.GetMap():lower()) then
					client:SetPos(data[1] or client:GetPos());
					client:SetEyeAngles(data[2] or Angle(0, 0, 0));
				end;
			end
			client.character:SetData("pos", nil, nil, true)
		end
	end);
end
