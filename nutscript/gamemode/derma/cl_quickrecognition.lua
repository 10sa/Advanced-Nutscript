local PANEL = {};

function PANEL:Init()
	AdvNut.util.DrawBackgroundBlur(self);
	self:InitDermaMenu();
	
	hook.Add("VGUIMousePressed", "QuickRecognitionMenuMousePressed", PANEL.VGUIMousePressed);
end;

function PANEL:InitDermaMenu()
	client = LocalPlayer();
	
	self.menu = DermaMenu();
	self.menu:AddOption("바라보고 있는 사람에게 인식",  function() 
		client:ConCommand("say /recognition aim")
		self:Close();
	end);
	
	self.menu:AddOption("속삭이기 범위 안의 사람에게 인식",  function() 
		client:ConCommand("say /recognition whisper")
		self:Close();
	end);
	
	self.menu:AddOption("말하기 범위 안의 사람에게 인식",  function() 
		client:ConCommand("say /recognition")
		self:Close();
	end);
	
	self.menu:AddOption( "외치기 범위 안의 사람에게 인식",  function() 
		client:ConCommand("say /recognition yell")
		self:Close();
	end);
	
	self.menu:Open()
	self.menu:SetPos(ScrW()* 0.45, ScrH() *0.45);
end;

function PANEL:Think()
	if(!input.IsKeyDown(KEY_F2)) then
		self:Close();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(0, 0, 0, 0));
	surface.DrawRect(0, 0, w, h);
end;

function PANEL:VGUIMousePressed(mouseCode)
	timer.Simple(0.1, function()
		if (IsValid(nut.gui.quickRecognition) and nut.gui.quickRecognition.menu != nil) then
			nut.gui.quickRecognition:InitDermaMenu();
		end;
	end);
end;

function PANEL:Close()
	AdvNut.util.RemoveBackgroundBlur(self);
	
	hook.Remove("VGUIMousePressed", "QuickRecognitionMenuMousePressed");
	self.menu:Remove();
	self:Remove();
end;
vgui.Register("nut_quickRecognition", PANEL, "AdvNut_BaseForm");

function PANEL:PlayerBindPress(bind, pressed)
	if(bind == "gm_showteam" and hook.Run("IsCanOpenQuickRecognitionMenu")) then
		nut.gui.quickRecognition = vgui.Create("nut_quickRecognition");
	end
end;
hook.Add("PlayerBindPress", "QuickRecognitionMenu", PANEL.PlayerBindPress);