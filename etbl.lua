local etbl={}

function etbl.find(t,v)
	for k,lv in pairs(t) do
		if lv==v then return k end
	end
	return false
end


function etbl.ifind(t,v)
	for i,lv in ipairs(t) do
		if lv==v then return i end
	end
	return false
end


function etbl.unpack(t,i)
	i=i or 1
	if i<=#t then return t[i],unpack(t,i+1) end
end


function etbl.foreach(func,t,twt)
	for k,v in pairs(t) do
		if type(v)=="table" and (not twt or (twt and twt>0)) then etbl.foreach(func,v,twt-1)
		else func(k,v,t,twt) end
	end
end


function etbl.shift(t,n,s,e)
	s,e=s or 1,e or #t
	local tt={}

	--store and remove values in position
	for i=s,e do  
		tt[i]=t[i]
		t[i]=nil
	end

	--copy stored duplicates to proper pos
	for i=s,e do  
		t[i+n]=tt[i]
	end
end


function etbl.duplicate(t,twt,copy_mt)
	if copy_mt==nil then copy_mt=true end
	local r={}
	etbl.foreach(function(k,v,t,twt)
		if type(v)=="table" and (not twt or (twt and twt>0)) then
			r[k]=etbl.foreach(fv,twt-1)
			if copy_mt then setmetatable(r[k],getmetatable(v)) end
		else r[k]=v end
	end,t,twt)
	return r
end


function etbl.nillify(t,twt)
	return etbl.foreach(function(k,v,t)
		t[k]=nil
	end,t,twt)
end

return etbl