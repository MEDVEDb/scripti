local Tinker = {}
Tinker.IsEnabled		= Menu.AddOption({ "Hero Specific","Tinker" }, "Enabled", "")
Tinker.Version			= Menu.AddOption({ "Hero Specific","Tinker" }, "Version", "- Alpha", 1,1,1)
Tinker.DMGCalculator	= Menu.AddOption({ "Hero Specific","Tinker", "Extra" }, "DMG Calculator", "", 1, 3)
Tinker.KillIndicator	= Menu.AddOption({ "Hero Specific","Tinker", "Extra" }, "Kill Indicator", "")
Tinker.RocketIndicator	= Menu.AddOption({ "Hero Specific","Tinker", "Extra" }, "Rocket indicator", "Draws particle for current targets")

Tinker.FailRockets		= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Fail Switch" }, "Fail Rockets", "")
Tinker.FailRearm		= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Fail Switch" }, "Fail Rearm", "")

Tinker.ExtraSoul		= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Items" }, "Soul Ring", "Cast Soul Ring before each ability")
Tinker.ExtraSoulT		= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Items" }, "Soul Ring Threshold", "", 150, 500, 50)
Tinker.ExtraSoulCombo	= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Items" }, "Soul Ring in any combo", "")
Tinker.ExtraBottle		= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Items" }, "Bottle", "Drink bottle on yourself before each ability")

Tinker.FailRearmAI		= Menu.AddOption({ "Hero Specific","Tinker", "Extra", "Fail Switch" }, "Fail Rearm - check abilities / items", "")
Tinker.KillSteal		= Menu.AddOption({ "Hero Specific","Tinker", "Extra" }, "Steal Kill by Spells", "")
Tinker.CastRange		= Menu.AddOption({ "Hero Specific","Tinker", "Orders", "Common" }, "Nearest to mouse", "", 50, 2000, 50)

Menu.SetValueName(Tinker.Version, 1, "4.5")
Menu.SetValueName(Tinker.DMGCalculator, 1, "Off")
Menu.SetValueName(Tinker.DMGCalculator, 2, "Enabled - Bar")
Menu.SetValueName(Tinker.DMGCalculator, 3, "Enabled - Mouse")

Tinker.FontDMG				= Renderer.LoadFont("Tahoma", 16, Enum.FontWeight.BOLD)
Tinker.FontKill				= Renderer.LoadFont("Tahoma", 30, Enum.FontWeight.BOLD)

Tinker.ComboCurrentCast		= {}
Tinker.ComboLastCastTime	= {}
Tinker.Enabled				= false
Tinker.FailTimeRearm		= 0
Tinker.RearmCast			= false
Tinker.LastCDAB				= nil
Tinker.Hero					= nil
Tinker.NearestEnemyHero		= nil
Tinker.NearestEnemyHeroPos	= nil
Tinker.SuccessNearest		= false
Tinker.ManaPoint			= 0
Tinker.TotalMagicDamage		= 0
Tinker.TotalMagicFactor		= 0
Tinker.TotalPureDamage		= 0
Tinker.TotalManaCost		= 0
Tinker.TotalDamage			= 0
Tinker.Fountain				= nil
Tinker.OrdersCount			= 10
Tinker.SpellCount			= 15
Tinker.RocketTargers		= {}

Tinker.CastTypes	= {
	["item_blink"]						= 3,
	["item_veil_of_discord"]			= 3,
	["item_soul_ring"]					= 1,
	["item_bottle"]						= 1,
	["item_ghost"]						= 1,
	["item_shivas_guard"]				= 1,
	["item_orchid"]						= 2,
	["item_bloodthorn"]					= 2,
	["item_solar_crest"]				= 2,
	["item_medallion_of_courage"]		= 2,
	["item_rod_of_atos"]				= 2,
	["item_cyclone"]					= 2,
	["item_dagon"]						= 2,
	["item_nullifier"]					= 2,
	["item_travel_boots"]				= 3,
	["item_lotus_orb"]					= 2,
	["item_sheepstick"]					= 2,
	["item_ethereal_blade"]				= 2,
	["item_refresher"]					= 1,
	["item_arcane_boots"]				= 1,
	["tinker_laser"]					= 2,
	["tinker_heat_seeking_missile"]		= 1,
	["tinker_march_of_the_machines"]	= 3,
	["tinker_rearm"]					= 1
}

Tinker.Abilitys				=  {}

