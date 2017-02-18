if (!nut.lang) then
	include("libs/sh_lang.lua");
end

local language = "korean";

// 글로벌
nut.lang.Add("return", "돌아가기", language);
nut.lang.Add("unknow", "알 수 없음", language);
nut.lang.Add("none", "없음", language);
nut.lang.Add("no_desc", "설정되지 않음", language);
nut.lang.Add("characters", "캐릭터", language);
nut.lang.Add("timeout", "응답 시간이 만료되었습니다.", language);
nut.lang.Add("disabled", "비활성화", language);
nut.lang.Add("command", "명령어", language);
nut.lang.Add("cancel", "취소", language);
nut.lang.Add("wrong_value", "잘못된 값 입니다.", language);
nut.lang.Add("faction", "팩션", language);

nut.lang.Add("nochar_talk_error", "캐릭터를 먼저 만들어야 합니다.", language);
nut.lang.Add("return_tip", "게임으로 돌아갑니다.", language);

nut.lang.Add("item_price", "가격: %s", language);
nut.lang.Add("trace_not_player", "조준점이 플레이어를 바라보고 있지 않습니다.", language);

// 프레임워크
nut.lang.Add("schema_author", "제작자: %s", language);
nut.lang.Add("based_framework", "NS 1.0 Base", language);
nut.lang.Add("auto_refreshed", "넛스트립트가 수정 사항을 자동으로 서버에 적용했습니다.", language);

nut.lang.Add("loadingData", "로컬 플레이어 기다리는 중", language);
nut.lang.Add("sendTime", "현재 시간 전송 중", language);
nut.lang.Add("initchardata", "플레이어 데이터 초기화 중", language);
nut.lang.Add("loadchar", "캐릭터 불러오는 중", language);
nut.lang.Add("otherloadchar", "다른 플레이어의 캐릭터 불러오는 중", language);
nut.lang.Add("charnetworking", "캐릭터 네트워킹...", language);
nut.lang.Add("website", "서버 그룹", language);

nut.lang.Add("unknown_player", "아직 모르는 사람", language);
nut.lang.Add("spawning", "리스폰 중입니다...", language);
nut.lang.Add("tied", "묶인 상태에서는 할수 없습니다.", language);

nut.lang.Add("string_request_ok", "확인", language);
nut.lang.Add("string_request_cancel", "취소", language);

nut.lang.Add("charMenuTitle", "Advanced Nutscript", language);
nut.lang.Add("charMenuDesc", "Advanced Nutscript", language);
nut.lang.Add("framework_version", "Advanced Nutscript Framework<br>프레임워크 버전 : %s\n<br>Developer : Tensa", language);

// 타이틀 메뉴
nut.lang.Add("load", "불러오기", language);
nut.lang.Add("create", "생성하기", language);
nut.lang.Add("leave", "나가기", language);

nut.lang.Add("leave_tip", "서버에서 나갑니다.", language);

// 캐릭터 생성
nut.lang.Add("name", "이름", language);
nut.lang.Add("desc", "설명", language);
nut.lang.Add("gender", "성별", language);
nut.lang.Add("model", "모델", language);
nut.lang.Add("attribs", "신체능력", language);
nut.lang.Add("male", "남성", language);
nut.lang.Add("female", "여성", language);
nut.lang.Add("finish", "완료하기", language);
nut.lang.Add("char_info", "이름: %s\n설명: %s\n팩션: %s", language);

nut.lang.Add("valid_name", "올바르지 않은 이름입니다.", language);
nut.lang.Add("valid_desc", "올바르지 않은 설명입니다.", language);
nut.lang.Add("valid_gender", "올바르지 않은 성별입니다.", language);
nut.lang.Add("valid_model", "올바르지 않은 모델입니다.", language);
nut.lang.Add("valid_faction", "올바르지 않은 팩션입니다.", language);

nut.lang.Add("name_desc", "게임 안에서 불릴 캐릭터의 이름입니다.", language);
nut.lang.Add("gender_desc", "캐릭터의 성별입니다.", language);
nut.lang.Add("model_desc", "게임 안에서의 캐릭터의 외형입니다.", language);
nut.lang.Add("create_tip", "RP에 사용할 캐릭터를 생성합니다.", language);
nut.lang.Add("char_create_tip", "모든 정보를 기입한 뒤 '생성하기'를 통해 캐릭터를 생성할 수 있습니다.", language);
nut.lang.Add("provide_valid", "다음 정보가 빠졌습니다, ", language);
nut.lang.Add("char_create_warn", "적절하지 않은 캐릭터 정보입니다.", language);
nut.lang.Add("char_validating", "서버에 데이터를 전송중입니다...", language);
nut.lang.Add("char_creating", "정상적으로 서버가 캐릭터를 생성하였습니다.", language);
nut.lang.Add("points_left", "%s점 만큼의 투자하지 않은 특성 점수가 있습니다.", language);

nut.lang.Add("next", "다음", language);

nut.lang.Add("faction_select", "팩션 선택", language);
nut.lang.Add("faction_select_desc", "이 탭에서는 캐릭터의 팩션을 결정할수 있습니다.", language);
nut.lang.Add("not_select_faction", "팩션은 반드시 선택되어야 합니다.", language);
nut.lang.Add("request_select_faction", "팩션을 선택하십시요.", language);

