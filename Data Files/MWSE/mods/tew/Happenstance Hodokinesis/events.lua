-- This is where we define all our events. --

local eventHandler = require("tew.Happenstance Hodokinesis.eventHandler")

event.register(tes3.event.equip, eventHandler.onEquip)
event.register(tes3.event.keyDown, eventHandler.onKeyDown, { filter = tes3.scanCode.h })
