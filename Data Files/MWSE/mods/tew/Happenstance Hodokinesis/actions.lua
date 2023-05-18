-- This module hold all the action we might want to take. --

local actions = {}

local helper = require("tew.Happenstance Hodokinesis.helper")

-- This action is called when we detect player has low vitals. --
function actions.healVital(vital)
	if not vital then return end

	local minRange = vital.current / 2
	local maxRange = helper.getMaxVital(vital)
	local addition = math.random(minRange, maxRange)

	vital.current = vital.current + addition

	-- We need to make sure the visual changes are applied immediately. --
	helper.updateVitalsUI()
end

-- This action is called when we detect player has low vitals. --
function actions.damageVital(vital)
	if not vital then return end

	local minRange = vital.current / 2
	local maxRange = vital.current
	local deduction = math.random(minRange, maxRange)
	local health = tes3.mobilePlayer.health
	if (
		(helper.numbersClose(vital.base, health.base))
			and
		(helper.numbersClose(vital.baseRaw, health.baseRaw))
			and
		(helper.numbersClose(vital.current, health.current))
			and
		(helper.numbersClose(vital.currentRaw, health.currentRaw))
			and
		(helper.numbersClose(vital.normalized, health.normalized))
	) then
		vital.current = math.ceil(math.clamp(vital.current - deduction, 1, maxRange))
	else
		vital.current = math.ceil(vital.current - deduction)
	end

	-- We need to make sure the visual changes are applied immediately. --
	helper.updateVitalsUI()
end

--
return actions