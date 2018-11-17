--[[
	Purpose: Creates a table of configuration values that are to help make customization
	of Nutscript easier.
--]]

nut.util.Include("libs/sh_config.lua");

nut.util.Include("sv_config.lua");
nut.util.Include("cl_config.lua");

// Don't Touch This, This's Version Counter. //
nut.config.Register("frameworkVersion", "Dev-0.21a", SHARE);

-- What language Nutscript shall use.
nut.config.Register("language", "korean", SHARE);

-- 기본 화면에서 스체마의 이름과 설명을 사용할 것인지에 대한 여부입니다.
-- false 시 sh_korean.lua 의 "charMenuTitle", "charMenuDesc" 를 가져다 사용합니다.
nut.config.Register("prefixTitle", false, SHARE);

-- Website!
nut.config.Register("website", "http://steamcommunity.com/groups/Advanced_Nutscript", SHARE);

-- The default walk speed.
nut.config.Register("walkSpeed", 90, SHARE);

-- The default run speed.
nut.config.Register("runSpeed", 200, SHARE);

nut.config.Register("staminaValue", 5, SHARE);

-- Weapons that are always raised and able to shoot.
nut.config.Register("alwaysRaised", {
	weapon_physgun = true,
	gmod_tool = true
}, SHARE);

-- 기본 설정의 문을 저장 하는지에 대한 여부.
nut.config.Register("saveDefaultDoor", false, SHARE);

-- 배고픔 / 목마름 수치가 낮을시 행동하는 여부.
nut.config.Register("statusMeActions", true, SHARE);

-- 배고픔 / 목마름 닳는 속도 (초)
nut.config.Register("hungerRestore", 1200, SHARE);
nut.config.Register("thristRestore", 1000, SHARE);

-- 스테미너의 회복량 입니다.
nut.config.Register("staminaRestore", 1, SHARE);

-- 인터페이스의 색상값입니다.
nut.config.Register("colorIntervalValue", 0.5, SHARE);

nut.config.Register("iconSize", 64, SHARE);

-- 일반 유저가 스폰 매뉴 (Q)를 열수 있는지에 대한 여부.
nut.config.Register("userCanOpenSpawnMenu", false, SHARE);

-- 클레스 메뉴의 활성화 여부. (클레스 기능을 끄는게 아님)
nut.config.Register("classmenuEnabled", false, SHARE);

-- 사업 메뉴의 활성화 여부.
nut.config.Register("businessEnabled", false, SHARE);

-- 플레이어 목록에 보이지 않게할 팩션.
-- 예제 : FACTION_CITIZEN, FACTION_CP 팩션을 보이지 않게함.
--[[ 
	nut.config.Register(dontshowfactions, { FACTION_CITIZEN, FACTION_CP } 
]]
nut.config.Register("dontshowfactions", {}, SHARE);

-- 프레임워크의 폼의 뒷배경 색상입니다.
nut.config.Register("panelBackgroundColor", color_white, SHARE);

-- If set to true, holding your reload key will toggleraise.
nut.config.Register("holdReloadToToggle", true, SHARE);

-- If set to true, nut will register its default attributes.
nut.config.Register("baseAttributes", true, SHARE);

-- How many seconds must the player hold reload for to toggleraise.
nut.config.Register("holdReloadTime", 0.8, SHARE);

-- How often database saving should occur for players (in seconds)
nut.config.Register("saveInterval", 600, SHARE);

-- How wide menus in the F1 menu are. This is a ratio for the screen's width. (0.5, half of the screen's width)
nut.config.Register("menuWidth", 0.7, SHARE);

-- How tall menus in the F1 menu are. This is a ratio for the screen's height. (0.5, half the screen's height)
nut.config.Register("menuHeight", 0.8, SHARE);

-- The main color scheme for buttons and such.
nut.config.Register("mainColor", Color(145, 145, 145), SHARE);

-- Minimum amount of characters for a description.
nut.config.Register("descMinChars", 8, SHARE);

nut.config.Register("nameMinChars", 3, SHARE);

-- How many attribute points a player gets when creating a character.
nut.config.Register("startingPoints", 20, SHARE);

-- Caps attribute points a player gets when a character is gaining attribute experience.
nut.config.Register("maximumPoints", 100, SHARE);

-- The maximum distance in Source units to hear someone whispering.
nut.config.Register("whisperRange", 160, SHARE);

-- The maximum distance in Source units to hear someone talk.
nut.config.Register("chatRange", 540, SHARE);

-- The maximum distance in Source units to hear someone yell.
nut.config.Register("yellRange", 720, SHARE);

-- The text color for game messages like joining/leaving or console text.
-- Uses a color object which goes red, green, blue. Each ranges from 0 to 255.
nut.config.Register("gameMsgColor", Color(230, 230, 230), SHARE);

-- How loud the menu music is out of 100.
nut.config.Register("menuMusicVol", 40, SHARE);

-- What the actual menu music is. It can be a URL or game sound. Set to false if you
-- do not want any menu music. This can also be overwritten by the schema.
nut.config.Register("menuMusic", false, SHARE);

-- How long it takes in seconds for the menu music to fade out.
nut.config.Register("menuMusicFade", 15, SHARE);

-- The starting weight for inventories.
nut.config.Register("defaultInvWeight", 20, SHARE);

-- Shows what other people are typing.
-- If set to false, it'll just show Typing... above someone's head when they are.
-- Setting it to true MIGHT cause a little network strain, depending on how many players there are.
nut.config.Register("showTypingText", true, SHARE);

-- The maximum number of characters.
nut.config.Register("maxChars", 1, SHARE);

-- The delay between which someone can buy something.
nut.config.Register("buyDelay", 1, SHARE);

-- The maximum number of characters in a chat message.
nut.config.Register("maxChatLength", 500, SHARE);

-- The initial date that is used by the time system.
nut.config.Register("dateStartMonth", 10, SHARE);
nut.config.Register("dateStartDay", 7, SHARE);
nut.config.Register("dateStartYear", 2033, SHARE);

-- If true, then you can't have multiple rifles, pistols, etc...
nut.config.Register("noMultipleWepSlots", true, SHARE);

-- The maximum number of characters in a name.
nut.config.Register("maxNameLength", 70, SHARE);

-- The maximum number of characters in a description.
nut.config.Register("maxDescLength", 240, SHARE);

-- How many seconds are in a minute.
nut.config.Register("dateMinuteLength", 60, SHARE);

nut.config.Register("introFadeTime", 7, SHARE);