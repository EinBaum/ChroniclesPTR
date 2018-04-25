local DELAY_SEC = 0.150
local DELAY_2 = 0.050

--------------------------------------------------------------------------------

-- from other files
local class_gear = ChroniclesPTR_class_gear
local class_zg_enchants = ChroniclesPTR_zg_enchants

local buffs_class = ChroniclesPTR_buffs_class
local buffs_normal = ChroniclesPTR_buffs_normal
local buffs_world = ChroniclesPTR_buffs_world
local buffs_heal = ChroniclesPTR_buffs_heal


local factions = {
	529,	-- Argent Dawn
	609,	-- Cenarion
	910,	-- Nozdormu
	270,	-- Zandalar
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

		local my_buffs = buffs_class[UnitClass(unit)]
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
		cmd(".learn all_recipes enchanting")
		cmd(".learn all_recipes engineering")
		cmd(".learn all_recipes first aid")
		cmd(".learn 33391") -- Riding
		cmd(".maxskill")
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
		local my_zg = class_zg_enchants[UnitClass("target")]
		if my_zg then
			for i = 1, 4 do
				cmd(".additem " .. my_zg[1]) -- 4 leg/head enchants
			end
			for i = 1, 2 do
				cmd(".additem " .. my_zg[2]) -- 4 leg/head enchants
			end
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
