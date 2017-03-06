nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local position = client:GetEyeTraceNoCursor().HitPos
		local angles = client:EyeAngles()
		angles.p = 0
		angles.y = angles.y - 180

		local entity = ents.Create("nut_vendor")
		entity:SetPos(position)
		entity:SetAngles(angles)
		entity:Spawn()
		entity:Activate()

		PLUGIN:SaveData()

		nut.util.Notify("성공적으로 상인을 생성하였습니다.", client)
	end
}, "vendoradd")


nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if (IsValid(entity) and entity:GetClass() == "nut_vendor") then
			entity:Remove()

			PLUGIN:SaveData()

			nut.util.Notify("성공적으로 상인을 삭제하였습니다.", client)
		else
			nut.util.Notify("당신은 상인을 바라보고 있지 않습니다.", client)
		end
	end
}, "vendorremove")
