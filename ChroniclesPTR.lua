local DELAY_SEC = 0.150
local DELAY_2 = 0.050

local factions = {
	529,	-- Argent Dawn
	609,	-- Cenarion
	910,	-- Nozdormu
	270,	-- Zandalar
}

local buffs_normal = {
	21564,	-- fort
	27681,	-- spirit
	27683,	-- shadow prot
	23028,	-- int
	21850,	-- motw
	9910,	-- thorns
	20906,	-- trueshot

	17548,	-- grt shadow prot
	17546,	-- grt nature prot
	24382,	-- zanza
	3593,	-- Elixir of Fortitude
}

local buffs_world = {
	22820,	-- DM 3% spellcrit
	22817,	-- DM 200 AP
	22818,	-- DM 15% stam

	22888,	-- dragonslayer
	15366,	-- songflower
	24425,	-- ZG heart
}

local buffs_druid = {
	17627,	-- flask: distilled wisdom
	24363,	-- mageblood potion mp5
	18194,	-- nightfin soup mp5
	22790,	-- DMN beer spirit
}

local buffs_hunter = {
	17626,	-- flask: titans
	17538,	-- Elixir of the Mongoose
	24363,	-- mageblood potion mp5
	18192,	-- Grilled Squid - Increased Agility 10
	5665,	-- Fury of the Bogling 1 phys dmg
	16329,	-- Juju might
	22789,	-- DMN beer stamina
}

local buffs_mage = {
	17628,	-- flask: supreme power
	18194,	-- nightfin soup mp5
	24363,	-- mageblood potion mp5
	17539,	-- Greater Arcane Elixir
	26276,	-- Elixir of Greater Firepower
	22790,	-- DMN beer spirit
}

local buffs_paladin = {
	17627,	-- flask: distilled wisdom
	24363,	-- mageblood potion mp5
	18194,	-- nightfin soup mp5
	22790,	-- DMN beer spirit
}

local buffs_priest = buffs_paladin
local buffs_shaman = buffs_paladin

local buffs_rogue = {
	17626,	-- flask: titans
	17538,	-- Elixir of the Mongoose
	20452,	-- Smoked Desert Dumplings - 20 str
	5665,	-- Fury of the Bogling 1 phys dmg
	16329,	-- Juju might
	12451,	-- Juju power
	22789,	-- DMN beer stamina
}

local buffs_warlock = {
	17628,	-- flask: supreme power
	18194,	-- nightfin soup mp5
	24363,	-- mageblood potion mp5
	17539,	-- Greater Arcane Elixir
	11474,	-- Elixir of shadowpower
	22790,	-- DMN beer spirit
}

local buffs_warrior = {
	17626,	-- flask: titans
	17538,	-- Elixir of the Mongoose
	20452,	-- Smoked Desert Dumplings - 20 str
	5665,	-- Fury of the Bogling 1 phys dmg
	16329,	-- Juju might
	12451,	-- Juju power
	22789,	-- DMN beer stamina
}

local buffs_heal = {
	29166,	-- innervate
	10929,	-- renew r9
	25299,	-- rejuvenation r11
	9858,	-- regrowth r9
}

local class_buffs = {
	["Druid"]	= buffs_druid,
	["Hunter"]	= buffs_hunter,
	["Mage"]	= buffs_mage,
	["Paladin"]	= buffs_paladin,
	["Priest"]	= buffs_priest,
	["Rogue"]	= buffs_rogue,
	["Shaman"]	= buffs_shaman,
	["Warlock"]	= buffs_warlock,
	["Warrior"]	= buffs_warrior,
}

local gear_druid = {
	19395,
	17064,
	19140,
	19382,
	19437,
	18875,
	21609,
	16899,
	22399,
	19312,
	21523,
	16904,
	16897,
	19430,
	18810,
	20685,
	21615,
-- heal extra
	21625,
}
local gear_hunter = {
	16939,
	18404,
	16937,
	17102,
	16942,
	16935,
	19865,
	19859,
	19361,
	16940,
	16936,
	16938,
	16941,
	19953,
	13965,
	19376,
	21596,
-- quivers
	18714,
	19320
}
local gear_mage = {
	21597,
	21622,
	19339,
	19379,
	21709,
	21210,
	16437,
	21461,
	22730,
	21585,
	19375,
	18814,
	19370,
	19857,
	16443,
	21186,
	19861,
	18820,
	19950
}
local gear_paladin = {
	19395,
	19950,
	19382,
	19140,
	18510,
	19885,
	19360,
	21610,
	22402,
-- T2
	16957,
	16954,
	16952,
	16956,
	16951,
	16958,
	16953,
	16955,
-- not T2
	19437,
	21667,
	19162,
	20264,
	21472,
	18810,
	19145,
	21604,
-- extra
	19343,
	21625
}
local gear_priest = {
-- heal
	21615,
	19885,
	16924,
	19430,
	21663,
	16926,
	18608,
	19395,
	18469,
	19140,
	19382,
	19437,
	16922,
	21582,
	21619,
	19435,
-- heal extra
	21625,
-- shadow
	19370,
	18814,
	21351,
	22731,
	19407,
	22730,
	21600,
	21709,
	21461,
	19379,
	18820,
	19434,
	21186,
	19360,
	19309,
	21603,
-- shadow extra
	19950,
	17064,
	19397
}
local gear_rogue = {
	21360,
	19377,
	21361,
	21701,
	21364,
	21602,
	18823,
	21586,
	21362,
	21359,
	21205,
	17063,
	21670,
	19406,
	21126,
	21244,
	17069,
	19384,
	21672,
	21650,
	19351,
	19866,
}
local gear_shaman = {
	22345,
	21372,
	21507,
	21376,
	19430,
	21374,
	16943,
	19360,
	19348,
	16948,
	16944,
	21375,
	21373,
	21620,
	19382,
	17064,
	19395
}
local gear_warlock = {
	19950,
	19379,
	21709,
	21417,
	21338,
	21336,
	16933,
	19407,
	21273,
	21186,
	21334,
	19857,
	21335,
	18814,
	21337,
	19861,
	18820,
}
local gear_warrior = {
-- dps
	21329,
	22732,
	21330,
	21710,
	21331,
	21602,
	19019,
	19351,
	21459,
	16863,
	21598,
	21332,
	21333,
	21205,
	17063,
	19341,
	21180,
	21650,
	21664,
-- tank
	19431,
	19406,
	21601,
	21269,
}

