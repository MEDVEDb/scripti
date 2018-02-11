local WardPositionTrack = {}

WardPositionTrack.Enable = Menu.AddOption({ "Utility", "Track Ward Position" }, "{{Track Ward Position}}Enable", "Show in game map ward position")
WardPositionTrack.EnablePanel = Menu.AddOption({ "Utility", "Track Ward Position" }, "{{Track Ward Position}}Panel", "Show ward list")
WardPositionTrack.Scale = Menu.AddOption({ "Utility", "Track Ward Position" }, "{{Track Ward Position}}Panel size %", "Panel scale in percent", 50, 200)
WardPositionTrack.BaseXOpt = Menu.AddOption({ "Utility", "Track Ward Position" }, "{{Track Ward Position}}X", "X Pos", 0, 2000, 20)
WardPositionTrack.BaseYOpt = Menu.AddOption({ "Utility", "Track Ward Position" }, "{{Track Ward Position}}Y", "Y Pos", 0, 2000, 10)
WardPositionTrack.Font = Renderer.LoadFont("Arial", 20, Enum.FontWeight.EXTRABOLD)
WardPositionTrack.Init = false
WardPositionTrack.BaseX = Config.ReadInt("WardPositionTrack", "BaseX", 0)
WardPositionTrack.BaseY = Config.ReadInt("WardPositionTrack", "BaseY", 100)
WardPositionTrack.ScaleMult = Config.ReadInt("WardPositionTrack", "Scale", 100) / 100

WardPositionTrack.FontMenu = Renderer.LoadFont("Arial", math.floor(18 * WardPositionTrack.ScaleMult), Enum.FontWeight.BOLD)
WardPositionTrack.FontMenu1 = Renderer.LoadFont("Arial", math.floor(15 * WardPositionTrack.ScaleMult), Enum.FontWeight.MEDIUM)
WardPositionTrack.FontMenu2 = Renderer.LoadFont("Arial", math.floor(18 * WardPositionTrack.ScaleMult), Enum.FontWeight.MEDIUM)
function WardPositionTrack.OnMenuOptionChange(option, oldValue, newValue)
	if option == WardPositionTrack.Scale then
		Config.WriteInt("WardPositionTrack", "Scale", newValue)
		WardPositionTrack.ScaleMult = newValue / 100
		WardPositionTrack.FontMenu = Renderer.LoadFont("Arial", math.floor(18 * WardPositionTrack.ScaleMult), Enum.FontWeight.BOLD)
		WardPositionTrack.FontMenu1 = Renderer.LoadFont("Arial", math.floor(15 * WardPositionTrack.ScaleMult), Enum.FontWeight.MEDIUM)
		WardPositionTrack.FontMenu2 = Renderer.LoadFont("Arial", math.floor(18 * WardPositionTrack.ScaleMult), Enum.FontWeight.MEDIUM)
	end
	if option == WardPositionTrack.BaseXOpt then
		Config.WriteInt("WardPositionTrack", "BaseX", newValue)
		WardPositionTrack.BaseX = newValue
	end
	if option == WardPositionTrack.BaseYOpt then
		Config.WriteInt("WardPositionTrack", "BaseY", newValue)
		WardPositionTrack.BaseY = newValue
	end
end

function WardPositionTrack.Code(x, y)
	local xmin, ymin = 0, 0
	local xmax, ymax = Renderer.GetScreenSize()
	local result = ((x < xmin) and 1 or 0) << 3 |
		((x > xmax) and 1 or 0) << 2 |
		((y < ymin) and 1 or 0) << 1 |
		((y > ymax) and 1 or 0)
	return result
end


