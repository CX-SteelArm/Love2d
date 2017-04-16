require("Collide")

-- test Collide

p1 = polygon(0,0,1)
p2 = polygon(0.5,0.867,0.5,2,1,1)

result = testCollide(p1,p2)

print('result:',result)
