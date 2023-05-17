-- This is where we define all our events. --

local controller = require("tew.Happenstance Hodokinesis.controller")

event.register(tes3.event.equip, controller.roll)
event.register(tes3.event.keyDown, controller.roll, { filter = tes3.scanCode.h })
