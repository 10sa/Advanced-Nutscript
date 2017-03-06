local PLUGIN = PLUGIN or { };

netstream.Hook("nut_PlayerEnterArea", function(data)
	hook.Run("PlayerEnterArea", data)
end)