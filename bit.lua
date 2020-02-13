local bit={}

function bit.topos(n)
	return 2^(n-1)
end


function bit.rshift(n,a)
	return math.floor(n/2^a)
end


function bit.lshift(n,a)
	return n*2^a
end


function bit.iter(a,b,func,len)
	local len=len or math.max(bit.len(a),bit.len(b))
	for i=1,len do
		func(bit.get(a,i),bit.get(b,i),i)
	end
end


function bit.and(a,b)
	local r=0
	bit.iter(a,b,function(a,b,i)
		if a==1 and b==1 then
			r=r+bit.topos(i)
		end
	end)
	return r
end


function bit.not(n)
	local r,len=0,bit.len(n)
	for i=1,len do
		if bit.get(n,i)==0 then r=r+bit.topos(i) end
	end
	return r
end


function bit.or(a,b)
	local r=0
	bit.iter(a,b,function(a,b,i)
		if a==1 or b==1 then
			r=r+bit.topos(i)
		end
	end)
	return rend
end


function bit.xor(a,b)
	local r=0
	bit.iter(a,b,function(a,b,i)
		if a==1 or b==1 and (a~=1 and b~=1) then
			r=r+bit.topos(i)
		end
	end)
	return r
end


function bit.get(n,p)
	return math.floor(bit.rshift(n,p-1)%2)
end


function bit.set(n,p,v)
	if bit.get(n,p)~=v then
		local m=bit.topos(p)
		if v==1 then n=n+m
		else n=n-m end
	end
	return n
end


function bit.len(n)
	local l=0
	if n==0 then return 0 end
	
	while n>0 do
		n=n-2^l
		l=l+1
	end
	return l
end


function bit.value(n,p,len,sign)
	local r=0
	for i=1,len do
		if bit.get(n,i+p-1)==1 then r=r+bit.topos(i) end
	end
	
	if sign and bit.get(n,len+p-1)==1 then r=r-bit.topos(len)*2 end
	return r
end


function bit.merge(a,b,len)			--merge bits together
	len=len or bit.len(b)
	return a+b*2^len
end

return bit