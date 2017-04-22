local PLUGIN = PLUGIN
PLUGIN.name = "스폰 포인트 (Spawn Points)"
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.desc = "스폰 포인트의 설정을 가능하게 합니다."
PLUGIN.points = PLUGIN.points or {}
PLUGIN.base = true;
PLUGIN:IncludeDir("language");

function PLUGIN:LoadData()
	self.points = self:ReadTable()
end

function PLUGIN:SaveData()
	self:WriteTable(self.points)
end

function PLUGIN:ChooseSpawn(client, spawns)
	if (#spawns > 0) then
		local data = table.Random(spawns)

		client:SetPos(data.pos)
		client:SetEyeAngles(data.ang)
	end
end

function PLUGIN:PlayerSpawn(client)
	timer.Simple(0.1, function()
		if (!IsValid(client)) then
			return
		end

		local faction = client:Team()
		local class = client:CharClass()
		local spawns = {}

		if (class) then
			for k, v in pairs(self.points) do
				if (v.faction == faction and v.class == class) then
					spawns[#spawns + 1] = v
				end
			end

			if (#spawns > 0) then
				return self:ChooseSpawn(client, spawns)
			end
		end

		for k, v in pairs(self.points) do
			if (v.faction == faction) then
				spawns[#spawns + 1] = v
			end
		end

		if (#spawns < 1) then
			for k, v in pairs(self.points) do
				if (!v.faction) then
					spawns[#spawns + 1] = v
				end
			end
		end

		self:ChooseSpawn(client, spawns)
	end)
end

nut.util.Include("sh_commands.lua");