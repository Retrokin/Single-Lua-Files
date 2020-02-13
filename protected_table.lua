local class=require "class"
local protected_table=class:new()

function protected_table:__index(k)
	local v=rawget(self,"__protected")
	if v=="unreadable" or v=="inaccessible" then error("This table cannot be indexed from!",2) end
	return class.__index(self,k)
end


function protected_table:__newindex(k,v)
	local v=rawget(self,"__protected")
	if v=="unwriteable" or v=="inaccessible" then error("New indexes cannot be created from this table!",2)
	elseif v=="unchangeable" then
		local unchange=rawget(self,"__protectedkeys")
		for i,v in pairs(unchange) do
			if k==v then error("Index '" .. k .. "' cannot be changed!",2) end
		end
	end
	rawset(self,k,v)
end


function protected_table:protect(mode,nested)
	nested=nested or 0
	if nested=="all" or nested==true then nested=999999 end
	if rawget(self,"__protected") then error("This table is already protected!",2) end
	
	if mode=="unchangeable" then
		local t={}
		for k,v in pairs(self) do
			t[#t+1]=k
		end
		rawset(self,"__protectedkeys",t)
	end

	if nested and nested>0 then		--protect all nested protected_tables as well
		local function _nestedprotect(self,nested)
			for k,v in pairs(self) do
				if type(v)=="table" then 
					if class:typeOf(v,true) and class.typeOf(self,protected_table,false) then protected_table.protect(v,mode,nested-1)
					else _nestedprotect(v,nested-1) end
				end
			end
		end
		_nestedprotect(self,nested)
	end
	rawset(self,"__protected",mode)
end

return protected_table