local class_gear = {
	["Druid"]	= gear_druid,
	["Hunter"]	= gear_hunter,
	["Mage"]	= gear_mage,
	["Paladin"]	= gear_paladin,
	["Priest"]	= gear_priest,
	["Rogue"]	= gear_rogue,
	["Shaman"]	= gear_shaman,
	["Warlock"]	= gear_warlock,
	["Warrior"]	= gear_warrior,
}

--------------------------------------------------------------------------------

local frame = CreateFrame("frame")
local raid_nextupdate = 0
local raid_currentmember = 1
local raid_onlytarget = true
local raid_function = nil

--------------------------------------------------------------------------------

local function print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 0.5)
end

local function stop()
	frame:SetScript("OnUpdate", nil)
	print("-- DONE --")
end

local function raid_update()
	if GetTime() > raid_nextupdate then
		local unit = "raid" .. raid_currentmember

		if not UnitExists(unit) then
			stop()
			return
		end

		if UnitIsUnit("player", unit) or not UnitIsConnected(unit) then
			print("Ignoring: " .. UnitName(unit))
			raid_currentmember = raid_currentmember + 1
			raid_nextupdate = GetTime() + DELAY_2
			raid_onlytarget = true
		else
			if raid_onlytarget then
				print("Targeting: [" .. raid_currentmember .. "] " .. UnitName(unit))
				ClearTarget()
				TargetUnit(unit)
			else
				if UnitIsUnit("target", unit) then
					raid_function(unit)
				end
				raid_currentmember = raid_currentmember + 1
			end

			raid_nextupdate = GetTime() + DELAY_SEC
			raid_onlytarget = not raid_onlytarget
		end
	end
end

local function raid_foreach(func)
	if frame:GetScript("OnUpdate") then
		print("Another command is being executed right now.")
	else
		print("-- COMMAND --")
		raid_currentmember = 1
		raid_onlytarget = true
		raid_function = func
		frame:SetScript("OnUpdate", raid_update)
	end
end

local function ontarget(func)
	if UnitExists("target") then
		func("target")
	else
		print("You need a target!")
	end
end

--------------------------------------------------------------------------------

local function cmd(text)
	SendChatMessage(text, "SAY")
end

local function buff_list(list)
	for _, buff in list do
		cmd(".aura " .. buff)
	end
end

local function cast_list(list)
	for _, spell in list do
		cmd(".cast " .. spell)
	end
end

local function give_gearlist(list)
	for _, item in list do
		cmd(".additem " .. item)
	end
end

--------------------------------------------------------------------------------

local function gm_raid_die()
	raid_foreach(function(unit)
		cmd(".die")
	end)
end

local function gm_raid_tp()
	raid_foreach(function(unit)
		cmd(".namego")
	end)
end

local function gm_raid_rev()
	raid_foreach(function(unit)
		cmd(".namego")
		cmd(".revive")

		cmd(".cooldown")
		cmd(".repairitems")
		buff_list(buffs_heal)
		buff_list(buffs_normal)
		--buff_list(buffs_world)

		local my_buffs = class_buffs[UnitClass(unit)]
		if my_buffs then
			buff_list(my_buffs)
		end
	end)
end

local function gm_raid_stop()
	stop()
end

local function gm_skills()
	ontarget(function(unit)
		cmd(".maxskill")
		cmd(".learn all_recipes enchanting")
		cmd(".learn all_recipes engineering")
	end)
end

local function gm_bags()
	ontarget(function(unit)
		cmd(".additem 17966 4") -- Onyxia bag
	end)
end

local function gm_gear()
	ontarget(function(unit)
		local my_gear = class_gear[UnitClass("target")]
		if my_gear then
			give_gearlist(my_gear)
		end
	end)
end

local function gm_rep()
	ontarget(function(unit)
		for _, faction in factions do
			cmd(".mod rep " .. faction .. " 999999")
		end
	end)
end

--------------------------------------------------------------------------------

local function gm_foreach(args)
	raid_foreach(function(unit)
		cmd(args)
	end)
end

--------------------------------------------------------------------------------

local chatcommand_list = {}

local function print_help()
	local str = "commands: "
	for cmd, _ in chatcommand_list do
		str = str .. cmd .. " "
	end
	print(str)
end

local function make_chatcommand(name, func)
	chatcommand_list[name] = 1
	setglobal("SLASH_PTR_" .. name .. "1", "/" .. name)
	SlashCmdList["PTR_" .. name] = func
end

--------------------------------------------------------------------------------

make_chatcommand("gm", print_help)

make_chatcommand("die", gm_raid_die)
make_chatcommand("tp", gm_raid_tp)
make_chatcommand("rev", gm_raid_rev)
make_chatcommand("stop", gm_raid_stop)

make_chatcommand("skills", gm_skills)
make_chatcommand("bags", gm_bags)
make_chatcommand("gear", gm_gear)
make_chatcommand("rep", gm_rep)

make_chatcommand("foreach", gm_foreach)
