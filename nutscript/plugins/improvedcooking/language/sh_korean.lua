local language = "korean";
local PLUGIN = PLUGIN;

PLUGIN:AddPluginLanguage("cook_it", "%s cooks the %s", language);

PLUGIN:AddPluginLanguage("cook_notice_cooked", "성공적으로 %s 를 조리하였습니다.", language);
PLUGIN:AddPluginLanguage("cook_notice_turnonstove", "%s 를 조리하기 위해서는 조리대를 켜야 합니다.", language);
PLUGIN:AddPluginLanguage("cook_notice_notcookable", "조리 실패: %s 는 조리가 가능한 식품이 아닙니다.", language);
PLUGIN:AddPluginLanguage("cook_notice_alreadycooked", "%s 는 이미 조리되어 있습니다.", language);
PLUGIN:AddPluginLanguage("cook_notice_havetofacestove", "%s 를 조리하기 위해서는 조리대를 바라봐야 합니다.", language);

PLUGIN:AddPluginLanguage("cook_stove_name", "조리대", language);
PLUGIN:AddPluginLanguage("cook_burcket_name", "양동이", language);
PLUGIN:AddPluginLanguage("cook_barrel_name", "드럼통", language);

PLUGIN:AddPluginLanguage("cook_stove_desc", "음식을 조리할때 쓰입니다.", language);
PLUGIN:AddPluginLanguage("cook_burcket_desc", "음식을 조리할때 쓰입니다.", language);
PLUGIN:AddPluginLanguage("cook_barrel_desc", "음식을 조리할때 쓰입니다.", language);

PLUGIN:AddPluginLanguage("cook_food_usenum", "%s\n이 음식은 %s 번 더 먹을 수 있습니다.", language);
PLUGIN:AddPluginLanguage("cook_food_status", "%s\n상태: %s ", language);

PLUGIN:AddPluginLanguage("cook_food_uncook", "조리되지 않음.", language);
PLUGIN:AddPluginLanguage("cook_food_worst", "형체를 알아볼 수 없음.", language);
PLUGIN:AddPluginLanguage("cook_food_reallybad", "형체만 남아 있음.", language);
PLUGIN:AddPluginLanguage("cook_food_bad", "겉이 다 탐.", language);
PLUGIN:AddPluginLanguage("cook_food_notgood", "좋지 않음.", language);
PLUGIN:AddPluginLanguage("cook_food_normal", "일반적임.", language);
PLUGIN:AddPluginLanguage("cook_food_good", "좋음.", language);
PLUGIN:AddPluginLanguage("cook_food_sogood", "맛있음.", language);
PLUGIN:AddPluginLanguage("cook_food_reallygood", "믿기지 않는 맛.", language);
PLUGIN:AddPluginLanguage("cook_food_best", "신이 좋아할 맛.", language);