Tinker.CastPosition			=  {}
Tinker.CastPosition[1]		=  "Off"
Tinker.CastPosition[2]		=  "Ghost"
Tinker.CastPosition[3]		=  "Soul Ring"
Tinker.CastPosition[4]		=  "Hex"
Tinker.CastPosition[5]		=  "Veil"
Tinker.CastPosition[6]		=  "Ethereal"
Tinker.CastPosition[7]		=  "Orchid"
Tinker.CastPosition[8]		=  "Blood"
Tinker.CastPosition[9]		=  "Rod"
Tinker.CastPosition[10]		=  "Bottle"
Tinker.CastPosition[11]		=  "Dagon"
Tinker.CastPosition[12]		=  "Shiva"
Tinker.CastPosition[13]		=  "Boots to Mouse"
Tinker.CastPosition[14]		=  "Boots to Base"
Tinker.CastPosition[15]		=  "Eul's on Enemy"
Tinker.CastPosition[16]		=  "Eul's on Self"
Tinker.CastPosition[17]		=  "Blink to Mouse"
Tinker.CastPosition[18]		=  "Blink to Base"
Tinker.CastPosition[19]		=  "Lotus"
Tinker.CastPosition[20]		=  "Medallion of Courage"
Tinker.CastPosition[21]		=  "Solar Crest"
Tinker.CastPosition[22]		=  "Laser"
Tinker.CastPosition[23]		=  "Rockets"
Tinker.CastPosition[24]		=  "March"
Tinker.CastPosition[25]		=  "Rearm"
Tinker.CastPosition[26]		=  "Safe Blink"
Tinker.CastPosition[27]		=  "Nullifier"
Tinker.CastPositionLength	=  27

Tinker.Orders				=  {}

Tinker.SafePos				=
{
	Vector(-7305, -5016, 384),
	Vector(-7328, -4768, 384),
	Vector(-7264, -4505, 384),
	Vector(-7136, -4384, 384),
	Vector(-7072, -1120, 384),
	Vector(-7072, -672, 384),
	Vector(-7200, -288, 384),
	Vector(-6880, 288, 384),
	Vector(-6944, 1568, 384),
	Vector(-6688, 3488, 384),
	Vector(-6752, 3616, 384),
	Vector(-6816, 3744, 384),
	Vector(-6816, 4448, 384),
	Vector(-5152, 5088, 384),
	Vector(-3936, 5536, 384),
	Vector(-5152, 6624, 384),
	Vector(-3680, 6624, 384),
	Vector(-2720, 6752, 384),
	Vector(-2720, 5536, 384),
	Vector(-1632, 6688, 384),
	Vector(-1056, 6752, 384),
	Vector(-736, 6816, 384),
	Vector(-992, 5536, 384),
	Vector(-1568, 5536, 384),
	Vector(608, 7008, 384),
	Vector(1632, 6752, 256),
	Vector(2336, 7136, 384),
	Vector(1568, 3040, 384),
	Vector(1824, 3296, 384),
	Vector(-2976, 480, 384),
	Vector(736, 1056, 256),
	Vector(928, 1248, 256),
	Vector(928, 1696, 256),
	Vector(2784, 992, 256),
	Vector(-2656, -1440, 256),
	Vector(-2016, -2464, 256),
	Vector(-2394, -3110, 256),
	Vector(-1568, -3232, 256),
	Vector(-2336, -4704, 256),
	Vector(-416, -7072, 384),
	Vector(2336, -5664, 384),
	Vector(2464, -5728, 384),
	Vector(2848, -5664, 384),
	Vector(2400, -6817, 384),
	Vector(3040, -6624, 384),
	Vector(4256, -6624, 384),
	Vector(4192, -6880, 384),
	Vector(5024, -5408, 384),
	Vector(5856, -6240, 384),
	Vector(6304, -6112, 384),
	Vector(6944, -5472, 384),
	Vector(7328, -5024, 384),
	Vector(7200, -3296, 384),
	Vector(7200, -2272, 384),
	Vector(6944, -992, 384),
	Vector(6816, -224, 384),
	Vector(7200, 480, 384),
	Vector(7584, 2080, 256),
	Vector(7456, 2784, 384),
	Vector(5344, 2528, 384),
	Vector(7200, 5536, 384),
	Vector(4192, 6944, 384),
	Vector(5472, 6752, 384),
	Vector(-6041, -6883, 384),
	Vector(-5728, -6816, 384),
	Vector(-5408, -7008, 384),
	Vector(-5088, -7072, 384),
	Vector(-4832, -7072, 384),
	Vector(-3744, -7200, 384)
}

local list = "List:"
local tempi = 1
for k,v in pairs(Tinker.CastPosition) do
	list = list .. "\r\n" .. tempi .. " - " .. v
	tempi = tempi + 1
end

