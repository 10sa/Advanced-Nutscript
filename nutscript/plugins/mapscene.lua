local PLUGIN = PLUGIN
PLUGIN.name = "맵 장면 (Map Scenes)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "메뉴에서 맵의 한 장면을 볼수 있게 해 줍니다."

if (CLIENT) then
	netstream.Hook("nut_MapScenePos", function(data)
		PLUGIN.position = data[1]
		PLUGIN.angles = data[2]
	end)

	function PLUGIN:CalcView(client, origin, angles, fov)
		if (PLUGIN.position and PLUGIN.angles and IsValid(nut.gui.charMenu)) then
			local view = {}
			view.origin = PLUGIN.position
			view.angles = PLUGIN.angles

			return view
		end
	end
else
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
end

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {
			position = client:EyePos(),
			angles = client:EyeAngles()
		}

		table.insert(PLUGIN.positions, data)
		netstream.Start(nil, "nut_MapScenePos", {data.position, data.angles})

		PLUGIN:SaveData()
		nut.util.Notify(nut.lang.Get("ms_add"), client)
	end
}, "mapsceneadd")

nut.command.Register({
	adminOnly = true,
	syntax = nut.lang.Get("syntax_radius"),
	onRun = function(client, arguments)
		local range = tonumber(arguments[1] or "160") or 160
		local count = 0

		for k, v in pairs(PLUGIN.positions) do
			if (v.position:Distance(client:GetPos()) <= range) then
				count = count + 1

				table.remove(PLUGIN.positions, k)
			end
		end

		if (count > 0) then
			PLUGIN:SaveData()
		end

		nut.util.Notify(nut.lang.Get("ms_remove", range, count), client)
	end
}, "mapsceneremove")
