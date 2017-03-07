PLUGIN.name = "플러그인 명령어 (Plugin Commands)"
PLUGIN.author = "Tensa"
PLUGIN.desc = "기초적인 명령어를 추가합니다."

AdvNut.util.PluginIncludeDir("language", PLUGIN.uniqueID, true);
nut.util.Include("sh_commands.lua");
nut.util.Include("sh_language.lua");
