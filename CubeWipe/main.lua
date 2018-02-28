local map = {}
local size = 32
local length,width = 18,12 -- 地图长宽尺寸
lg = love.graphics

local keyBuff = {} -- 保存的位置
local mX,mY = 0,0 -- 鼠标点击的位置
local score = 0
local maxTimer = 30
local timer = maxTimer

-- 块的颜色
local tileColor = {
		{168,114,32},
		{195,23,16},
		{56,185,32},
		{188,188,111},
		{68,68,68},
}

-- 初始化map
for i = 1,length do
	local k = {}
	for j = 1,width do
		k[j] = 0
	end
	map[i] = k
end

-- 判断两个数组相等
local function tableEqual(t1,t2)
	assert(#t1 == #t2, "Length of the two tables must be the same.")
	for i = 1,#t1 do
		if t1[i] ~= t2[i] then
			return false
		end
	end
	return true
end

-- 不指定zone则随机生成(x,y,w,h)矩形范围，指定zone则把此区域之上的部分平移到该部分底端
local function fillArea(x,y,w,h,zone)
	if not zone then 
		for i = 1,w do 
			for j = 1,h do
				map[x+i-1][y+j-1] = math.random(1,#tileColor)
			end
		end
	else 
		for i = x-1,1,-1 do
			for j = y,y+w-1 do
				map[i+h][j] = map[i][j]
			end
		end
	end
end

-- 测试是否消除块,点击两次和四次的时候会判定
local function testRemove(x1,y1,x2,y2,flag)
	local tm = map[x1][y1]
	if flag == 2 and x1 ~= x2 and y1 ~= y2 then
		if map[x1][y2] == tm and map[x2][y1] == tm and map[x2][y2] == tm then
			return true
		else 
			keyBuff = {}
			return false
		end
	end
	
	if flag == 4 then 
		if map[x1][y2] == tm and map[x2][y1] == tm and map[x2][y2] == tm then
			if	(tableEqual({x1,y2},keyBuff[2]) and tableEqual({x2,y1},keyBuff[4])) or
				(tableEqual({x1,y2},keyBuff[4]) and tableEqual({x2,y1},keyBuff[2]))then
				return true
			end
		else
			keyBuff = {}
			return false
		end
		
	end

	return false
end

local function getPos(x,y)
	return math.ceil(x/size),math.ceil(y/size)
end

-- 绘制时间条
local function drawTimerBar()
	local w,h = 16,200
	local timerLevel = math.ceil((timer / maxTimer) / 0.05)
	lg.setLineWidth(2)
	lg.rectangle("line",434,300,w,h)
	lg.setColor(10*(20-timerLevel),10*timerLevel,32)
	lg.rectangle("fill",435,302+(20-timerLevel)*h/20,w-2,10*timerLevel-3)
end

local function GameOver()
	if timer <= 0 then
		return true
	end
	return false
end

function love.load()
	bg = lg.newImage("bg.jpg")
	ft = lg.newFont(24)
	lg.setFont(ft)
	lg.setBackgroundColor(233,233,233)
	fillArea(1,1,length,width)
end

function love.update(dt)
	if not GameOver() then
		if mX ~= 0 then
			table.insert(keyBuff,{mX,mY})
			local x,y,w,h = 0,0,0,0
			local flag = #keyBuff
			if flag == 2 or flag == 4 then 
				x1,y1 = keyBuff[1][1],keyBuff[1][2]
				if flag == 2 then
					x2,y2 = keyBuff[2][1],keyBuff[2][2]
				else 
					x2,y2 = keyBuff[3][1],keyBuff[3][2]
				end
				
				x = math.min(x1,x2)
				y = math.min(y1,y2)
				w = math.abs(y1-y2)+1
				h = math.abs(x1-x2)+1
				
				if testRemove(x1,y1,x2,y2,flag) then
					fillArea(x,y,w,h,true)
					fillArea(1,y,w,h)
					local ts = score
					score = w*h > 50 and score + 50 or score + w*h
					if maxTimer >= 10 then
						if math.ceil(ts/150) ~= math.ceil(score/150) then
							maxTimer = maxTimer - 3
						end
					end
					timer = maxTimer
					keyBuff = {}
				end
			end
		
			mX,mY = 0,0	
		end
		timer = timer - dt
	end
end

function love.draw()
	lg.draw(bg,350,0)
	for i = 1,length do
		for j = 1,width do
			lg.setColor(unpack(tileColor[map[i][j]]))
			lg.rectangle('fill',size*(j-1),size*(i-1),size,size)
		end
	end
	
	lg.setColor(0,0,0)
	lg.setLineWidth(4)
	for i = 0,length do
		lg.line(0,i*size,size*width,i*size)
	end
	for i = 0,width do
		lg.line(i*size,0,i*size,size*length)
	end
	
	lg.print("Score:",410,50)
	lg.print(tostring(score),430,80)
	if GameOver() then
		lg.print(" Press\n 'R' to \nrestart",400,135)
	end
	drawTimerBar()
	lg.setColor(233,233,233)
end

function love.mousepressed(x,y,key)
	if key == 1 then 
		mY,mX = getPos(x,y)
	end
	if key == 2 then
		keyBuff = {}
	end
end

function love.keypressed(key)
	if GameOver() and key == "r" then
		score = 0
		maxTimer = 30
		timer = maxTimer
	end
end
