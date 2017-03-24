local language = "korean";
local PLUGIN = PLUGIN;

PLUGIN:AddPluginLanguage("vd_vendor", "상인", language);

PLUGIN:AddPluginLanguage("vd_buy", "구매", language);
PLUGIN:AddPluginLanguage("vd_sell", "판매", language);
PLUGIN:AddPluginLanguage("vd_name", "이름", language);
PLUGIN:AddPluginLanguage("vd_price", "설정된 가격", language);
PLUGIN:AddPluginLanguage("vd_orignal_price", "원래 가격", language);
PLUGIN:AddPluginLanguage("vd_itemID", "아아템 코드", language);

PLUGIN:AddPluginLanguage("vd_admin", "관리", language);

PLUGIN:AddPluginLanguage("vd_admin_faction", "팩션 권한 설정", language);
PLUGIN:AddPluginLanguage("vd_admin_faction_desc", "%s 팩션에게 구매 / 판매 권한을 부여합니다.", language);

PLUGIN:AddPluginLanguage("vd_admin_classes", "클래스 권한 설정", language);
PLUGIN:AddPluginLanguage("vd_admin_classes_desc", "%s 클래스에게 구매 / 판매 권한을 부여합니다.", language);

PLUGIN:AddPluginLanguage("vd_admin_action", "구매 / 판매 여부", language);
PLUGIN:AddPluginLanguage("vd_admin_sell", "플레이어에게 판매함", language);
PLUGIN:AddPluginLanguage("vd_admin_buy", "플레이어에게서 구매함", language);

PLUGIN:AddPluginLanguage("vd_admin_selling", "판매 여부", language);
PLUGIN:AddPluginLanguage("vd_admin_buying", "구매 여부", language);

PLUGIN:AddPluginLanguage("vd_admin_name", "이름", language);
PLUGIN:AddPluginLanguage("vd_admin_adj", "물가 조정 (배수)", language);
PLUGIN:AddPluginLanguage("vd_admin_money", "상인이 가지고 있는 돈", language);
PLUGIN:AddPluginLanguage("vd_admin_desc", "설명", language);
PLUGIN:AddPluginLanguage("vd_admin_model", "모델", language);

PLUGIN:AddPluginLanguage("vd_admin_save", "저장", language);

PLUGIN:AddPluginLanguage("vd_admin_faction_desc", "%s 팩션에게 접근을 허가합니다.", language);
PLUGIN:AddPluginLanguage("vd_admin_tip", "왼쪽 클릭으로 판매 / 구매, 오른쪽 클릭으로 가격을 정합니다.", language);
PLUGIN:AddPluginLanguage("vd_sell_desc", "이름: %s\n설명: %s\n%s", language);
PLUGIN:AddPluginLanguage("vd_admin_ask_price", "이 아이템의 가격은?", language);

PLUGIN:AddPluginLanguage("created_vendor", "성공적으로 상인을 생성하였습니다.", language);
PLUGIN:AddPluginLanguage("removed_vendor", "성공적으로 상인을 삭제하였습니다.", language);
PLUGIN:AddPluginLanguage("not_trace_vendor", "당신은 상인을 바라보고 있지 않습니다.", language);

PLUGIN:AddPluginLanguage("vendor_no_afford", "상인은 이 아이템을 구매하기에 충분한 돈을 가지고 있지 않습니다.", language);
PLUGIN:AddPluginLanguage("vendor_cash", "이 상인은 %s을(를) 가지고 있습니다.", language);