nut.lang.Add("charinfo_select", "캐릭터 정보", language);
nut.lang.Add("charinfo_select_desc", "이 탭에서는 캐릭터의 이름과 설명, 모델을 결정할수 있습니다.", language);
nut.lang.Add("not_enough_desc", "캐릭터의 설명은 최소한 %s자 이상이여야 합니다.", language);
nut.lang.Add("not_enough_name", "캐릭터의 이름은 최소한 %s자 이상이여야 합니다.", language);
nut.lang.Add("overflow_name", "캐릭터의 이름은 %s자 이하여야 합니다.", language);
nut.lang.Add("overflow_desc", "캐릭터의 설명은 %s자 이하여야 합니다.", language);
nut.lang.Add("not_select_model", "모델은 반드시 선택되어야 합니다.", language);

nut.lang.Add("attribute_setup", "능력치 설정", language);
nut.lang.Add("attribute_setup_desc", "이 탭에서는 캐릭터의 능력치를 결정할수 있습니다.", language);

nut.lang.Add("charcreate_waiting", "데이터 전송", language);
nut.lang.Add("charcreate_waiting_desc", "작성된 데이터를 서버에 전송하는 중...", language);
nut.lang.Add("charcreate_timeout", "정보 전송 시간이 초과되었습니다. \n이 상황이 지속되는 경우 서버 운영자에게 문의하십시요.", language);


// 캐릭터 불러오기
nut.lang.Add("choose", "선택", language);

nut.lang.Add("load_tip", "만들어진 캐릭터를 불러옵니다.", language);
nut.lang.Add("choose_tip", "플레이 할 캐릭터를 선택합니다.", language);

// 캐릭터 삭제
nut.lang.Add("delete", "삭제", language);

nut.lang.Add("delete_tip", "케릭터를 삭제합니다.", language);
nut.lang.Add("delete_question", "정말로 %s 을(를); 삭제 하시겠습니까?", language);

// 캐릭터 상태
nut.lang.Add("week_hungry", "%s 배에서 꼬르륵 소리가 난다.", language);
nut.lang.Add("die_hungry", "%s 심한 배고픔으로 인해 쓰러진다.", language);

nut.lang.Add("week_thirst", "%s 약간의 갈증을 느낀다.", language);
nut.lang.Add("die_thirst", "%s 심한 갈증으로 인해 쓰러진다.", language);


// 채팅
nut.lang.Add("chat_normal", "%s 님의 말 ", language);
nut.lang.Add("chat_yell", "%s 님의 외침 ", language);
nut.lang.Add("chat_whisper", "%s 님의 속삭임 ", language);
nut.lang.Add("chat_pm", "[귓속말] ", language);
nut.lang.Add("chat_broadcast", "%s 님의 방송 ", language);

nut.lang.Add("chat_ooctime", "OOC 채팅을 사용하려면 %s 초 만큼 더 기다려야 합니다.", language);

// 메뉴, 설정
nut.lang.Add("settings", "설정", language);
nut.lang.Add("settings_tip", "이 탭을 통해 게임의 각종 설정을 변경할 수 있습니다.", language);
nut.lang.Add("settings_category_framework", "프레임워크 설정", language);

nut.lang.Add("settings_crosshair", "크로스헤어", language);
nut.lang.Add("settings_crosshair_size", "크로스헤어  크기", language);
nut.lang.Add("settings_crosshair_spacing", "크로스헤어 간격", language);
nut.lang.Add("settings_crosshair_alpha", "크로스헤어 투명도", language);

// 메뉴, 신체 능력
nut.lang.Add("attribute", "신체 능력", language);
nut.lang.Add("attribute_tip", "이 창은 플레이어의 신체 능력치를 표시합니다.", language);
nut.lang.Add("attribute_tip2", "신체 능력치는 특정 행동을 통하여 향상시킬 수 있습니다.", language);

// 신체 능력, 능력치
nut.lang.Add("acrobatics", "곡예", language);
nut.lang.Add("speed", "속도", language);
nut.lang.Add("stamina", "지구력", language);
nut.lang.Add("strength", "힘", language);
nut.lang.Add("cook", "요리", language);

nut.lang.Add("acrobatics_desc", "이 수치가 높을수록 점프할 수 있는 높이가 더욱 높아집니다.", language);
nut.lang.Add("speed_desc", "얼마나 빠르게 뛸 수 있는지에 대한 능력치입니다.", language);
nut.lang.Add("stamina_desc", "얼마나 오래 뛸 수 있는지에 대한 능력치입니다.", language);
nut.lang.Add("strength_desc", "이 수치가 높을수록 캐릭터의 힘이 강해집니다.", language);
nut.lang.Add("cooking_desc", "요리한 음식의 결과물을 결정합니다.", language);

// 메뉴, 인벤토리
nut.lang.Add("inventory", "인벤토리", language);
nut.lang.Add("equippedinventory", "장비된 아이템", language);

nut.lang.Add("no_invspace", "인벤토리에 여유가 없습니다.", language);
nut.lang.Add("inv_tip", "이 탭은 당신의 인벤토리의 내용물을 관리합니다.", language);

// 메뉴, 사업
nut.lang.Add("business", "사업", language);

nut.lang.Add("business_tip", "아이콘을 클릭하여 아이템을 구매할 수 있습니다.", language);

// 메뉴, 스코어보드
nut.lang.Add("scoreboard", "플레이어 목록", language);

nut.lang.Add("sb_tip", "플레이어 아이콘을 누르면 플레이어에 대한 정보를 볼 수 있습니다.", language);
nut.lang.Add("sb_avatar_tip", "클릭으로 %s 님의 프로필을 엽니다. | Steam ID : %s", language);
nut.lang.Add("sb_model_tip", "이 플레이어의 핑 : %s", language);