function WardPositionTrack.ClipLine(x1, y1, x2, y2)
	local c1, c2 = WardPositionTrack.Code(x1, y1), WardPositionTrack.Code(x2, y2)
	local dx, dy
	local xmin, ymin = 0, 0
	local xmax, ymax = Renderer.GetScreenSize()
	while (c1 | c2) ~= 0 do
		if (c1 & c2) ~= 0 then
			return x1, y1, x2, y2
		end
		dx = x2 - x1
		dy = y2 - y1
		if c1 ~= 0 then
			if x1 < xmin then
				y1 = y1 + dy * (xmin - x1) / dx
				x1 = xmin
			elseif x1 > xmax then
				y1 = y1 + dy * (xmax - x1) / dx
				x1 = xmax
			elseif y1 < ymin then
				x1 = x1 + dx * (ymin - y1) / dy
				y1 = ymin
			elseif y1 > ymax then
				x1 = x1 + dx * (ymax - y1) / dy
				y1 = ymax
			end
			c1 = WardPositionTrack.Code(x1, y1)
		else
			if x2 < xmin then
				y2 = y2 + dy * (xmin - x2) / dx
				x2 = xmin
			elseif x2 > xmax then
				y2 = y2 + dy * (xmax - x2) / dx
				x2 = xmax
			elseif y2 < ymin then
				x2 = x2 + dx * (ymin - y2) / dy
				y2 = ymin
			elseif y2 > ymax then
				x2 = x2 + dx * (ymax - y2) / dy
				y2 = ymax
			end
			c2 = WardPositionTrack.Code(x2, y2)
		end
	end
	return x1, y1, x2, y2
end

function WardPositionTrack.DrawCircle(UnitPos, radius)
	local x1, y1, visible = Renderer.WorldToScreen(UnitPos)
	local x4, y4, x3, y3
	local dergee = 20
	if visible == 1 then
		for angle = 0, 360 / dergee do
			x4 = 0 * math.cos(angle * dergee / 57.3) - radius * math.sin(angle * dergee / 57.3)
			y4 = radius * math.cos(angle * dergee / 57.3) + 0 * math.sin(angle * dergee / 57.3)
			local tmp_vec = UnitPos + Vector(x4,y4,0)
			if PositInfo ~= nil and PositInfo.GetHeightInPoint(tmp_vec:GetX(), tmp_vec:GetY()) ~= nil then
				tmp_vec:SetZ(PositInfo.GetHeightInPoint(tmp_vec:GetX(), tmp_vec:GetY()))
			end
			x3, y3, visible3 = Renderer.WorldToScreen(tmp_vec)
			if visible1 == 1 and visible3 == 1 then
				local tx1, ty1, tx3, ty3 = WardPositionTrack.ClipLine(x1, y1, x3, y3)
				Renderer.DrawLine(math.floor(tx1), math.floor(ty1), math.floor(tx3), math.floor(ty3))
			end
			x1, y1, visible1 = x3, y3, visible3
		end
	end
end

WardPositionTrack.WardList = __WardList
if not WardPositionTrack.WardList then
	WardPositionTrack.WardList = {}
end
WardPositionTrack.WardState = {}
WardPositionTrack.HeroNumObsWards = {}
WardPositionTrack.HeroNumSenWards = {}
WardPositionTrack.HeroLastState = {}
function WardPositionTrack.OnGameStart()
	if not Menu.IsEnabled(WardPositionTrack.Enable) then
		return
	end
	WardPositionTrack.WardList = {}
	WardPositionTrack.WardState = {}
	WardPositionTrack.HeroNumObsWards = {}
	WardPositionTrack.HeroNumSenWards = {}
	WardPositionTrack.HeroLastState = {}
end

function WardPositionTrack.OnEntityDestroy(ent)
	if not Menu.IsEnabled(WardPositionTrack.Enable) then
		return
	end
	for i, ward in pairs(WardPositionTrack.WardList) do
		if ward.entity == ent then
			table.remove(WardPositionTrack.WardList, i)
		end
	end
end

function WardPositionTrack.OnEntityCreate(ent)
	if not Menu.IsEnabled(WardPositionTrack.Enable) then
		return
	end
	table.insert(WardPositionTrack.WardState, ent)
end

