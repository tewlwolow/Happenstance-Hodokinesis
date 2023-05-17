-- This is our main controller for determining what we want to do. --

local controller = {}

--
local conditions = require("tew.Happenstance Hodokinesis.conditions")
local helper = require("tew.Happenstance Hodokinesis.helper")
--

function controller.roll(e)
	-- This is a base chance for either a bonus or a malus to be applied, based on the player's Luck. --
	local boon = helper.calcActionChance() > math.random()

	-- This is a table to hold our applicable conditions. --
	local currentConditions = {}

	-- Let's run our condition checks and see if anything is worth doing. --
	-- TODO: maybe some fallback?
	for _, conditionCheck in pairs(conditions) do
		local isActive, action, param = conditionCheck()
		if isActive then
			-- Write off our action and the param to act upon. --
			currentConditions[action] = param
		end
	end

	-- Roll a dice to get a randomised applicable action to take. --
	local rolledAction = table.choice(table.keys(currentConditions))

	-- If we got a hit, i.e. there are some applicable conditions, let's run the action. --
	if rolledAction then
		rolledAction(currentConditions[rolledAction], boon)
	end
end


--
return controller