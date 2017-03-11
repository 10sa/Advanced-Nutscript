local PANEL = {};

function PANEL:Init()
	self:AddTitle(nut.lang.Get("system"), color_black);
	self:SetSize(AdvNut.util.GetCurrentMenuSize());
	self:SetPos(AdvNut.util.GetCurrentMenuPos())
	self:MakePopup()
	
	self.noticePanel = vgui.Create("nut_NoticePanel", self);
	self.noticePanel:Dock(TOP);
	self.noticePanel:DockMargin(5, 5, 5, 0)
	self.noticePanel:SetType(4)
	self.noticePanel:SetText(nut.lang.Get("system_tip"));
	
	self.secondNoticePanel = vgui.Create("nut_NoticePanel", self);
	self.secondNoticePanel:Dock(TOP);
	self.secondNoticePanel:DockMargin(5, 5, 5, 0)
	self.secondNoticePanel:SetType(4)
	self.secondNoticePanel:SetText(nut.lang.Get("system_second_tip"));
	
	self.sheet = vgui.Create("DListView", self);
	self.sheet:Dock(FILL);
	self.sheet:DockMargin(5, 5, 5, 5);
	self.sheet:AddColumn(nut.lang.Get("system_key"));
	self.sheet:AddColumn(nut.lang.Get("system_value"));
	self.sheet.OnRowRightClick = function(panel, index, line)
		self.stringRequestPanel = Derma_StringRequest(nut.lang.Get("system_set_value"), nut.lang.Get("system_set_value_desc", line.type), tostring(line.var), function(var)
			local castedVar;
			
			if (line.type == "number") then
				castedVar = tonumber(var);
			elseif (line.type == "boolean") then
				castedVar = tobool(var);
			elseif (line.type == "string") then
				castedVar = line.var;
			end;
			
			if (castedVar != nil) then
				local configs = {
					key = line.index,
					var = castedVar
				};
				netstream.Start(AdvNut.util.CreateIdentifier("SetServerConfigs", SERVER), {key = line.index, var = castedVar});
				self.noticePanel:SetType(4)
				self.noticePanel:SetText(nut.lang.Get("system_tip"));
				
				self:Build();
			else
				self.noticePanel:SetType(5);
				self.noticePanel:SetText(nut.lang.Get("wrong_value"));
			end;
		end);
	end;
	self:Build();
end

function PANEL:Build()
	self.sheet:Clear();
	netstream.Start(AdvNut.util.CreateIdentifier("GetServerConfigs", SERVER));
	
end;

function PANEL:Close()
	if (self.stringRequestPanel) then
		self.stringRequestPanel:Remove();
	end;
	
	self:Remove();
end;

netstream.Hook(AdvNut.util.CreateIdentifier("GetServerConfigs", CLIENT), function(data)
	for index, config in SortedPairs(data) do
		local varType = type(config.var);
		
		if (varType != nil) then
			if (varType == "table" or varType == "function") then continue end;

			local line = nut.gui.system.sheet:AddLine(config.key, tostring(config.var));
			line.type = varType;
			line.index = config.key;
			line.var = config.var;
		end;
	end;
end);
vgui.Register("AdvNut_System", PANEL, "AdvNut_BaseForm");