--[[
	Purpose: The framework needs to define this so the schemas can reference
	the framework without GM.BaseClass since it the baseclass is not defined in time.
--]]

resource.AddWorkshop("207739713");
resource.AddWorkshop("589615668");
resource.AddWorkshop("865625406");

local startTime = SysTime();

include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

if (string.lower(GetConVarString("gamemode")) == "nutscript") then
	MsgC(Color(255, 0, 0), "FATAL WARNING! CHANGE +GAMEMODE TO YOUR SCHEMA, NOT NUTSCRIPT!\n")

	local _, gamemodes = file.Find("gamemodes/*", "GAME")

	for k, v in pairs(gamemodes) do
		local files = file.Find("gamemodes/"..v.."/*.txt", "GAME")

		for k2, v2 in pairs(files) do
			local contents = string.lower(file.Read("gamemodes/"..v.."/"..v2, "GAME"))

			if (string.find(string.lower(contents), [["base"(%s+)"nutscript"]])) then
				MsgC(Color(255, 255, 0), "FOUND SCHEMA '"..v.."'\n")
				game.ConsoleCommand("gamemode "..v.."\n")
				game.ConsoleCommand("bot\n")

				AdvNut.hook.Add("Think", "nut_ChangeLevel", function()
					MsgC(Color(255, 255, 0), "CHANGING MAP TO INITIALIZE THE '"..v.."' SCHEMA...\n")
					game.ConsoleCommand("changelevel "..game.GetMap().."\n")
				end)
			end
		end
	end

	return
end

MsgC(Color(0, 255, 0), "[Advanced Nutscript] "..math.Round(SysTime() - startTime, 3).. " second(s) to initialize.\n");