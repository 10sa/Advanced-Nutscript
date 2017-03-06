local PLUGIN = PLUGIN or { };

function PLUGIN:PlayerLoadedData(client)
	for k, v in pairs(self.panels) do
		netstream.Start(client, "nut_PanelData", {v.pos, v.angle, v.url, v.w, v.h, v.scale})
	end
end

function PLUGIN:AddPanel(client, url, w, h, scale)
	local trace = client:GetEyeTraceNoCursor()
	local data = {
		pos = trace.HitPos + trace.HitNormal,
		angle = trace.HitNormal:Angle(),
		url = url,
		w = w,
		h = h,
		scale = scale or 0.25
	}
	data.angle:RotateAroundAxis(data.angle:Up(), 90)
	data.angle:RotateAroundAxis(data.angle:Forward(), 90)

	self.panels[#self.panels + 1] = data
	self:SaveData()

	netstream.Start(nil, "nut_PanelData", {data.pos, data.angle, data.url, data.w, data.h, data.scale})
end

function PLUGIN:SaveData()
	self:WriteTable(self.panels)
end

function PLUGIN:LoadData()
	self.panels = self:ReadTable()
end

function PLUGIN:Remove(position, radius)
	local i = 0

	for k, v in pairs(self.panels) do
		if (v.pos:Distance(position) <= radius) then
			netstream.Start(nil, "nut_PanelRemove", k)

			self.panels[k] = nil
			i = i + 1
		end
	end

	return i
end