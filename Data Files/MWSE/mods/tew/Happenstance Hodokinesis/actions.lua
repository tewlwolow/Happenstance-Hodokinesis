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

	local minRange
	local v = tes3.mobilePlayer.health
	if (
		(helper.numbersClose(vital.base, v.base))
			and
		(helper.numbersClose(vital.baseRaw, v.baseRaw))
			and
		(helper.numbersClose(vital.current, vital.current))
			and
		(helper.numbersClose(vital.currentRaw, vital.currentRaw))
			and
		(helper.numbersClose(vital.normalized, vital.normalized))
	) then
		minRange = 1
	else
		minRange = vital.current / 2
	end

	local maxRange = vital.current
	local deduction = math.random(minRange, maxRange)

	vital.current = vital.current - deduction

	-- We need to make sure the visual changes are applied immediately. --
	helper.updateVitalsUI()
end

--
return actions