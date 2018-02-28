-- for ellipse (version 1.01)
local a, b = 240, 150
local r = 59
local dr = 32
local maxdg = 2*math.pi
local x, y = 0, 0
local ax, ay, ax1, ay1 = a, 0, a-r, 0
local degree, degree1 = 0, 0
local drawTB = {}
math.randomseed(os.time())
cos = math.cos
sin = math.sin
int = math.floor
pi = math.pi
sqrt = math.sqrt

local function Dist(x1,y1,x2,y2)
  return sqrt((x1-x2)^2 + (y1-y2)^2)
end

function love.load()
  love.graphics.setColor(233,30,30)
end

function love.update(dt)
  ax = (a-r)*cos(degree)
  ay = (a-r)*cos(degree)
  
  degree1 = degree1 + Dist(ax,ay,ax1,ay1)/r
  
  x = (int)(dr * cos(degree1) + (a-r)*cos(degree)) + 320
  y = (int)(dr * sin(degree1) - (b-r)*sin(degree)) + 240
  
  ax1 = ax
  ay1 = ay
  
  table.insert(drawTB,x)
  table.insert(drawTB,y)
  degree = degree + 0.01
end

function love.draw(dt)
  love.graphics.points(drawTB)
end