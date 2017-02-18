surface.CreateFont("nut_NotiFont", {
	font = "Arial",
	size = 15,
	weight = 450,
	antialias = true
})

local PANEL = {}
PANEL.pnlTypes = {
	[1] = { -- NOT ALLOWED
		col = Color( 200, 60, 60 ),
		icon = "icon16/exclamation.png"
	},
	[2] = { -- COULD BE CANCELED
		col = Color( 255, 100, 100 ),
		icon = "icon16/cross.png"
	},
	[3] = { -- WILL BE CANCELED
		col = Color( 255, 100, 100 ),
		icon = "icon16/cancel.png"
	},
	[4] = { -- TUTORIAL/GUIDE
		col = Color( 161, 180, 184 ),
		icon = "icon16/book.png"
	},
	[5] = { -- ERROR
		col = Color( 220, 200, 110 ),
		icon = "icon16/error.png"
	},
	[6] = { -- YES
		col = Color( 140, 255, 165 ),
		icon = "icon16/accept.png"
	},
	[7] = { -- TUTORIAL/GUIDE
		col = Color( 100, 185, 255 ),
		icon = "icon16/information.png"
	},
}
function PANEL:Init()
	self.type = 1
	self.text = self:Add( "DLabel" )
	self.text:SetFont( "nut_NotiFont" )
	self.text:SetContentAlignment(5)
	self.text:SetTextColor( color_white )
	self.text:SizeToContents()
	self.text:Dock( FILL )
	self.text:DockMargin(2, 2, 2, 2)
	self.text:SetExpensiveShadow(1, Color(25, 25, 25, 150))
	self:SetTall(28)
	
	self.Paint = function(panel, w, h)
		local col = self.pnlTypes[ self.type ].col
		
		draw.RoundedBox(4, 0, 0, w, h, color_black);
		draw.RoundedBox(4, 1, 1, w-2, h-2, col);
		
		self.material = nut.util.GetMaterial(self.pnlTypes[self.type].icon)
		local mat = self.material
		local size = self:GetTall()*.6
		local marg = 3
			if mat then
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( size/2, self:GetTall()/2-size/2 + 1, size, size )
			end
	end	
end
function PANEL:SetType( num )
	self.type = num
	return 
end
function PANEL:SetText( str )
	self.text:SetText( str )
end
function PANEL:SetFont( str )
	self.text:SetFont( str )
end

vgui.Register("nut_NoticePanel", PANEL, "DPanel")