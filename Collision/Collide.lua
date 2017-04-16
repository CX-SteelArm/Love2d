-- Collision test module
-- Collide.lua
-- Thanks to http://www.jianshu.com/p/4000a301c32a
require('Polygon')

local function dot(v1,v2)
	return v1[1]*v2[1] + v1[2]*v2[2]
end

local function normalize(v1)
	local length = v1[1]^2 + v1[2]^2
	return {v1[1]/length,v1[2]/length}
end

local function perp(v)
	return {v[2],-v[1]}
end

local function segVec(v1,v2)
	return {v2[1]-v1[1],v2[2]-v1[2]}
end

local function distSquare(o1,o2)
	return (o2[1]-o1[1])^2 + (o2[2]-o1[2])^2
end

local function polyEdge(plg)
	local edge = {}
	
	if plg['shape'] ~= 'Circle' then
		for i = 1,#plg.para do
			table.insert(edge,segVec(plg.para[i],plg.para[1+i%(#plg.para)]))
		end
	end
	plg.edge = edge
	return plg
end

-- Exam

local function overlap(a,b)
	local len_a = a[2]-a[1]
	local len_b = b[2]-b[1]
	if len_a + len_b < math.max(b[2],a[2]) - math.min(b[1],a[1]) 
	then return false end
	return true
end

local function radiusLap(plg1,plg2)
	local centerVec = segVec(plg1.para[1],plg2.para[1])
	local centerDistance = plg1.para[2]+plg2.para[2]
	return centerDistance^2 > centerVec[1]^2 + centerVec[2]^2
end

local function project(plg,axis)
	local axis = normalize(axis)
	if plg.shape == 'Circle' then
		local cd = dot(plg.para[1],axis)
		return {cd-plg.para[2],cd+plg.para[2]}
	else 
		local minimum = dot(plg.para[1],axis)
		local maximum = minimum
		for i,v in ipairs(plg.para) do
			local dottemp = dot(v,axis)
			if dottemp > maximum then maximum = dottemp end
			if dottemp < minimum then minimum = dottemp end
		end
		return {minimum,maximum}
	end
end

local function segColCir(plg,o1,o2)
	local axis = normalize(perp{o2[1]-o1[1],o2[2]-o1[2]})
	local center,radius = plg.para[1],plg.para[2]
	local pc = project(plg,axis)
	local pm = {dot(o1,axis),dot(o2,axis)}
	--print("#####")
	if overlap(pc,pm) then
		if distSquare(o1,center) < radius^2 or distSquare(o2,center) < radius^2 then
			return true
		end 
		if dot(segVec(o1,center),segVec(o1,o2)) * dot(segVec(o2,center),segVec(o1,o2)) < 0 then
			return true
		end
	else return false
	end
end

function testCollide(p1,p2)
	local p1 = polyEdge(p1)
	local p2 = polyEdge(p2)
	if p1.shape == 'Circle' then
		p1,p2 = p2,p1
	end
	
	if p1.shape == 'Circle' then
		return radiusLap(p1,p2)
	
	elseif p2.shape == 'Circle' then
		for i = 1,#p1.para do
			if segColCir(p2,p1.para[i],p1.para[1+i%(#p1.para)]) then
				return true
			end
		end
		return false
		
	else
		for i = 1,#p1.edge do
			local axis = perp(p1.edge[i])
			local pa = project(p1,axis)
			local pb = project(p2,axis)
			if not overlap(pa,pb) then return false end
		end

		for i = 1,#p2.edge do
			local axis = perp(p2.edge[i])
			local pa = project(p1,axis)
			local pb = project(p2,axis)
			if not overlap(pa,pb) then return false end
		end
		
		return true
	end
end