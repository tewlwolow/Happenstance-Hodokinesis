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

function actions.addPotionFeather()
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.feather)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionBurden()
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.burden)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionDisease()
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.cureCommonDisease)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionBlight()
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.cureBlightDisease)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionCurePoison()
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.curePoison)
	tes3.addItem({
		reference = tes3.player,
		item = potionTable[helper.resolvePriority(#potionTable)]
	})
	helper.showMessage(messages.potion)
end

function actions.addPotionPoison()
	local potionTable = helper.getConsumables(tes3.objectType.alchemy, tes3.effect.poison)
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

function actions.addIngredientFeather()
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.feather)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientBurden()
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.burden)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientDisease()
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.cureCommonDisease)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientBlight()
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.cureBlightDisease)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end

function actions.addIngredientCurePoison()
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.curePoison)
	tes3.addItem({
		reference = tes3.player,
		item = ingredientTable[helper.resolvePriority(#ingredientTable)]
	})
	helper.showMessage(messages.ingredient)
end


function actions.addIngredientPoison()
	local ingredientTable = helper.getConsumables(tes3.objectType.ingredient, tes3.effect.poison)
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

function actions.addScrollOpen()
	local scrollTable = helper.getScrolls(tes3.effect.open, nil)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollLock()
	local scrollTable = helper.getScrolls(tes3.effect.lock, nil)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollFeather()
	local scrollTable = helper.getScrolls(tes3.effect.feather, tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollBurden()
	local scrollTable = helper.getScrolls(tes3.effect.burden, tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollDisease()
	local scrollTable = helper.getScrolls(tes3.effect.cureCommonDisease, tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollBlight()
	local scrollTable = helper.getScrolls(tes3.effect.cureBlightDisease, tes3.effectRange.self)
	tes3.addItem({
		reference = tes3.player,
		item = scrollTable[helper.resolvePriority(#scrollTable)]
	})
	helper.showMessage(messages.scroll)
end

function actions.addScrollCurePoison()
	local scrollTable = helper.getScrolls(tes3.effect.curePoison, tes3.effectRange.self)
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

	helper.playVisual(
		"Pteroma",
		{ id = tes3.effect.feather, duration = duration, min = power, max = power },
		tes3.player,
		data.vfx.alteration
	)
	helper.showMessage(messages.spellFeather)
end

function actions.burden()
	local duration = helper.roundFloat(math.remap(helper.resolvePriority(100), 1, 100, 5, 240))
	local power =  helper.resolvePriority(100)

	helper.playVisual(
		"Barophoria",
		{ id = tes3.effect.burden, duration = duration, min = power, max = power },
		tes3.player,
		data.vfx.alteration
	)
	helper.showMessage(messages.spellBurden)
end

function actions.bountyLess()
	local mp = tes3.mobilePlayer
	local bounty = mp.bounty
	local percentage = math.clamp(math.remap(helper.resolvePriority(100), 1, 100, 100, 1) / 100, 0.0, 1.0)
	local newBounty = helper.roundFloat((bounty) - (bounty * percentage))
	mp.bounty = newBounty
	helper.showMessage(messages.bountyLess)
end

function actions.bountyMore()
	local mp = tes3.mobilePlayer
	local bounty = mp.bounty
	local percentage = math.clamp(helper.resolvePriority(100) / 100, 0.0, 1.0)
	local newBounty = helper.roundFloat((bounty) + (bounty * percentage))
	mp.bounty = newBounty
	helper.showMessage(messages.bountyMore)
end

function actions.bountyTeleport()
	local locations = data.bountyNPCs
	local mp = tes3.mobilePlayer
	local teleportPosition, teleportCell
	if mp then
		teleportPosition, teleportCell = helper.getRandomNPCPositionFromTable(locations)
	end
	debug.log(teleportPosition)
	if teleportPosition and teleportCell then
		tes3.positionCell{
			position = teleportPosition,
			cell = teleportCell
		}
		helper.showMessage(messages.bountyTeleport)
	end
end

function actions.templeTeleport()
	helper.playVisual(
		"Trioktasis",
		{ id = tes3.effect.almsiviIntervention, duration = 1, min = 100, max = 100 },
		tes3.player,
		data.vfx.mysticism
	)
	helper.showMessage(messages.templeTeleport)
end

function actions.cultTeleport()
	helper.playVisual(
		"Theioktasis",
		{ id = tes3.effect.divineIntervention, duration = 1, min = 100, max = 100 },
		tes3.player,
		data.vfx.mysticism
	)
	helper.showMessage(messages.cultTeleport)
end

function actions.cureDisease()
	helper.playVisual(
		"Nososeuthesis",
		{ id = tes3.effect.cureCommonDisease, duration = 1, min = 100, max = 100 },
		tes3.player,
		data.vfx.restoration
	)
	helper.showMessage(messages.diseaseCured)
end

function actions.cureBlight()
	helper.playVisual(
		"Lytosepsis",
		{ id = tes3.effect.cureBlightDisease, duration = 1, min = 100, max = 100 },
		tes3.player,
		data.vfx.restoration
	)
	helper.showMessage(messages.blightCured)
end

function actions.curePoison()
	helper.playVisual(
		"Toxicure",
		{ id = tes3.effect.curePoison, duration = 1, min = 100, max = 100 },
		tes3.player,
		data.vfx.restoration
	)
	helper.showMessage(messages.poisonCured)
end

function actions.contractDisease()
	tes3.cast{
		reference = tes3.player,
		spell = table.choice(data.diseases),
		alwaysSucceeds = true,
		bypassResistances = true,
		instant = true,
		target = tes3.player
	}
	helper.showMessage(messages.diseaseContracted)
end

function actions.contractBlight()
	tes3.cast{
		reference = tes3.player,
		spell = table.choice(data.blights),
		alwaysSucceeds = true,
		bypassResistances = true,
		instant = true,
		target = tes3.player
	}
	helper.showMessage(messages.blightContracted)
end

function actions.poison()
	local duration = helper.roundFloat(math.remap(helper.resolvePriority(100), 1, 100, 5, 20))
	local power =  helper.resolvePriority(25)

	helper.playVisual(
		"Toxicon",
		{ id = tes3.effect.poison, duration = duration, min = power, max = power },
		tes3.player,
		data.vfx.poison
	)
	helper.showMessage(messages.spellPoison)
end

--
return actions