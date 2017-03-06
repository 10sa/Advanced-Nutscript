ITEM.name = PLUGIN:GetPluginLanguage("fl_flashlight_name")
ITEM.uniqueID = "flashlight"
ITEM.model = Model("models/maxofs2d/lamp_flashlight.mdl")
ITEM.desc = PLUGIN:GetPluginLanguage("fl_flashlight_desc")

if (SERVER) then
	ITEM:Hook("Drop", function(itemTable, client)
		if (client:FlashlightIsOn()) then
			client:Flashlight(false)
		end
	end)
end