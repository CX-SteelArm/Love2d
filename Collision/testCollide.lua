require("Collide")

-- test Collide

p1 = polygon(0,0,1,0,0,2)
p2 = polygon(0.3,0,2.1,0,1.1,2)

result = testCollide(p1,p2)

print('result:',result)
