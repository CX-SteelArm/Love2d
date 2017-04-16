function polygon(...)
	if #arg < 3 then
		print('Entry number should be even and more than 2.')
	
	elseif #arg == 4 then
		-- 'A segment'
		local v1 = {arg[1],arg[2]}
		local v2 = {arg[3],arg[4]}
		return {para={v1,v2},shape='Segment'}
		
	elseif #arg == 3 then
		-- 'A circle'
		return {para={{arg[1],arg[2]},arg[3]},shape='Circle'}

	elseif #arg % 2 == 1 then
		print('Entry number should be even and more than 2.')
	else
		-- 'A polygon'
		local poly = {}
		local para = {}
		for i = 1,#arg,2 do
			table.insert(para,{arg[i],arg[i+1]})
		end
		poly.para = para
		poly.shape = 'Ploygon'
		return poly
	end
	
	return 
end
