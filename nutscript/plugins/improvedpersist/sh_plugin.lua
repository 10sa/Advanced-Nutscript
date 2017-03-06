local PLUGIN = PLUGIN or { };
PLUGIN.name = "개선된 영구 저장 (Improved Persistent)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "엔티티 저장에 대한 유효성 검사와 명령어를 추가시키고 임시 버퍼를 만듭니다."

AdvNut.util.Include("language", PLUGIN.uniqueID, true);

nut.util.Include("sv_plugin.lua");
nut.util.Include("sh_commands.lua");