nut.lang.Add("sb_menu_change_name", "이름 변경", language);
nut.lang.Add("sb_menu_change_name_desc", "변경할 캐릭터의 이름을 입력하세요.", language);

nut.lang.Add("sb_menu_faction_give", "팩션 지급", language);
nut.lang.Add("sb_menu_faction_take", "팩션 제거", language);

nut.lang.Add("sb_menu_flags", "플래그", language);
nut.lang.Add("sb_menu_flags_give", "플래그 지급", language);
nut.lang.Add("sb_menu_flags_give_desc", "지급할 플래그를 입력하세요.", language);

nut.lang.Add("sb_menu_flags_take", "플래그 제거", language);
nut.lang.Add("sb_menu_flags_take_desc", "제거할 플래그를 입력하세요.", language);

nut.lang.Add("sb_menu_kick", "킥", language);

nut.lang.Add("sb_menu_kick_reason", "사유 작성", language);
nut.lang.Add("sb_menu_kick_reason_desc", "킥 사유를 작성하세요. (243자 미만)", language);

nut.lang.Add("sb_menu_ban", "밴", language);
nut.lang.Add("sb_menu_ban_desc", "밴 시간을 입력하세요. (분 단위, 0 입력 시 영구 밴)", language);

// 메뉴, 클래스
nut.lang.Add("classes", "클래스", language);
nut.lang.Add("class_icon_tip", "클릭으로 %s 클래스에 가입합니다.", language);

nut.lang.Add("class_joined", "%s 클래스에 성공적으로 가입하였습니다.", language);
nut.lang.Add("class_failed", "당신은 이 클래스에 가입할 수 없습니다.", language);

// 메뉴, 도움말
nut.lang.Add("help", "도움말", language);

// 메뉴, 시스템

nut.lang.Add("system", "시스템", language);
nut.lang.Add("system_key", "키", language);
nut.lang.Add("system_value", "값", language);
nut.lang.Add("system_tip", "이 탭은 설정 값 변경하게 도와주는 탭 입니다.", language);
nut.lang.Add("system_second_tip", "라인을 우클릭 하여 값을 변경할 수 있으나, 일부 값은 변경하지 못할수도 있습니다.", language)
nut.lang.Add("system_set_value", "값 지정", language);
nut.lang.Add("system_set_value_desc", "%s 형의 값을 입력하세요.", language);
nut.lang.Add("system_notify", "%s 님이 '%s' 설정 값을 '%s' 으(로) 변경하였습니다.", language);

// 캐릭터 상태
nut.lang.Add("dead_talk_error", "사망한 상태에서는 할 수 없는 행동입니다.", language);
nut.lang.Add("pay_received", "당신은 월급으로 %s 을(를) 받았습니다.", language);
nut.lang.Add("item_pickup_samechar", "당신의 다른 캐릭터의 아이템을 획득할 수 없습니다!", language);
nut.lang.Add("no_perm_tied", "묶인 상태에서는 할 수 없습니다.", language);
nut.lang.Add("no", "아니요.", language);
nut.lang.Add("yes", "예.", language);

// 아이템
nut.lang.Add("item_info", "이름: %s\n설명: %s", language);
nut.lang.Add("item_icon_desc", "이름: %s\n설명: %s\n%s", language);
nut.lang.Add("item_drop", "버리기", language);
nut.lang.Add("item_take", "줍기", language);
nut.lang.Add("notexist", "%s (정의되지 않음)", language);

// 아이템, 버튼
nut.lang.Add("cooking", "요리하기", language);
nut.lang.Add("free", "무료", language);
nut.lang.Add("eat", "먹기", language);
nut.lang.Add("open", "열기", language);
nut.lang.Add("lock", "잠구기", language);
nut.lang.Add("drinking", "마시기", language);
nut.lang.Add("reload", "장전하기", language);
nut.lang.Add("b_reading", "읽기", language);

nut.lang.Add("wp_equip", "장착하기", language);
nut.lang.Add("wp_unequip", "장착해제", language);

nut.lang.Add("wear", "입기", language);
nut.lang.Add("unwear", "벗기", language);

nut.lang.Add("setup", "설치하기", language);
nut.lang.Add("setup_desc", "아이템을 설치합니다.", language);

// 아이템 카테고리
nut.lang.Add("c_cooking", "요리", language);
nut.lang.Add("storage", "저장", language);
nut.lang.Add("food", "음식", language);
nut.lang.Add("misc", "잡동사니", language);
nut.lang.Add("storage_security", "저장고, 보안", language);
nut.lang.Add("weapon", "무기", language);
nut.lang.Add("alcohol", "주류", language);
nut.lang.Add("ammo", "탄약", language);
nut.lang.Add("clothing", "의류", language);
nut.lang.Add("book", "도서", language);
nut.lang.Add("part", "장비", language);

// 아이템 / 옷
nut.lang.Add("cant_wear_cl", "이 옷을 입은 상태에서는 할수 없습니다.", language);
nut.lang.Add("already_wear_cl", "이미 그 옷을 입고 있습니다.", language);

// 아이템 / 장비
nut.lang.Add("already_wear_part", "이미 그 장비를 착용하고 있습니다.", language);
nut.lang.Add("already_wear_parttype", "이미 %s 타입의 장비를 착용중입니다.", language);

nut.lang.Add("cant_wear_part", "이 장비를 입은 상태에서는 할수 없습니다.", language);

