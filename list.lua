local class=require "code/class"
local list=class:new()

local function _remove(vtbl,k)
	for i,l in ipairs(vtbl) do
		if l==k then
			table.remove(vtbl,i)
			break
		end
	end
end



function list:__init()
	rawset(self,"__vars",{})
end


function list:__newindex(k,v)
	rawset(self,k,v)
	local vars=rawget(self,"__vars")
	if v==nil then
		_remove(vars,k)
		return
	end
	if type(k)=="string" and k:sub(1,2)~="__" then rawset(vars,#vars+1,k) end
end


function list:foreach(func,reverse)
    local start,step,limit=1,1,#self.__vars
    if reverse then
        start,step,limit=limit,-step,start
    end
	for i=start,limit,step do
		local k=self.__vars[i]
		func(k,self[k])
	end
end


function list:sort(tbl)			--sort the variables so that they run in a specific order
	local old_vars=self.__vars
	rawset(self,"__vars",{})

	for i,l in ipairs(tbl) do			--make sure variable is actually declared in the list
		for v,ll in ipairs(old_vars) do
			if l==ll then
				self.__vars[#self.__vars+1]=l
				old_vars[v]=nil			--remove variable name from table (makes adding remaining faster)
				break
			end
		end
	end

	for i,l in ipairs(old_vars) do		--add remaining vars
		if l~=nil then self.__vars[#self.__vars+1]=l end
	end
	old_vars=nil
end


function list:remove(k)
	_remove(self.__vars,k)
end

return list