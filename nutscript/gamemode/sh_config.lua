--[[
	Purpose: Creates a table of configuration values that are to help make customization
	of Nutscript easier.
--]]

-- We don't want clients to get our database information.
if (SERVER) then
	-- Include server-side configurations like database information.
	nut.util.Include("sv_config.lua");
end

nut.util.Include("libs/sh_config.lua");

// Don't Touch This, This's Version Counter. //
nut.config.Register("frameworkVersion", "Dev-0.21a");

-- What language Nutscript shall use.
nut.config.Register("language", "korean");

-- 기본 화면에서 스체마의 이름과 설명을 사용할 것인지에 대한 여부입니다.
-- false 시 sh_korean.lua 의 "charMenuTitle", "charMenuDesc" 를 가져다 사용합니다.
nut.config.Register("prefixTitle", false);

-- Website!
nut.config.Register("website", "http://steamcommunity.com/groups/Advanced_Nutscript");

-- The default walk speed.
nut.config.Register("walkSpeed", 90);

-- The default run speed.
nut.config.Register("runSpeed", 200);

nut.config.Register("staminaValue", 5);

-- Weapons that are always raised and able to shoot.
nut.config.Register("alwaysRaised", {
	weapon_physgun, true,
	gmod_tool, true
});

-- 기본 설정의 문을 저장 하는지에 대한 여부.
nut.config.Register("saveDefaultDoor", false);

-- 배고픔 / 목마름 수치가 낮을시 행동하는 여부.
nut.config.Register("statusMeActions", true);

-- 배고픔 / 목마름 닳는 속도 (초)
nut.config.Register("hungerRestore", 120);
nut.config.Register("thristRestore", 100);

-- 스테미너의 회복량 입니다.
nut.config.Register("staminaRestore", 1);

-- 인터페이스의 색상값입니다.
nut.config.Register("colorIntervalValue", 0.5);

nut.config.Register("iconSize", 64);

-- 일반 유저가 스폰 매뉴 (Q)를 열수 있는지에 대한 여부.
nut.config.Register("userCanOpenSpawnMenu", false);

-- 클레스 메뉴의 활성화 여부. (클레스 기능을 끄는게 아님)
nut.config.Register("classmenuEnabled", false);

-- 사업 메뉴의 활성화 여부.
nut.config.Register("businessEnabled", false);

-- 플레이어 목록에 보이지 않게할 팩션.
-- 예제 : FACTION_CITIZEN, FACTION_CP 팩션을 보이지 않게함.
--[[ 
	nut.config.Register(dontshowfactions, { FACTION_CITIZEN, FACTION_CP } 
]]
nut.config.Register("dontshowfactions", {});

-- 프레임워크의 폼의 뒷배경 색상입니다.
nut.config.Register("panelBackgroundColor", color_white);

-- If set to true, holding your reload key will toggleraise.
nut.config.Register("holdReloadToToggle", true);

-- If set to true, nut will register its default attributes.
nut.config.Register("baseAttributes", true);

-- How many seconds must the player hold reload for to toggleraise.
nut.config.Register("holdReloadTime", 0.8);

-- How often database saving should occur for players (in seconds)
nut.config.Register("saveInterval", 600);

-- How wide menus in the F1 menu are. This is a ratio for the screen's width. (0.5, half of the screen's width)
nut.config.Register("menuWidth", 0.7);

-- How tall menus in the F1 menu are. This is a ratio for the screen's height. (0.5, half the screen's height)
nut.config.Register("menuHeight", 0.8);

-- The main color scheme for buttons and such.
nut.config.Register("mainColor", Color(145, 145, 145));

-- Minimum amount of characters for a description.
nut.config.Register("descMinChars", 8);

nut.config.Register("nameMinChars", 3);

-- How many attribute points a player gets when creating a character.
nut.config.Register("startingPoints", 20);

-- Caps attribute points a player gets when a character is gaining attribute experience.
nut.config.Register("maximumPoints", 100);

-- The maximum distance in Source units to hear someone whispering.
nut.config.Register("whisperRange", 160);

-- The maximum distance in Source units to hear someone talk.
nut.config.Register("chatRange", 540);

-- The maximum distance in Source units to hear someone yell.
nut.config.Register("yellRange", 720);

-- The text color for game messages like joining/leaving or console text.
-- Uses a color object which goes red, green, blue. Each ranges from 0 to 255.
nut.config.Register("gameMsgColor", Color(230, 230, 230));

-- How loud the menu music is out of 100.
nut.config.Register("menuMusicVol", 40);

-- What the actual menu music is. It can be a URL or game sound. Set to false if you
-- do not want any menu music. This can also be overwritten by the schema.
nut.config.Register("menuMusic", false);

-- How long it takes in seconds for the menu music to fade out.
nut.config.Register("menuMusicFade", 15);

-- The starting weight for inventories.
nut.config.Register("defaultInvWeight", 20);

-- Shows what other people are typing.
-- If set to false, it'll just show Typing... above someone's head when they are.
-- Setting it to true MIGHT cause a little network strain, depending on how many players there are.
nut.config.Register("showTypingText", true);

-- The maximum number of characters.
nut.config.Register("maxChars", 4);

-- The delay between which someone can buy something.
nut.config.Register("buyDelay", 1);

-- The maximum number of characters in a chat message.
nut.config.Register("maxChatLength", 500);

-- The initial date that is used by the time system.
nut.config.Register("dateStartMonth", 10);
nut.config.Register("dateStartDay", 7);
nut.config.Register("dateStartYear", 2033);

-- If true, then you can't have multiple rifles, pistols, etc...
nut.config.Register("noMultipleWepSlots", true);

-- The maximum number of characters in a name.
nut.config.Register("maxNameLength", 70);

-- The maximum number of characters in a description.
nut.config.Register("maxDescLength", 240);

-- How many seconds are in a minute.
nut.config.Register("dateMinuteLength", 60);

nut.config.Register("introFadeTime", 7);

if (CLIENT) then
	-- Whether or not the money is shown in the side menu.
	nut.config.Register("showMoney", true);

	-- Whether or not the time is shown in the side menu.
	nut.config.Register("showTime", true);

	-- If set to false, then color correction will not be enabled.
	nut.config.Register("sadColors", true);

	-- Whether or not to enable the crosshair.
	nut.config.Register("crosshair", false);

	-- The dot size of the crosshair.
	nut.config.Register("crossSize", 1);

	-- The amount of spacing beween each crosshair dot in pixels.
	nut.config.Register("crossSpacing", 6);

	-- How 'see-through' the crosshair is from 0-255, where 0 is invisible and 255 is fully
	-- visible.
	nut.config.Register("crossAlpha", 150);
	
	nut.config.Register("targetTall", 0);
	
	AdvNut.hook.Add("SchemaInitialized", "nut_FontConfig", function()
		surface.SetFont("nut_TargetFontSmall")

		_, tall = surface.GetTextSize("W");
		nut.config.Set("targetTall", tall);

		if (nut.config.Get("targetTall")) then
			nut.config.Set("targetTall", nut.config.Get("targetTall") + 2);
		end

		nut.config.Set("targetTall", nut.config.Get("targetTall") or 10);
	end)
end
