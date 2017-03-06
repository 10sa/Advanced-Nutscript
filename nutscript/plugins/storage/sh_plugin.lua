local PLUGIN = PLUGIN
PLUGIN.name = "저장고 (Storage)"
PLUGIN.author = "Chessnut and rebel1324 / 번역자 : Tensa"
PLUGIN.desc = "저장고를 추가시켜 줍니다."

-- Black Tea added few lines.

AdvNut.util.PluginIncludeDir("language", PLUGIN.uniqueID, true);

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");

AdvNut.util.PluginIncludeDir("derma", PLUGIN.uniqueID, true);