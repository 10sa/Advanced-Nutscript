PLUGIN.name = "방송 시스템 (Broadcast System)"
PLUGIN.author = "Black Tea / 번역자 : Tensa"
PLUGIN.desc = "맵 전체에 방송되는 장비를 추가해 줍니다."

AdvNut.util.PluginIncludeDir("language", PLUGIN.uniqueID, true);

nut.util.Include("sv_plugin.lua");
nut.util.Include("cl_plugin.lua");
nut.util.Include("sh_command.lua");