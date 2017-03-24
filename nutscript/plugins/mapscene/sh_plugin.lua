local PLUGIN = PLUGIN
PLUGIN.name = "맵 장면 (Map Scenes)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "메뉴에서 맵의 한 장면을 볼수 있게 해 줍니다."
PLUGIN.base = true;

PLUGIN:IncludeDir("language");

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");
nut.util.Include("sh_commands.lua");