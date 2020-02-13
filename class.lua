--ADDS A SIMPLE AND EASY TO USE SYSTEM FOR CREATING CLASSES AND CLASS INSTANCES--
local class_mt={}

function class_mt:new(...)

	local nc={}
	setmetatable(nc,self)

	if self.__init then self.__init(nc,...) end

	return nc

end



function class_mt.__index(self,k)			--ISSUE: With checking metatables, the _inherit table isn't checked

	--check self
	local var=rawget(self,k)
	if var~=nil then return var end

	--check inheritances
	local _inherit=rawget(self,"_inherit")
	if _inherit~=nil then
		
		for i=1,#_inherit do

			var=_inherit[i][k]
			if var~=nil then return var end

		end

	end

	--check metatables
	local mt=getmetatable(self)

	if mt~=nil then var=mt[k] end
	if var~=nil then return var end

end



function class_mt.__init(nc,...)

	nc._inherit={...}

	nc.__index=class_mt.__index
	function nc.__init() return nil end

end



function class_mt:typeOf(name)

	if self.type and ((type(name)=="table" and self==name) or self:type()=="name") then return true end

	local mt=getmetatable(self)
	if mt and mt.type then return mt:typeOf(name) end

	return false

end

return class_mt