for i = 1, Tinker.OrdersCount do 
	Tinker.Orders[i] = {}
	local temp = i
	if i < 10 then temp = "0" .. i end
	Tinker.Orders[i][100] = Menu.AddOption({ "Hero Specific","Tinker", "Orders", "Order #" .. temp }, temp .. ". Enabled", "" )
	Tinker.Orders[i][200] = Menu.AddKeyOption({ "Hero Specific","Tinker", "Orders", "Order #" .. temp }, temp .. ". Key", Enum.ButtonCode.KEY_PAD_0 )
	Tinker.Orders[i][300] = Menu.AddOption({ "Hero Specific","Tinker", "Orders", "Order #" .. temp }, temp .. ". Reset", "", 1, 10, 1)
	Tinker.Orders[i][400] = Menu.AddOption({ "Hero Specific","Tinker", "Orders", "Order #" .. temp }, temp .. ". MP Threshold", "", 0, 2000, 100)

	for l = 1, Tinker.SpellCount do	
		local stemp = ""
		if l < 10 then stemp = "0" end
		Tinker.Orders[i][l] =  Menu.AddOption({ "Hero Specific","Tinker", "Orders", "Order #" .. temp }, temp .. ". Spell cast #" .. stemp .. l, list, 1, Tinker.CastPositionLength )
		for k, v in pairs(Tinker.CastPosition) do
			Menu.SetValueName(Tinker.Orders[i][l], k, v)
		end
	end
	
end

function Tinker.OnUpdate()
	Tinker.Enabled = false
	
	if not Menu.IsEnabled(Tinker.IsEnabled) then return end
	if Tinker.Hero == nil or not Entity.IsNPC(Tinker.Hero) then Tinker.Hero = Heroes.GetLocal() end
	if not Entity.IsNPC(Tinker.Hero) then return end
	if	NPC.GetUnitName(Tinker.Hero) ~= "npc_dota_hero_tinker"
		or	NPC.HasModifier(Tinker.Hero, "modifier_teleporting")
		or	not Entity.IsAlive(Tinker.Hero) 
	then return end
	
	Tinker.Enabled		= true
	Tinker.ManaPoint	= NPC.GetMana(Tinker.Hero)
	if Tinker.Fountain == nil then
		for i = 1, NPCs.Count() do 
			local npc = NPCs.Get(i)
			if Entity.IsSameTeam(Tinker.Hero, npc) and NPC.IsStructure(npc) then
				local name = NPC.GetUnitName(npc)
				if name ~= nil and name == "dota_fountain" then
					Tinker.Fountain = npc
				return end
			end
		end
	end
	
	for k, v in pairs(Tinker.CastTypes) do
		Tinker.InitAbility(k)
	end

	if Menu.IsEnabled(Tinker.RocketIndicator) then	
		Tinker.Indicate()
	end 
	
	for i = 1, Tinker.OrdersCount do
		if Menu.IsKeyDown(Tinker.Orders[i][200])  and Menu.IsEnabled(Tinker.Orders[i][100]) and not Input.IsInputCaptured() then
			if Tinker.ComboLastCastTime[i] == nil then Tinker.ComboLastCastTime[i] = os.clock() end
			if Tinker.ComboLastCastTime[i] < os.clock() - Menu.GetValue(Tinker.Orders[i][300]) then Tinker.CastList[i] = {} end
			
			if Tinker.ManaPoint <= Menu.GetValue(Tinker.Orders[i][400]) then return end
			if NPC.IsChannellingAbility(Tinker.Hero) then return end
			if NPC.IsSilenced(Tinker.Hero) then return end
			if NPC.IsStunned(Tinker.Hero) then return end
			Tinker.PreComboWombo(i)
			Tinker.ComboLastCastTime[i] = os.clock()

			return
		end
	end
	
	if Menu.IsEnabled(Tinker.KillSteal) then
		Tinker.StealCheck()
	end
end

function Tinker.Indicate()
	if not Tinker.Abilitys['tinker_heat_seeking_missile'] then return end
	local targets	= 2
	if	NPC.GetItem(Tinker.Hero, "item_ultimate_scepter", true) ~= nil then
		targets		= 4
	end
	for k, v in pairs(Heroes.GetAll()) do
		if not Entity.IsSameTeam(Tinker.Hero, v) then
			if	NPC.IsEntityInRange(Tinker.Hero, v, Ability.GetCastRange(Tinker.Abilitys['tinker_heat_seeking_missile']))
				and Entity.IsAlive(v)
				and not Entity.IsDormant(v)
			then
				local d = Entity.GetAbsOrigin(v):Distance(Entity.GetAbsOrigin(Tinker.Hero)):Length2D()
				if Tinker.RocketTargers[NPC.GetUnitName(v)] == nil then
					local t = {}
					t.hero = v
					t.particle = nil
					t.dis = d
					Tinker.RocketTargers[NPC.GetUnitName(v)] = t
				else
					Tinker.RocketTargers[NPC.GetUnitName(v)].dis = d
				end
			else
				if Tinker.RocketTargers[NPC.GetUnitName(v)] ~= nil then
					if Tinker.RocketTargers[NPC.GetUnitName(v)].particle ~= nil then
						Particle.Destroy(Tinker.RocketTargers[NPC.GetUnitName(v)].particle)
						Tinker.RocketTargers[NPC.GetUnitName(v)].particle = nil
					end
				end
			end
		end
	end
	
	local sortedKeys = getKeysSortedByValue(Tinker.RocketTargers, function(a, b) return a.dis < b.dis end)

	if Length(Tinker.RocketTargers) > 2 then
		local ta = Tinker.RocketTargers
		local i = 0
		Tinker.RocketTargers = {}
		for k, v in pairs(sortedKeys) do
			if i < targets
			then
				Tinker.RocketTargers[v] = ta[v]
				i = i + 1
			else
				if ta[v].particle ~= nil then
					Particle.Destroy(ta[v].particle)
				end
			end
		end
		
		
	end

