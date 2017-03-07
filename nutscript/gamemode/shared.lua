--[[
	Purpose: Provides some utility functions that include core
	gamemode files and prepares schemas.
--]]

local startTime = CurTime()

-- Allows us to use the spawn menu and toolgun.
DeriveGamemode("sandbox")

-- Gamemode variables.
nut.Name = "Adv_Nutscript"
nut.Author = "Tensa"

-- Include and send needed utility functions.
include("sh_util.lua");
AddCSLuaFile("sh_util.lua");

-- More of a config, but a table of models for factions to use be default.
-- We use Model(modelName) because it also precaches them for us.
MALE_MODELS = {
	Model("models/Humans/Group01/Male_01.mdl"),
	Model("models/Humans/Group01/male_02.mdl"),
	Model("models/Humans/Group01/male_03.mdl"),
	Model("models/Humans/Group01/Male_04.mdl"),
	Model("models/Humans/Group01/male_05.mdl"),
	Model("models/Humans/Group01/male_06.mdl"),
	Model("models/Humans/Group01/Male_07.mdl"),
	Model("models/Humans/Group01/male_08.mdl"),
	Model("models/Humans/Group01/male_09.mdl")
}

-- Ditto, except they're men.
FEMALE_MODELS = {
	Model("models/Humans/Group01/Female_01.mdl"),
	Model("models/Humans/Group01/Female_02.mdl"),
	Model("models/Humans/Group01/Female_03.mdl"),
	Model("models/Humans/Group01/Female_04.mdl"),
	Model("models/Humans/Group01/Female_06.mdl"),
	Model("models/Humans/Group01/Female_07.mdl")
}

-- Include translations and configurations.
nut.util.Include("sh_config.lua")
nut.util.Include("sh_translations.lua");

-- Other core directories. The second argument is true since they're in the framework.
-- If they werne't, it'd try to include them from the schema!
nut.util.IncludeDir("libs", true);

nut.util.IncludeDir("kernel/netstreams", true);
nut.util.IncludeDir("kernel", true);

nut.util.IncludeDir("derma", true);
nut.util.IncludeDir("utils", true);

// Load Cached Configs. //
AdvNut.util.LoadCachedConfigs();

function AdvNut.hook.Add(hook, hookIdentifier, doFunction)
	if (CLIENT) then
		hook.Add(hook, AdvNut.util.CreateIdentifier(hookIdentifier, CLIENT), doFunction);
	elseif (SERVER) then
		hook.Add(hook, AdvNut.util.CreateIdentifier(hookIdentifier, SERVER), doFunction);
	else
		Error("Wrong Hook Add.");
	end;
end;

function AdvNut.hook.Run(hook, hookIdentifier, data)
	if (CLIENT) then
		return hook.Run(hook, AdvNut.util.CreateIdentifier(hookIdentifier, CLIENT), data);
	elseif (SERVER) then
		return hook.Run(hook, AdvNut.util.CreateIdentifier(hookIdentifier, SERVER), data);
	else
		Error("Wrong Hook Add.");
	end;
end;

function AdvNut.hook.Remove(hook, hookIdentifier)
	if (CLIENT) then
		hook.Remove(hook, AdvNut.util.CreateIdentifier(hookIdentifier, CLIENT));
	elseif (SERVER) then
		hook.Remov(hook, AdvNut.util.CreateIdentifier(hookIdentifier, SERVER));
	else
		Error("Wrong Hook Add.");
	end;
end;

-- Include commands.
nut.util.Include("sh_commands.lua");

NSFolderName = AdvNut.FolderName

if (!SERVER and game.IsDedicated()) then
	concommand.Remove("gm_save")
	
	concommand.Add("exit", function(client, command, arguments)
		client:ChatPrint("You are not allowed to do that, administrators have been notified.")

		if ((client.nutNextWarn or 0) < CurTime()) then
			local message = client:Name().." ["..client:SteamID().."] has possibly attempted to crash the server with 'gm_save'"

			for k, v in ipairs(player.GetAll()) do
				if (v:IsAdmin()) then
					v:ChatPrint(message)
				end
			end

			MsgC(Color(255, 255, 0), message.."\n")
			client.nutNextWarn = CurTime() + 60
		end
	end)
end
