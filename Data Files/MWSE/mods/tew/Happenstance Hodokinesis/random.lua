local random = {}

local actions = require("tew.Happenstance Hodokinesis.actions")

random.actions = {
	[true] = {
		-- actions.teleportRandom,
		actions.luckyContainer,
		-- actions.summonScrib,
	},
	[false] = {
		-- actions.teleportRandom,
		actions.luckyContainer,
		-- actions.summonScrib,
	}
}

return random

