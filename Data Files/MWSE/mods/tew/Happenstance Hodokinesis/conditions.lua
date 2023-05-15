-- This file holds condition checks as a table of dispatch-like functions. --
-- These should always return a boolean value indicating whether the condition is met, an action function to take, and a parameter to act upon when the action function is called. --

local conditions = {}

--
local config = require("tew.Happenstance Hodokinesis.config")
local actions = require("tew.Happenstance Hodokinesis.actions")
--

-- Determine if player needs healing for any 3 base vitals. --
function conditions.playerVitalsLow()
	-- Action definition --
	local action = actions.healVital

	local statNames = {"health", "fatigue", "magicka"}

	-- Internal checker for vitals --
	local function statisticLow(statName)
		local stat = tes3.mobilePlayer[statName]
		if stat then
			return stat.normalized < config.vitalsThreshold / 100, stat.normalized
		end
	end

	-- Check all three vitals and write it off to a table. --
	local vitals = {}
	for _, s in pairs(statNames) do
		local statLow, statRatio = statisticLow(s)
		vitals[s] = {
			isLow = statLow,
			ratio = statRatio,
			vital = tes3.mobilePlayer[s]
		}
	end

	-- We need to know all the vitals that might be low to determine the one with the lowest ratio. --
	local lowVitals = {}
	for _, data in pairs(vitals) do
		if data.isLow then
			lowVitals[data.ratio] = data.vital
		end
	end

	-- Determine vital with the lowest ratio and return it. --
	local lowestRatio = nil
	if not table.empty(lowVitals) then
		lowestRatio = math.min(table.unpack(table.keys(lowVitals)))
	end

	return lowestRatio ~= nil, action, lowVitals[lowestRatio]
end


--
return conditions