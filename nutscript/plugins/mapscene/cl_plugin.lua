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