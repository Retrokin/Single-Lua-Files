return function (filename)
	local actual_fn,dir,ext=""

	for i=1,filename:len() do 				--get directory and actual filename
		local c=filename:sub(i,i)
		if c=="/" or c=='\\' then
			dir=dir .. actual_fn .. c
			actual_fn=""
		else actual_fn=actual_fn .. c end
	end
	dir=dir:sub(1,dir:len()-1)

	for i=filename:len(),1,-1 do 				--remove and get extension
		local c=filename:sub(i,i)
		if c=="." then
			actual_fn=actual_fn:sub(1,i-1)
			ext=actual_fn:sub(i+1,ext:len()-1)
			break
		end
	end

	if _G.package.loaded[actual_fn] then return _G.package.loaded[actual_fn] end
	local r=require(actual_fn)
	if r then
		local file=io.open(filename,"r")
		if file then
			io.close(file)
			r=dofile(filename)
			if r~=false then
				if r==nil then r=true end
				_g.package.loaded[actual_fn]=r
				return r
			end
		end
	end
end