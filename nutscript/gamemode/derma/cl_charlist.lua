local PANEL = {};

function PANEL:Init()
	local width = ScrW() * 0.325
	self:SetWide(width)
	self:SetTall(ScrH() * 0.7);
	self:SetPos((ScrW() - self:GetWide()) * 0.5, ScrH() * 0.1);
	self:SetVisible(false);

	self.name = vgui.Create("DLabel", self);
	self.name:SetPos(0, 10);
	self.name:SetFont("nut_LargeFont");
	self.name:SetTextColor(color_white)
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	self.name:SetContentAlignment(5)
	self.name:SetSize(width, 28)

	self.model = vgui.Create("DModelPanel", self);
	self.model:SetPos(0, 28)
	self.model:SetFOV(72)
	self.model:SetSize(width, ScrH() * 0.55)
	self.model.LayoutEntity = function(panel, entity)
		local xRatio = gui.MouseX() / ScrW()
		local yRatio = gui.MouseY() / ScrH()

		entity:SetPoseParameter("head_pitch", yRatio*80 - 40)
		entity:SetPoseParameter("head_yaw", (xRatio - 0.75)*70 + 23)
		entity:SetAngles(Angle(0, 45, 0));
		entity:SetIK(false)

		panel:RunAnimation()
	end
	self.model.OnMouseEntered = function() end
	self.model.OnMousePressed = function() end
	self.model:SetCursor("none")

	local SetModel = self.model.SetModel

	self.model.SetModel = function(panel, model)
		SetModel(panel, model)

		local entity = panel.Entity
		local sequence = entity:LookupSequence("idle")

		if (sequence <= 0) then
			sequence = entity:LookupSequence("idle_subtle")
		end

		if (sequence <= 0) then
			sequence = entity:LookupSequence("batonidle2")
		end

		if (sequence <= 0) then
			sequence = entity:LookupSequence("idle_unarmed")
		end

		if (sequence <= 0) then
			sequence = entity:LookupSequence("idle01")
		end

		if (sequence > 0) then
			entity:ResetSequence(sequence)
		end
	end

	local x, y = self:ScreenToLocal(0, ScrH() - 28)

	self.bottom = vgui.Create("DPanel", self);
	self.bottom:SetPos(0, y - 350)
	self.bottom:SetSize(width, 48)
	self.bottom:SetDrawBackground(false)

	self.choose = self.bottom:Add("DButton")
	self.choose:SetWide(width / 2 - 8)
	self.choose:Dock(LEFT)
	self.choose:SetTextColor(color_black)
	self.choose:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	self.choose:SetFont("nut_MediumFont")
	self.choose:SetText(nut.lang.Get("choose"))
	self.choose.Paint = function() end

	function self.choose:OnCursorEntered()
		surface.PlaySound("ui/buttonrollover.wav")
		self:SetTextColor(Color(255, 230, 0, 255))
	end

	function self.choose:OnCursorExited()
		self:SetTextColor(color_black)
		selfalpha = 15
	end
				
	self.delete = self.bottom:Add("DButton")
	self.delete:SetWide(width / 2 - 8)
	self.delete:Dock(RIGHT)
	self.delete:SetTextColor(color_black)
	self.delete:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	self.delete:SetFont("nut_MediumFont")
	self.delete:SetText(nut.lang.Get("delete"))
	self.delete.Paint = function() end
				
	function self.delete:OnCursorEntered()
		surface.PlaySound("ui/buttonrollover.wav")
		self:SetTextColor(Color(255, 230, 0, 255))
	end

	function self.delete:OnCursorExited()
		self:SetTextColor(color_black)
		selfalpha = 15
	end
end;

function PANEL:SetCharacter(index, deleteCallback)
	local info = LocalPlayer().characters[index];
	if (info) then
		self.index = info.id
		
		self.name:SetText(info.name)
		self.name:SetTextColor(team.GetColor(info.faction))
		self.name:SetAlpha(banned and 50 or 255)
		self.model:SetModel(info.model)
		self.model:SetAlpha(banned and 50 or 255)
		
		self.delete.DoClick = function(panel)
			LocalPlayer().characters[self.index] = nil;
			
			local orignalChoose = self.choose.DoClick;
			local orignalDelete = self.delete.DoClick;
			
			self.choose:SetText(nut.lang.Get("yes"));
			self.choose.DoClick = function()
				self.choose:SetText(nut.lang.Get("choose"));
				self.choose.DoClick = orignalChoose;
				
				self.delete:SetText(nut.lang.Get("delete"));
				self.delete.DoClick = orignalDelete;
				
				netstream.Start("nut_CharDelete", self.index);
				deleteCallback();
			end;
			
			self.delete:SetText(nut.lang.Get("no"));
			self.delete.DoClick = function()
				self.choose.DoClick = orignalChoose;
				self.choose:SetText(nut.lang.Get("choose"));
				
				self.delete.DoClick = orignalDelete;
				self.delete:SetText(nut.lang.Get("delete"));
			end;
		end
		
		self.choose.DoClick = function(panel)
			if (!self.banned) then
				nut.lastCharIndex = self.index
				netstream.Start("nut_CharChoose", self.index);
			end
		end
	end
end

function PANEL:Next(prevPanel)
	local x, y = self:GetPos();
	local panel = self;
	
	if(prevPanel != nil) then
		prevPanel:Prev();
		timer.Simple(0.2, function()
			panel:Next();
			return;
		end);
	else
		self:SetPos(ScrW(), y);
		self:SetVisible(true);
		self:SetAlpha(255);
		self:MoveTo((ScrW() - self:GetWide()) * 0.5, y, 0.5);
	end;
end;

function PANEL:Prev()
	local x, y = self:GetPos();
	self:MoveTo(self:GetWide() * -0.5, y, 0.5, 0, -1, function()
		self:SetVisible(false);
		self:SetAlpha(255);
	end);
end;
vgui.Register("AdvNut_CharacterSelect", PANEL, "AdvNut_BaseForm")