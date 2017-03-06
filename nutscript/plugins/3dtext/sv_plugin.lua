local PLUGIN = PLUGIN or { };

function PLUGIN:PlayerLoadedData(client)
	for k, v in pairs(self.text) do
		netstream.Start(client, "nut_TextData", {v.pos, v.angle, v.text, v.scale})
	end
end

function PLUGIN:AddText(client, text, scale)
	local trace = client:GetEyeTraceNoCursor()
	local data = {
		pos = trace.HitPos + trace.HitNormal,
		angle = trace.HitNormal:Angle(),
		text = text,
		scale = math.max(math.abs(scale or 0.25), 0.005)
	}
	data.angle:RotateAroundAxis(data.angle:Up(), 90)
	data.angle:RotateAroundAxis(data.angle:Forward(), 90)

	self.text[#self.text + 1] = data

	netstream.Start(nil, "nut_TextData", {data.pos, data.angle, data.text, data.scale})
end

function PLUGIN:SaveData()
	nut.util.WriteTable("3dtext", self.text)
end

function PLUGIN:LoadData()
	self.text = nut.util.ReadTable("3dtext")
end

function PLUGIN:Remove(position, radius)
	local i = 0
	for k, v in pairs(self.text) do
		if (v.pos:Distance(position) <= radius) then
			netstream.Start(nil, "nut_TextRemove", k)
			self.text[k] = nil
			i = i + 1
		end
	end
	
	return i
end