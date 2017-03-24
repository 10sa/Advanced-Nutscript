local PLUGIN = PLUGIN
PLUGIN.name = "상인 (AdvNS Custom Vendors)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "기존 플러그인을 커스텀한 상인 플러그인을 추가합니다."
PLUGIN.base = true;

PLUGIN:IncludeDir("language");

nut.util.Include("sv_plugin.lua");
nut.util.Include("sh_commands.lua");

PLUGIN:IncludeDir("derma");