// 아이템 / 바디그룹
nut.lang.Add("wrong_bodygroup_model", "당신의 캐릭터 모델에서는 이 아이템을 사용할수 없습니다.", language);
nut.lang.Add("already_equip_bodygroup", "당신은 이미 해당 바디그룹 아이템을 입고 있습니다.", language);


// 아이템 / 음식(cookfood2 not);
nut.lang.Add("not_need_eat", "당신은 당장 이것을 마실 이유가 없습니다.", language);

// 아이템 / 무기
nut.lang.Add("already_equip_weapon", "이미 그 무기를 장착하고 있습니다.", language);
nut.lang.Add("already_wear_parttype", "이미 %s 타입의 무기를 장착하고 있습니다.", language);

nut.lang.Add("cant_equip_weapon", "이 무기를 장착한 상태에서는 할수 없습니다.", language);

// 상인
nut.lang.Add("no_afford", "당신은 이 아이템을 구매할 충분한 돈이 없습니다.", language);
nut.lang.Add("vendor_no_afford", "상인은 이 아이템을 구매하기에 충분한 돈을 가지고 있지 않습니다.", language);
nut.lang.Add("vendor_cash", "이 상인은 %s을(를) 가지고 있습니다.", language);
nut.lang.Add("purchased_for", "당신은 %s을(를) %s 에 구매하였습니다.", language);
nut.lang.Add("sold", "당신은 %s을(를) %s 에 판매하였습니다.", language);
nut.lang.Add("notenoughitem", "당신은 판매할 %s을(를) 가지고 있지 않습니다.", language);

// 명령어
nut.lang.Add("nocommend", "정의되지 않은 명령어입니다.", language);
nut.lang.Add("missing_arg", "%s 번째 인자가 빠졌습니다.", language);
nut.lang.Add("no_perm", "권한 밖의 명령어입니다, %s.", language);
nut.lang.Add("no_ply", "잘못된 플레이어입니다.", language);
nut.lang.Add("wrong_arg", "잘못된 인자입니다.", language);

//인자 선언 (문자열);
nut.lang.Add("syntax_none", "|인자 없음|", language);
nut.lang.Add("syntax_string", "<문자열>", language);
nut.lang.Add("syntax_name", "<이름>", language);
nut.lang.Add("syntax_reason", "<사유>", language);
nut.lang.Add("syntax_steamID", "<스팀 ID>", language);
nut.lang.Add("syntax_map", "<맵 이름>", language);
nut.lang.Add("syntax_name_steamID", "<이름|스팀 ID>", language);
nut.lang.Add("syntax_rank", "<랭크>", language);
nut.lang.Add("syntax_url", "<URL>", language);
nut.lang.Add("syntax_faction", "<팩션>", language);
nut.lang.Add("syntax_class", "<클래스>", language);
nut.lang.Add("syntax_flags", "<플래그>", language);
nut.lang.Add("syntax_model", "<모델>", language);
nut.lang.Add("syntax_customclass", "<커스텀클래스>", language);
nut.lang.Add("syntax_itemID", "<아이템 코드>", language);
nut.lang.Add("syntax_password", "<비밀번호>", language);

//,인자 선언 (넘버);
nut.lang.Add("syntax_bool", "[부울값]")
nut.lang.Add("syntax_toaimpos", "[(0|1)/바라보는 곳으로]", language);
nut.lang.Add("syntax_amount", "[값]", language);
nut.lang.Add("syntax_area_showtime", "[시간 표시 여부]", language);
nut.lang.Add("syntax_groupnumber", "[그룹 번호]", language);
nut.lang.Add("syntax_force", "[힘]", language);
nut.lang.Add("syntax_time", "[시간]", language);
nut.lang.Add("syntax_immunity", "[권한]", language);
nut.lang.Add("syntax_hp", "[체력]", language);
nut.lang.Add("syntax_armor", "[아머]", language);
nut.lang.Add("syntax_width", "[길이]", language);
nut.lang.Add("syntax_height", "[높이]", language);
nut.lang.Add("syntax_scale", "[크기]", language);
nut.lang.Add("syntax_radius", "[범위]", language);
nut.lang.Add("syntax_bodygroup", "[바디그룹]", language);
nut.lang.Add("syntax_skin", "[스킨]", language);

// 명령어(캐릭터);
nut.lang.Add("char_deleted", "%s 님의 %s 캐릭터를 삭제하였습니다.", language);

nut.lang.Add("char_ban", "%s 님이 %s 님의 캐릭터를 밴하였습니다.", language);
nut.lang.Add("a_char_unban", "%s 님이 '%s' 님의 캐릭터를 언밴하였습니다.", language);
nut.lang.Add("c_char_unban", "%s 님은 더이상 밴 상태가 아닙니다.", language);

nut.lang.Add("char_set_bodygroup", "%s 님이 %s 님의 %s 바디그룹을 %s 로 설정하였습니다.", language);
nut.lang.Add("char_bad_bodygroup", "잘못된 바디그룹입니다.", language);

nut.lang.Add("char_set_desc", "성공적으로 캐릭터의 설명을 변경하였습니다.", language);
nut.lang.Add("char_min_desc", "캐릭터의 설명은 최소한 %s 자 이상이여야 합니다.", language);
nut.lang.Add("char_set_baddesc", "이전과 같은 설명을 입력할 수 없습니다.", language);

nut.lang.Add("char_set_model", "%s 님이 %s 님의 모델을 %s 로 변경하였습니다.", language);
nut.lang.Add("char_set_customclass", "%s 님이 %s 님의 커스텀 클래스를 %s 으로 변경하였습니다.", language);

