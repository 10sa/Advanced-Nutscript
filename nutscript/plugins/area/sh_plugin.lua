local PLUGIN = PLUGIN or { };
PLUGIN.name = "구역 (Area)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "구역과 관련된 기능을 추가합니다."
PLUGIN.base = true;

PLUGIN:IncludeDir("language");

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");
nut.util.Include("sh_commands.lua");