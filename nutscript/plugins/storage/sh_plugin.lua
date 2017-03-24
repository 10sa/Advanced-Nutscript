local PLUGIN = PLUGIN
PLUGIN.name = "저장고 (Storage)"
PLUGIN.author = "Chessnut and rebel1324 / 번역자 : Tensa"
PLUGIN.desc = "저장고를 추가시켜 줍니다."
PLUGIN.base = true;

-- Black Tea added few lines.

PLUGIN:IncludeDir("language");

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");
nut.util.Include("sh_commands.lua");

PLUGIN:IncludeDir("derma");