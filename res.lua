res = {}

res.images = {}
res.sounds = {}
res.music = {}
res.quads = {}
res.tilesets = {}
res.sprites = {}

function res.init()
	print(ansicolors.yellow.."Initialising resources..."..ansicolors.clear)
	print(ansicolors.cyan.."- Images:"..ansicolors.clear)
	local files = love.filesystem.getDirectoryItems('res/images')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.png' then
			local item = {val = nil, users = 0}
			res.images[b]=item
			print('Loaded image, '..ansicolors.green..b..ansicolors.clear)
		end
	end
	print(ansicolors.cyan.."- Sprites:"..ansicolors.clear)
	local files = love.filesystem.getDirectoryItems('res/sprites')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.png' then
			local item = {val = nil, users = 0}
				res.images[b] = item
				print('Loaded sprite image, '..ansicolors.green..b..ansicolors.clear)
		elseif string.sub(b,-3) == '.ss' then
			local item = love.filesystem.newFile('res/sprites/'..b)
			item:open('r')
			local data = ' '
			local doLoop = true
			local ry = 0
			while doLoop do
				local rx = 1
				local val = 0
				local quad = {}
				local newLine = false
				data = item:read(1)
				while not newLine do
					if data == '\n' or item:isEOF() then
						newLine = true
						rx = rx+1
						val = 0
					elseif data ~= ',' then
						val =  (10*val) + (tonumber(data))
						quad[rx] = val
						data = item:read(1)
					else
						rx = rx+1
						val = 0
						data = item:read(1)
					end
				end
				ry = ry+1
				if item:isEOF() then
					doLoop = false
				end
				res.quads[string.sub(b,1,-4)..ry] = love.graphics.newQuad(quad[1],quad[2],quad[3],quad[4],quad[5],quad[6],quad[7])
			end
			item:close()
			print('Loaded sprite sheet '..ansicolors.green..b..ansicolors.clear)
--		end
		elseif string.sub(b,-5) == '.anim' then
			local item = love.filesystem.newFile('res/sprites/'..b)
			item:open('r')
			local data = ' '
			local doLoop = true
			local ry = 0
			while doLoop do
				local rx = 1
				local val = nil
				local quad = {}
				local newLine = false
				data = item:read(1)
				while not newLine do
					if data == '\n' or item:isEOF() then
						newLine = true
						rx = rx+1
						val = nil
					elseif data ~= ',' then
						if string.byte(data) < 58 then
							if val then
								val =  (10*val) + (tonumber(data))
							else
								val = data
							end
						else
							if val then
								val = val..data
							else
								val = data
							end
						end

						quad[rx] = val
						data = item:read(1)
					else
						rx = rx+1
						val = nil
						data = item:read(1)
					end
				end
				ry = ry+1
				if item:isEOF() then
					doLoop = false
				end
				res.sprites[string.sub(b,1,-6)] = {}
				res.sprites[string.sub(b,1,-6)].anim= {quad[1],quad[2],quad[3],quad[4]}
				res.sprites[string.sub(b,1,-6)].users = 0
				res.sprites[string.sub(b,1,-6)].val = nil
				print(res.sprites[string.sub(b,1,-6)].users..' users')
			end
				item:close()
			print('Loaded animation, '..ansicolors.green..b..ansicolors.clear)
		end
	end
	print(ansicolors.cyan.."- Sounds:"..ansicolors.clear)
	local files = love.filesystem.getDirectoryItems('res/sounds')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.mp3' then
			local item = {val = nil, users = 0}
			res.sounds[b]=item
		end
		print("Loaded sound, "..ansicolors.green..b..ansicolors.clear)
	end
	print(ansicolors.cyan.."- Music:"..ansicolors.clear)
	local files = love.filesystem.getDirectoryItems('res/music')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.mp3' then
			local item = {val = nil, users = 0}
			res.music[b]=item
		end
	end
	print(ansicolors.cyan.."- Tilesets:"..ansicolors.clear)
	local files = love.filesystem.getDirectoryItems('res/tilesets')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.png' then
			local item = {val = nil, users = 0}
			res.tilesets[b]=item
		elseif string.sub(b,-5) == '.quad' then
			local item = love.filesystem.newFile('res/tilesets/'..b)
			item:open('r')
			local data = ' '
			local doLoop = true
			local ry = 0
			while doLoop do
				local rx = 1
				local val = 0
				local quad = {}
				local newLine = false
				data = item:read(1)
				while not newLine do
					if data == '\n' or item:isEOF() then
						newLine = true
						rx = rx+1
						val = 0
					elseif data ~= ',' then
						val =  (10*val) + (tonumber(data))
						quad[rx] = val
						data = item:read(1)
					else
						rx = rx+1
						val = 0
						data = item:read(1)
					end
				end
				ry = ry+1
				if item:isEOF() then
					doLoop = false
				end
				res.quads[string.sub(b,1,-6)..ry] = love.graphics.newQuad(quad[1],quad[2],quad[3],quad[4],quad[5],quad[6],quad[7])
			end
			item:close()
			print('Loaded quad sheet, '..ansicolors.green..b..ansicolors.clear)
		end
	end
