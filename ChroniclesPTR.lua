local DELAY_SEC = 0.250

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
}

local buffs_healer = {
	17627,	-- flask: distilled wisdom
	24363,	-- mageblood potion mp5
	18194,	-- nightfin soup mp5
}

local buffs_caster = {
	17628,	-- flask: supreme power
}

local class_buffs = {
	["Druid"]	= buffs_healer,
	["Hunter"]	= buffs_melee,
	["Mage"]	= buffs_caster,
	["Paladin"]	= buffs_healer,
	["Priest"]	= buffs_healer,
	["Rogue"]	= buffs_melee,
	["Shaman"]	= buffs_melee,
	["Warlock"]	= buffs_caster,
	["Warrior"]	= buffs_melee,
}

--------------------------------------------------------------------------------

local frame = CreateFrame("frame")
local raid_lastupdate = 0
local raid_currentmember = 1
local raid_onlytarget = true
local raid_function = nil

--------------------------------------------------------------------------------

local function print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text, 1, 0.6, 0.9)
end

local function raid_update()
	if GetTime() - raid_lastupdate > DELAY_SEC then
		local unit = "raid" .. raid_currentmember

		if not UnitExists(unit) then
			frame:SetScript("OnUpdate", nil)
			return
		end

		if UnitIsUnit("player", unit) then
			raid_currentmember = raid_currentmember + 1
		else
			if raid_onlytarget then
				print("Target: " .. raid_currentmember)
				TargetUnit(unit)
			else
				if UnitIsUnit("target", unit) then
					raid_function(unit)
				end
				raid_currentmember = raid_currentmember + 1
			end
		end

		raid_onlytarget = not raid_onlytarget
		raid_lastupdate = GetTime()
	end
end

local function raid_foreach(func)
	if frame:GetScript("OnUpdate") then
		print("Another command is being executed right now.")
	else
		raid_currentmember = 1
		raid_onlytarget = true
		raid_function = func
		frame:SetScript("OnUpdate", raid_update)
	end
end

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

local function gm_die()
	raid_foreach(function(unit)
		cmd(".die")
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

--------------------------------------------------------------------------------

SLASH_PTR_DIE1 = "/die"
SlashCmdList["PTR_DIE"] = gm_die

SLASH_PTR_REV1 = "/rev"
SlashCmdList["PTR_REV"] = gm_rev
