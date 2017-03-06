local PLUGIN = PLUGIN
PLUGIN.name = "3D 패널 (3D Panels)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "3D 패널을 추가시켜 줍니다."
PLUGIN.panels = PLUGIN.panels or {}

AdvNut.util.Include("language", PLUGIN.uniqueID, true);

nut.util.Include("sv_plugin.lua");
nut.util.Inlcude("cl_plugin.lua");
nut.util.Include("sh_commands.lua");