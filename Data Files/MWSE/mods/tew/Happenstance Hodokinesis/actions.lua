-- This module hold all the action we might want to take. --

local actions = {}

local helper = require("tew.Happenstance Hodokinesis.helper")

-- This action is called when we detect player has low vitals. --
function actions.healVital(vital, boon)
	-- We need to determine whether to apply a bonus or a malus. --
	local signum = -1
	if boon then signum = 1 end

	-- Apply our effect, either positive or negative, and give the effect a little boost and randomness. --
	vital.current = signum * (helper.calcActionChance() / (math.random(50, 200) / 100)) * helper.getMaxVital(vital)

	-- We need to make sure the visual changes are applied immediately. --
	helper.updateVitalsUI()
end

--
return actions