local language = "korean";

PLUGIN:AddPluginLanguage("rg_syntax", "<인자 없음|aim|whisper|yell>", language);

PLUGIN:AddPluginLanguage("rg_normal", "일반", language);
PLUGIN:AddPluginLanguage("rg_whisper", "속삭임", language);
PLUGIN:AddPluginLanguage("rg_yell", "외침", language);

PLUGIN:AddPluginLanguage("rg_recongitioned_aim", "바라보는 플레이어에게 인식되었습니다.", language);
PLUGIN:AddPluginLanguage("rg_recongitioned", "%s 범위 안의 플레이어에게 인식되었습니다.", language);
PLUGIN:AddPluginLanguage("rg_not_player", "조준점이 플레이어을 바라보고 있지 않습니다.", language);