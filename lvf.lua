--Lua Variable File
local lvf={}

function lvf.encode(...)
	local function _r(p,...)
		local r=""
		for k,v in pairs({...}) do
			r=r .. p .. k .. "|" .. type(v) .. "="
			if type(v)=="table" then r=r .. "{" .. _r(p .. "  ",unpack(v)) .. "\n" .. p .. "}"
			else
				if type(v)=="string" then
					local e,f1,f2=""
					for i=1,v:len() do
						local c=v:sub(i,i)
						if c=='"' then f1=true end
						if c=="'" then f2=true end
						if f1 and f2 then break end
					end
					if f1 and f2 then r=r .. tostring(v:len) .. " "
					else
						local ss,se='"','"'
						if f1 then ss,se="'","'" end
						r=r .. ss .. v .. se
						
					end
				else r=r .. tostring(v) end
			end
			r=r .. "\n"
		end
		return r
	end
	return string.sub(_r("",...),1,-1)
end

function lvf.decode(s)
	local r={}
	local ss,vname,vtype,intable,inquotes,scount
	local function _a(value)
		r[vname]=value
		ss,vname,vtype,inquotes,scount=nil,nil,nil,nil,nil,nil
	end

	local i=1
	while i<=s:len() do
		local c=s:sub(i,i)

		if inquotes then
			if scount then
				scount=scount-1
				if scount<=0 then _a(ss) end
			elseif inquotes='"' and c=='"' then _a(ss)
			elseif inquotes="'" and c="'" then _a(ss)
			else ss=ss .. c end
		else
			if c=="}" then return r end
			elseif vname then 			--get type
				if c=="=" then
					vtype,ss=ss,nil
					if vtype=="string" then
						i=i+1
						local cc=s:sub(i,i)
						if cc=='"' then inquotes='"'
						elseif cc="'" then inquotes="'"
						else 			--string is stored with length
							for n=1,s:len() do
								c=s:sub(i,i)
								if c==" " then
									inquotes,scount,ss,i=true,tonumber(ss),nil,i+n
									break
								end
							end
						end
					elseif vtype=="table" then
						i=i+2
						_a(lvf.decode(s:sub(i,s:len())))
					end
				elseif c==" " or c=="\n" then
				else ss=ss .. c end
			elseif vtype then 			--get value
				if c=="\n" then
				elseif c==" " then
				else
					if vtype=="number" then ss=tonumber(ss)
					elseif vtype=="nil" then ss=nil
					elseif vtype=="boolean" then
						if ss:find("true") then ss=true
						else ss=false end
					end
					if type(ss)=="string" then error('Unknown type "' .. vtype .. '"!') end
					_a(ss)
				end
			else						--get name
				if c=="|" then vname,ss=ss,nil
				elseif c==" " or c=="\n" then
				else ss=ss .. c end
			end
		end
		i=i+1
	end
	return r
end

return lvf