end

function Tinker.OnGameStart()
	Tinker.ComboCurrentCast		= {}
	Tinker.ComboLastCastTime	= {}
	Tinker.Enabled				= false
	Tinker.FailTimeRearm		= 0
	Tinker.RearmCast			= false
	Tinker.LastCDAB				= nil
	Tinker.Hero					= nil
	Tinker.NearestEnemyHero		= nil
	Tinker.NearestEnemyHeroPos	= nil
	Tinker.SuccessNearest		= false
	Tinker.ManaPoint			= 0
	Tinker.TotalMagicDamage		= 0
	Tinker.TotalMagicFactor		= 0
	Tinker.TotalPureDamage		= 0
	Tinker.TotalManaCost		= 0
	Tinker.TotalDamage			= 0
	Tinker.Fountain				= nil
	Tinker.CastList				= {}
	Tinker.RocketTargers		= {}
end

Tinker.CastList					= {}
Tinker.CastPosition				= {}
Tinker.CastPosition[1]			=  "Off"
Tinker.CastPosition[2]			=  "item_ghost"
Tinker.CastPosition[3]			=  "item_soul_ring"
Tinker.CastPosition[4]			=  "item_sheepstick"
Tinker.CastPosition[5]			=  "item_veil_of_discord"
Tinker.CastPosition[6]			=  "item_ethereal_blade"
Tinker.CastPosition[7]			=  "item_orchid"
Tinker.CastPosition[8]			=  "item_bloodthorn"
Tinker.CastPosition[9]			=  "item_rod_of_atos"
Tinker.CastPosition[10]			=  "item_bottle"
Tinker.CastPosition[11]			=  "item_dagon"
Tinker.CastPosition[12]			=  "item_shivas_guard"
Tinker.CastPosition[13]			=  "item_travel_boots"
Tinker.CastPosition[14]			=  "item_travel_boots"
Tinker.CastPosition[15]			=  "item_cyclone"
Tinker.CastPosition[16]			=  "item_cyclone"
Tinker.CastPosition[17]			=  "item_blink"
Tinker.CastPosition[18]			=  "item_blink"
Tinker.CastPosition[19]			=  "item_lotus_orb"
Tinker.CastPosition[20]			=  "item_medallion_of_courage"
Tinker.CastPosition[21]			=  "item_solar_crest"
Tinker.CastPosition[22]			=  "tinker_laser"
Tinker.CastPosition[23]			=  "tinker_heat_seeking_missile"
Tinker.CastPosition[24]			=  "tinker_march_of_the_machines"
Tinker.CastPosition[25]			=  "tinker_rearm"
Tinker.CastPosition[26]			=  "item_blink"
Tinker.CastPosition[27]			=  "item_nullifier"

function Tinker.PreComboWombo(order)
	if Tinker.CastList[order] == nil then Tinker.CastList[order] = {} end
	local inc = 1
	if Length(Tinker.CastList[order]) == 0 then
		for i = 1, Tinker.SpellCount do
			if Tinker.Orders[order][i] > 1 then
				local a = Tinker.Abilitys[Tinker.CastPosition[Menu.GetValue(Tinker.Orders[order][i])]]
				if a ~= nil and Ability.IsCastable(a, Tinker.ManaPoint) then
					Tinker.CastList[order][inc] = Menu.GetValue(Tinker.Orders[order][i])
					inc = inc + 1
				end
			end
		end
	end
	
	if Length(Tinker.CastList[order]) > 0 then
		local a = Tinker.Abilitys[Tinker.CastPosition[Tinker.CastList[order][1]]]
		if	not Ability.IsCastable(a, Tinker.ManaPoint)
			or (Ability.GetName(a) == "tinker_rearm" and Tinker.LastCDAB == nil)
		then
			table.remove(Tinker.CastList[order], 1)
		else
			Tinker.ComboCast(Tinker.CastList[order][1])
		end
	end
end

