-- This is our main controller for determining what we want to do. --

local controller = {}

--
local conditions = require("tew.Happenstance Hodokinesis.conditions")
local helper = require("tew.Happenstance Hodokinesis.helper")
local data = require("tew.Happenstance Hodokinesis.data")
--

function controller.roll()
	-- This is a base chance for either a bonus or a malus to be applied, based on the player's Luck. --
	local boon = helper.calcBoon()

	-- This is a table to hold our applicable conditions. --
	local currentConditions = {}

	-- Let's run our condition checks and see if anything is worth doing. --
	-- TODO: maybe some fallback?
	for _, conditionCheck in pairs(conditions) do
		local isActive, action = conditionCheck(boon)
		if isActive then
			-- Write off our action and the param to act upon. --
			table.insert(currentConditions, action)
		end
	end

	-- Roll a dice to get a randomised applicable action to take. --
	local rolledAction = table.choice(currentConditions)

	-- If we got a hit, i.e. there are some applicable conditions, let's run the action. --
	if rolledAction then
		local rollSound = tes3.getSound("tew_s_hodo_alea")
		local castSound = tes3.getSound("tew_s_hodo_cast")
		rollSound:play()
		timer.start{
			type=timer.real,
			iterations = 1,
			duration = 3,
			persist = false,
			callback = function()
				helper.playVisual(tes3.player, data.vfx.mysticism)
				castSound:play()
				rolledAction()
			end
		}
	end
end


--
return controller