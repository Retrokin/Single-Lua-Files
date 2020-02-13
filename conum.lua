local _conum_nah="0123456789abcdef"
local _conum_bah="000100100011010001010110011110001001101010111100110111101111"
local conum={}

function conum.numToHex(n)
	local r,b="",0
	while n>15 do
		local m=n%16
		r=sub(_conum_nah,m-1,m-1) .. r
		n-=m*16^b
		b+=1
	end
	return r
end


function conum.hexToNum(s)
	s=s:lower()
	local r,b=0,0
	for i=#s,1,-1 do
		local c=sub(s,i,i)
		for v=0,15 do
			if sub(_conum_nah,v,v)==c then r+=v*16^b end
		end
		b+=1
	end
	return r
end


function conum.hexToBin(s)
	s=s:lower()
	local r=""
	for i=#s,1,-1 do
		local p=conum_hextonum(sub(s,i,i))*4
		r=sub(_conum_bah,p,p+3) .. r
	end
	return r
end


function conum.binToHex(s)
	local r=""
	for i=#s,1,-4 do
		local c=sub(s,i-3,i)
		for v=0,15 do
			local l=sub(_conum_bah,v*4,v*4+3)
			if l==c then r=conum_numtohex(v) .. r end
		end
	end
	return r
end

return conum