function Tinker.ComboCast(cast)
	if Tinker.RearmCast then return end
	
	Tinker.SuccessNearest			=	false
	Tinker.NearestEnemyHero			=	Input.GetNearestHeroToCursor(Entity.GetTeamNum(Tinker.Hero), Enum.TeamType.TEAM_ENEMY)
	if	Tinker.NearestEnemyHero		~=	nil	then
		Tinker.NearestEnemyHeroPos	=	Entity.GetAbsOrigin(Tinker.NearestEnemyHero)
		Tinker.SuccessNearest		=	NPC.IsPositionInRange(Tinker.NearestEnemyHero, Input.GetWorldCursorPos(), Menu.GetValue(Tinker.CastRange), 0)
	end
	
	if Menu.IsEnabled(Tinker.ExtraSoulCombo) then
		if	NPC.GetItem(Tinker.Hero, "item_soul_ring", true) ~= nil 
			and Entity.GetHealth(Tinker.Hero) > Menu.GetValue(Tinker.ExtraSoulT)
		then
			Tinker.Cast('item_soul_ring', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
		end
	end
	
	if cast == 2 then 
		Tinker.Cast('item_ghost', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 3 then 
		Tinker.Cast('item_soul_ring', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 4 then 
		Tinker.Cast('item_sheepstick', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 5 then 
		Tinker.Cast('item_veil_of_discord', Tinker.Hero, Tinker.NearestEnemyHero, NPC.GetAbsOrigin(Tinker.NearestEnemyHero), Tinker.ManaPoint)
	return end
	
	if cast == 6 then 
		Tinker.Cast('item_ethereal_blade', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 7 then 
		Tinker.Cast('item_orchid', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 8 then 
		Tinker.Cast('item_bloodthorn', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 9 then 
		Tinker.Cast('item_rod_of_atos', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 10 then 
		Tinker.Cast('item_bottle', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 11 then 
		Tinker.Cast('item_dagon', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 12 then 
		Tinker.Cast('item_shivas_guard', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 13 then 
		Tinker.Cast('item_travel_boots', Tinker.Hero, nil, Input.GetWorldCursorPos(), Tinker.ManaPoint)
	return end
	
	if cast == 14 then 
		Tinker.Cast('item_travel_boots', Tinker.Hero, nil, NPC.GetAbsOrigin(Tinker.Fountain), Tinker.ManaPoint)
	return end
	
	if cast == 15 then 
		Tinker.Cast('item_cyclone', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 16 then 
		Tinker.Cast('item_cyclone', Tinker.Hero, Tinker.Hero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 17 then 
		Tinker.Cast('item_blink', Tinker.Hero, Tinker.NearestEnemyHero, Input.GetWorldCursorPos(), Tinker.ManaPoint)
	return end
	
	if cast == 18 then 
		Tinker.Cast('item_blink', Tinker.Hero, Tinker.NearestEnemyHero, NPC.GetAbsOrigin(Tinker.Fountain), Tinker.ManaPoint)
	return end
	
	if cast == 19 then 
		Tinker.Cast('item_lotus_orb', Tinker.Hero, Tinker.Hero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 20 then 
		Tinker.Cast('item_medallion_of_courage', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == 21 then 
		Tinker.Cast('item_solar_crest', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end

	if cast == (Tinker.CastPositionLength - 5) then 
		Tinker.Cast('tinker_laser', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == (Tinker.CastPositionLength - 4) then 
		Tinker.Cast('tinker_heat_seeking_missile', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
	
	if cast == (Tinker.CastPositionLength - 3) then 
		Tinker.Cast('tinker_march_of_the_machines', Tinker.Hero, Tinker.NearestEnemyHero, NPC.GetAbsOrigin(Tinker.Hero), Tinker.ManaPoint)
	return end
	
	if cast == (Tinker.CastPositionLength - 2) then
		if Tinker.LastCDAB ~= nil then
			Tinker.Cast('tinker_rearm', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
		end
	return end

	if cast == (Tinker.CastPositionLength - 1) then 
		local t = false
		for k, v in pairs(Tinker.SafePos) do 
			if	Input.GetWorldCursorPos():Distance(v):Length() < 1200
			then
				t = true
				Tinker.Cast('item_blink', Tinker.Hero, Tinker.NearestEnemyHero, v, Tinker.ManaPoint)
			break end
		end
		
		if not t then 
			Tinker.Cast('item_blink', Tinker.Hero, Tinker.NearestEnemyHero, Input.GetWorldCursorPos(), Tinker.ManaPoint)
		end
	return end
	
	if cast == Tinker.CastPositionLength then 
		Tinker.Cast('item_nullifier', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
	return end
end

function Tinker.InitAbility(name)
	if not Tinker.Enabled then return end
	
	Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, name, true) or NPC.GetAbility(Tinker.Hero, name)
	
	-- kostyli
	if name == "item_dagon" then
		Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, "item_dagon", true)
		for i = 0, 5 do
			if not Tinker.Abilitys[name] then Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, "item_dagon_" .. i, true) end
		end
	end

	if name == "item_travel_boots" then
		Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, "item_travel_boots", true)
		for i = 0, 2 do
			if not Tinker.Abilitys[name] then Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, "item_travel_boots_" .. i, true) end
		end
	end
	
	if Tinker.Abilitys[name] ~= nil then
		if Ability.GetCooldownTimeLeft(Tinker.Abilitys[name]) > 0 and Tinker.LastCDAB == nil then
			Tinker.LastCDAB = Tinker.Abilitys[name]
		end
	end
	
	if not Entity.IsAbility(Tinker.LastCDAB) or (Tinker.LastCDAB ~= nil and Ability.IsReady(Tinker.LastCDAB))  then
		Tinker.RearmCast	= false
		Tinker.LastCDAB		= nil
	end
end

function Tinker.Cast(name, self, npc, position, manapoint)
	local ability = NPC.GetItem(self, name, true) or NPC.GetAbility(self, name)

	if name == "item_dagon" then
		ability = NPC.GetItem(self, "item_dagon", true)

		for i = 0, 5 do
			if not ability then ability = NPC.GetItem(self, "item_dagon_" .. i, true) end
		end
	end

	if name == "item_travel_boots" then
		Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, "item_travel_boots", true)
		for i = 0, 2 do
			if not Tinker.Abilitys[name] then Tinker.Abilitys[name] = NPC.GetItem(Tinker.Hero, "item_travel_boots_" .. i, true) end
		end
	end
	
	local casttype = Tinker.CastTypes[name]
	if ability == nil then return end
	if	ability
		and  Ability.IsCastable(ability, Tinker.ManaPoint)
		and  Ability.IsReady(ability)
	then
		if casttype	== 1 then Ability.CastNoTarget(ability)
			elseif casttype == 2 then 
				if 	Tinker.SuccessNearest
					and	not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)
					and NPC.IsEntityInRange(npc, self, Ability.GetCastRange(ability))
				then
					Ability.CastTarget(ability, npc)
				end
			else Ability.CastPosition(ability, position)
		end
		
		if	name == "tinker_rearm"	then
			Tinker.RearmCast = true
		end
	end
end

function Tinker.StealCheck()
	local abilityLaser = NPC.GetAbilityByIndex(Tinker.Hero, 0)
    local abilityRockets = NPC.GetAbilityByIndex(Tinker.Hero, 1)
	local dmgLaser, dmgRockets = 0, 0
	local uniqRangeBonus = NPC.GetAbilityByIndex(Tinker.Hero, 10)	
	local uniqDamageBonus = NPC.GetAbilityByIndex(Tinker.Hero, 11)	

	if Ability.GetLevel(abilityLaser) > 0 then dmgLaser = Ability.GetLevelSpecialValueFor(abilityLaser, "laser_damage") end
	if Ability.GetLevel(abilityRockets) > 0 then dmgRockets = Ability.GetDamage(abilityRockets) end

	local totaldmg = dmgLaser + dmgRockets
	
	local abilityLens = NPC.GetItem(Tinker.Hero, "item_aether_lens", true)
		
	local laserRadius = 650
	local rocketsRadius = 2500
	
	if abilityLens then 
		laserRadius = laserRadius + 220
		rocketsRadius = rocketsRadius + 220
	end

	if Ability.GetLevel(uniqRangeBonus) == 1 then
		laserRadius = laserRadius + 75
		rocketsRadius = rocketsRadius + 75
	end
	
	if Ability.GetLevel(uniqDamageBonus) == 1 then
		totaldmg = totaldmg + 100
	end
	
	for d, npc in pairs(Entity.GetHeroesInRadius(Tinker.Hero, laserRadius, Enum.TeamType.TEAM_ENEMY)) do	
		if Entity.IsHero(npc) 
			and not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) 
			and not Entity.IsDormant(npc) 
			and Ability.IsReady(abilityLaser)
			and Ability.IsCastable(abilityLaser, Tinker.ManaPoint) 
		then
			local ttlDMG = NPC.GetMagicalArmorDamageMultiplier(npc) * totaldmg
			
			if Entity.GetHealth(npc) < ttlDMG then
				Ability.CastTarget(abilityLaser, npc)
			end

			if Entity.GetHealth(npc) < ttlDMG and Entity.IsAlive(npc) and Ability.IsCastable(abilityRockets, Tinker.ManaPoint) and Ability.IsReady(abilityRockets)  then
				Ability.CastNoTarget(abilityRockets) 
			end
		end
	end
	
	for d, npc in pairs(Entity.GetHeroesInRadius(Tinker.Hero, rocketsRadius, Enum.TeamType.TEAM_ENEMY)) do	
		if Entity.IsHero(npc) and not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not Entity.IsDormant(npc) then
			local ttlDMG = NPC.GetMagicalArmorDamageMultiplier(npc) * dmgRockets
			
			if Entity.GetHealth(npc) < ttlDMG and Ability.IsCastable(abilityRockets, Tinker.ManaPoint) and Ability.IsReady(abilityRockets) then
				Ability.CastNoTarget(abilityRockets) 
			end
		end
	end
end

function Tinker.OnDraw()
	if not Menu.IsEnabled(Tinker.DMGCalculator) then return true end
	if Tinker.Hero == nil or not Entity.IsNPC(Tinker.Hero) then return end
	if NPC.GetUnitName(Tinker.Hero) ~= "npc_dota_hero_tinker" then return end
	CalculateTotalDMG()
	if Tinker.TotalDamage == 0 then return end
	
	if Menu.GetValue(Tinker.DMGCalculator) == 2 then
		Renderer.SetDrawColor(0, 0, 0, 255)
		Renderer.DrawFilledRect(0, 250, 120, 30)
		Renderer.SetDrawColor(255, 255, 255, 255)
		Renderer.DrawTextCenteredX(Tinker.FontDMG, 60, 257, "damage: " .. math.floor(Tinker.TotalDamage), 1)
	end
	
	if Menu.GetValue(Tinker.DMGCalculator) == 3 then
		local x, y = Input.GetCursorPos()
		Renderer.SetDrawColor(0, 0, 0, 70)
		Renderer.DrawFilledRect(x - 60, y - 35, 120, 30)
		Renderer.SetDrawColor(255, 255, 255, 255)
		Renderer.DrawTextCenteredX(Tinker.FontDMG, x, y - 28, "damage: " .. math.floor(Tinker.TotalDamage), 1)
	end
	
	if not Menu.IsEnabled(Tinker.KillIndicator) then return true end

	local fullDMG = math.floor(Tinker.ManaPoint / Tinker.TotalManaCost) * Tinker.TotalDamage
	
	for i = 1, Heroes.Count() do
		local hero = Heroes.Get(i)
		if	not Entity.IsSameTeam(Tinker.Hero, hero) 
			and Entity.IsAlive(hero)
			and not Entity.IsDormant(hero)
			then
			local hp = Entity.GetHealth(hero)
			local dmg = fullDMG * NPC.GetMagicalArmorDamageMultiplier(hero)
			if dmg > hp then
				local pos = Entity.GetAbsOrigin(hero)
				local x, y, visible = Renderer.WorldToScreen(pos)
				if visible then
					Renderer.SetDrawColor(255, 0, 0, 255)
					Renderer.DrawTextCentered(Tinker.FontKill, x, (y + 20), "*")
				end
			end
		end
	end
	
	if Menu.IsEnabled(Tinker.RocketIndicator) then
		for k, v in pairs(Tinker.RocketTargers) do
			if v.particle == nil then
				v.particle =	Particle.Create("particles/ui_mouseactions/range_finder_tower_aoe.vpcf", Enum.ParticleAttachment.PATTACH_INVALID, v.hero)
			end
				
			Particle.SetControlPoint(v.particle, 2, Entity.GetOrigin(Tinker.Hero))
			Particle.SetControlPoint(v.particle, 6, Vector(1, 0, 0))
			Particle.SetControlPoint(v.particle, 7, Entity.GetOrigin(v.hero))
		end
	end
end

function Tinker.OnPrepareUnitOrders(orders)
	if not Tinker.Enabled then return true end
	
	if	orders.ability ~= nil 
		and Entity.IsAbility(orders.ability) 
	then
		if orders.order == Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_NO_TARGET then
			if Menu.IsEnabled(Tinker.FailRockets) then
				if Ability.GetName(orders.ability) == "tinker_heat_seeking_missile"
				then
					local c = #Entity.GetHeroesInRadius(Tinker.Hero, Ability.GetCastRange(orders.ability), Enum.TeamType.TEAM_ENEMY)
					if c == 0 then	return false end
				end
			end
			
			if Menu.IsEnabled(Tinker.FailRearm) then
				if Ability.GetName(orders.ability) == "tinker_rearm"
				then
					if GameRules.GetGameTime() < Tinker.FailTimeRearm then return false end
					local abilityRearm = NPC.GetAbility(Tinker.Hero, 'tinker_rearm')
					if Ability.IsChannelling(abilityRearm) then
						return false
					else
						Tinker.FailTimeRearm = Ability.GetCastPoint(orders.ability) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + GameRules.GetGameTime() + 0.1
					end

					if Menu.IsEnabled(Tinker.FailRearmAI) then
						local ret = false
						for i = 0, 5 do 
							local item = NPC.GetItemByIndex(Tinker.Hero, i)
							local ab = NPC.GetAbilityByIndex(Tinker.Hero, i)
							
							if ab ~= nil and Ability.GetCooldown(ab) > 0 then
								ret = true
							end
							
							if item ~= nil and Ability.GetCooldown(item) > 0 then
								ret = true
							end
						end
						
						if not ret then return ret end
					end
				end
			end		
		end
		
		if orders.order > 4 and orders.order < 10 then
			if Menu.IsEnabled(Tinker.ExtraSoul) then
				if	NPC.GetItem(Tinker.Hero, "item_soul_ring", true) ~= nil 
					and Entity.GetHealth(Tinker.Hero) > Menu.GetValue(Tinker.ExtraSoulT)
				then
					Tinker.Cast('item_soul_ring', Tinker.Hero, Tinker.NearestEnemyHero, nil, Tinker.ManaPoint)
				end
			end
			
			if Menu.IsEnabled(Tinker.ExtraBottle) then
				local bott = NPC.GetItem(Tinker.Hero, "item_bottle", true)
				if	bott ~= nil 
					and Ability.IsCastable(bott, Tinker.ManaPoint)
					and (Entity.GetHealth(Tinker.Hero) < Entity.GetMaxHealth(Tinker.Hero) or Tinker.ManaPoint < NPC.GetMaxMana(Tinker.Hero))
					and not NPC.HasModifier(Tinker.Hero, "modifier_bottle_regeneration")
				then
					Ability.CastNoTarget(bott)
				end
			end
		end
	end
	
	
	return true
end

function CalculateTotalDMG()
	if Tinker.Hero == nil then return end
	
	Tinker.TotalPureDamage = 0
	Tinker.TotalMagicDamage = 0
	Tinker.TotalMagicFactor = 0
	Tinker.TotalManaCost = 0
	local xfactor = 1

	local laser = NPC.GetAbilityByIndex(Tinker.Hero, 0)
    local rocket = NPC.GetAbilityByIndex(Tinker.Hero, 1)
    local rearm = NPC.GetAbility(Tinker.Hero, 'tinker_rearm')
	local uniqLaserBonus = NPC.GetAbilityByIndex(Tinker.Hero, 12)	
	local uniqDamageBonus = NPC.GetAbilityByIndex(Tinker.Hero, 6)	
		
	xfactor = xfactor + Hero.GetIntellectTotal(Tinker.Hero) / 100 * 0.066891
	
	if Ability.GetLevel(uniqDamageBonus) == 1 then
		xfactor = xfactor + 0.06
	end
	
	Tinker.TotalMagicFactor = xfactor
	
	local tempVeil = NPC.GetItem(Tinker.Hero, "item_veil_of_discord", true)
	if tempVeil
	then 
		Tinker.TotalMagicFactor = Tinker.TotalMagicFactor + 0.25 
		Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(tempVeil)
	end
	
	if NPC.GetItem(Tinker.Hero, "item_kaya", true)
	then 
		Tinker.TotalMagicFactor = Tinker.TotalMagicFactor + 0.10
		xfactor = xfactor + 0.10
	end
	
	
	local tempEthereal = NPC.GetItem(Tinker.Hero, "item_ethereal_blade", true)
	if tempEthereal
	then 
		Tinker.TotalMagicFactor = Tinker.TotalMagicFactor + 0.4 
		Tinker.TotalMagicDamage = Tinker.TotalMagicDamage + (75 + (Hero.GetIntellectTotal(Tinker.Hero) * 2))
		Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(tempEthereal)
	end

	local tempShivas = NPC.GetItem(Tinker.Hero, "item_shivas_guard", true)
	if	tempShivas
	then 
		Tinker.TotalMagicDamage = Tinker.TotalMagicDamage + Ability.GetLevelSpecialValueFor(tempShivas, "blast_damage")
		Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(tempShivas)
	end

	for i = 0, 5 do
		local dagon = NPC.GetItem(Tinker.Hero, "item_dagon_" .. i, true)
		if i == 0 then dagon = NPC.GetItem(Tinker.Hero, "item_dagon", true) end
        if dagon then
			Tinker.TotalMagicDamage = Tinker.TotalMagicDamage + Ability.GetLevelSpecialValueFor(dagon, "damage")
			Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(dagon)
		end
    end	
		
	if Ability.GetLevel(laser) > 0 then Tinker.TotalPureDamage = Tinker.TotalPureDamage + Ability.GetLevelSpecialValueFor(laser, "laser_damage") end
	if Ability.GetLevel(uniqLaserBonus) == 1 then
		Tinker.TotalPureDamage = Tinker.TotalPureDamage + 100
	end

	if Ability.GetLevel(rocket) > 0 then Tinker.TotalMagicDamage = Tinker.TotalMagicDamage + Ability.GetLevelSpecialValueFor(rocket, "damage") end
		
	Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(laser)
	Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(rocket)
	Tinker.TotalManaCost = Tinker.TotalManaCost + Ability.GetManaCost(rearm)
	
	Tinker.TotalDamage = (Tinker.TotalMagicDamage * Tinker.TotalMagicFactor) + (Tinker.TotalPureDamage * xfactor)
end

return Tinker
