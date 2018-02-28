gui = require('Gspot')

R, r = 240, 150
dr = 60
local x, y = 0, 0
local a, b = 0, 0
local degree, maxdegree = 0, 0
local drawTB = {}
local grid = false
math.randomseed(os.time())
cos = math.cos
sin = math.sin
int = math.floor
pi = math.pi
sqrt = math.sqrt
local m, n, tmp = 0, 0, 0

local function Aget()
  m, n, tmp = R, r, 0
  while n ~= 0 do
    tmp = m % n
    m = n
    n = tmp
  end
  return r / m * 2 * pi
end

maxdegree = Aget()

local function Reset()
  x, y = 0, 0
  a, b = 0, 0
  degree = 0
  drawTB = {}
  maxdegree = Aget()
end


function love.load()
  inputR  = gui:input('R',{50,50,100,gui.style.unit})
  txtR  = gui:dytext('R', {0,30,50,gui.style.unit}, inputR)
  btnR    = gui:button('o',{inputR.pos.w - 20, 30, 20, gui.style.unit}, inputR)
  
  inputr  = gui:input('r',{50,110,100,gui.style.unit})
  txtr  = gui:dytext('r', {0,30,50,gui.style.unit}, inputr)
  btnr    = gui:button('o',{inputr.pos.w - 20, 30, 20, gui.style.unit}, inputr)
  
  inputdr = gui:input('d',{50,170,100,gui.style.unit})
  txtdr = gui:dytext('dr', {0,30,50,gui.style.unit}, inputdr)
  btndr   = gui:button('o',{inputdr.pos.w - 20, 30, 20, gui.style.unit}, inputdr)
  
  scshot = gui:button('screenShot', {50,250,100,gui.style.unit})
  
  svexpr = gui:button('saveExpre', {50,290,100,gui.style.unit})
  
  grid = gui:button('Grid', {50,330,100,gui.style.unit})
  
  btnR.click = function(this)
    R = tonumber(this.parent.value)
    Reset()
  end
  
  btnr.click = function(this)
    r = tonumber(this.parent.value)
    Reset()
  end
  
  btndr.click = function(this)
    dr = tonumber(this.parent.value)
    Reset()
  end
  
  love.filesystem.setIdentity('screenshot')
  scshot.click = function(this)
    local sct = love.graphics.newScreenshot()
    sct:encode("png",os.time()..".png")
  end
  
  svexpr.click = function(this)
    local f = io.open('outputExpression.txt', 'w')
    f:write('x = int('..tostring(dr)..'*cos(a*'..tostring(R/r-1)..')+'..tostring(R-r)..'*cos(a))\n')
    f:write('y = int('..tostring(dr)..'*sin(a*'..tostring(R/r-1)..')-'..tostring(R-r)..'*sin(a))\n')
    f:write('maxdegree = '..tostring(r / m * 360)..'\n')
    f:close()
  end
  
  grid.click = function(this)
    if grid then grid = false else grid = true end
  end
end

function love.update(dt)
  if degree <= maxdegree then
    x = (int)(dr * cos(degree*(R / r - 1)) + (R - r) * cos(degree)) + 420
    y = (int)(dr * sin(degree*(R / r - 1)) - (R - r) * sin(degree)) + 270
    table.insert(drawTB,x)
    table.insert(drawTB,y)
    degree = degree + 0.01
  end
  gui:update(dt)
end

function love.draw(dt)
  love.graphics.setColor(233,30,30)
  love.graphics.points(drawTB)
  
  love.graphics.setColor(233,233,233)
  love.graphics.rectangle('line',27,40,140,320)
  
  if grid then love.graphics.rectangle('line',228,46,384,448) end
  gui:draw()
end

love.keypressed = function(key, code, isrepeat)
	if gui.focus then
		gui:keypress(key) -- only sending input to the gui if we're not using it for something else
	else
		if key == 'return'then -- binding enter key to input focus
			-- leave something here
		elseif key == 'f1' then -- toggle show-hider
			if showhider.display then showhider:hide() else showhider:show() end
		else
			gui:feedback(key) -- why not
		end
	end
end

love.textinput = function(key)
	if gui.focus then
		gui:textinput(key) -- only sending input to the gui if we're not using it for something else
	end
end

-- deal with 0.10 mouse API changes
love.mousepressed = function(x, y, button)
	gui:mousepress(x, y, button) -- pretty sure you want to register mouse events
end
love.mousereleased = function(x, y, button)
	gui:mouserelease(x, y, button)
end
love.wheelmoved = function(x, y)
	gui:mousewheel(x, y)
end
