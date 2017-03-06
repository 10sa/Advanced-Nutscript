local PLUGIN = PLUGIN or { };

PLUGIN.areas = PLUGIN.areas or {}

timer.Create("nut_AreaManager", 1, 0, function()
	local areas = PLUGIN.areas

	if (#areas > 0) then
		for k = 1, #areas do
			local v = areas[k]
			local entities = ents.FindInBox(v.min, v.max)

			for k2, v2 in pairs(entities) do
				if (IsValid(v2) and v2:IsPlayer() and v2.character and v2:GetNetVar("area", "") != v.name) then
					v2:SetNetVar("area", v.name)

					hook.Run("PlayerEnterArea", v2, v, entities)
					netstream.Start(nil, "nut_PlayerEnterArea", v2)
				end
			end
		end
	end
end)

function PLUGIN:PlayerEnterArea(client, area)
	local text = area.name

	if (area.showTime) then
		text = text..", "..os.date("!%X", nut.util.GetTime()).."."
	end

	nut.scroll.Send(text, client)
end

function PLUGIN:LoadData()
	self.areas = nut.util.ReadTable("areas")
end

function PLUGIN:SaveData()
	nut.util.WriteTable("areas", self.areas)
end