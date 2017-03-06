local PLUGIN = PLUGIN or { };

PLUGIN.positions = PLUGIN.positions or {}

function PLUGIN:LoadData()
	self.positions = nut.util.ReadTable("scenes")
end

function PLUGIN:SaveData()
	nut.util.WriteTable("scenes", self.positions)
end

function PLUGIN:PlayerLoadedData(client)
	if (#self.positions > 0) then
		local data = table.Random(self.positions)

		netstream.Start(client, "nut_MapScenePos", {data.position, data.angles})

		client:SetNutVar("mapScenePos", data.position)
	end
end

function PLUGIN:SetupPlayerVisibility(client, viewEntity)
	local position = client:GetNutVar("mapScenePos")

	if (!client.character and position) then
		AddOriginToPVS(position)
	end
end