nut.lang.Add("char_change_name", "이름 변경", language);
nut.lang.Add("char_change_name_desc", "변경될 캐릭터의 이름을 입력하세요.", language)
nut.lang.Add("char_set_name", "%s 님이 %s 님의 이름을 %s 으로 변경하였습니다.", language);
nut.lang.Add("char_bad_name", "잘못된 이름입니다.", language);

nut.lang.Add("char_desc_change", "캐릭터 설명 바꾸기", language);
nut.lang.Add("char_desc_change_desc", "변경할 설명을 입력하세요.", language);

// 명령어(팩션 관리);
nut.lang.Add("already_whitelisted", "해당 플레이어는 이미 그 팩션을 가지고 있습니다.", language);
nut.lang.Add("not_whitelisted", "해당 플레이어는 그 팩션을 가지고 있지 않습니다.", language);
nut.lang.Add("invalid_faction", "잘못된 팩션입니다.", language);
nut.lang.Add("blacklisted", "%s 님이 %s 님에게서 %s 팩션을 제거하였습니다.", language);
nut.lang.Add("whitelisted", "%s 님이 %s 님에게 %s 팩션을 부여하였습니다.", language);

// 명령어 (돈);
nut.lang.Add("min_give_money", "건네줄 돈의 금액은 최소한 %s 은 되어야 합니다.", language);
nut.lang.Add("min_drop_money", "떨어트릴 돈은 최소한 %s 은 되어야 합니다.", language);

nut.lang.Add("give_money", "%s 님이 %s 만큼의 돈을 %s 님에게 줬습니다.", language);
nut.lang.Add("take_money", "%s 님이 %s 만큼의 돈을 %s 님에게서 가져갔습니다.", language);
nut.lang.Add("set_money", "%s 님이 %s 님의 돈을 %s 으로 설정하였습니다.", language);

nut.lang.Add("no_money", "돈이 모자랍니다.", language);

// 명렁어(플레그);
nut.lang.Add("flags_give", "%s 님이 '%s' 플레그를 %s 님에게 부여하였습니다.", language);
nut.lang.Add("flags_take", "%s 님이 '%s' 플래그를 %s 님에게서 가져갔습니다.", language);

// 명령어 (이외);
nut.lang.Add("rollcube", "%s 님이 주사위를 굴려 %s 이 나왔습니다.", language);

nut.lang.Add("gettingup", "일어나는 중입니다...", language);
nut.lang.Add("movebody", "몸이 움직이는 동안은 일어날 수 없습니다.", language);
nut.lang.Add("getupstatus", "당신은 이미 일어나고 있습니다.", language);
nut.lang.Add("donotfallover", "당신은 기절해 있지 않습니다.", language);
nut.lang.Add("fallover", "이미 기절해 있습니다.", language);

nut.lang.Add("delete_voicemail_done", "성공적으로 보이스메일을 삭제하였습니다.", language);
nut.lang.Add("change_voicemail_done", "성공적으로 보이스메일을 변경하였습니다.", language);

// 명령어 (아이템);
nut.lang.Add("c_giveitem", "%s 님에게 %s 개의 %s 아이템을 줬습니다.", language);
nut.lang.Add("t_giveitem", "%s 님이 %s 개의 %s 아이템을 전달하였습니다.", language);

nut.lang.Add("bad_item_id", "잘못된 ID입니다.", language);

// 캐릭터 상태 (F1);
nut.lang.Add("status_money", "돈: ", language);
nut.lang.Add("status_hunger", "배고픔 수치: ", language);
nut.lang.Add("status_thirst", "목마름 수치: ", language);
nut.lang.Add("status_inv", "사용중인 인벤토리: ", language);
nut.lang.Add("status_synt", "캐릭터 상태: ", language);

nut.lang.Add("status_fallover", "쓰러지기", language);
nut.lang.Add("status_changedesc", "설명 바꾸기", language);

nut.lang.Add("synt_fine", "괜찮음.", language);
nut.lang.Add("synt_die", "사망 직전.", language);
nut.lang.Add("synt_hunger", "매우 배고픔.", language);
nut.lang.Add("synt_thirst", "매우 목마름.", language);

nut.lang.Add("developer", "개발자", language);
nut.lang.Add("owner", "오너", language);
nut.lang.Add("superadmin", "슈퍼 어드민", language);
nut.lang.Add("admin", "어드민", language);
nut.lang.Add("operator", "오퍼레이터", language);
nut.lang.Add("donator", "후원자", language);
nut.lang.Add("user", "유저", language);

// 플러그인, 방송 장치
nut.lang.Add("bc_machine", "방송 장치", language);

nut.lang.Add("bc_machine_desc", "/방송, 또는 /b 명령어를 이용하여 방송을 할 수 있습니다.", language);
nut.lang.Add("bc_machine_notactive", "장치를 먼저 켜야 합니다.", language);

// 플러그인, 요리
nut.lang.Add("cook_it", "%s cooks the %s", language);

nut.lang.Add("cook_notice_cooked", "성공적으로 %s 를 조리하였습니다.", language);
nut.lang.Add("cook_notice_turnonstove", "%s 를 조리하기 위해서는 조리대를 켜야 합니다.", language);
nut.lang.Add("cook_notice_notcookable", "조리 실패: %s 는 조리가 가능한 식품이 아닙니다.", language);
nut.lang.Add("cook_notice_alreadycooked", "%s 는 이미 조리되어 있습니다.", language);
nut.lang.Add("cook_notice_havetofacestove", "%s 를 조리하기 위해서는 조리대를 바라봐야 합니다.", language);

