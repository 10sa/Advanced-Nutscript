local language = "korean";
local PLUGIN = PLUGIN;

PLUGIN:AddPluginLanguage("doors_can_buy", "구매 가능한 문", language);
PLUGIN:AddPluginLanguage("doors_cant_buy", "구매 불가능한 문", language);
PLUGIN:AddPluginLanguage("doors_show", "보임", language);
PLUGIN:AddPluginLanguage("doors_hidden", "숨김", language);

PLUGIN:AddPluginLanguage("doors_buy_unownable", "이 문은 구매가 불가능합니다.", language);

PLUGIN:AddPluginLanguage("doors_sell_door", "당신은 %s 에 문을 판매하였습니다.", language);
PLUGIN:AddPluginLanguage("doors_buy_door", "당신은 %s 에 문을 구매하였습니다.", language);
PLUGIN:AddPluginLanguage("doors_buy_desc", "F2 키를 눌러 문을 구매합니다.", language);
PLUGIN:AddPluginLanguage("doors_open_door", "성공적으로 문을 열었습니다.", language);
PLUGIN:AddPluginLanguage("doors_close_door", "성공적으로 문을 잠궜습니다.", language);

PLUGIN:AddPluginLanguage("doors_change_title", "성공적으로 문의 이름을 변경하였습니다.", language);
PLUGIN:AddPluginLanguage("doors_change_unownable", "성공적으로 문의 설정을 구매 불가 상태로 변경하였습니다.", language);
PLUGIN:AddPluginLanguage("doors_change_ownable", "성공적으로 문의 설정을 구매 가능 상태로 변경하였습니다.", language);
PLUGIN:AddPluginLanguage("doors_change_hidden", "성공적으로 문의 상태를 %s 상태로 설정하였습니다.", language);

PLUGIN:AddPluginLanguage("doors_selled_door", "이미 구매된 문입니다.", language);
PLUGIN:AddPluginLanguage("doors_buyed_door", "구매된 문", language);

PLUGIN:AddPluginLanguage("doors_owner", "%s 의 소유", language);
PLUGIN:AddPluginLanguage("doors_not_owner", "이 문은 당신의 소유가 아닙니다.", language);
PLUGIN:AddPluginLanguage("doors_not_door", "조준점이 문을 바라보고 있지 않습니다.", language);
PLUGIN:AddPluginLanguage("already_buyed", "다른 플레이어가 소유중인 문 입니다.", language);
PLUGIN:AddPluginLanguage("already_ownable", "이미 구매 가능한 문입니다.", language);
PLUGIN:AddPluginLanguage("successful_selling", "성공적으로 문을 판매하였습니다.", language);