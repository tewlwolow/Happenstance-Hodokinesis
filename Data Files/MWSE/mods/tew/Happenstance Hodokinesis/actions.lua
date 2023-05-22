-- This module hold all the action we might want to take. --

local actions = {}

local helper = require("tew.Happenstance Hodokinesis.helper")
local data = require("tew.Happenstance Hodokinesis.data")
local messages = require("tew.Happenstance Hodokinesis.messages")


function actions.healVital(vital)
	local chance = helper.calcActionChance()
    local maxVital = helper.getMaxVital(vital)
    local randomValue = math.random()
    local range = maxVital - vital.current
    local increment = range * chance * randomValue

    vital.current = helper.roundFloat(vital.current + increment)
    vital.current = math.clamp(vital.current, vital.current, maxVital)

	helper.playVisual(tes3.player, data.vfx.restoration)
	helper.updateVitalsUI()
	helper.showMessage(messages.healedVital)
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
	helper.playVisual(tes3.player, data.vfx.destruction)

	helper.updateVitalsUI()
	helper.showMessage(messages.damagedVital)
end


function actions.addPotionRestore(vital)
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, helper.getVitalRestoreEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionFeather(ref)
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.feather)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionBurden(ref)
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.burden)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addIngredientRestore(vital)
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, helper.getVitalRestoreEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientDamage(vital)
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, helper.getVitalDamageEffect(vital))
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientFeather(vital)
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.feather)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientBurden(vital)
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.burden)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addScrollRestore(vital)
	local scrollTable = helper.getScrolls(helper.getVitalRestoreEffect(vital), tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollOpen(ref)
	local scrollTable = helper.getScrolls(tes3.effect.open, nil)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollLock(ref)
	local scrollTable = helper.getScrolls(tes3.effect.lock, nil)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollFeather(ref)
	local scrollTable = helper.getScrolls(tes3.effect.feather, tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollBurden(ref)
	local scrollTable = helper.getScrolls(tes3.effect.burden, tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.unlock(ref)
	helper.playVisual(ref, data.vfx.alteration)
	tes3.unlock{reference = ref}
	helper.showMessage(messages.unlocked)
end

function actions.lockLess(ref)
	helper.playVisual(ref, data.vfx.alteration)
	local lockNode = ref.lockNode
	if lockNode then
		local levelOld = lockNode.level
		local levelNew = math.clamp(helper.roundFloat(helper.resolvePriority(100)), 1, levelOld)
		lockNode.level = levelNew
	end
	helper.showMessage(messages.lockedLess)
end

function actions.lockMore(ref)
	helper.playVisual(ref, data.vfx.alteration)
	local lockNode = ref.lockNode
	if lockNode then
		local levelOld = lockNode.level
		local levelNew = math.clamp(helper.roundFloat(helper.resolvePriority(100)), levelOld, 100)
		lockNode.level = levelNew
	end
	helper.showMessage(messages.lockedMore)
end

function actions.feather()
	local duration = helper.roundFloat(math.remap(helper.resolvePriority(100), 1, 100, 240, 5))
	local power =  helper.roundFloat(math.remap(helper.resolvePriority(100), 1, 100, 100, 1))
	debug.log(duration)
	debug.log(power)

	local magicSourceInstance = tes3.applyMagicSource({
		name = "Pteroma",
		reference = tes3.player,
		castChance = 100,
		bypassResistances = true,
		effects = {
		{ id = tes3.effect.feather, duration = duration, min = power, max = power },
		}
	})
	magicSourceInstance:playVisualEffect{
		effectIndex = 0,
		position = tes3.player.position,
		visual = data.vfx.alteration
	}
	helper.showMessage(messages.spellFeather)
end

function actions.burden()
	local duration = helper.roundFloat(math.remap(helper.resolvePriority(100), 1, 100, 240, 5))
	local power =  helper.roundFloat(math.remap(helper.resolvePriority(100), 1, 100, 100, 1))

	local magicSourceInstance = tes3.applyMagicSource({
		name = "Barophoria",
		reference = tes3.player,
		castChance = 100,
		bypassResistances = true,
		effects = {
		{ id = tes3.effect.burden, duration = duration, min = power, max = power },
		}
	})
	magicSourceInstance:playVisualEffect{
		effectIndex = 0,
		position = tes3.player.position,
		visual = data.vfx.alteration
	}
	helper.showMessage(messages.spellBurden)
end

--
return actions