function WardPositionTrack.OnUpdate()
	if not Menu.IsEnabled(WardPositionTrack.Enable) then
		return
	end

	local myHero = Heroes.GetLocal()

	if not myHero then
		return
	end
	for i, v in pairs(WardPositionTrack.WardState) do
		if Entity.IsNPC(v) and not Entity.IsSameTeam(myHero, v) and (NPC.GetUnitName(v) == "npc_dota_sentry_wards" or NPC.GetUnitName(v) == "npc_dota_observer_wards") then
			if NPC.HasModifier(v, "modifier_item_buff_ward") then
				local find = false
				for j, b in pairs(WardPositionTrack.WardList) do
					if math.floor(Modifier.GetDieTime(NPC.GetModifier(v, "modifier_item_buff_ward")) / 3) == math.floor(b.time / 3) and not b.entity then
						b.position = Entity.GetAbsOrigin(v)
						b.entity = v
						table.remove(WardPositionTrack.WardState, i)
						find = true
					end
				end
				if not find then
					local tmp_obj = {}
					if NPC.GetUnitName(v) == "npc_dota_observer_wards" then
						tmp_obj.type = 1
						tmp_obj.radius = 1600
					end
					if NPC.GetUnitName(v) == "npc_dota_sentry_wards" then
						tmp_obj.type = 2
						tmp_obj.radius = 850
					end
					tmp_obj.time = Modifier.GetDieTime(NPC.GetModifier(v, "modifier_item_buff_ward"))
					tmp_obj.position = Entity.GetAbsOrigin(v)
					tmp_obj.entity = v
					table.insert(WardPositionTrack.WardList, tmp_obj)
					table.remove(WardPositionTrack.WardState, i)
				end
			end
		else
			table.remove(WardPositionTrack.WardState, i)
		end
	end

	if not WardPositionTrack.Init then

		Menu.SetValue(WardPositionTrack.Scale, math.floor(WardPositionTrack.ScaleMult * 100), false)
		Menu.SetValue(WardPositionTrack.BaseXOpt, WardPositionTrack.BaseX, false)
		Menu.SetValue(WardPositionTrack.BaseYOpt, WardPositionTrack.BaseY, false)
		for _, v in pairs(NPCs.GetAll()) do
			if not Entity.IsSameTeam(myHero, v) and NPC.HasModifier(v, "modifier_item_buff_ward") then
				if NPC.GetUnitName(v) == "npc_dota_observer_wards" then
					local tmp_obj = {}
					tmp_obj.type = 1
					tmp_obj.radius = 1600
					tmp_obj.time = Modifier.GetDieTime(NPC.GetModifier(v, "modifier_item_buff_ward"))
					tmp_obj.position = Entity.GetAbsOrigin(v)
					tmp_obj.entity = v
					table.insert(WardPositionTrack.WardList, tmp_obj)
				end
				if NPC.GetUnitName(v) == "npc_dota_sentry_wards" then
					local tmp_obj = {}
					tmp_obj.type = 2
					tmp_obj.radius = 850
					tmp_obj.time = Modifier.GetDieTime(NPC.GetModifier(v, "modifier_item_buff_ward"))
					tmp_obj.position = Entity.GetAbsOrigin(v)
					tmp_obj.entity = v
					table.insert(WardPositionTrack.WardList, tmp_obj)
				end
			end
		end
		WardPositionTrack.Init = true
	end

	for _, hero in pairs(Heroes.GetAll()) do
		if not Entity.IsSameTeam(myHero, hero) then
			local ward_dispenser = NPC.GetItem(hero, "item_ward_dispenser", 1)
			local ward_observer = NPC.GetItem(hero, "item_ward_observer", 1)
			local ward_sentry = NPC.GetItem(hero, "item_ward_sentry", 1)

			local num_observer, num_sentry

			if ward_dispenser then
				num_observer = Item.GetCurrentCharges(ward_dispenser)
				num_sentry = Item.GetSecondaryCharges(ward_dispenser)
			elseif ward_observer then
				num_observer = Item.GetCurrentCharges(ward_observer)
			elseif ward_sentry then
				num_sentry = Item.GetCurrentCharges(ward_sentry)
			end

			if num_observer == nil then
				num_observer = 0
			end
			if num_sentry == nil then
				num_sentry = 0
			end

			if WardPositionTrack.HeroLastState[hero] ~= nil and not WardPositionTrack.HeroLastState[hero] and not Entity.IsDormant(hero) then
				if WardPositionTrack.HeroNumObsWards[hero] ~= nil and (num_observer < WardPositionTrack.HeroNumObsWards[hero] or num_sentry < WardPositionTrack.HeroNumSenWards[hero])then
					local tmp_vec = Entity.GetAbsOrigin(hero) + Vector(500, 0, 0):Rotated(Entity.GetAbsRotation(hero))
					local tmp_obj = {}
					if num_observer < WardPositionTrack.HeroNumObsWards[hero] then
						tmp_obj.type = 1
						tmp_obj.radius = 1600
						tmp_obj.time = GameRules.GetGameTime() + 360
					else
						tmp_obj.type = 2
						tmp_obj.radius = 850
						tmp_obj.time = GameRules.GetGameTime() + 240
					end
					tmp_obj.position = tmp_vec
					table.insert(WardPositionTrack.WardList, tmp_obj)
				end
			end

			WardPositionTrack.HeroLastState[hero] = Entity.IsDormant(hero)
			WardPositionTrack.HeroNumObsWards[hero] = num_observer
			WardPositionTrack.HeroNumSenWards[hero] = num_sentry
		end
	end
