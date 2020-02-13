local function c(x1,y1,w1,h1,x2,y2,w2,h2)
	if type(x1)=="table" and type(y1)=="table" then return c(x1[1],x1[2],x1[3],x1[4],y1[1],y1[2],y1[3],y1[4]) end
	return x1<x2+w2 and x2<x1+w1 and y1<y2+h2 and y2<y1+h1
end
return c