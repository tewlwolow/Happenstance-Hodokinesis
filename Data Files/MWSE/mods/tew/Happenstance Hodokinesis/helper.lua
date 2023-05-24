-- A couple of helper functions. --


local helper = {}

local config = require("tew.Happenstance Hodokinesis.config")
local dataHandler = require("tew.Happenstance Hodokinesis.dataHandler")

-- We need to calculate a chance of good/bad effects to happen, based on the player's Luck --
function helper.calcActionChance()
	local chance = math.clamp((tes3.mobilePlayer.luck.current / 100 - (dataHandler.getUsedPerDay(tes3.worldController.daysPassed.value) / 10)), 0.05, 1.0)
	debug.log(chance)
	return chance
end

function helper.calcBoon()
	return helper.calcActionChance() > math.random()
end

function helper.getVitalRestoreEffect(vital)

	local vitalEffects = {
		["health"] = tes3.effect.restoreHealth,
		["fatigue"] = tes3.effect.restoreFatigue,
		["magicka"] = tes3.effect.restoreMagicka
	}

	return vitalEffects[helper.getVitalName(vital)]
end

function helper.getVitalDamageEffect(vital)

	local vitalEffects = {
		["health"] = tes3.effect.damageHealth,
		["fatigue"] = tes3.effect.damageFatigue,
		["magicka"] = tes3.effect.damageMagicka
	}

	return vitalEffects[helper.getVitalName(vital)]
end

function helper.getConsumables(objectType, effect)
	local tab = {}
	for _, obj in ipairs(tes3.dataHandler.nonDynamicData.objects) do
		if obj.objectType == objectType then
			if obj.effects then
				if objectType == tes3.objectType.ingredient then
					if obj.effects[1] == effect then
						table.insert(tab, obj)
					end
				elseif objectType == tes3.objectType.alchemy then
					if obj.effects[1].id == effect then
						table.insert(tab, obj)
					end
				end
			end
		end
	end
	table.sort(tab, function(a, b) return a.value > b.value end)
	return tab
end

function helper.getScrolls(effect, effectRange)
	local tab = {}
	for _, obj in ipairs(tes3.dataHandler.nonDynamicData.objects) do
		if obj.objectType == tes3.objectType.book and obj.type == tes3.bookType.scroll then
			if obj.enchantment then
				for _, e in ipairs(obj.enchantment.effects) do
					if e.id == effect then
						if effectRange then
							if e.rangeType == effectRange then
								table.insert(tab, obj)
							end
						else
							table.insert(tab, obj)
						end
					end
				end
			end
		end
	end
	table.sort(tab, function(a, b) return a.value > b.value end)
	return tab
end

function helper.roundFloat(n)
	return math.floor(math.abs(n + 0.5))
end

function helper.resolvePriority(tableSize)
	if tableSize == 1 then return tableSize end

	local luck = tes3.mobilePlayer.luck.current
	local clampedLuck = math.clamp(luck, 0, 100)

	local minIndex = 1
	local maxIndex = tableSize

	-- Adjust the scaling factor as needed
	local scalingFactor = 1 - clampedLuck / 100

	-- Determine whether to completely randomize the luck
	local completelyRandom = math.random() <= 0.15 -- Adjust the chance as desired

	local randomOffset = 0
	if completelyRandom then
	  randomOffset = math.random(minIndex, maxIndex)
	else
	  -- Calculate the random offset with adjusted scaling factor
	  randomOffset = math.random() * scalingFactor * (clampedLuck / 100) - scalingFactor * (clampedLuck / 200)
	end

	local index = math.floor(scalingFactor * (maxIndex - minIndex) + minIndex + randomOffset)

	index = math.clamp(index, minIndex, maxIndex)

	return index
end


-- Fillbars don't update immediately, so we need to force it. --
function helper.updateVitalsUI()
	local menuIds = {
		tes3ui.findMenu(tes3ui.registerID("MenuStat")),
		tes3ui.findMenu(tes3ui.registerID("MenuMulti"))
	}

	local barIds = {
		[tes3.mobilePlayer.health] = tes3ui.registerID("MenuStat_health_fillbar"),
		[tes3.mobilePlayer.fatigue] = tes3ui.registerID("MenuStat_fatigue_fillbar"),
		[tes3.mobilePlayer.magicka] = tes3ui.registerID("MenuStat_magic_fillbar"),
	}

	for _, menu in ipairs(menuIds) do
		for vital, id in pairs(barIds) do
			local bar = menu:findChild(id)

			if bar then
				bar.widget.current = vital.current
				bar:updateLayout()
				menu:updateLayout()
			end
		end
	end
end

-- I suppose there might change in between calls, so make sure we factor that in. --
function helper.numbersClose(firstValue, secondValue)
	return math.isclose(firstValue, secondValue, 0.01)
end

-- Get a vital name to use in data indexing
function helper.getVitalName(vital)

	local vitalEffects = {
		[tes3.mobilePlayer.health] = "health",
		[tes3.mobilePlayer.fatigue] = "fatigue",
		[tes3.mobilePlayer.magicka] = "magicka"
	}

	for v, e in pairs(vitalEffects) do
		if (
			(helper.numbersClose(vital.base, v.base))
				and
			(helper.numbersClose(vital.baseRaw, v.baseRaw))
				and
			(helper.numbersClose(vital.current, v.current))
				and
			(helper.numbersClose(vital.currentRaw, v.currentRaw))
				and
			(helper.numbersClose(vital.normalized, v.normalized))
		) then
			return e
		end
	end
end


-- We need to know which fortify effect might be at play. --
function helper.getFortifyEffect(vital)
	local vitalEffects = {
		["health"] = tes3.effect.fortifyHealth,
		["fatigue"] = tes3.effect.fortifyFatigue,
		["magicka"] = tes3.effect.fortifyMagicka
	}
	return vitalEffects[helper.getVitalName(vital)]
end

-- Max stats are essentialy the base value + any fortify effects at a given time, so let's make sure we calculate from the actual max value available. --
function helper.getMaxVital(vital)

	local fortifyEffect = helper.getFortifyEffect(vital)

	-- If we don't match any effect for some reason, let's just not do anything
	local fortifyBonus = 0

	if fortifyEffect then
		fortifyBonus = tes3.getEffectMagnitude({
			reference = tes3.player,
			effect = fortifyEffect
		})
	end

	return (vital.base + fortifyBonus)
end

function helper.cast(name, effects, ref, vfx)
	local magicSourceInstance = tes3.applyMagicSource({
		name = name,
		reference = ref,
		castChance = 100,
		bypassResistances = true,
		effects = effects
	})
	magicSourceInstance:playVisualEffect{
		effectIndex = 0,
		position = ref.position,
		visual = vfx
	}
end

function helper.showMessage(message)
	if config.showInfoMessages then
		tes3.messageBox{
			message = message
		}
	end
end

function helper.getRandomNPCPositionFromTable(tab)
	local mp = tes3.mobilePlayer
	if mp then
		local npc = tes3.getReference(table.choice(tab))
		return npc.position:copy(), npc.cell
	end
end

function helper.getExteriorDoor(cell)
	for door in cell:iterateReferences(tes3.objectType.door) do
		if door.destination then
			if (door.destination.cell.isOrBehavesAsExterior) then
				return door
			end
		end
	end
end

--
return helper