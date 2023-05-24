local statistic = {}

local helper = require("tew.Happenstance Hodokinesis.helper")
local messages = require("tew.Happenstance Hodokinesis.messages")

function statistic.increaseLuck()
	tes3.modStatistic{
		reference = tes3.player,
		attribute = tes3.attribute.luck,
		value = 1,
		limit = true,
	}
	helper.showMessage(messages.luckIncreased)
end

return statistic