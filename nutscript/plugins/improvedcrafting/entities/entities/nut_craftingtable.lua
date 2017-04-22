local PLUGIN = PLUGIN;

// 주석이 쳐진 곳 이외에는 본 예시의 코드를 그대로 사용하세요, 파일 이름이 같아선 안됩니다. //
// 작업대를 추가 한 뒤, sh_plugin.lua 파일에 있는 craftingTables 테이블에 이 파일의 이름을 추가하세요. //

// 작업대 이름 //
ENT.PrintName = PLUGIN:GetPluginLanguage("craftingtable");

// 작업대 설명 //
ENT.Desc = PLUGIN:GetPluginLanguage("craftingtable_desc");

// 제작자 이름, 필수적이진 않음. //
ENT.Author = "Black Tea"

ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript"
ENT.RenderGroup = RENDERGROUP_BOTH

if (SERVER) then
	function ENT:Initialize()
		// 작업대의 모델입니다.//
		self:SetModel("models/props_c17/FurnitureTable002a.mdl");
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local physicsObject = self:GetPhysicsObject()
		if ( IsValid(physicsObject) ) then
			physicsObject:Wake()
		end
	end

	function ENT:Use(activator)
		netstream.Start(activator, "nut_CraftWindow", {activator, self});
	end
else
	netstream.Hook("nut_CraftWindow", function(data)
		if (IsValid(nut.gui.crafting)) then
			nut.gui.crafting:Remove()
		else
			surface.PlaySound("items/ammocrate_close.wav");
			nut.gui.crafting = vgui.Create("nut_Crafting");
			nut.gui.crafting:SetEntity(data[2], PLUGIN:GetPluginLanguage("craftingtable"), true);
			nut.gui.crafting:Center()
		end;
	end)

	function ENT:Initialize()
	end
	
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:DrawTargetID(x, y, alpha)
		local color = nut.config.mainColor;
		color.a = alpha;
		
		nut.util.DrawText(x, y - nut.config.targetTall, self.PrintName, color, "AdvNut_EntityTitle");
		nut.util.DrawText(x, y, self.Desc, Color(255, 255, 255, alpha), "AdvNut_EntityDesc");
	end;
	
	function ENT:OnRemove()
	end
end
