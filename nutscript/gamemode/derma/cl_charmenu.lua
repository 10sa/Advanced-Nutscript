local PANEL = {}
local gradient = surface.GetTextureID("gui/gradient_up")
local gradient2 = surface.GetTextureID("gui/gradient_down")
local gradient3 = surface.GetTextureID("gui/gradient")
local gradient4 = surface.GetTextureID("vgui/gradient-r")
local blur = Material("pp/blurscreen")

local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255, 125)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function PANEL:Init()
	timer.Remove("nut_FadeMenuMusic")
	
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:ParentToHUD()
	
	local color = nut.config.mainColor
	local r, g, b = color.r, color.g, color.b

	self.side = self:Add("DPanel")
	self.side:SetPos(0, 0)
	self.side:SetSize(ScrW(), ScrH())
	self.side.Paint = function(this, w, h)
		DrawBlur(self.side, 8)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
	end

	self.title = self.side:Add("DLabel")
	self.title:Dock(TOP)
	self.title:SetFont("nut_TitleFont")
	self.title:SetTall(100)
	self.title:SetTextColor(Color(240, 240, 240))
	self.title:SetContentAlignment(5)
	self.title:DockMargin(24, ScrH()*0.15, 24, 0)
	self.title:SetText(SCHEMA.name);
	
	self.subTitle = self.side:Add("DLabel")
	self.subTitle:Dock(TOP)
	self.subTitle:SetText(SCHEMA.desc);
	self.subTitle:SetContentAlignment(5)
	self.subTitle:SetTall(ScrH()*0.09)
	self.subTitle:DockMargin(0, self.subTitle:GetTall()*-0.2, 0, 0)
	self.subTitle:SetFont("nut_SubTitleFont")
	
	self.leftButtons = self.side:Add("AdvNut_ScrollPanel")
	self.leftButtons:Dock(LEFT)
	self.leftButtons:SetWide(self.side:GetWide()*0.25)
	self.leftButtons:DockMargin(20, 50, 0, 0)
	self.leftButtons:DockPadding(0, 0, 0, 80)
	
	self.rightButtons = self.side:Add("AdvNut_ScrollPanel");
	self.rightButtons:Dock(RIGHT);
	self.rightButtons:SetWide(self.side:GetWide()*0.25);
	self.rightButtons:DockMargin(0, 50, 20, 0);
	self.rightButtons:DockPadding(0, 0, 0, 80);
	
	nut.OldRenderScreenspaceEffects = nut.RenderScreenspaceEffects

	timer.Simple(0.1, function()
		GAMEMODE.RenderScreenspaceEffects = function()
			if (IsValid(self)) then
				self:RenderScreenspaceEffects()
			else
				GAMEMODE.RenderScreenspaceEffects = nut.OldRenderScreenspaceEffects
			end
		end
	end)

	local first = true
	self.leftButtonCount = 0;
	self.rightButtonCount = 0;

	local function AddButton(text, callback, dockPointer, noLang)
		if (self.choosing) then return end
		
		local button;
		local count;
		if(dockPointer == nil or dockPointer == LEFT) then
			button = self.leftButtons:Add("DLabel");
			self.leftButtonCount = self.leftButtonCount + 1;
			count = self.leftButtonCount;
		elseif (dockPointer == RIGHT) then
			button = self.rightButtons:Add("DLabel");
			self.rightButtonCount = self.rightButtonCount + 1;
			count = self.rightButtonCount;
		else
			ErrorNoHalt("Wrong Dock Pointer!");
		end;
		
		button:SetText(noLang and text:upper() or nut.lang.Get(text:lower()):upper());
		button:SetPos(ScrH()*0.1, ScrW()*0.3 - count * 50)
		button:SetWide(self:GetParent():GetWide());
		button:SetFont("nut_MediumFont")
		button:SetContentAlignment(4)
		button:SetTextColor(color_white)
		button:SetTextInset(28, 0)
		button:SetTall(64)
		button:SetMouseInputEnabled(true)
	
		function button:OnCursorEntered()
			surface.PlaySound("ui/buttonrollover.wav")
			self:SetTextColor(Color(255, 230, 0, 255))
		end

		function button:OnCursorExited()
			self:SetTextColor(color_white)
			self.alpha = 15
		end
				
		button:SetExpensiveShadow(1, Color(0, 0, 0, 220))

		if (first) then
			button:DockMargin(0, 20, 0, 0)
			first = false
		end

		if (callback) then
			button.DoClick = callback
		end
	end

	local function CreateMainButtons()
		self.leftButtonCount = 0;
		self.rightButtonCount = 0;
		
		if (IsValid(self.content)) then
			self.content:Remove()
		end

		self:RemoveButtons()
		
		local factions = {}

		for k, v in pairs(nut.faction.buffer) do
			if (nut.faction.CanBe(LocalPlayer(), v.index)) then
				factions[#factions + 1] = v
			end
		end

		local charIsValid = LocalPlayer().character != nil

		AddButton(charIsValid and "return" or "leave", function()
			if (charIsValid) then
				self:Remove()
			else
				LocalPlayer():ConCommand("disconnect")
			end
		end)
		
		if (nut.config.website and nut.config.website:find("http")) then
			AddButton("website", function()
				gui.OpenURL(nut.config.website)
			end)
		end
		
		if (#factions > 0 and (LocalPlayer().character and table.Count(LocalPlayer().characters) or 0) < nut.config.maxChars) then
			AddButton("create", function()
				local stageCounter = 1;
				self.leftButtonCount = 0;
				self.rightButtonCount = 0;
				
				self.Stages = {
					vgui.Create("AdvNut_charCreateFactionSelect", self),
					vgui.Create("AdvNut_charCreateWriteInfo", self),
					vgui.Create("AdvNut_charCreateAttributeSet", self),
					vgui.Create("AdvNut_charCreateWait", self)
				}
				self.Stages[stageCounter]:NextCallback(factions);
				
				self.leftButtons:Clear();
				self.rightButtons:Clear();
				
				self.title:SetText("");
				self.subTitle:SetText("");
				
				self.Stages[1]:Next();
				AddButton("return", function()
					self.Stages[stageCounter]:Prev();
					
					if(stageCounter <= 1) then
						CreateMainButtons();
					else
						self.Stages[stageCounter - 1]:Next(self.Stages[stageCounter]);
						stageCounter = stageCounter - 1;
					end;
				end)
				
				AddButton("next", function()
					if(self.Stages[stageCounter]:ValidCheck() != false) then
						if(stageCounter < (table.Count(self.Stages) - 1)) then
							stageCounter = stageCounter + 1;
							
							self.Stages[stageCounter]:Next(self.Stages[stageCounter - 1]);
							self.Stages[stageCounter]:NextCallback(self.Stages[stageCounter - 1]:GetData());
						else
							self.Stages[stageCounter]:Prev();
							self.Stages[stageCounter + 1]:Next();
							
							self.leftButtons:Clear();
							self.rightButtons:Clear();
							
							local characterInfo = {};
							local infoTable = {
								"name",
								"gender",
								"desc",
								"model",
								"attribs",
								"factionID"
							};
							
							for k, v in pairs(self.Stages) do
								local data = v:GetData();
								
								if (data != nil) then
									for k2, v2 in pairs(infoTable) do
										if(data[v2] != nil) then
											characterInfo[v2] = data[v2];
										end;
									end;
								end;
							end;
							
							self.isCreafting = true;
							self.creatingCallback = function()
								timer.Remove("timer.charCreate_Timeout");
								self.Stages[#self.Stages]:Prev();
								CreateMainButtons();
							end;
							
							PrintTable(characterInfo);
							netstream.Start("nut_CharCreate", characterInfo);
							
							timer.Create("timer.charCreate_Timeout", 10, 0, function()
								self.Stages[stageCounter + 1]:TimeoutCallBack();
							end);
						end;
					end;
				end, RIGHT)
			end)
		end
		
		local charAmount = 0;
		
		if(LocalPlayer().characters != nil) then
			charAmount = table.Count(LocalPlayer().characters);
			for k, v in pairs(LocalPlayer().characters) do
				if (v.banned) then
					charAmount = charAmount - 1;
				end
			end
		end
		
		if (nut.lastCharIndex) then
			charAmount = charAmount - 1;
		end;
				
		if (charAmount > 0) then
			AddButton("load", function()
				local charSelectCounter = 1;
				
				self.leftButtonCount = 0;
				self.rightButtonCount = 0;
				self.title:SetText("")
				self.subTitle:SetText("")

				self.leftButtons:Clear()
				self.rightButtons:Clear()
				self.charStage = {};
				
				for k, v in SortedPairsByMemberValue(LocalPlayer().characters, "id") do
					if (k != "__SortedIndex" and !v.banned and v.id != nut.lastCharIndex) then
						local charSelect = vgui.Create("AdvNut_CharacterSelect", self);
						local insertIndex = #self.charStage + 1;
						charSelect:SetCharacter(k, function()
							if (charSelectCounter <= charAmount) then
								if(self.charStage[insertIndex - 1] == nil) then
									CreateMainButtons();
								else
									self.charStage[insertIndex - 1]:Next(charSelect);
									charSelectCounter = charSelectCounter - 1;
								end
							else
								CreateMainButtons();
								topButtons:Remove();
							end;
							
							self.charStage[insertIndex] = nil;
							charSelect:Remove();
						end);
						
						table.insert(self.charStage, charSelect);
						
					end
				end
				
				self.charStage[1]:Next();
				
				AddButton("return", function()
					self.charStage[charSelectCounter]:Prev();
					if (charSelectCounter <= 1) then
						CreateMainButtons();
					else
						charSelectCounter = charSelectCounter - 1;
						self.charStage[charSelectCounter]:Next(self.charStage[charSelectCounter + 1]);
						
						if (charSelectCounter < charAmount) then
							self.rightButtons:Clear();
							self.rightButtonCount = 0;
							
							AddButton("next", function()
								charSelectCounter = charSelectCounter + 1;
								self.charStage[charSelectCounter]:Next(self.charStage[charSelectCounter - 1]);
								
								if (!(charSelectCounter < charAmount)) then
									self.rightButtonCount = 0;
									self.rightButtons:Clear();
								end;
							end, RIGHT); 
						else
							self.rightButtonCount = 0;
							self.rightButtons:Clear();
						end;
					end;
				end);
				
				if (charSelectCounter < charAmount) then
					AddButton("next", function()
						charSelectCounter = charSelectCounter + 1;
						self.charStage[charSelectCounter]:Next(self.charStage[charSelectCounter - 1]);
						
						if (!(charSelectCounter < charAmount)) then
							self.rightButtonCount = 0;
							self.rightButtons:Clear();
						end;
					end, RIGHT);
				end
			end);
		end

		if(nut.config.prefixTitle) then
			self.title:SetText(nut.lang.Get("charMenuTitle"));
			self.subTitle:SetText(nut.lang.Get("charMenuDesc"));
		else
			self.title:SetText(SCHEMA.name);
			self.subTitle:SetText(SCHEMA.desc);
		end;
	end

	timer.Simple(0, CreateMainButtons)

	if (nut.config.menuMusic) then
		if (nut.menuMusic) then
			nut.menuMusic:Stop()
			nut.menuMusic = nil
		end

		local lower = string.lower(nut.config.menuMusic)

		if (string.Left(lower, 4) == "http") then
			local function createMusic()
				if (!IsValid(nut.gui.charMenu)) then
					return
				end

				local nextAttempt = 0

				sound.PlayURL(nut.config.menuMusic, "noplay", function(music)
					if (music) then
						nut.menuMusic = music
						nut.menuMusic:Play()

						timer.Simple(0.5, function()
							if (!nut.menuMusic) then
								return
							end
							
							nut.menuMusic:SetVolume(nut.config.menuMusicVol / 100)
						end)
					elseif (nextAttempt < CurTime()) then
						nextAttempt = CurTime() + 1
						createMusic()
					end
				end)
			end

			createMusic()
		else
			nut.menuMusic = CreateSound(LocalPlayer(), nut.config.menuMusic)
			nut.menuMusic:Play()
			nut.menuMusic:ChangeVolume(nut.config.menuMusicVol / 100, 0)
		end
	end

	nut.loaded = true
end

local colorData = {}
colorData["$pp_colour_addr"] = 0
colorData["$pp_colour_addg"] = 0
colorData["$pp_colour_addb"] = 0
colorData["$pp_colour_brightness"] = -0.05
colorData["$pp_colour_contrast"] = 1
colorData["$pp_colour_colour"] = 0
colorData["$pp_colour_mulr"] = 0
colorData["$pp_colour_mulg"] = 0
colorData["$pp_colour_mulb"] = 0

function PANEL:RenderScreenspaceEffects()
	local x, y = self.side:LocalToScreen(0, 0)
	local w, h = self.side:GetWide(), ScrH()

	render.SetStencilEnable(true)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)
	render.ClearStencilBufferRectangle(x, y, x + w, h, 1)
	render.SetStencilEnable(1)

	DrawColorModify(colorData)
	render.SetStencilEnable(false)
end

function PANEL:FadeOutMusic()
	if (!nut.menuMusic) then
		return
	end

	if (nut.menuMusic.SetVolume) then
		local start = CurTime()
		local finish = CurTime() + nut.config.menuMusicFade

		if (timer.Exists("nut_FadeMenuMusic")) then
			timer.Remove("nut_FadeMenuMusic")

			if (nut.menuMusic) then
				nut.menuMusic:Stop()
				nut.menuMusic = nil
			end
		end

		timer.Create("nut_FadeMenuMusic", 0, 0, function()
			local fraction = (1 - math.TimeFraction(start, finish, CurTime())) * nut.config.menuMusicVol

			if (nut.menuMusic) then
				nut.menuMusic:SetVolume(fraction / 100)

				if (fraction <= 0) then
					nut.menuMusic:SetVolume(0)
					nut.menuMusic:Stop()
					nut.menuMusic = nil
				end
			end
		end)
	else
		nut.menuMusic:FadeOut(nut.config.menuMusicFade)
		nut.menuMusic = nil
	end
end

function PANEL:OnRemove()
		self:FadeOutMusic()
end

function PANEL:RemoveButtons()
	self.leftButtons:Clear();
	self.rightButtons:Clear();
	
	self.leftButtonCount = 0;
	self.rightButtonCount = 0;
end;

vgui.Register("nut_CharMenu", PANEL, "EditablePanel")

if (IsValid(nut.gui.charMenu)) then
	nut.gui.charMenu:Remove()
	nut.gui.charMenu = vgui.Create("nut_CharMenu")
end

netstream.Hook("nut_CharMenu", function(forced)
	if (type(forced) == "table") then
		if (forced[2] == true) then
			LocalPlayer().character = nil

			if (forced[3]) then
				for k, v in pairs(LocalPlayer().characters) do
					if (v.id == forced[3]) then
						LocalPlayer().characters[k] = nil
					end
				end
			end
		end

		forced = forced[1]
	end

	if (IsValid(nut.gui.charMenu)) then
		nut.gui.charMenu:FadeOutMusic()

		if (IsValid(nut.gui.charMenu.model)) then
			nut.gui.charMenu.model:Remove()
		end

		nut.gui.charMenu:Remove()

		if (!forced) then
			return
		end
	end

	if (forced) then
		nut.loaded = nil
	end

	nut.gui.charMenu = vgui.Create("nut_CharMenu")
end)

netstream.Hook("nut_CharCreateAuthed", function()
	if (IsValid(nut.gui.charMenu)) then
		nut.gui.charMenu.creating = false
		nut.gui.charMenu.creatingCallback()
		nut.gui.charMenu.creatingCallback = nil
	end
end)