--ADDS A SIMPLE AND EASY TO USE SYSTEM FOR CREATING CLASSES AND CLASS INSTANCES--
local class={}

function class:new(...)
	local nc={}
	setmetatable(nc,self)

	--run inherits inits; and go through nested tables
	local function _inheritInit(self)
		local inherit=rawget(self,"__inherit")
		if inherit then
			for i=#inherit,1,-1 do
			    local l=inherit[i]
				_inheritInit(l)
				local func=l.__init
				if func then func(nc) end
			end
		end
	end
	_inheritInit(self)

	if self.__init then self.__init(nc,...) end
	return nc
end


function class.__index(self,k)
	--check self
	local var=rawget(self,k)
	if var~=nil then return var end

	--check inheritances
	local __inherit=rawget(self,"__inherit")
	if __inherit then
		for i=1,#__inherit do
			var=__inherit[i][k]
			if var~=nil then return var end
		end
	end

	--check metatables
	local mt=getmetatable(self)
	if mt~=nil then var=mt[k] end
	return var
end


function class.__init(nc,...)
	nc.__inherit={...}

	nc.__index=class.__index
	function nc.__init(nc,tbl) tbl=tbl or {} for k,v in pairs(tbl) do nc[k]=v end end
end


function class:typeOf(name,skip_inherit)
	if self==name or (self.type and self:type()==name) then return true end

	--check inheritances
	local inh=rawget(self,"__inherit")
	if not skip_inherit and inh then
		for i,ltbl in ipairs(inh) do
			if ltbl==name or (ltbl.type and ltbl:type()==name) then return true end
		end
	end
	
	--check metatable
	local mt=getmetatable(self)	
	if mt then return class.typeOf(mt,name,skip_inherit) end

	return false
end


function class:hasInheritance(tbl,skip_mt)
	if rawget(self.__inherit) then
		for i,ltbl in ipairs(self.__inherit) do
			if ltbl==tbl or (ltbl.type and ltbl:type()==tbl) then return true end
		end	
	end

	if not skip_mt then
		local mt=getmetatable(self)
		return class.hasInheritance(self,tbl,skip_mt)
	end
	return false
end


function class:hasInheritMeta()
	if rawget(self,"__inherit") then return true
	else return false end
end

return class