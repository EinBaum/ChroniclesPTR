local DELAY_SEC = 0.150
local DELAY_2 = 0.050

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
	["Shaman"]	= buffs_paladin,
	["Warlock"]	= buffs_shaman,
	["Warrior"]	= buffs_warrior,
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

--------------------------------------------------------------------------------

local function gm_die()
	raid_foreach(function(unit)
		cmd(".die")
	end)
end

local function gm_tp()
	raid_foreach(function(unit)
		cmd(".namego")
	end)
end

local function gm_rev()
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

local function gm_skills()
	raid_foreach(function(unit)
		cmd(".maxskill")
		cmd(".learn all_recipes enchanting")
		cmd(".learn all_recipes engineering")
	end)
end

local function gm_stop()
	stop()
end

--------------------------------------------------------------------------------

local function make_chatcommand(name, func)
	setglobal("SLASH_PTR_" .. name .. "1", "/" .. name)
	SlashCmdList["PTR_" .. name] = func
end

make_chatcommand("die", gm_die)
make_chatcommand("tp", gm_tp)
make_chatcommand("rev", gm_rev)
make_chatcommand("skills", gm_skills)
make_chatcommand("stop", gm_stop)
