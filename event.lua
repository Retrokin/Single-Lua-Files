local etbl=require "etbl"
local event={}
local _events={}

function event.getFuncs()
	return _events
end

function event.add(k,f)
	_events[k]=_events[k] or {}
	local p=#events[k]+1
	_events[p]=f
	return p
end

function event.remove(k,i)
	_events[i]=nil
	etbl.shift(_events,-1,i)
end

function event.run(k,...)
	for i,l in ipairs(_events[k]) do
		l(...)
	end
end

return event