-- This module hold all the action we might want to take. --

local actions = {}

local helper = require("tew.Happenstance Hodokinesis.helper")


function actions.healVital(vital)
	local chance = helper.calcActionChance()
    local maxVital = helper.getMaxVital(vital)
    local randomValue = math.random()
    local range = maxVital - vital.current
    local increment = range * chance * randomValue

    vital.current = helper.roundFloat(vital.current + increment)
    vital.current = math.clamp(vital.current, vital.current, maxVital)

	helper.updateVitalsUI()
end


function actions.damageVital(vital)
	local chance = helper.calcActionChance()
	local randomValue = math.random()
    local range = math.clamp(vital.current / chance, vital.current - vital.current*2, vital.current)
    local decrement = range * randomValue

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
		vital.current = math.clamp(helper.roundFloat(vital.current - decrement), 1, helper.getMaxVital(vital))
	else
    	vital.current = math.clamp(vital.current - helper.roundFloat(decrement), vital.current - vital.current*2, vital.current)
	end


	helper.updateVitalsUI()
end


function actions.addPotionRestore(vital)
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, helper.getVitalRestoreEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
end

function actions.addIngredientRestore(vital)
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, helper.getVitalRestoreEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
end

function actions.addIngredientDamage(vital)
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, helper.getVitalDamageEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
end

function actions.addScrollRestore(vital)
	local scrollTable = helper.getScrolls(helper.getVitalRestoreEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
end

--
return actions