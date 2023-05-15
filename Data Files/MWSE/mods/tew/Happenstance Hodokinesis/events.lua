-- This is where we define all our events. --

local controller = require("tew.Happenstance Hodokinesis.controller")

event.register(tes3.event.keyDown, controller.keyDown, { filter = tes3.scanCode.h })
