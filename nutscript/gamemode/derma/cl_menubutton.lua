local PANEL = {}
local HOVER_ALPHA = 150
local TEXT_COLOR = Color(240, 240, 240)
function PANEL:Init()
	surface.SetFont("nut_MenuButtonFont")
	local _, height = surface.GetTextSize("W")

	self.Paint = function(panel, w, h)
			surface.SetDrawColor(255, 255, 255, 0)
			surface.DrawRect(0, 0, w, h)
	end
		
	self:SetTall(height + 15)
	self:DockMargin(0, 0, 0, 5)
	self:Dock(TOP)
	self:SetDrawBackground(false)
	self:SetFont("nut_MenuButtonFont")
	self:SetTextColor(TEXT_COLOR)
	self:SetExpensiveShadow(1, color_black)
	self.alphaApproach = 15
	self.alpha = self.alphaApproach
	self:SetMouseInputEnabled(true)
end

function PANEL:OnCursorEntered()
	surface.PlaySound("ui/buttonrollover.wav")
	self:SetTextColor(Color(200, 200, 200, 255));
end

function PANEL:OnCursorExited()
	self:SetTextColor(TEXT_COLOR)
	self.alpha = 15
end

function PANEL:DoClick()
	if (self.OnClick) then
		local result = self:OnClick()

		if (result == false) then
			surface.PlaySound("buttons/button8.wav")
		else
			surface.PlaySound("ui/buttonclick.wav")
			self.alphaApproach = HOVER_ALPHA + 150
		end
	end
end

local sin = math.sin

function PANEL:Paint(w, h)
	self.alphaApproach = math.Approach(self.alphaApproach, self.alpha, FrameTime() * 150)

	local blink = 0

	if (self.alphaApproach == HOVER_ALPHA) then
		blink = sin(RealTime() * 5) * 10
	end

	local color = nut.config.mainColor

	surface.SetDrawColor(135, 135, 135, self.alphaApproach + blink)
	surface.DrawRect(0, 0, w, h)
end
vgui.Register("nut_MenuButton", PANEL, "DLabel")