nut.lang.Add("cook_stove_name", "조리대", language);
nut.lang.Add("cook_burcket_name", "양동이", language);
nut.lang.Add("cook_barrel_name", "드럼통", language);

nut.lang.Add("cook_stove_desc", "음식을 조리할때 쓰입니다.", language);
nut.lang.Add("cook_burcket_desc", "음식을 조리할때 쓰입니다.", language);
nut.lang.Add("cook_barrel_desc", "음식을 조리할때 쓰입니다.", language);

nut.lang.Add("cook_food_usenum", "%s\n이 음식은 %s 번 더 먹을 수 있습니다.", language);
nut.lang.Add("cook_food_status", "%s\n상태: %s ", language);

nut.lang.Add("cook_food_uncook", "조리되지 않음.", language);
nut.lang.Add("cook_food_worst", "형체를 알아볼 수 없음.", language);
nut.lang.Add("cook_food_reallybad", "형체만 남아 있음.", language);
nut.lang.Add("cook_food_bad", "겉이 다 탐.", language);
nut.lang.Add("cook_food_notgood", "좋지 않음.", language);
nut.lang.Add("cook_food_normal", "일반적임.", language);
nut.lang.Add("cook_food_good", "좋음.", language);
nut.lang.Add("cook_food_sogood", "맛있음.", language);
nut.lang.Add("cook_food_reallygood", "믿기지 않는 맛.", language);
nut.lang.Add("cook_food_best", "신이 좋아할 맛.", language);

// 플러그인, 문
nut.lang.Add("doors_can_buy", "구매 가능한 문", language);
nut.lang.Add("doors_cant_buy", "구매 불가능한 문", language);
nut.lang.Add("doors_show", "보임", language);
nut.lang.Add("doors_hidden", "숨김", language);

nut.lang.Add("doors_buy_unownable", "이 문은 구매가 불가능합니다.", language);

nut.lang.Add("doors_sell_door", "당신은 %s 에 문을 판매하였습니다.", language);
nut.lang.Add("doors_buy_door", "당신은 %s 에 문을 구매하였습니다.", language);
nut.lang.Add("doors_buy_desc", "F2 키를 눌러 문을 구매합니다.", language);
nut.lang.Add("doors_open_door", "성공적으로 문을 열었습니다.", language);
nut.lang.Add("doors_close_door", "성공적으로 문을 잠궜습니다.", language);

nut.lang.Add("doors_change_title", "성공적으로 문의 이름을 변경하였습니다.", language);
nut.lang.Add("doors_change_unownable", "성공적으로 문의 설정을 구매 불가 상태로 변경하였습니다.", language);
nut.lang.Add("doors_change_ownable", "성공적으로 문의 설정을 구매 가능 상태로 변경하였습니다.", language);
nut.lang.Add("doors_change_hidden", "성공적으로 문의 상태를 %s 상태로 설정하였습니다.", language);

nut.lang.Add("doors_selled_door", "이미 구매된 문입니다.", language);
nut.lang.Add("doors_buyed_door", "구매된 문", language);

nut.lang.Add("doors_owner", "%s 의 소유", language);
nut.lang.Add("doors_not_owner", "이 문은 당신의 소유가 아닙니다.", language);
nut.lang.Add("doors_not_door", "조준점이 문을 바라보고 있지 않습니다.", language);

// 플러그인, 손전등
nut.lang.Add("fl_flashlight_name", "손전등", language);

nut.lang.Add("fl_flashlight_desc", "배터리를 포함한 작은 손전등입니다.", language);

// 플러그인, 모더레이터
nut.lang.Add("mr_low_permisson", "권한이 모자랍니다.", language);
nut.lang.Add("mr_exist_rank", "정의되지 않은 랭크입니다.", language);
nut.lang.Add("mr_notfound_pos", "도착 좌표를 찾지 못하였습니다.", language);
nut.lang.Add("mr_selfban", "자기 자신을 밴할 수 없습니다.", language);
nut.lang.Add("mr_exist_map", "서버에 존재하지 않는 맵입니다.", language);
nut.lang.Add("mr_change_map", "%s 님이 %s 맵으로 %s 초 뒤에 변경하게 하였습니다.", language);

nut.lang.Add("mr_bad_rank_name", "그룹 이름을 입력해야 합니다.", language);
nut.lang.Add("mr_create_rank", "%s 님이 %s 급 권한의 '%s' 랭크를 만드셨습니다.", language);
nut.lang.Add("mr_remove_rank", "%s 님이 %s 랭크를 삭제하였습니다.", language);

nut.lang.Add("mr_slaped", "%s 님이 %s 님을 %s 의 힘으로 밀쳤습니다.", language);
nut.lang.Add("mr_slayed", "%s 님이 %s 님을 슬레이 하였습니다.", language);

nut.lang.Add("mr_freeze", "%s 님이 %s 님을 냉동하였습니다.", language);
nut.lang.Add("mr_unfreezn", "%s 님이 %s 님을 해동하였습니다.", language);

nut.lang.Add("mr_ignite", "%s 님이 %s 님을 %s 초 동안 불태웁니다.", language);
nut.lang.Add("mr_unignite", "%s 님이 %s 님의 불을 끕니다.", language);

nut.lang.Add("mr_set_hp", "%s 님이 %s 님의 체력을 %s 로 설정하였습니다.", language);
nut.lang.Add("mr_set_armor", "%s 님이 %s 님의 아머를 %s 로 설정하였습니다.", language);

