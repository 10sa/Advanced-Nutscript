PLUGIN.name = "인식 (Recognition)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "인식 시스템을 추가합니다."

function PLUGIN:SetRecognized(client, other)
	local id = client.character:GetVar("id");
	local recognized = other.character:GetData("recog", {});
	recognized[id] = true;
	
	other.character:SetData("recog", recognized);
end

nut.util.Include("sh_commands.lua")
nut.util.Include("cl_plugin.lua");
AdvNut.util.PluginIncludeDir("derma", PLUGIN.uniqueID, true);