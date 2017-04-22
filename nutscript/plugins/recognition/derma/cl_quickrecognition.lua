local PANEL = {};
local PLUGIN = PLUGIN or { };

function PANEL:Init()
	AdvNut.util.DrawBackgroundBlur(self);
	self:InitDermaMenu();
	
	AdvNut.hook.Add("VGUIMousePressed", "QuickRecognitionMenuMousePressed", PANEL.VGUIMousePressed);
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
	timer.Simple(0.1, function()PLUGIN:GetPluginIdentifier("QuickRecognitionMenu", CLIENT)
		if (IsValid(nut.gui.QuickRecognition) and nut.gui.QuickRecognition.menu != nil) then
			nut.gui.QuickRecognition:InitDermaMenu();
		end;
	end);
end;

function PANEL:Close()
	AdvNut.util.RemoveBackgroundBlur(self);
	
	hook.Remove("VGUIMousePressed", PLUGIN:GetPluginIdentifier("QuickRecognitionMenuMousePressed", CLIENT));
	self.menu:Remove();
	self:Remove();
end;
vgui.Register("AdvNut_QuickRecognition", PANEL, "AdvNut_BaseForm");


function PANEL:PlayerBindPress(bind, pressed)
	if(bind == "gm_showteam" and AdvNut.hook.Run("PlayerCanOpenQuickRecognitionMenu")) then
		nut.gui.QuickRecognition = vgui.Create("AdvNut_QuickRecognition");
	end
end;
AdvNut.hook.Add("PlayerBindPress", PLUGIN:GetPluginIdentifier("QuickRecognitionMenu", CLIENT), PANEL.PlayerBindPress);


function PLUGIN:PlayerCanOpenQuickRecognitionMenu()
	return true;
end;