nut.lang.Add("mr_strip", "%s 님이 %s 님의 모든 무기를 제거하였습니다.", language);
nut.lang.Add("mr_arm", "%s 님이 %s 님을 재무장시켰습니다.", language);

nut.lang.Add("mr_tp", "%s 님이 %s 님을 자신의 위치로 이동시켰습니다.", language);
nut.lang.Add("mr_goto", "%s 님이 %s 님의 위치로 이동하였습니다.", language);

nut.lang.Add("mr_kick", "%s 님이 %s 님을 킥하였습니다.", language);
nut.lang.Add("mr_ban", "%s 님이 %s 님을 %s 동안 밴하였습니다.", language);
nut.lang.Add("mr_unban", "%s 님이 %s 님을 언밴하였습니다.", language);

nut.lang.Add("mr_no_reason", "사유 없음.", language);
nut.lang.Add("mr_permanently", "영구", language);
nut.lang.Add("mr_moderator", "모더레이터", language);


// 플러그인, 전광판
nut.lang.Add("nb_set_title", "타이틀 설정", language);
nut.lang.Add("nb_set_text", "텍스트 설정", language);

nut.lang.Add("nb_set_group", "게시판을 성공적으로 %s 그룹으로 설정하였습니다.", language);
nut.lang.Add("nb_set_group_text", "%s 그룹의 (%s 개의 전광판); 텍스트를 %s 로 설정하였습니다.", language);
nut.lang.Add("nb_not_notiborad", "조준점이 전광판을 바라보고 있지 않습니다.", language);

// 플러그인, 인식
nut.lang.Add("rg_syntax", "<인자 없음|aim|whisper|yell>", language);

nut.lang.Add("rg_normal", "일반", language);
nut.lang.Add("rg_whisper", "속삭임", language);
nut.lang.Add("rg_yell", "외침", language);

nut.lang.Add("rg_recongitioned_aim", "바라보는 플레이어에게 인식되었습니다.", language);
nut.lang.Add("rg_recongitioned", "%s 범위 안의 플레이어에게 인식되었습니다.", language);
nut.lang.Add("rg_not_player", "조준점이 플레이어을 바라보고 있지 않습니다.", language);

// 플러그인, 저장고
nut.lang.Add("sr_storage", "저장고", language);
nut.lang.Add("sr_usespace", "%s 만큼의 공간 사용 중.", language);
nut.lang.Add("sr_locked", "잠겨있는 저장고.", language);
nut.lang.Add("sr_move", "옮기기", language);

nut.lang.Add("sr_open_desc", "저장고를 엽니다.", language);
nut.lang.Add("sr_lock_try", "잠겨진 저장고입니다.", language);

nut.lang.Add("sr_lock_desc", "저장고를 잠급니다.", language);
	nut.lang.Add("sr_lock_itsworld", "월드 저장고는 잠그실 수 없습니다.", language);
	
nut.lang.Add("sr_confirmation", "방식 결정", language);
nut.lang.Add("sr_lock_type", "어떤 방식의 잠금장치를 사용하시겠습니까?", language);
	nut.lang.Add("sr_lock_noitem", "그 잠금장치를 소지하고 있지 않습니다.", language);
	nut.lang.Add("sr_lock_success", "성공적으로 저장고를 잠갔습니다.", language);

nut.lang.Add("sr_admin_open", "권한으로 열기", language);
nut.lang.Add("sr_admin_open_desc", "잠금을 무시하고 저장고를 엽니다.", language);


// 저장고, 아이템
nut.lang.Add("sr_c_locker_name", "자물쇠", language);
nut.lang.Add("sr_c_locker_desc", "열쇠로 열 수 있는 잠금장치입니다.", language);

nut.lang.Add("sr_d_locker_name", "전자식 비밀번호 패드", language);
nut.lang.Add("sr_d_locker_desc", "4자리 비밀번호식 잠금장치입니다.", language);
nut.lang.Add("sr_enter_password", "비밀번호를 입력하세요.", language);
nut.lang.Add("sr_wrong_password", "잘못된 비밀번호입니다.", language);

nut.lang.Add("sr_key_name", "열쇠", language);
nut.lang.Add("sr_key_desc", "잠긴 자물쇠를 열때 사용합니다.", language);

// 저장고, 명령어
nut.lang.Add("sr_world_container", "이 저장고는 이제 유저 생성 저장고입니다.", language);
nut.lang.Add("sr_user_container", "이 저장고는 이제 유저 생성 저장고입니다.", language);

nut.lang.Add("sr_set_password", "%s 로 비밀번호를 설정하였습니다.", language);
nut.lang.Add("sr_lock_unlocked", "이 저장고의 잠금을 해제하셨습니다.", language);

nut.lang.Add("sr_lock_locked", "이미 잠겨져 있는 저장고입니다.", language);
nut.lang.Add("sr_notstorage", "잘못된 저장고입니다.", language);

// 플러그인, 상인
nut.lang.Add("vd_vendor", "상인", language);

nut.lang.Add("vd_buy", "구매", language);
nut.lang.Add("vd_sell", "판매", language);
nut.lang.Add("vd_name", "이름", language);
nut.lang.Add("vd_price", "설정된 가격", language);
nut.lang.Add("vd_orignal_price", "원래 가격", language);
nut.lang.Add("vd_itemID", "아아템 코드", language);

nut.lang.Add("vd_admin", "관리", language);

