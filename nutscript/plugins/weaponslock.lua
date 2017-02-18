PLUGIN.name = "무기 잠금 (Weapons Lock)"
PLUGIN.author = "Tensa"
PLUGIN.desc = "무기를 내린 상태에서는 발포할 수 없도록 합니다."

function PLUGIN:StartCommand(client, command)
	local weapon = client:GetActiveWeapon();

	if (!client:GetNetVar("wepRaised", false)) then
		if (IsValid(weapon) and weapon.FireWhenLowered) then
			return;
		end
	
		command:RemoveKey(IN_ATTACK + IN_ATTACK2);
	end
end