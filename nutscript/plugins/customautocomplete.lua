local PLUGIN = PLUGIN
PLUGIN.name = "자동 완성 (AdvNS Custom Auto-complete)"
PLUGIN.author = "Tensa / Atebite and Chessnut"
PLUGIN.desc = "기존 플러그인을 커스텀한 자동 환성 기능을 추가합니다."

if (CLIENT) then
	local chatText = ""
	local textColor = Color(231, 231, 231)
	local outline = Color(0, 0, 0, 150)
	
	function PLUGIN:HUDPaint()
		local frame = nut.chat.panel.frame
		local contentFrame = nut.chat.panel.content;

		if (IsValid(frame) and LocalPlayer():IsTyping()) then
			if (chatText:sub(1, 1) == "/" and chatText:sub(1, 2) != "//") then
				local spacer = 0
				local counter = 0
				local x, y = frame:GetPos()
				local tall = frame:GetTall()
				local mainColor = nut.config.mainColor
				local color = Color(mainColor.r, mainColor.g, mainColor.b)

				for k, v in SortedPairs(nut.command.buffer) do
					local k2 = "/"..k
					
					for index, message in pairs(nut.chat.messages) do
						message:SetAlpha(50);
					end;

					if (k2:find(chatText:sub(1, #k2):lower()) and counter < 4) then
						local x2, y2 = x + 9, (y + tall - 20) + spacer
						local w = draw.SimpleTextOutlined(k2.." ", "nut_BoldChatFont", x2, y2, color, 0, 0, 1, outline)
						draw.SimpleTextOutlined(v.syntax or "[none]", "nut_BoldChatFont", x2 + w, y2, textColor, 0, 0, 1, outline)

						spacer = spacer - 17
						counter = counter + 1
					end
				end
			end;
		end
	end

	function PLUGIN:ChatTextChanged(text)
		chatText = text
	end

	function PLUGIN:FinishChat()
		chatText = ""
	end
end
