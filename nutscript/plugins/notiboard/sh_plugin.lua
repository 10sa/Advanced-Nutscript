PLUGIN.name = "게시판 (Noti-Board)"
PLUGIN.author = "Black Tea / 번역자 : Tensa"
PLUGIN.desc = "3D 텍스트와 유사한 판넬을 추가시켜 줍니다."

if SERVER then
	function PLUGIN:LoadData()
		local restored = nut.util.ReadTable("notiboards")

		if (restored) then
			for k, v in pairs(restored) do
				local position = v.position
				local angles = v.angles
				local title  = v.title
				local text = v.text
				local group = v.group

				local entity = ents.Create("nut_notiboard")
				entity:SetPos(position)
				entity:SetAngles(angles)
				entity:Spawn()
				entity:Activate()
				entity:SetNetVar("title", title)
				entity:SetNetVar("text", text)
				entity.group = group

				local physicsObject = entity:GetPhysicsObject();
				if (IsValid(physicsObject)) then
					physicsObject:EnableMotion(false);
					physicsObject:Sleep();
				end

			end
		end
	end

	function PLUGIN:SaveData()
		local data = {}

		for k, v in pairs(ents.FindByClass("nut_notiboard")) do
			data[#data + 1] = {
				position = v:GetPos(),
				angles = v:GetAngles(),
				title = v:GetNetVar("title"),
				text = v:GetNetVar("text"),
				group = v.group
			}
		end

		nut.util.WriteTable("notiboards", data)
	end
end

nut.command.Register({
	syntax = nut.lang.Get("syntax_groupnumber"),
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 450
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity
		local gp = arguments[1] or ""

		if (IsValid(entity) and entity:GetClass() == "nut_notiboard") then
			entity.group = gp
			nut.util.Notify(nut.lang.Get("nb_set_group", gp), client)
		else
			nut.util.Notify(nut.lang.Get("nb_not_notiborad"), client)
		end
	end
}, "notisetgroup")

nut.command.Register({
	syntax = nut.lang.Get("syntax_groupnumber")..nut.lang.Get("syntax_string"),
	adminOnly = true,
	onRun = function(client, arguments)
		if #arguments < 2 then 
			nut.util.Notify(nut.lang.Get("missing_arg", 2), client)
			return
		end
		local gp = arguments[1] or ""
		table.remove(arguments, 1)
		local text = table.concat(arguments, " ")
		local count = 0
		for k, v in pairs(ents.FindByClass("nut_notiboard")) do
			if v.group == gp then
				v:SetNetVar("text", text)
				count = count + 1
			end
		end
		nut.util.Notify(nut.lang.Get("nb_set_group_text", gp, count, text), client)
	end
}, "notisetgrouptext")