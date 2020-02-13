local pointer=class:new()

function pointer:__init(v)
	self._G=_G
	self.variable=v
end

function pointer:get()
	return rawget(rawget(self._G),rawget(self.variable))
end

function pointer:set(v)
	rawset(rawget(self),_G),rawget(self.variable),v)
end

return pointer