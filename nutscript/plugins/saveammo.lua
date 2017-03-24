PLUGIN.name = "탄약 저장 (Save Ammo)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "플레이어의 탄약을 저장합니다."
PLUGIN.base = true;

local AMMO_TYPES = {
	"ar2",
	"alyxgun",
	"pistol",
	"smg1",
	"357",
	"xbowbolt",
	"buckshot",
	"rpg_round",
	"smg1_grenade",
	"sniperround",
	"sniperpenetratedround",
	"grenade",
	"thumper",
	"gravity",
	"battery",
	"gaussenergy",
	"combinecannon",
	"airboatgun",
	"striderminigun",
	"helicoptergun",
	"ar2altfire",
	"slam"
}

function PLUGIN:CharacterSave(client)
	local ammo = {}
	local weapon = client:GetActiveWeapon()
		for k, v in pairs(AMMO_TYPES) do
			local count = client:GetAmmoCount(v)

			if (count > 0) then
				ammo[v] = count
			end
		end
	client.character:SetData("ammo", ammo)
	
	if(!IsValid(weapon) and IsValid(weapon.Clip1)) then
		client.character:SetData("clip1", weapon:Clip1());
	else
		client.character:SetData("clip1", 0);
	end;
end

function PLUGIN:PlayerFirstLoaded(client)
	client:RemoveAllAmmo()

	local ammo = client.character:GetData("ammo")
	local weapon = client:GetActiveWeapon()

	if (IsValid(weapon)) then
		weapon:SetClip1(client.character:GetData("clip1"))
	end

	if (ammo) then
		for ammoType, amount in pairs(ammo) do
			client:SetAmmo(tonumber(amount) or 0, ammoType)
		end

		client.character:SetData("ammo", {})
	end
end