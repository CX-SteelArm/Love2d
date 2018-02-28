function love.conf(t)
	t.version = "0.10.0"
	t.console = false
	t.window.title = "Amazing Draw"
	t.window.icon = nil
	t.window.width = 720
    t.window.height = 540
	t.window.vsync = false
	
	t.modules.audio = false
	t.modules.joystick = false
	t.modules.sound = false
	t.modules.physics = false
end