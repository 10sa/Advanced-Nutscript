local PLUGIN = PLUGIN or { };

netstream.Hook("nut_PlayerEnterArea", function(data)
	AdvNut.hook.Run("PlayerEnterArea", data)
end)