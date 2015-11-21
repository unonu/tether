credits = {}
credits.__index = credits

function credits.make()
	screen:clearEffects('flash')
	local c = {}
	setmetatable(c,credits)
	c.offset = screen.height
	c.credits = {}
	local file = "res/credits/credits.txt"
	local y = 0
	for l in love.filesystem.lines(file) do
		if l:sub(1,2) == '#!' then
			love.graphics.setFont(fonts[l:sub(3)])
			table.insert(c.credits,{l,0,0})
		else
			table.insert(c.credits,{l,love.graphics.getFont():getWidth(l),y})
			if l:sub(1,2) ~= '#?' then
				y = y + love.graphics.getFont():getHeight(l) + 4
			end
		end
	end

	c.particles = {}
	c.files = {}
	local t = love.filesystem.getDirectoryItems("res/sprites/")
	local removed = 0
	for i,f in ipairs(t) do
		if f:sub(-4) == ".png" then
			table.insert(c.files,f)
		end
	end

	c.name = "Credits"

	return c
end

function credits:draw()
	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	love.graphics.setColor(255,255,255)

	for i,o in ipairs(self.particles) do
		love.graphics.setColor(128,128,128,o[8])
		love.graphics.draw(o[1],o[2],o[3],o[6],o[4],o[4],o[1]:getWidth()/2,o[1]:getHeight()/2)
		if o[3]-o[1]:getHeight()/2 > screen.height then table.remove(self.particles,i) end
		o[3] = o[3]+o[5]
		o[6] = o[6]-o[7]
	end

	love.graphics.setColor(255,255,255)
	for i,l in ipairs(self.credits) do
		if l[1]:sub(1,2) == '#!' then
			love.graphics.setFont(fonts[l[1]:sub(3)])
		elseif l[1]:sub(1,2) == '#?' then
			love.graphics.setColor(unpack(hexToCol(l[1]:sub(3))))
		else
			love.graphics.print(l[1],screen:getCentre('x')-(l[2]/2),self.offset + l[3])
		end
	end

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(fonts.small)
	love.graphics.print("Questions, complaints or suggestions should be directed to unonuorea@gmail.com",4,screen.height-24)
end

function credits:update(dt)
	if self.offset + self.credits[#self.credits][3] > -24 then
		-- state = mainmenu.make(true)
	self.offset = self.offset - 1
	end

	local i = math.random()
	if math.random(0,40) == 40 then
		-- makes random sprites: image,x,y,fall speed,scale,rotation,direction/speed,alpha
		local o = {res.load("sprite",self.files[math.random(1,#self.files)]),math.random(0,screen.width),0,i,i/2,0,i*math.pi/100*math.rsign(),math.random(64,196)}
		o[3] = -o[1]:getHeight()
		table.insert(self.particles,o)
	end

end

function credits:keypressed(k)
	state = mainmenu.make(true)
end