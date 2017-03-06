local PLUGIN = PLUGIN or { };

netstream.Hook("nut_PanelRemove", function(index)
	PLUGIN.panels[index] = nil
end)

netstream.Hook("nut_PanelData", function(data)
	local position = data[1]
	local angle = data[2]
	local url = data[3]
	local w = data[4]
	local h = data[5]
	local scale = data[6]

	local panel = vgui.Create("DHTML")
	panel:SetSize(w, h)
	panel:SetMouseInputEnabled(false)
	panel:OpenURL(url)
	panel:SetPaintedManually(true)

	PLUGIN.panels[#PLUGIN.panels + 1] = {pos = position, angle = angle, panel = panel, scale = scale}
end)

function PLUGIN:PostDrawTranslucentRenderables()
	local position = LocalPlayer():GetPos()

	for i = 1, #self.panels do
		local data = self.panels[i]

		if (data and IsValid(data.panel)) then
			cam.Start3D2D(data.pos, data.angle, data.scale or 0.25)
				data.panel:SetPaintedManually(false)
					data.panel:PaintManual()
				data.panel:SetPaintedManually(true)
			cam.End3D2D()
		end
	end
end