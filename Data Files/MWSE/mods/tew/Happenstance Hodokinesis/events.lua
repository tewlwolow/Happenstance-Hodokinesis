-- This is where we define all our events. --

local eventsHandler = require("tew.Happenstance Hodokinesis.eventsHandler")

event.register(tes3.event.equip, eventsHandler.onEquip)
event.register(tes3.event.keyDown, eventsHandler.onKeyDown, { filter = tes3.scanCode.h })
