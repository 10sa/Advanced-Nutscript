local PLUGIN = PLUGIN
PLUGIN.name = "개선된 3인칭 시점 추가 (New Fancy Third Person)"
PLUGIN.author = "Tensa / Black Tea"
PLUGIN.desc = "3인칭 시점을 사용할 수 있게 합니다."

AdvNut.util.PluginIncludeDir("language", PLUGIN.uniqueID, true);

nut.util.Include("cl_plugin.lua");