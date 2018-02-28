function love.conf(t)
	t.version = "0.10.0"
	t.console = false
	t.window.title = "CubeWipe"
	t.window.icon = "ico.jpg"
	t.window.width =  500
    t.window.height = 576
	t.window.vsync = true
	
	t.modules.audio = false
	t.modules.joystick = false
	t.modules.sound = false
	t.modules.physics = false
end
