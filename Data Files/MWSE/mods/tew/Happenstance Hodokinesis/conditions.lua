-- This file holds condition checks as a table of dispatch-like functions. --
-- These should always return a boolean value indicating whether the condition is met, an action function to take, and a parameter to act upon when the action function is called. --

local conditions = {}

--
local config = require("tew.Happenstance Hodokinesis.config")
local actions = require("tew.Happenstance Hodokinesis.actions")
local helper = require("tew.Happenstance Hodokinesis.helper")
--

-- Determine if player needs healing for any 3 base vitals. --
function conditions.playerVitalsLow(boon)
	-- Action definition --
	-- Order matters. Top = best/less annoying
	local dispatch = {
		[true] = {
			actions.healVital,
			actions.addScrollRestore,
			actions.addPotionRestore,
			actions.addIngredientRestore
		},
		[false] = {
			actions.addIngredientDamage,
			actions.damageVital
		}
	}
	local priority = helper.resolvePriority(#dispatch[boon])

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

	return lowestRatio ~= nil, function() dispatch[boon][priority](lowVitals[lowestRatio]) end
end

---

-- Determine if player is looking at a locked object. --
function conditions.playerLookingAtLock(boon)
	-- Action definition --
	-- Order matters. Top = best/less annoying
	local dispatch = {
		[true] = {
			actions.unlock,
			actions.addScrollOpen,
			actions.lockLess
		},
		[false] = {
			actions.addScrollLock,
			actions.lockMore
		}
	}
	local priority = helper.resolvePriority(#dispatch[boon])

	local result = tes3.getPlayerTarget()

	return tes3.getLocked{reference = result}, function() dispatch[boon][priority](result) end
end

---


-- Determine if player is encumbered. --
function conditions.playerEncumbered(boon)
	-- Action definition --
	-- Order matters. Top = best/less annoying
	local dispatch = {
		[true] = {
			actions.feather,
			actions.addScrollFeather,
			actions.addPotionFeather,
			actions.addIngredientFeather
		},
		[false] = {
			actions.addIngredientBurden,
			actions.addPotionBurden,
			actions.addScrollBurden,
			actions.burden
		}
	}

	local priority = helper.resolvePriority(#dispatch[boon])

	local mp = tes3.mobilePlayer

	local playerEncumbered = false
	if mp then
		local encumbrance = mp.encumbrance
		if encumbrance.normalized >= 1.0 then
			playerEncumbered = true
		end
	end

	return playerEncumbered, dispatch[boon][priority]
end

---

-- Determine if player has a bounty on their head. --
function conditions.playerWanted(boon)
	-- Action definition --
	-- Order matters. Top = best/less annoying
	local dispatch = {
		[true] = {
			actions.bountyLess
		},
		[false] = {
			actions.bountyMore
		}
	}
	-- TODO: Detect if player in TG, teleport to nearest bounty handler

	local priority = helper.resolvePriority(#dispatch[boon])

	local mp = tes3.mobilePlayer

	local bounty = mp.bounty

	return bounty ~= 0, dispatch[boon][priority]
end


--
return conditions