end

function res.load(typ, name,mode)
	if typ == 'image' and (res.images[name].users == 0 or res.images[name].val == nil) then
		res.images[name].users = res.images[name].users + 1
		res.images[name].val = love.graphics.newImage('res/images/'..name)
		return res.images[name].val
	elseif typ == 'sprite' then
		if res.sprites[name..".png"] then
				if (res.images[name..".png"].users == 0 or res.images[name..".png"].val == nil) then
					res.images[name..".png"].users = res.images[name..".png"].users + 1
					res.images[name..".png"].val = love.graphics.newImage('res/sprites/'..name..".png")
				end
				res.sprites[name..".png"].users = res.sprites[name..".png"].users + 1
				local rVal = newAnimation(res.images[name..".png"].val,res.sprites[name..".png"].anim[1],res.sprites[name..".png"].anim[2],res.sprites[name..".png"].anim[3]/100,res.sprites[name..".png"].anim[4])
				return rVal
		elseif res.images[name] then
			if res.images[name].val == nil then
				res.images[name].val = love.graphics.newImage('res/sprites/'..name)
			end
				res.images[name].users = res.images[name].users + 1
				return res.images[name].val
		else
			print(ansicolors.red.."Couldn\'t find image "..name..ansicolors.clear)
		end
	elseif typ == 'sound' then
		if mode == "new" then return love.audio.newSource('res/sounds/'..name..'.mp3',"static") end
		if res.sounds[name..'.mp3'].val == nil then
			res.sounds[name..'.mp3'].val = love.audio.newSource('res/sounds/'..name..'.mp3',"static")
		end
		res.sounds[name..'.mp3'].users = res.sounds[name..'.mp3'].users + 1
		return res.sounds[name..'.mp3'].val
	elseif typ == 'music' then
		if mode == "new" then return love.audio.newSource('res/music/'..name..'.mp3',"stream") end
		if res.music[name..'.mp3'].val == nil then
			res.music[name..'.mp3'].val = love.audio.newSource('res/music/'..name..'.mp3',"stream")
		end
		res.music[name..'.mp3'].users = res.music[name..'.mp3'].users + 1
		return res.music[name..'.mp3'].val
	elseif typ == 'tileset' then
		if res.tilesets[name].val == nil then
			res.tilesets[name].val = love.graphics.newImage('res/tilesets/'..name)
		end
		res.tilesets[name].users = res.tilesets[name].users + 1
		return res.tilesets[name].val
	elseif typ == 'quad' then
		return res.quads[name]
	else
		if typ == 'music' then
			res.music[name].users = loc[name].users + 1
			return res.music[name].val
		else
			local loc = res[typ..'s']
			loc[name].users = loc[name].users + 1
			return loc[name].val
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
-------------------------------------------------------------------------------------------------------------------------

function loadFonts()
	print(ansicolors.yellow.."Loading fonts..."..ansicolors.clear)
	local fonts = {}
	local numFonts = 0
	local files = love.filesystem.getDirectoryItems('fonts/')
	for i, f in ipairs(files) do
		if string.sub(f,-4) == '.png' then
			local fontDef = string.sub(love.filesystem.read('fonts/'..string.sub(f,1,-4)..'font'),1,-2)
			print(ansicolors.cyan..'- found '..f..ansicolors.clear..'\n'..fontDef)
			fonts[string.sub(f,1,-5)] = love.graphics.newImageFont('fonts/'..f,fontDef)
			numFonts = numFonts + 1
		end
	end

	print(numFonts..' fonts found\n-----------------------------')
	return fonts
end
