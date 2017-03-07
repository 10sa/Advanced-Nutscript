local language = "korean";
local PLUGIN = PLUGIN;

PLUGIN:AddPluginLanguage("sr_storage", "저장고", language);
PLUGIN:AddPluginLanguage("sr_usespace", "%s 만큼의 공간 사용 중.", language);
PLUGIN:AddPluginLanguage("sr_locked", "잠겨있는 저장고.", language);
PLUGIN:AddPluginLanguage("sr_move", "옮기기", language);

PLUGIN:AddPluginLanguage("sr_open_desc", "저장고를 엽니다.", language);
PLUGIN:AddPluginLanguage("sr_lock_try", "잠겨진 저장고입니다.", language);

PLUGIN:AddPluginLanguage("sr_lock_desc", "저장고를 잠급니다.", language);
PLUGIN:AddPluginLanguage("sr_lock_itsworld", "월드 저장고는 잠그실 수 없습니다.", language);
	
PLUGIN:AddPluginLanguage("sr_confirmation", "방식 결정", language);
PLUGIN:AddPluginLanguage("sr_lock_type", "어떤 방식의 잠금장치를 사용하시겠습니까?", language);
PLUGIN:AddPluginLanguage("sr_lock_noitem", "그 잠금장치를 소지하고 있지 않습니다.", language);
PLUGIN:AddPluginLanguage("sr_lock_success", "성공적으로 저장고를 잠갔습니다.", language);

PLUGIN:AddPluginLanguage("sr_admin_open", "권한으로 열기", language);
PLUGIN:AddPluginLanguage("sr_admin_open_desc", "잠금을 무시하고 저장고를 엽니다.", language);

PLUGIN:AddPluginLanguage("sr_c_locker_name", "자물쇠", language);
PLUGIN:AddPluginLanguage("sr_c_locker_desc", "열쇠로 열 수 있는 잠금장치입니다.", language);

PLUGIN:AddPluginLanguage("sr_d_locker_name", "전자식 비밀번호 패드", language);
PLUGIN:AddPluginLanguage("sr_d_locker_desc", "4자리 비밀번호식 잠금장치입니다.", language);
PLUGIN:AddPluginLanguage("sr_enter_password", "비밀번호를 입력하세요.", language);
PLUGIN:AddPluginLanguage("sr_wrong_password", "잘못된 비밀번호입니다.", language);

PLUGIN:AddPluginLanguage("sr_key_name", "열쇠", language);
PLUGIN:AddPluginLanguage("sr_key_desc", "잠긴 자물쇠를 열때 사용합니다.", language);

PLUGIN:AddPluginLanguage("sr_world_container", "이 저장고는 이제 유저 생성 저장고입니다.", language);
PLUGIN:AddPluginLanguage("sr_user_container", "이 저장고는 이제 유저 생성 저장고입니다.", language);

PLUGIN:AddPluginLanguage("sr_set_password", "%s 로 비밀번호를 설정하였습니다.", language);
PLUGIN:AddPluginLanguage("sr_lock_unlocked", "이 저장고의 잠금을 해제하셨습니다.", language);

PLUGIN:AddPluginLanguage("sr_lock_locked", "이미 잠겨져 있는 저장고입니다.", language);
PLUGIN:AddPluginLanguage("sr_notstorage", "잘못된 저장고입니다.", language);