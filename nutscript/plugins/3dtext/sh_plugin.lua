local PLUGIN = PLUGIN or { };
PLUGIN.name = "3D 텍스트 (3D Text)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "아무곳에나 3D 텍스트를 쓸수 있게 해줍니다."
PLUGIN.text = PLUGIN.text or {}
PLUGIN.base = true;

PLUGIN:IncludeDir("language");

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");
nut.util.Include("sh_commands.lua");