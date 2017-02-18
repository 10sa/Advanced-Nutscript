BASE.name = "Alcohol Base"
BASE.amount = 0.2
BASE.time = 180
BASE.category = nut.lang.Get("alcohol")
BASE.functions = {}
BASE.junk = ""
BASE.functions.Use = {
	text = nut.lang.Get("drinking"),
	run = function(item)
		if (CLIENT) then return end
		
		local client = item.player
		client:SetNetVar("drunk", client:GetNetVar("drunk", 0) + item.amount)

		timer.Simple(item.time, function()
			if (IsValid(client)) then
				client:SetNetVar("drunk", math.max(client:GetNetVar("drunk", 0) - item.amount, 0))
			end
		end)
		client:UpdateInv( item.junk, 1 )
	end
}
