local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent",	"IsMenu",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable",		"Draggable",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",			"Sizable",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",		"ScreenLock",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",	"DeleteOnClose",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow",		"PaintShadow",		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth", "MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight", "MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur", "BackgroundBlur", FORCE_BOOL )

function PANEL:Init()
	self:SetFocusTopLevel( true )
	self:SetPaintShadow( true )
	AdvNut.util.DrawRoundedBox(self, 6, 0, 0, w, h);
	
	self.buttonBase = vgui.Create("DPanel", self);
	self.buttonBase:SetDrawBackground(false);
	self.buttonBase.Paint = function(panel, w, h)
		surface.SetDrawColor(color_black);
		surface.DrawRect(8, h-1, w-15, h);
	end;
	
	self.buttonBase:SetPos(0, 0);
	self.buttonBase:SetTall(30);
	
	self.btnClose = vgui.Create("DButton", self.buttonBase);
	self.btnClose:Dock(RIGHT);
	self.btnClose:DockMargin(5, 5, 5, 5);
	self.btnClose:SetText( "X" )
	self.btnClose:SetSize(40, 20);
	AdvNut.util.DrawRoundedBox(self.btnClose, 5, 0, 0, w, h);
	self.btnClose.DoClick = function (button)
		self:Close();
	end
	
	self.lblTitle = vgui.Create( "DLabel", self.buttonBase)
	self.lblTitle:Dock(LEFT);
	self.lblTitle:DockMargin(10, 5, 5, 2);
	self.lblTitle.UpdateColours = function( label, skin )
		if ( self:IsActive() ) then return label:SetTextStyleColor( skin.Colours.Window.TitleActive ) end

		return label:SetTextStyleColor( skin.Colours.Window.TitleInactive )
	end

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )
	self.lblTitle:SetColor(color_black);
	self.lblTitle:SetFont("nut_MediumFont");
	self:SetTitle( "Window" )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )
end

function PANEL:ShowCloseButton( bShow )
	self.btnClose:SetVisible( bShow )
end

function PANEL:SetTitle( strTitle )
	self.lblTitle:SetText( strTitle )
end

function PANEL:Close()
	self:SetVisible(false)

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()
end

function PANEL:OnClose()
end

function PANEL:Center()
	self:InvalidateLayout( true )
	self:CenterVertical()
	self:CenterHorizontal()
end

function PANEL:IsActive()
	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false
end

function PANEL:SetIcon( str )
	if ( !str && IsValid( self.imgIcon ) ) then
		return self.imgIcon:Remove() -- We are instructed to get rid of the icon, do it and bail.
	end

	if ( !IsValid( self.imgIcon ) ) then
		self.imgIcon = vgui.Create( "DImage", self )
	end

	if ( IsValid( self.imgIcon ) ) then
		self.imgIcon:SetMaterial( Material( str ) )
	end
end

function PANEL:Think()
	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	if ( self.Dragging ) then
		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then
			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )
		end

		self:SetPos( x, y )
	end

	if ( self.Sizing ) then
		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return;
	end

	if ( self.Hovered && self.m_bSizable && mousex > ( self.x + self:GetWide() - 20 ) && mousey > ( self.y + self:GetTall() - 20 ) ) then
		self:SetCursor( "sizenwse" )
		return;
	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( self.y + 24 ) ) then
		self:SetCursor( "sizeall" )
		return;
	end

	self:SetCursor( "arrow" )

	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end
end

function PANEL:Paint( w, h )
	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	derma.SkinHook( "Paint", "Frame", self, w, h )
	return true;
end

function PANEL:OnMousePressed()
	if ( self.m_bSizable && gui.MouseX() > ( self.x + self:GetWide() - 20 ) && gui.MouseY() > ( self.y + self:GetTall() - 20 ) ) then
		self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
		self:MouseCapture( true )
		return;
	end

	if ( self:GetDraggable() && gui.MouseY() < (self.y + 24) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return;
	end
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )
end

function PANEL:PerformLayout()
	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then
		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16
	end

	self.btnClose:SetPos( self:GetWide() - 31 - 4, 5 )
	self.buttonBase:SetWide(self:GetWide());

	self.lblTitle:SetPos( 8 + titlePush, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, 20 )
end
derma.DefineControl( "DFrame", "A simple window", PANEL, "EditablePanel" )