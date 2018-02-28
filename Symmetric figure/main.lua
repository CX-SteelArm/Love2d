gui = require('Gspot')
require('mainMethods')

math.randomseed(os.time())
cos = math.cos
sin = math.sin
int = math.floor
pi = math.pi
sqrt = math.sqrt
atan = math.atan
int = math.floor

offsetx, offsety = 450, 270
gridon = true

function calcPoint()
  
  local function dist(x1,y1)
    return sqrt((x1^2 + y1^2))
  end
  
  local function angle(x1,y1)
    if x1 == 0 then 
      if y1 > 0 then return pi/2 elseif y1 < 0 then return -pi/2 else return 0 end
    elseif x1 > 0 then
      return atan(y1/x1)
    else 
      if y1 >= 0 then return pi+atan(y1/x1) else return atan(y1/x1)-pi end
    end
  end
  
  local x, y = love.mouse.getX()-offsetx, love.mouse.getY()-offsety
  return dist(x,y), angle(x,y)
end

px, py = 999, 999
id = 1
drawTB = {}
actTB = {}
dm = 8
ma = 1

function love.load()
  image = love.graphics.newImage("bullet.png")
  w, h = image:getDimensions()
  imageQuad = {}
  for i = 1,7 do 
    table.insert(imageQuad, love.graphics.newQuad((i-1)*32, 0, 32, 16, 256, 16))
  end
  
  pickMA = gui:collapsegroup('Squad',{50,70,100,gui.style.unit})
  local sq = gui:group('Squad', {0,gui.style.unit,100,gui.style.unit}, pickMA)
  sq.click = function(this)
    ma = 1
    this.parent.label = 'Squad'
    this.parent:toggle()
  end
  
  local ast = gui:group('Astr', {0,2*gui.style.unit,100,gui.style.unit}, pickMA)
  ast.click = function(this)
    ma = 2
    this.parent.label = 'Astr'
    this.parent:toggle()
  end
  pickMA:toggle()
  maText = gui:text('Method', {0, -gui.style.unit,100,gui.style.unit}, pickMA)
  maText.nohide = true
  
  pickDM = gui:collapsegroup('8',{50,110,100,gui.style.unit})
  dmTB = {}
  local num = {1,2,3,4,5,6,8}
  for i = 1, #num do
    local pic = gui:group(tostring(num[i]), {0,i*gui.style.unit,100,gui.style.unit}, pickDM)
    pic.click = function(this)
      dm = num[i]
      this.parent.label = tostring(num[i])
      this.parent:toggle()
      end
    table.insert(dmTB, pic)
  end
  pickDM:toggle()
  dmText = gui:text('Dimension', {0, -gui.style.unit,100,gui.style.unit}, pickDM)
  dmText.nohide = true
  
  pickco = gui:collapsegroup('color1',{50,150,100,gui.style.unit})
  pickTB = {}
  for i = 1, 7 do
    local pur = gui:group('color'..tostring(i), {0,i*gui.style.unit,100,gui.style.unit},pickco)
    pur.click = function(this) 
      id = i 
      this.parent.label = 'color'..tostring(id) 
      this.parent:toggle()
    end
    table.insert(pickTB, pur)
  end
  pickco:toggle()
  coText = gui:text('Color Pick', {0, -gui.style.unit,100,gui.style.unit}, pickco)
  coText.nohide = true
  
  pickdis = gui:collapsegroup('10',{50,190,100,gui.style.unit})
  pickDIS = {}
  for i = 1, 7 do
    local pur = gui:group(tostring(5*(i+1)), {0,i*gui.style.unit,100,gui.style.unit},pickdis)
    pur.click = function(this) 
      dis = 5*(i+1) 
      this.parent.label = tostring(5*(i+1)) 
      this.parent:toggle()
    end
    table.insert(pickDIS, pur)
  end
  pickdis:toggle()
  disText = gui:text('Dis Select', {0, -gui.style.unit,100,gui.style.unit}, pickdis)
  disText.nohide = true
  
  scshot = gui:button('ScreenShot', {50,250,100,gui.style.unit})
  
  clear = gui:button('Clear', {50,290,100,gui.style.unit})
  
  grid = gui:button('Grid', {50,330,100,gui.style.unit})
  
  back = gui:button('Back', {50,370,100,gui.style.unit})
  
  save = gui:button('Save', {50,410,100,gui.style.unit})
  
  load = gui:button('Load',{50,450,100,gui.style.unit})
  
  love.filesystem.setIdentity('screenshot')
  scshot.click = function(this)
    local sct = love.graphics.newScreenshot()
    sct:encode("png",os.time()..".png")
  end
  
  clear.click = function(this)
    drawTB = {}
  end
  
  grid.click = function(this)
    if gridon then gridon = false else gridon = true end
  end
  
  back.click = function(this)
    table.remove(drawTB)
  end
  
  save.click = function(this)
    Save()
  end
  
  load.click = function(this)
    Load()
  end
end

dis = 10

function love.update(dt)
  local x, y = love.mouse.getX(), love.mouse.getY()
  if love.mouse.isDown(1) and x > 200 and (x-px)^2+(y-py)^2 > dis^2 then
    if not next(actTB) then
      actTB = newtb()
      actTB.info = {type=ma, dimension=dm, color=id}
      table.insert(drawTB, actTB)
    end
    local r, o = calcPoint()
    if ma == 1 then 
      Squad(r, o, dm)
    elseif ma == 2 then 
      Astr(r, o, dm)
    end
    px, py = x, y
  end
  
  
  gui:update(dt)
  
end

function love.draw(dt)
  love.graphics.rectangle('line',30,40,140,450)
  gui:draw()
  love.graphics.rectangle('line',200,40,500,450)
  
	love.graphics.translate(offsetx, offsety)
  
  if gridon then
    love.graphics.line(-200,0,200,0)
    love.graphics.line(0,-200,0,200)
  end
  
  if drawTB ~= {} then
    for _, t in ipairs(drawTB) do
        local k = t.info.color 
        for i = 1,#(t.data)/2 do
          love.graphics.draw(image, imageQuad[tonumber(k)], t.data[2*i-1], t.data[2*i], 0, 1, 1, 16, 8)
      end
    end
  end
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
  if x > 200 then
    actTB = {}
  end
	gui:mouserelease(x, y, button)
end

love.wheelmoved = function(x, y)
	gui:mousewheel(x, y)
end
