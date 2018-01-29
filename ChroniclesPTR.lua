local DELAY_SEC = 0.250
local DELAY_2 = 0.050

local buffs_normal = {
	21564,	-- fort
	27681,	-- spirit
	27683,	-- shadow prot
	23028,	-- int
	21850,	-- motw
	9910,	-- thorns
	20906,	-- trueshot
}

local buffs_world = {
	22820,	-- DM 3% spellcrit
	22817,	-- DM 200 AP
	22818,	-- DM 15% stam

	22888,	-- dragonslayer
	15366,	-- songflower
	24425,	-- ZG heart
}

local buffs_heal = {
	29166,	-- innervate
	10929,	-- renew r9
	25299,	-- rejuvenation r11
	9858,	-- regrowth r9
}

local buffs_melee = {
	17626,	-- flask: titans
	17538,	-- Elixir of the Mongoose
	17038,	-- Winterfall Firewater
	16323,	-- Juju Power
	18192,	-- Grilled Squid - Increased Agility 10
}

local buffs_healer = {
	17627,	-- flask: distilled wisdom
	24363,	-- mageblood potion mp5
	18194,	-- nightfin soup mp5
}

local buffs_caster = {
	17628,	-- flask: supreme power
	18194,	-- nightfin soup mp5
	24363,	-- mageblood potion mp5
	17539,	-- Greater Arcane Elixir
	26276,	-- Elixir of Greater Firepower
	11474,	-- Elixir of Shadow Power
}

local class_buffs = {
	["Druid"]	= buffs_healer,
	["Hunter"]	= buffs_melee,
	["Mage"]	= buffs_caster,
	["Paladin"]	= buffs_healer,
	["Priest"]	= buffs_healer,
	["Rogue"]	= buffs_melee,
	["Shaman"]	= buffs_healer,
	["Warlock"]	= buffs_caster,
	["Warrior"]	= buffs_melee,
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

local function raid_update()
	if GetTime() > raid_nextupdate then
		local unit = "raid" .. raid_currentmember

		if not UnitExists(unit) then
			frame:SetScript("OnUpdate", nil)
			print("-- DONE --")
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

		local class_specific_buffs = class_buffs[UnitClass(unit)]
		if class_specific_buffs then
			buff_list(class_specific_buffs)
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

--------------------------------------------------------------------------------

local function make_chatcommand(name, func)
	setglobal("SLASH_PTR_" .. name .. "1", "/" .. name)
	SlashCmdList["PTR_" .. name] = func
end

make_chatcommand("die", gm_die)
make_chatcommand("tp", gm_tp)
make_chatcommand("rev", gm_rev)
make_chatcommand("skills", gm_skills)
