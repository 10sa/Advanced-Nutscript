local PLUGIN = PLUGIN
PLUGIN.name = "개선된 지구력 (Improved Stamina)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "지구력과 관련된 능력치를 추가해 줍니다."

nut.util.Include("sv_hooks.lua")

function PLUGIN:RegisterAttributes()
	ATTRIB_SPD = nut.attribs.SetUp(nut.lang.Get("speed"), nut.lang.Get("speed_desc"), "spd")
	ATTRIB_END = nut.attribs.SetUp(nut.lang.Get("stamina"), nut.lang.Get("stamina_desc"), "end")
end
	
function PLUGIN:CreateCharVars(character)
	character:NewVar("stamina", 100, CHAR_PRIVATE, true);
end;

function PLUGIN:CharacterSave(client)
	client.character:SetData("stamina", client.character:GetVar("stamina", 100));
end;