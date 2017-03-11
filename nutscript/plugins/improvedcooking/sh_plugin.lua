PLUGIN.name = "개선된 요리 (Improved Cooking)"
PLUGIN.author = "Tensa / Black Tea"
PLUGIN.desc = "배고픔, 목마름과 요리를 추가해 줍니다."

PLUGIN.hungerSpeed = nut.config.hungerRestore
PLUGIN.thirstSpeed = nut.config.thristRestore
PLUGIN.meActions = nut.config.statusMeActions;

AdvNut.util.PluginIncludeDir("language", PLUGIN.uniqueID, true);

ATTRIB_COOK = nut.attribs.SetUp(PLUGIN:GetPluginLanguage("cook"), PLUGIN:GetPluginLanguage("cooking_desc"), "cook");

function PLUGIN:CreateCharVars(character)
	character:NewVar("hunger", 100, CHAR_PRIVATE, true);
	character:NewVar("thirst", 100, CHAR_PRIVATE, true);
end

local entityMeta = FindMetaTable("Entity");
	
function entityMeta:IsStove()
	return ( self:GetClass() == "nut_stove" or self:GetClass() == "nut_bucket"  or self:GetClass() == "nut_barrel" );
end

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");
