--[[
	Purpose: The framework needs to define this so the schemas can reference
	the framework without AdvNut.BaseClass since it the baseclass is not defined in time.
--]]

-- Set this since self.BaseClass for schemas aren't created in time.
AdvNut = AdvNut or GM;
nut = AdvNut or GM;

-- A table of vgui elements. This is useful to keep track of stuff or if you can run clientside lua
-- and get a menu stuck on your screen. Happens a lot during development.
nut.gui = nut.gui or {};
AdvNut.gui = AdvNut.gui or {};

-- Include shared.lua since it is very important.
include("shared.lua")

-- Create out fonts here that are going to be used.

-- Quick variable to change all the fonts.
local mainFont = "Segoe UI"
local subFont = "Arial";

surface.CreateFont("nut_TitleFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(48),
	weight = 1000,
	antialias = true
})

surface.CreateFont("nut_SubTitleFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(20),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_ScoreTeamFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(7),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_HeaderFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(18),
	weight = 1000,
	antialias = true
})

surface.CreateFont("nut_MenuButtonFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(9),
	weight = 600,
	antialias = true
})

surface.CreateFont("nut_BigMenuButtonFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(9),
	weight = 600,
	antialias = true
})

surface.CreateFont("nut_BigThinFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(11),
	weight = 1000,
	antialias = true
})

surface.CreateFont("nut_TargetFont", {
	font = subFont,
	size = AdvNut.util.GetScreenScaleFontSize(10),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_PingFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(5),
	weight = 1000,
	antialias = true
})

surface.CreateFont("nut_TargetFontSmall", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(8),
	weight = 800,
	antialias = true
})

surface.CreateFont("nut_WhisperFont", {
	font = subFont,
	size = AdvNut.util.GetScreenScaleFontSize(6),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_ChatFont", {
	font = subFont,
	size = AdvNut.util.GetScreenScaleFontSize(7.5),
	weight = 500,
	antialias = true,
})

surface.CreateFont("nut_BoldChatFont", {
	font = subFont,
	size = AdvNut.util.GetScreenScaleFontSize(7.5),
	weight = 700,
	antialias = true,
})

surface.CreateFont("nut_YellFont", {
	font = subFont,
	size = AdvNut.util.GetScreenScaleFontSize(10),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_ChatFontAction", {
	font = subFont,
	size = AdvNut.util.GetScreenScaleFontSize(7.5),
	weight = 500,
	italic = true,
	antialias = true
})

surface.CreateFont("nut_ScaledFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(150),
	weight = 1000
})

surface.CreateFont("nut_infoname", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(10),
	weight = 1000,
	antialias = true
})

surface.CreateFont("nut_infodesc", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(20),
	weight = 1000,
	antialias = true
})

surface.CreateFont("nut_infodesc_s", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(7),
	weight = 500,
	antialias = true
})

surface.CreateFont("AdvNut_EntityTitle", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(9),
	weight = 700,
	antialias = true
})

surface.CreateFont("AdvNut_EntityDesc", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(9),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_SmallFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(7),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_MediumFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(9),
	weight = 500,
	antialias = true
})

surface.CreateFont("nut_LargeFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(14),
	weight = 500,
	antialias = true
})

surface.CreateFont("AdvNut_3D2DTitleFont", { 
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(32),
	weight = 700,
	antialias = true,
	additive = false
})

surface.CreateFont("AdvNut_3D2DDescFont", {
	font = mainFont,
	size = AdvNut.util.GetScreenScaleFontSize(20),
	weight = 500,
	antialias = true
})

timer.Destroy("HintSystem_OpeningMenu")
timer.Destroy("HintSystem_Annoy1")
timer.Destroy("HintSystem_Annoy2")

if (!nut.localPlayerValid) then
	AdvNut.hook.Add("Think", "nut_WaitForLocalPlayer", function()
		if (IsValid(LocalPlayer())) then
			netstream.Start("nut_LocalPlayerValid")
			hook.Remove("Think", "nut_WaitForLocalPlayer")
		end
	end)

	nut.localPlayerValid = true
end
