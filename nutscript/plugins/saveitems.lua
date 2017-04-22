PLUGIN.name = "아이템 저장 (Save Items)"
PLUGIN.desc = "월드에 존재하는 아이템을 저장해 줍니다."
PLUGIN.author = "Chessnut / 번역자 : Tensa"
PLUGIN.base = true;

if (SERVER) then
	function PLUGIN:LoadData()
		local restored = nut.util.ReadTable("saveditems")

		if (restored) then
			for k, v in pairs(restored) do
				local position = v.position
				local angles = v.angles
				local itemTable = nut.item.Get(v.uniqueID)
				local data = v.data

				if itemTable then
					local entity = nut.item.Spawn(position, angles, itemTable, data)

					AdvNut.hook.Run("ItemRestored", itemTable, entity)
				end
			end
		end
	end

	function PLUGIN:SaveData()
		local data = {}
		for k, v in pairs(ents.FindByClass("nut_item")) do
			if(v:GetPersistent()) then
				v:SetPersistent(false);
			end;
			
			if (AdvNut.hook.Run("ItemShouldSave", v) != false) then
				data[k] = {
					position = v:GetPos(),
					angles = v:GetAngles(),
					uniqueID = v:GetItemTable().uniqueID,
					data = v:GetData()
				}

				AdvNut.hook.Run("ItemSaved", v)
			end
		end
		nut.util.WriteTable("saveditems", data)
	end
end
