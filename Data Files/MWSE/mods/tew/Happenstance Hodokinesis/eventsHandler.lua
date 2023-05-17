local eventsHandler = {}

local controller = require("tew.Happenstance Hodokinesis.controller")

function eventsHandler.onEquip(e)
	if e.item then
		if e.item.id then
			if (e.reference == tes3.player) and (e.item.id == "tew_aleapsychon") then
				controller.roll()
			end
		end
	end
end

-- TODO: Check if dice is in inventory
function eventsHandler.onKeyDown(e)
	if (e.isShiftDown) then
		controller.roll()
	end
end


return eventsHandler