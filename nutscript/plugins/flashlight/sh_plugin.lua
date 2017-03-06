PLUGIN.name = "손전등 (Flashlight)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "F키를 이용한 손전등을 추가시켜 줍니다."

function PLUGIN:PlayerSwitchFlashlight(client, state)
	if (state and !client:HasItem("flashlight")) then
		return false
	end

	return true
end

AdvNut.util.PluginIncludeDir("language", PLUGIN.uniqueID, true);