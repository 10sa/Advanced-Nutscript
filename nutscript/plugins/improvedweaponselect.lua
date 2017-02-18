PLUGIN.name = "개선된 무기 탭 (Improved Weapon Selector)"
PLUGIN.author = "Tensa / Chessnut"
PLUGIN.desc = "기존 플러그인을 개선한 무기 탭 플러그인입니다."

if (CLIENT) then
	PLUGIN.lastSlot = PLUGIN.lastSlot or 1
	PLUGIN.lifeTime = PLUGIN.lifeTime or 0
	PLUGIN.deathTime = PLUGIN.deathTime or 0

	local LIFE_TIME = 4
	local DEATH_TIME = 5

	function PLUGIN:OnSlotChanged()
		local client = LocalPlayer();
		self.lifeTime = CurTime() + LIFE_TIME
		self.deathTime = CurTime() + DEATH_TIME

		for k, v in SortedPairs(LocalPlayer():GetWeapons()) do
			if (k == self.lastSlot) then
				local primaryAmmo;
				local secondaryAmmo;
				
				local clipTwoAmount = client:GetAmmoCount(v:GetSecondaryAmmoType());
				local clipOneAmount = client:GetAmmoCount(v:GetPrimaryAmmoType());
				local clipTwo = v:Clip2();
				local clipOne = v:Clip1();
				
				if (!v.Primary or !v.Primary.ClipSize or v.Primary.ClipSize > 0) then
					if (clipOne >= 0) then
						primaryAmmo = "주 탄약: "..clipOne.."/"..clipOneAmount;
					end;
				end;
	
				if (!v.Secondary or !v.Secondary.ClipSize or v.Secondary.ClipSize > 0) then
					if (clipTwo >= 0) then
						secondaryAmmo = "보조 탄약: "..clipTwo.."/"..clipTwoAmount;
					end;
				end;
				
				if (!v.Instructions) then v.Instructions =  ""; end
				if (!v.Purpose) then v.Purpose = ""; end;
				if (!v.Contact) then v.Contact = ""; end;
				if (!v.Author) then v.Author = ""; end;
				
				if (primaryAmmo or secondaryAmmo or v.Instructions != "") then
					local text = "<font=nut_MediumFont>";
					
					if (v.Instructions != "") then
						text = text..(v.Instructions).."\n\n";
					end;
					
					if (primaryAmmo or secondaryAmmo) then
						text = text.."탄약\n";
						
						if (primaryAmmo) then
							text = text..primaryAmmo.."\n";
						end;
						
						if (secondaryAmmo) then
							text = text..secondaryAmmo.."\n";
						end;
					end;

					if (v.Purpose != "") then
						text = text.."설명\n"..v.Purpose.."\n\n";
					end;
		
					if (v.Contact != "") then
						text = text.."연락\n"..v.Contact.."\n";
					end;
		
					if (v.Author != "") then
						text = text.."제작자\n"..v.Author.."\n";
					end;
		
					text = text.."</font>";
					self.markup = markup.Parse(text);
					
					return;
				else
					self.markup = nil;
				end;
			end
		end
	end

	function PLUGIN:PlayerBindPress(client, bind, pressed)
		local weapon = client:GetActiveWeapon()

		if (!client:InVehicle() and (!IsValid(weapon) or weapon:GetClass() != "weapon_physgun" or !client:KeyDown(IN_ATTACK))) then
			bind = string.lower(bind)

			if (string.find(bind, "invprev") or string.find(bind, "slot2") and pressed) then
				self.lastSlot = self.lastSlot - 1

				if (self.lastSlot <= 0) then
					self.lastSlot = #client:GetWeapons()
				end

				self:OnSlotChanged()

				return true
			elseif (string.find(bind, "invnext") or string.find(bind, "slot1") and pressed) then
				self.lastSlot = self.lastSlot + 1

				if (self.lastSlot > #client:GetWeapons()) then
					self.lastSlot = 1
				end

				self:OnSlotChanged()

				return true
			elseif (string.find(bind, "+attack") and pressed) then
				if (CurTime() < self.deathTime) then
					self.lifeTime = 0
					self.deathTime = 0

					for k, v in SortedPairs(LocalPlayer():GetWeapons()) do
						if (k == self.lastSlot) then
							RunConsoleCommand("nut_selectwep", v:GetClass())

							return true
						end
					end
				end
			elseif (string.find(bind, "slot") and pressed) then
				return true
			end
		end
	end

	function PLUGIN:HUDPaint()
		local x = ScrW() * 0.475

		for k, v in SortedPairs(LocalPlayer():GetWeapons()) do
			local y = (ScrH() * 0.4) + (k * 24);
			local color = Color(255, 255, 255)
			
			if (k == self.lastSlot) then
				color = nut.config.mainColor
			end

			color.a = math.Clamp(255 - math.TimeFraction(self.lifeTime, self.deathTime, CurTime()) * 255, 0, 255)
			nut.util.DrawText(x, y, string.upper(v:GetPrintName()), color, nil, 0)

			if (k == self.lastSlot and self.markup) then
				local markupWidth = self.markup:GetWidth();
				local markupHeight = self.markup:GetHeight();
				
				local drawYPos = (ScrH() * 0.4);
				local drawXPos = x + 150;
				local drawWidth = markupWidth + 20;
				local drawHeight = markupHeight + 18;
				
				local backgroundColor = Color(30, 30, 30, color.a * 0.5);
				local gradientColor = backgroundColor;
				gradientColor.a = math.min(255, color.a * 0.8);
				
				surface.SetDrawColor(backgroundColor)
				surface.DrawRect(drawXPos, drawYPos, drawWidth, drawHeight);
				AdvNut.util.DrawCenterGradient(drawXPos, drawYPos, drawWidth, drawHeight, gradientColor);

				local markupDrawYPos = drawYPos + (markupHeight / 2);
				local markupDrawXPos = drawXPos + 5;
				self.markup:Draw(markupDrawXPos + 5, markupDrawYPos, 0, 1, color.a)
			end
		end
	end
else
	concommand.Add("nut_selectwep", function(client, command, arguments)
		client:SelectWeapon(arguments[1] or (nut.config.nutFists and "nut_fists" or "nut_keys"))
	end)
end