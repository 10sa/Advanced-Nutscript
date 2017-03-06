nut.chat.Register("broadcast", {
	onChat = function(speaker, text)
		surface.PlaySound( "ambient/levels/prison/radio_random" .. math.random( 1, 9 ) ..".wav" )
		if (LocalPlayer() != speaker and speaker:GetPos():Distance(LocalPlayer():GetPos()) <= nut.config.chatRange) then
			chat.AddText(Color(255, 100, 100), PLUGIN:GetPluginLanguage("chat_broadcast",speaker:Name()).."\""..text.."\"")
		else
			chat.AddText(Color(180, 0, 0), PLUGIN:GetPluginLanguage("chat_broadcast",speaker:Name()).."\""..text.."\"")
		end
	end,
	prefix = { "/broadcast", "/ㅠ", "/방송", "/b" },
	canHear = function(speaker, listener)
		return true
	end,
	canSay = function(speaker)
	
		for k, v in pairs( ents.FindInSphere( speaker:GetPos(), 128 ) ) do
			if v:GetClass() == "nut_bdcast" and v:GetNetVar( "active" ) then
				return true
			end
		end
		nut.util.Notify(PLUGIN:GetPluginLanguage("bc_machine_notactive"), speaker)
		
	end,
	font = "nut_ChatFontRadio"
});