end
local ScrollPos = 0
local ClickTime = 0
function WardPositionTrack.OnDraw()
	if not Menu.IsEnabled(WardPositionTrack.Enable) then
		return
	end
	if not Engine.IsInGame() then
		return
	end
	if not Heroes.GetLocal() then
		return
	end
	if Menu.IsEnabled(WardPositionTrack.EnablePanel) then
		Renderer.SetDrawColor(30, 30, 30, 150)
		Renderer.DrawFilledRect(WardPositionTrack.BaseX, WardPositionTrack.BaseY, math.floor(80 * WardPositionTrack.ScaleMult), math.floor(150 * WardPositionTrack.ScaleMult))
		Renderer.SetDrawColor(200, 200, 200, 150)
		Renderer.DrawOutlineRect(WardPositionTrack.BaseX, WardPositionTrack.BaseY, math.floor(80 * WardPositionTrack.ScaleMult), math.floor(150 * WardPositionTrack.ScaleMult))
		Renderer.SetDrawColor(20, 20, 20, 200)
		Renderer.DrawFilledRect(WardPositionTrack.BaseX, WardPositionTrack.BaseY + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(80 * WardPositionTrack.ScaleMult), math.floor(19 * WardPositionTrack.ScaleMult))
		Renderer.SetDrawColor(220, 220, 220, 250)
		Renderer.DrawText(WardPositionTrack.FontMenu1, WardPositionTrack.BaseX + math.floor(2 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(152 * WardPositionTrack.ScaleMult), ScrollPos .. "-" .. ScrollPos + 9 .. " " .. #WardPositionTrack.WardList)
		if Input.IsCursorInRect(WardPositionTrack.BaseX + math.floor(65 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(3 * WardPositionTrack.ScaleMult) + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult)) then
			Renderer.SetDrawColor(100, 100, 100, 250)
			Renderer.DrawFilledRect(WardPositionTrack.BaseX + math.floor(65 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(3 * WardPositionTrack.ScaleMult) + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult))
			if Input.IsKeyDown(Enum.ButtonCode.MOUSE_LEFT) and os.clock() > ClickTime then
				if ScrollPos > 0 then
					ScrollPos = ScrollPos - 1
				end
				ClickTime = os.clock() + 0.1
			end
		end
		Renderer.SetDrawColor(200, 200, 200, 150)
		Renderer.DrawOutlineRect(WardPositionTrack.BaseX + math.floor(65 * WardPositionTrack.ScaleMult),WardPositionTrack.BaseY + math.floor(3 * WardPositionTrack.ScaleMult) + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult))
		Renderer.SetDrawColor(255, 255, 255, 255)
		Renderer.DrawText(WardPositionTrack.FontMenu2, WardPositionTrack.BaseX + math.floor(65 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(150 * WardPositionTrack.ScaleMult), "↑")

		if Input.IsCursorInRect(WardPositionTrack.BaseX + math.floor(50 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(3 * WardPositionTrack.ScaleMult) + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult)) then
			Renderer.SetDrawColor(100, 100, 100, 250)
			Renderer.DrawFilledRect(WardPositionTrack.BaseX + math.floor(50 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(3 * WardPositionTrack.ScaleMult) + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult))
			if Input.IsKeyDown(Enum.ButtonCode.MOUSE_LEFT) and os.clock() > ClickTime then

				if ScrollPos + 9 < #WardPositionTrack.WardList then
					ScrollPos = ScrollPos + 1
				end
				ClickTime = os.clock() + 0.1
			end
		end
		Renderer.SetDrawColor(200, 200, 200, 150)
		Renderer.DrawOutlineRect(WardPositionTrack.BaseX + math.floor(50 * WardPositionTrack.ScaleMult),WardPositionTrack.BaseY + math.floor(3 * WardPositionTrack.ScaleMult) + math.floor(150 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult))
		Renderer.SetDrawColor(255, 255, 255, 255)
		Renderer.DrawText(WardPositionTrack.FontMenu2, WardPositionTrack.BaseX + math.floor(50 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(150 * WardPositionTrack.ScaleMult), "↓")
	end

	__WardList = WardPositionTrack.WardList
	for i, ward in pairs(WardPositionTrack.WardList) do
		if ward.time > GameRules.GetGameTime() then
			local x1, y1 = Renderer.WorldToScreen(ward.position)
			if ward.type == 1 then
				Renderer.SetDrawColor(255, 220, 150, 255)
			else
				Renderer.SetDrawColor(25, 170, 200, 255)
			end
			Renderer.DrawTextCentered(WardPositionTrack.Font, x1, y1, math.floor((ward.time - GameRules.GetGameTime()) / 60) .. ":" .. string.format("%02d", math.floor((ward.time - GameRules.GetGameTime()) % 60)), 1)
			WardPositionTrack.DrawCircle(ward.position, ward.radius)
			if i > ScrollPos and i <= ScrollPos + 9 and Menu.IsEnabled(WardPositionTrack.EnablePanel) then
				Renderer.DrawText(WardPositionTrack.FontMenu, WardPositionTrack.BaseX + math.floor(20 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(16 * WardPositionTrack.ScaleMult) * (i - ScrollPos - 1), math.floor((ward.time - GameRules.GetGameTime()) / 60) .. ":" .. string.format("%02d", math.floor((ward.time - GameRules.GetGameTime()) % 60)))
				if ward.type == 1 then
					Renderer.DrawText(WardPositionTrack.FontMenu, WardPositionTrack.BaseX + 5, WardPositionTrack.BaseY + math.floor(16 * WardPositionTrack.ScaleMult) * (i - ScrollPos - 1), "O")
				else
					Renderer.DrawText(WardPositionTrack.FontMenu, WardPositionTrack.BaseX + 5, WardPositionTrack.BaseY + math.floor(16 * WardPositionTrack.ScaleMult) * (i - ScrollPos - 1), "S")
				end
				if Input.IsCursorInRect(WardPositionTrack.BaseX + math.floor(60 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(16 * WardPositionTrack.ScaleMult) * (i - ScrollPos - 1) + math.floor(3 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult)) then
					Renderer.SetDrawColor(100, 100, 100, 250)
					Renderer.DrawFilledRect(WardPositionTrack.BaseX + math.floor(60 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(16 * WardPositionTrack.ScaleMult) * (i - ScrollPos - 1) + math.floor(3 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult))
					if Input.IsKeyDown(Enum.ButtonCode.MOUSE_LEFT) then
						Engine.ExecuteCommand("dota_camera_set_lookatpos " .. ward.position:GetX() .. " " .. ward.position:GetY())
					end
				end
				Renderer.SetDrawColor(200, 200, 200, 150)
				Renderer.DrawOutlineRect(WardPositionTrack.BaseX + math.floor(60 * WardPositionTrack.ScaleMult), WardPositionTrack.BaseY + math.floor(16 * WardPositionTrack.ScaleMult) * (i - ScrollPos - 1) + math.floor(3 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult), math.floor(14 * WardPositionTrack.ScaleMult))
			end
		else
			table.remove(WardPositionTrack.WardList, i)
		end
	end
end
return WardPositionTrack