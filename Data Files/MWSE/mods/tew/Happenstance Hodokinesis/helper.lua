-- A couple of helper functions. --


local helper = {}

-- We need to calculate a chance of good/bad effects to happen, based on the player's Luck --
function helper.calcActionChance()
	-- TODO: introduce diminishing returns based on data - how many times used today? If more than x, diminish chance.
	return (tes3.mobilePlayer.luck.current / 100) + 0.1
end

function helper.calcBoon()
	return helper.calcActionChance() > math.random()
end

function helper.resolvePriority(tableSize)
	if tableSize == 1 then return tableSize end

	local luck = tes3.mobilePlayer.luck.current ~= 0 and tes3.mobilePlayer.luck.current or 1
	local luck_inverted = 101 - luck

	local range_min = math.floor(luck * 0.25) -- Adjust the scaling factor as needed
	local range_max = math.floor(luck * 0.75) -- Adjust the scaling factor as needed

	local randomness = math.random(range_max - range_min + 1) + range_min - 0.5

	local luck_normalised = luck + randomness

	return math.floor(math.remap(luck_normalised, luck - luck_inverted, luck + luck_inverted, tableSize, 1) + 0.5)
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


-- We need to know which fortify effect might be at play. --
function helper.getFortifyEffect(vital)
	local vitalEffects = {
		[tes3.mobilePlayer.health] = tes3.effect.fortifyHealth,
		[tes3.mobilePlayer.fatigue] = tes3.effect.fortifyFatigue,
		[tes3.mobilePlayer.magicka] = tes3.effect.fortifyMagicka
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

--
return helper