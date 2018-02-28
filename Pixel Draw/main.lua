local draw_n = 16
local ds = 640 / draw_n
local show_grid = true

local WIN_WIDTH, WIN_HEIGHT = love.graphics.getWidth(), love.graphics.getHeight()
local image = love.graphics.newImage("origin.JPG")
local image_w, image_h = image:getWidth(), image:getHeight()
local sx, sy = 640 / image_w, 640 / image_h

local image_canvas = love.graphics.newCanvas(640,640)
local im_data = nil
local new_img = nil
local draw_canvas = love.graphics.newCanvas(640,640)
local mini_canvas = love.graphics.newCanvas(90, 90)

local color_selected = {0, 0, 0}
local color_tb = {color_selected}
local mode = 'pen'
local lock = false

local draw_table = {}
for i = 1, draw_n do
  draw_table[i] = {}
  for j = 1, draw_n do
    draw_table[i][j] = 0
  end
end

local function MouseDown()
  if love.mouse.isDown(1,2) then
    local x, y = love.mouse.getX(), love.mouse.getY()
    if x <= WIN_WIDTH - 650 or x >= WIN_WIDTH - 10 or y <= 10 or y >= 650 then
      return 
    end
    if love.mouse.isDown(2) then
      local r, g, b = im_data:getPixel(x+650-WIN_WIDTH, y-10)
      color_selected = {r, g, b}
    else
      local i, j = math.ceil((x+650-WIN_WIDTH)/ds), math.ceil((y-10)/ds)
      if mode == 'eraser' and draw_table[i][j] ~= 0 then
        draw_table[i][j] = 0
      elseif mode == 'pen' and (not lock and draw_table[i][j] ~= color_selected) or (lock and draw_table[i][j] == 0) then
        draw_table[i][j] = color_selected
      end
    end
  end
end

local function grid()
  love.graphics.setColor(22,22,22,100)
  for i = 0, draw_n-1 do
    love.graphics.line(WIN_WIDTH-650, 10+i*ds, WIN_WIDTH-10, 10+i*ds)
    love.graphics.line(WIN_WIDTH-650+i*ds, 10, WIN_WIDTH-650+i*ds, 650)
  end
end

local function MiniMap()
  
end

function love.load()
  love.graphics.setBackgroundColor(233,233,233)
  image_canvas:renderTo(function()
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(image, 0, 0, 0, sx, sy)
  end)
  im_data = image_canvas:newImageData()
  new_img = love.graphics.newImage(im_data)
end
 
function love.update(dt)
  MouseDown()
  draw_canvas:renderTo(function()
    love.graphics.clear()
    for i = 1, draw_n do
      for j = 1, draw_n do
        if draw_table[i][j] ~= 0 then
          love.graphics.setColor(unpack(draw_table[i][j]))
          love.graphics.rectangle('fill', ds*(i-1), ds*(j-1), ds, ds)
        end
      end
    end
  end)

  mini_canvas:renderTo(function()
    love.graphics.clear()
    love.graphics.setColor(22,22,22,100)
    love.graphics.line(0, 0, 90, 0, 90, 90, 0, 90, 0, 0)
    local dss = 80 / draw_n
    for i = 1, draw_n do
      for j = 1, draw_n do
        if draw_table[i][j] ~= 0 then
          love.graphics.setColor(unpack(draw_table[i][j]))
          love.graphics.rectangle('fill', 5+dss*(i-1), 5+dss*(j-1), dss, dss)
        end
      end
    end
  end)
end
 
function love.draw()
  love.graphics.setColor(22,22,22)
  love.graphics.line(WIN_WIDTH-650, 10, WIN_WIDTH-10, 10, WIN_WIDTH-10, WIN_HEIGHT-10, WIN_WIDTH-650, WIN_HEIGHT-10, WIN_WIDTH-650, 10)
  
  if show_grid then
    grid()
  end
  love.graphics.setColor(255,255,255,100)
  love.graphics.draw(new_img, WIN_WIDTH-650, 10)
  
  love.graphics.setColor(255,255,255)
  love.graphics.draw(draw_canvas, WIN_WIDTH-650, 10)
  love.graphics.draw(mini_canvas, 80, 40)
end

function love.mousereleased(x, y, button)
  if button == 3 then
    if mode == 'pen' then mode = 'eraser'
    elseif mode == 'eraser' then mode = 'pen'
    end
  end
end

function love.keyreleased(key)
  if key == "space" then
    lock = not lock
  end
end