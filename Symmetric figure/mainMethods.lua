function newtb()
  local tb = {}
  tb.info = {}
  tb.data = {}
  return tb
end

function ad(m, n)
  if n < -180 then 
    n = n + 2*pi
  elseif n > 180 then 
    n = n - 2*pi
  end
  
  table.insert(actTB.data, int(m*cos(n)))
  table.insert(actTB.data, int(m*sin(n)))
end

function Squad(r, o, d)
  local da = 2/d*pi
  for i = 0, int(d-1) do
    ad(r, da*i+o)
    ad(r, da*i+da-o)
  end
end

function Astr(r, o, d)
  local da = 2/d*pi
  for i = 0,int(d-1) do
    ad(r, o+i*da)
  end
end

function Save()
  local f = io.open('data.lua','w')
  f:write('local data = {\n')
  for k,t in pairs(drawTB) do
    f:write('{\n')
    f:write('info = {type='..tostring(t.info.type)..', dimension='..tostring(t.info.dimension)..', color='..tostring(t.info.color)..', points='..tostring(#(t.data)/2)..'},\n')
    
    for m,n in pairs(t.data) do
      f:write(tostring(n)..', ')
    end
    f:write('\n},\n')
  end
  f:write('}\nreturn data \n')
  f:close()
end

function Load()
  package.loaded['data'] = nil
  local data = require('data')
  drawTB = {}
  for _, t in pairs(data) do 
    local tt = newtb()
    tt.info.type = t.info.type
    tt.info.dimension = t.info.dimension
    tt.info.color = t.info.color
    for x,d in ipairs(t) do
      table.insert(tt.data, d)
    end
    table.insert(drawTB, tt)
  end
end