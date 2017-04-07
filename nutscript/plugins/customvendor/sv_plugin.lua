local PLUGIN = PLUGIN or {};

function PLUGIN:LoadData()
	for k, v in pairs(nut.util.ReadTable("vendors")) do
		local position = v.pos
		local angles = v.angles
		local data = v.data
		local factionData = v.factionData
		local classData = v.classData
			
			
		local vendorAction = v.vendorAction
		local buyadjustment = v.buyadjustment
		local money = v.money
			
		local name = v.name
		local desc = v.desc
		local model = v.model

		local entity = ents.Create("nut_vendor")
		entity:SetPos(position)
		entity:SetAngles(angles)
		entity:Spawn()
		entity:Activate()
		entity:SetNetVar("data", data)
		entity:SetNetVar("factiondata", factionData)
		entity:SetNetVar("classdata", classData)
		entity:SetNetVar("name", name)
		entity:SetNetVar("desc", desc)			
			
		entity:SetNetVar("vendoraction", vendorAction)
		entity:SetNetVar("buyadjustment", buyadjustment)
		entity:SetNetVar("money", money)
			
		entity:SetModel(model)
		entity:SetAnim()
	end
end

	
	
function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs(ents.FindByClass("nut_vendor")) do
		data[#data + 1] = {
			pos = v:GetPos(),
			angles = v:GetAngles(),
			data = v:GetNetVar("data", {}),			
			factionData = v:GetNetVar("factiondata", {}),
			classData = v:GetNetVar("classdata", {}),
				
			vendorAction = v:GetNetVar("vendoraction", { sell = true, buy = false} ),
			buyadjustment = v:GetNetVar("buyadjustment", .5),
			money = v:GetNetVar("money", 100),
				
			name = v:GetNetVar("name", "설정되지 않음"),
			desc = v:GetNetVar("desc", nut.lang.Get("no_desc")),
			model = v:GetModel()
		}
	end
	nut.util.WriteTable("vendors", data)
end