nut.lang.Add("vd_admin_faction", "팩션 권한 설정", language);
nut.lang.Add("vd_admin_faction_desc", "%s 팩션에게 구매 / 판매 권한을 부여합니다.", language);

nut.lang.Add("vd_admin_classes", "클래스 권한 설정", language);
nut.lang.Add("vd_admin_classes_desc", "%s 클래스에게 구매 / 판매 권한을 부여합니다.", language);

nut.lang.Add("vd_admin_action", "구매 / 판매 여부", language);
nut.lang.Add("vd_admin_sell", "플레이어에게 판매함", language);
nut.lang.Add("vd_admin_buy", "플레이어에게서 구매함", language);

nut.lang.Add("vd_admin_selling", "판매 여부", language);
nut.lang.Add("vd_admin_buying", "구매 여부", language);

nut.lang.Add("vd_admin_name", "이름", language);
nut.lang.Add("vd_admin_adj", "물가 조정 (배수)", language);
nut.lang.Add("vd_admin_money", "상인이 가지고 있는 돈", language);
nut.lang.Add("vd_admin_desc", "설명", language);
nut.lang.Add("vd_admin_model", "모델", language);

nut.lang.Add("vd_admin_save", "저장", language);

nut.lang.Add("vd_admin_faction_desc", "%s 팩션에게 접근을 허가합니다.", language);
nut.lang.Add("vd_admin_tip", "왼쪽 클릭으로 판매 / 구매, 오른쪽 클릭으로 가격을 정합니다.", language);
nut.lang.Add("vd_sell_desc", "이름: %s\n설명: %s\n%s", language);
nut.lang.Add("vd_admin_ask_price", "이 아이템의 가격은?", language);

// 플러그인, 3D 판넬
nut.lang.Add("3dp_addpanel", "조준점에 3D 판넬을 추가하였습니다.", language);
nut.lang.Add("3dp_removepanle", "%s 개의 3D 판넬을 삭제하였습니다.", language);

// 플러그인 -3D 텍스트
nut.lang.Add("3dt_addtext", "조준점에 3D 텍스트를 추가하였습니다.", language);
nut.lang.Add("3dt_removetext", "%s 개의 3D 텍스트를 삭제하였습니다.", language);

// 플러그인, 모션 추가
nut.lang.Add("act_menu", "모션", language);
nut.lang.Add("act_cant_fallover", "기절한 상태에서는 할 수 없습니다.", language);
nut.lang.Add("act_closewall", "해당 모션은 벽에 기대야 할 수 있습니다.", language);
nut.lang.Add("act_veryfast", "다음 행동을 하기 위해서는 잠시 기다려야 합니다.", language);
nut.lang.Add("act_invoid", "해당 모션은 공중에서 할 수 없습니다.", language);
nut.lang.Add("act_cant_model", "해당 모션은 현재의 캐릭터 모델로 할 수 없습니다.", language);

// 플러그인, 구역
nut.lang.Add("area_area", "구역", language);
nut.lang.Add("area_pointstart", "구역에 끝에 도착한 다음 다시 명령어를 입력하세요.", language);
nut.lang.Add("area_add", "성공적으로 구역을 추가하였습니다.", language);
nut.lang.Add("area_remove", "%s 개의 구역을 삭제하였습니다.", language);

// 플러그인, 맵 장면
nut.lang.Add("ms_add", "성공적으로 맵 장면을 추가하였습니다.", language);
nut.lang.Add("ms_remove", "%s 범위 안의 %s 개의 맵 장면을 삭제하였습니다.", language);

// 플러그인, 영구 저장
nut.lang.Add("ps_saved", "이 엔티티는 이제 저장되는 엔티티입니다.", language);
nut.lang.Add("ps_unsaved", "이 엔티티는 더 이상 저장되는 엔티티가 아닙니다.", language);
nut.lang.Add("ps_isworldentity", "월드 엔티티는 저장할 수 없습니다.", language);

// 플러그인, 스폰 포인트
nut.lang.Add("sp_default", "기본", language);
nut.lang.Add("sp_add_class", "성공적으로 %s 팩션, %s 클래스의 스폰 지점을 추가하였습니다.", language);
nut.lang.Add("sp_add_faction", "성공적으로 %s 팩션의 스폰 지점을 추가하였습니다.", language);
nut.lang.Add("sp_remove", "%s 개의 스폰 지점을 삭제하였습니다.", language);

// 플러그인, 3인칭 시점 추가
nut.lang.Add("tp_name", "3인칭 시점 설정", language);
nut.lang.Add("tp_setting", "3인칭 시점", language);
nut.lang.Add("tp_mousedpi", "마우스 감도", language);
nut.lang.Add("tp_lefthand", "왼손잡이 모드", language);
nut.lang.Add("tp_clasic", "클래식 모드", language);


// 플러그인, 제작
nut.lang.Add("crafting", "제작", language);
nut.lang.Add("norecipes", "이 탭에서 제작 가능한 아이템이 없습니다.", language);

nut.lang.Add("craft_menu_tip1", "초록색 테두리가 쳐진 아이템을 클릭하여 아이템을 조합할 수 있습니다.", language);
nut.lang.Add("craft_menu_tip2", "몇몇 레시피는 특정한 아이템이 있어아 표기됩니다.", language);

nut.lang.Add("crft_text", "제작 : %s\n\n%s\n\n요구 재료\n%s\n결과물\n%s", language);

nut.lang.Add("craftingtable", "작업대", language);
nut.lang.Add("craftingtable_desc", "무언가를 만들기 적합한 작업대입니다.", language);