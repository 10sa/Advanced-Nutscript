local PLUGIN = PLUGIN or { };

netstream.Hook("nut_TextRemove", function(index)
	PLUGIN.text[index] = nil
end)

netstream.Hook("nut_TextData", function(data)
	local position = data[1]
	local angle = data[2]
	local text = data[3]
	local scale = data[4]

	local markupText = "<font=nut_ScaledFont>"..string.gsub(text, "\\n", "\n")
	markupText = string.gsub(markupText, "\\t", "\t")
	markupText = markupText.."</font>"
	local markupObj = nut.markup.Parse(markupText)
		function markupObj:DrawText(text, font, x, y, color, hAlign, vAlign, alpha)
			color.a = alpha
			local color2 = Color(0, 0, 0, alpha)

			draw.SimpleTextOutlined(text, font, x, y, color, 0, 1, 2, color2)
		end
	PLUGIN.text[#PLUGIN.text + 1] = {pos = position, angle = angle, text = text, scale = scale, markup = markupObj}
end)

function PLUGIN:PostDrawTranslucentRenderables()
	local position = LocalPlayer():GetPos()

	for i = 1, #self.text do
		local data = self.text[i]

		if (data) then
			local alpha = nut.util.GetAlphaFromDist(position, data.pos, 1024)

			if (alpha > 0) then
				cam.Start3D2D(data.pos, data.angle, data.scale or 0.25)
					data.markup:Draw(0, 0, 1, 1, alpha)
				cam.End3D2D()
			end
		end
	end
end