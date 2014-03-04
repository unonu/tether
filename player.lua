player = {}
player.__index = player

function player.make(number)
	local p = {}
	setmetatable(p,player)
	p.x,p.y = screen:getCentre('x'),screen:getCentre('y')
	p.number = number
	p.members = {}
		p.members.a = {}
			p.members.a.x = screen:getCentre('x')/2
			p.members.a.y = screen:getCentre('y')
			p.members.a.x_vol = 0
			p.members.a.y_vol = 0
			p.members.a.rot = 0
			p.members.a.forces = {}
			p.members.a.speed = 1.5
			p.members.a._points = 0
			p.members.a.points = 0
			p.members.a.stats = {hp = 16, deaths = 0}
			p.members.a.hp = 16
			p.members.a.immunity = 0
			p.members.a.lives = 3
			p.members.a.tether = false
			p.members.a.perks = {}
			p.members.a.attraction = 100
			p.members.a.target = {rot = 0, scale = 1}
			p.members.a.lapse = 0
		p.members.b = {}
			p.members.b.x = screen:getCentre('x')*1.5
			p.members.b.y = screen:getCentre('y')
			p.members.b.x_vol = 0
			p.members.b.y_vol = 0
			p.members.b.rot = 0
			p.members.b.forces = {}
			p.members.b.speed = 1.5
			p.members.b._points = 0
			p.members.b.points = 0
			p.members.b.stats = {hp = 16, deaths = 0}
			p.members.b.hp = 16
			p.members.b.immunity = 0
			p.members.b.lives = 3
			p.members.b.tether = false
			p.members.b.perks = {}
			p.members.b.attraction = 100
			p.members.b.target = {rot = 0, scale = 1}
			p.members.b.lapse = 0
	if number > 0 then
	p.joystick = {}
		p.joystick.leftH = tonumber(joysticks[love.joystick.getName(number)].axes.leftH)
		p.joystick.leftV = tonumber(joysticks[love.joystick.getName(number)].axes.leftV)
		p.joystick.rightH = tonumber(joysticks[love.joystick.getName(number)].axes.rightH)
		p.joystick.rightV = tonumber(joysticks[love.joystick.getName(number)].axes.rightV)
		p.joystick.leftShoulder = tonumber(joysticks[love.joystick.getName(number)].buttons['leftShoulder'])
		p.joystick.rightShoulder = tonumber(joysticks[love.joystick.getName(number)].buttons['rightShoulder'])
	if not love.joystick.isOpen(number) then love.joystick.open(number) end
	end
	p.sounds = {}
		p.sounds.aHit = res.load("sound","damage","new")
		p.sounds.bHit = res.load("sound","damage","new")
		p.sounds.adanger = res.load("sound","danger","new")
		p.sounds.acritical = res.load("sound","critical","new")
		p.sounds.bdanger = res.load("sound","danger","new")
		p.sounds.bcritical = res.load("sound","critical","new")
		p.sounds.aDie = res.load("sound","dead","new")
		p.sounds.bDie = res.load("sound","dead","new")
	p.dead = false
	p.distance = 100
	p.tetherDistance = 100
	p.image = res.load("sprite","player.png")
	p.imageLarge = res.load("sprite","playerLarge.png")
	return p
end

function player:push(member,x,y,f)
	table.insert(self.members[member].forces, {f or ((x or 0)^2+(y or 0)^2)^(.5),math.atan2(y or 0,x or 0)})
--	print(self.members[member].forces[1][1],self.members[member].forces[1][2])
end
function player:reverse(member,dir)
	if dir == 'x' then
--		print(self.members[member].x_vol)
		self.members[member].x_vol = -self.members[member].x_vol
--		print(self.members[member].x_vol)
	elseif dir == 'y' then
--		print(self.members[member].y_vol)
		self.members[member].y_vol = -self.members[member].y_vol
--		print(self.members[member].y_vol)
	end
end

function player:closest(x,y)
	if ((self.members.a.x-x)^2+(self.members.a.y-y)^2)^(.5) <= ((self.members.b.x-x)^2+(self.members.b.y-y)^2)^(.5) then
		return {x=self.members.a.x,y=self.members.a.y}
	else
		return {x=self.members.b.x,y=self.members.b.y}
	end
end

function player:drawA(x,y,s)
--			local rot
		if self.number > 0 then
			if love.joystick.getAxis(self.number,1) ~= 0 or love.joystick.getAxis(self.number,2) ~= 0 then
				self.members.a.rot = math.atan2(love.joystick.getAxis(self.number,1),-love.joystick.getAxis(self.number,2))
			else
				self.members.a.rot = self.members.a.rot - (math.pi/128)
			end
		else
			if love.keyboard.isDown("w") and love.keyboard.isDown("a") then self.members.a.rot = 7*math.pi/4
			elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") then self.members.a.rot = 5*math.pi/4
			elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then self.members.a.rot = 3*math.pi/4
			elseif love.keyboard.isDown("d") and love.keyboard.isDown("w") then self.members.a.rot = math.pi/4
			elseif love.keyboard.isDown("w") then self.members.a.rot = 0
			elseif love.keyboard.isDown("s") then self.members.a.rot = math.pi
			elseif love.keyboard.isDown("a") then self.members.a.rot = 3*math.pi/2
			elseif love.keyboard.isDown("d") then self.members.a.rot = math.pi/2
			else self.members.a.rot = self.members.a.rot-(math.pi/128) end
		end
	if (self.number < 0 and not love.keyboard.isDown('w','a','s','d'))or(self.number > 0 and love.joystick.getAxis(self.number,1) == 0 and love.joystick.getAxis(self.number,2) == 0) then
		if self.distance < self.tetherDistance then
			love.graphics.setColor(158,3,151,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge3"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player3"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,24,24)
			end
		else
			love.graphics.setColor(0,0,0,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge3"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player3"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,24,24)
			end
		end
		love.graphics.setColor(100,100,255,255-math.random(0,math.max(0,self.members.a.immunity*255)))
		if s then
			love.graphics.draw(self.imageLarge,res.quads["playerLarge1"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,144,144)
		else
			love.graphics.draw(self.image,res.quads["player1"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,24,24)
		end
	else
		if self.distance < self.tetherDistance then
			love.graphics.setColor(158,3,151,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge4"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player4"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,24,24)
			end
		else
			love.graphics.setColor(0,0,0,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge4"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player4"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,24,24)
			end
		end
		love.graphics.setColor(100,100,255,255-math.random(0,math.max(0,self.members.a.immunity*255)))
		if s then
			love.graphics.draw(self.imageLarge,res.quads["playerLarge2"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,144,144)
		else
			love.graphics.draw(self.image,res.quads["player2"],x or self.members.a.x,y or self.members.a.y,self.members.a.rot,1,1,24,24)
		end
	end
	if self.members.a.hp <= self.members.a.stats.hp/4 and self.members.a.hp > self.members.a.stats.hp/8 then love.graphics.print("Low HP",(x or self.members.a.x)+12,(y or self.members.a.y)-26) end
	if self.members.a.hp <= self.members.a.stats.hp/8 then love.graphics.print("Very Low HP!",(x or self.members.a.x)+12,(y or self.members.a.y)-26) end
end

function player:drawB(x,y,s)
--			local rot
		if self.number > 0 then
			if love.joystick.getAxis(self.number,3) ~= 0 or love.joystick.getAxis(self.number,4) ~= 0 then
				self.members.b.rot = math.atan2(love.joystick.getAxis(self.number,3),-love.joystick.getAxis(self.number,4))
			else
				self.members.b.rot = self.members.b.rot - (math.pi/128)
			end
		else
			if love.keyboard.isDown("p") and love.keyboard.isDown("l") then self.members.b.rot = 7*math.pi/4
			elseif love.keyboard.isDown("l") and love.keyboard.isDown(";") then self.members.b.rot = 5*math.pi/4
			elseif love.keyboard.isDown(";") and love.keyboard.isDown("\'") then self.members.b.rot = 3*math.pi/4
			elseif love.keyboard.isDown("\'") and love.keyboard.isDown("p") then self.members.b.rot = math.pi/4
			elseif love.keyboard.isDown("p") then self.members.b.rot = 0
			elseif love.keyboard.isDown(";") then self.members.b.rot = math.pi
			elseif love.keyboard.isDown("l") then self.members.b.rot = 3*math.pi/2
			elseif love.keyboard.isDown("\'") then self.members.b.rot = math.pi/2 
			else self.members.b.rot = self.members.b.rot- (math.pi/128) end
		end
	if (self.number < 0 and not love.keyboard.isDown('p','l',';','\'')) or (self.number > 0 and love.joystick.getAxis(self.number,3) == 0 and love.joystick.getAxis(self.number,4) == 0) then
		if self.distance < self.tetherDistance then
			love.graphics.setColor(158,3,151,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge3"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player3"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,24,24)
			end
		else
			love.graphics.setColor(0,0,0,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge3"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player3"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,24,24)
			end
		end
		love.graphics.setColor(255,100,100,255-math.random(0,math.max(0,self.members.b.immunity*255)))
		if s then
			love.graphics.draw(self.imageLarge,res.quads["playerLarge1"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,144,144)
		else
			love.graphics.draw(self.image,res.quads["player1"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,24,24)
		end
	else
		if self.distance < self.tetherDistance then
			love.graphics.setColor(158,3,151,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge4"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player4"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,24,24)
			end
		else
			love.graphics.setColor(0,0,0,128)
			if s then
				love.graphics.draw(self.imageLarge,res.quads["playerLarge4"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,144,144)
			else
				love.graphics.draw(self.image,res.quads["player4"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,24,24)
			end
		end
		love.graphics.setColor(255,100,100,255-math.random(0,math.max(0,self.members.b.immunity*255)))
		if s then
			love.graphics.draw(self.imageLarge,res.quads["playerLarge2"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,144,144)
		else
			love.graphics.draw(self.image,res.quads["player2"],x or self.members.b.x,y or self.members.b.y,self.members.b.rot,1,1,24,24)
		end
	end
	if self.members.b.hp <= self.members.b.stats.hp/4 and self.members.b.hp > self.members.b.stats.hp/8 then love.graphics.print("Low HP",(x or self.members.b.x)+12,(y or self.members.b.y)-26) end
	if self.members.b.hp <= self.members.b.stats.hp/8 then love.graphics.print("Very Low HP!",(x or self.members.b.x)+12,(y or self.members.b.y)-26) end
end

function player:draw()

	if self.members.a.tether and self.members.b.tether then
		if self.distance <= self.tetherDistance then
			love.graphics.setLineWidth(math.floor(24-24*self.distance/self.tetherDistance))
			love.graphics.setColor(158,3,152,255-(128*self.distance/self.tetherDistance))
			love.graphics.line(self.members.a.x,self.members.a.y,self.members.b.x,self.members.b.y)
		end
	else
		if self.distance <= self.tetherDistance then
			love.graphics.setLineWidth(3)
			love.graphics.setColor(180,0,180,24)
			love.graphics.line(self.members.a.x,self.members.a.y,self.members.b.x,self.members.b.y)
		end
		love.graphics.setLineWidth(1)
		love.graphics.setColor(255,0,0,16)
		love.graphics.line(self.members.a.x,self.members.a.y,self.members.b.x,self.members.b.y)
	end

	--------------
	-- A member --
	--------------
	self:drawA()

	--------------
	-- B member --
	--------------
	self:drawB()

	--------------
	
--	love.graphics.rectangle('line',self.members.a.x-16,self.members.a.y-16,32,32)
--	love.graphics.rectangle('line',self.members.b.x-16,self.members.b.y-16,32,32)
end

function player:updateA(dt)
	self.members.a._points = self.members.a.points
	if self.number > 0 then
	local horiz, vert = love.joystick.getAxis(self.number,self.joystick.leftH), love.joystick.getAxis(self.number,self.joystick.leftV)
		if love.joystick.isDown(self.number,self.joystick.leftShoulder) then self.members.a.tether = true else self.members.a.tether = false end
		if horiz ~= 0 then self.members.a.x_vol = self.members.a.x_vol + horiz*.8*self.members.a.speed end--x
		if vert ~= 0 then self.members.a.y_vol = self.members.a.y_vol + vert*.8*self.members.a.speed end--y
	else
		if love.keyboard.isDown('lshift') then self.members.a.tether = true else self.members.a.tether = false end
		if love.keyboard.isDown('a') then self.members.a.x = self.members.a.x - 4*self.members.a.speed end
		if love.keyboard.isDown('d') then self.members.a.x = self.members.a.x + 4*self.members.a.speed end
		if love.keyboard.isDown('w') then self.members.a.y = self.members.a.y - 4*self.members.a.speed end
		if love.keyboard.isDown('s') then self.members.a.y = self.members.a.y + 4*self.members.a.speed end
	end
	if self.members.a.x < 0 then self:push('a',-self.members.a.x) end
	if self.members.a.x > screen.width then self:push('a',screen.width-self.members.a.x) end
	if self.members.a.y < 64 then self:push('a',0,64-self.members.a.y) end
	if self.members.a.y > screen.height then self:push('a',0,screen.height-self.members.a.y) end
------------------------------------------------------>
	if self.members.a.tether and self.distance > self.tetherDistance then -- and self.members.b.tether == false
		self:push('b',self.members.a.x-self.members.b.x,self.members.a.y-self.members.b.y,math.round(64/math.abs(self.distance),2))
		self:push('a',self.members.b.x-self.members.a.x,self.members.b.y-self.members.a.y,math.round(32/math.abs(self.distance),2))
	end
------------------------------------------------------>
	if self.members.a.hp <= self.members.a.stats.hp/4 and self.members.a.hp > self.members.a.stats.hp/8 then
		if not screen.flashing then screen:flash(1,5,{0,0,255},"edge") end
		love.audio.play(self.sounds.adanger)
		if self.members.a.lapse > 1200 then -- should I make this constant a stat?
			self.members.a.lapse = 0
			self:giveHealth('a')
		end
	end
	if self.members.a.hp <= self.members.a.stats.hp/8 then
		if not screen.flashing then screen:flash(1,10,{0,0,255},"edge") end
		if math.random(1,3) == 2 then screen:aberate(math.random(1,3),math.random(0,2)) end
		love.audio.play(self.sounds.acritical)
		if self.members.a.lapse > 1200 and self.members.a.lives <= 1 then -- should I make this constant a stat?
			self.members.a.lapse = 0
			self:giveHealth('a')
		end
	end
	if self.members.a.hp <= 0 then
		self.members.a.lives = self.members.a.lives - 1
		self.members.a.stats.deaths = self.members.a.stats.deaths +1
		self.members.a.hp = self.members.a.stats.hp
		screen:shake(1,12)
		for ii=1, math.min(self.members.a.points,100) do
			table.insert(state.crystals, crystal.make(self.members.a.x+math.random(-48,48),self.members.a.y+math.random(-48,48)))
		end
		self.members.a.points = math.max(0,self.members.a.points-100)
		messages:new("Player "..self.number.." died",self.members.a.x,self.members.a.y,'up',-1,{0,128,90},'small')
		print(self.members.a.lives.." lives left.")
		self.members.a.x,self.members.a.y = screen:getCentre('x'),screen:getCentre('y')
		self.members.a.immunity = 18
		love.audio.play(self.sounds.aDie)
	end
	
	if self.members.a.target.rot < math.pi*2 then
		self.members.a.target.rot = self.members.a.target.rot+(math.pi/120)
	else
		self.members.a.target.rot = 0
	end
	if self.members.a.target.scale > 1 then
		self.members.a.target.scale = self.members.a.target.scale - .2
	end
	
	if self.members.a.immunity > 0 then self.members.a.immunity = self.members.a.immunity - .1;else self.members.a.immunity = 0 end
end

function player:updateB(dt)
	self.members.b._points = self.members.b.points
	if self.number > 0 then
	local horiz, vert = love.joystick.getAxis(self.number,self.joystick.rightH), love.joystick.getAxis(self.number,self.joystick.rightV)
		if love.joystick.isDown(self.number,self.joystick.rightShoulder) then self.members.b.tether = true else self.members.b.tether = false end
		if horiz ~= 0 then self.members.b.x_vol = self.members.b.x_vol + horiz*.8*self.members.b.speed end--x
		if vert ~= 0 then self.members.b.y_vol = self.members.b.y_vol + vert*.8*self.members.b.speed end--y
	else
		if love.keyboard.isDown('rshift') then self.members.b.tether = true else self.members.b.tether = false end
		if love.keyboard.isDown('l') then self.members.b.x = self.members.b.x - 4*self.members.b.speed end
		if love.keyboard.isDown('\'') then self.members.b.x = self.members.b.x + 4*self.members.b.speed end
		if love.keyboard.isDown('p') then self.members.b.y = self.members.b.y - 4*self.members.b.speed end
		if love.keyboard.isDown(';') then self.members.b.y = self.members.b.y + 4*self.members.b.speed end
	end
	if self.members.b.x < 0 then self:push('b',-self.members.b.x) end
	if self.members.b.x > screen.width then self:push('b',screen.width-self.members.b.x) end
	if self.members.b.y < 64 then self:push('b',0,64-self.members.b.y) end
	if self.members.b.y > screen.height then self:push('b',0,screen.height-self.members.b.y) end
------------------------------------------------->
	if self.members.b.tether and self.distance > self.tetherDistance then -- and self.members.a.tether == false
		self:push('a',self.members.b.x-self.members.a.x,self.members.b.y-self.members.a.y,math.round(64/math.abs(self.distance),2))
		self:push('b',self.members.a.x-self.members.b.x,self.members.a.y-self.members.b.y,math.round(32/math.abs(self.distance),2))
	end
------------------------------------------------------>
	if self.members.b.hp <= self.members.b.stats.hp/4 and self.members.b.hp > self.members.b.stats.hp/8 then
		if not screen.flashing then screen:flash(1,5,{255,0,0},"edge") end
		love.audio.play(self.sounds.bdanger)
		if self.members.b.lapse > 1200 then -- should I make this constant a stat?
			self.members.b.lapse = 0
			self:giveHealth('b')
		end
	end
	if self.members.b.hp <= self.members.b.stats.hp/8 then
		if not screen.flashing then screen:flash(1,10,{255,0,0},"edge") end
		if math.random(1,3) == 2 then screen:aberate(math.random(1,3),math.random(0,2)) end
		love.audio.play(self.sounds.bcritical)
		if self.members.b.lapse > 1200 and self.members.b.lives <= 1 then -- should I make this constant a stat?
			self.members.b.lapse = 0
			self:giveHealth('b')
		end
	end
	if self.members.b.hp <= 0 then
		self.members.b.lives = self.members.b.lives - 1
		self.members.b.stats.deaths = self.members.b.stats.deaths +1
		self.members.b.hp = self.members.b.stats.hp
		screen:shake(1,12)
		for ii=1, math.min(self.members.b.points,100) do
			table.insert(state.crystals, crystal.make(self.members.b.x+math.random(-48,48),self.members.b.y+math.random(-48,48)))
		end
		self.members.b.points = math.max(0,self.members.b.points-100)
		messages:new("Player "..(self.number+1).." died. ",self.members.b.x,self.members.b.y,'up',-1,{0,128,90},'small')
		print(self.members.b.lives.." lives left.")
		self.members.b.x,self.members.b.y = screen:getCentre('x'),screen:getCentre('y')
		self.members.b.immunity = 18
		love.audio.play(self.sounds.bDie)
	end
	
	if self.members.b.target.rot < math.pi*2 then
		self.members.b.target.rot = self.members.b.target.rot+(math.pi/120)
	else
		self.members.b.target.rot = 0
	end
	if self.members.b.target.scale > 1 then
		self.members.b.target.scale = self.members.b.target.scale - .2
	end
	
	if self.members.b.immunity > 0 then self.members.b.immunity = self.members.b.immunity - .1;else self.members.b.immunity = 0 end
end

function player:update()
	self.distance = ((self.members.a.x-self.members.b.x)^2+(self.members.a.y-self.members.b.y)^2)^(.5)
	

	--------------
	-- A member --
	--------------
	self:updateA(dt)

	--------------
	-- B member --
	--------------
	self:updateB(dt)
	
	for i,f in ipairs(self.members.a.forces) do self.members.a.x_vol = self.members.a.x_vol + math.cos(f[2])*f[1] end
	for i,f in ipairs(self.members.a.forces) do self.members.a.y_vol = self.members.a.y_vol + math.sin(f[2])*f[1] end
	for i,f in ipairs(self.members.b.forces) do self.members.b.x_vol = self.members.b.x_vol + math.cos(f[2])*f[1] end
	for i,f in ipairs(self.members.b.forces) do self.members.b.y_vol = self.members.b.y_vol + math.sin(f[2])*f[1] end
	self.members.a.x = self.members.a.x + self.members.a.x_vol
	self.members.a.y = self.members.a.y + self.members.a.y_vol
	self.members.b.x = self.members.b.x + self.members.b.x_vol
	self.members.b.y = self.members.b.y + self.members.b.y_vol

	------------
	-- Tether --
	------------
	local tetherSrength = (math.floor(24-24*self.distance/self.tetherDistance))/12
	if self.members.a.tether and self.members.b.tether then
		if self.distance <= self.tetherDistance then
			for i,e in ipairs(state.enemies) do
				if math.checkIntersect({x=self.members.a.x,y=self.members.a.y},{x=self.members.b.x,y=self.members.b.y},{x=e.x-e.r,y=e.y-e.r},{x=e.x+e.r,y=e.y+e.r}) or math.checkIntersect({x=self.members.a.x,y=self.members.a.y},{x=self.members.b.x,y=self.members.b.y},{x=e.x-e.r,y=e.y+e.r},{x=e.x+e.r,y=e.y-e.r}) then
					e.hp = e.hp - tetherSrength
					screen:shake(.15,3,false)
				end
			end
			for i,r in ipairs(state.rocks) do
				if math.checkIntersect({x=self.members.a.x,y=self.members.a.y},{x=self.members.b.x,y=self.members.b.y},{x=r.x-r.r,y=r.y-r.r},{x=r.x+r.r,y=r.y+r.r}) or math.checkIntersect({x=self.members.a.x,y=self.members.a.y},{x=self.members.b.x,y=self.members.b.y},{x=r.x-r.r,y=r.y+r.r},{x=r.x+r.r,y=r.y-r.r}) then
					r.hp = r.hp - tetherSrength
					screen:shake(.15,3,false)
				end
			end
		end
	end

	-------------
	-- Collide --
	-------------
	self.members.a.lapse = self.members.a.lapse + 1
	self.members.b.lapse = self.members.b.lapse + 1

	for i,b in ipairs(state.bullets) do
		if self.members.a.immunity == 0 and b.owner == 'enemy' and b.x >= self.members.a.x-6 and b.x <= self.members.a.x+6 and b.y >= self.members.a.y-6 and b.y <= self.members.a.y+6 then
			self.members.a.hp = self.members.a.hp - 1
			self.members.a.lapse = 0
			screen:shake(.5,4)
			if not screen.flashing then screen:flash(1,20,{0,0,255},"edge") end
			love.audio.rewind(self.sounds.aHit);love.audio.play(self.sounds.aHit)
			table.remove(state.bullets,i)
		end
		if self.members.b.immunity == 0 and b.owner == 'enemy' and b.x >= self.members.b.x-12 and b.x <= self.members.b.x+12 and b.y >= self.members.b.y-12 and b.y <= self.members.b.y+12 then
			self.members.b.hp = self.members.b.hp - 1
			self.members.b.lapse = 0
			screen:shake(.5,4)
			if not screen.flashing then screen:flash(1,20,{255,0,0},"edge") end
			love.audio.rewind(self.sounds.bHit);love.audio.play(self.sounds.bHit)
			table.remove(state.bullets,i)
		end
	end
	for i,c in ipairs(state.crystals) do
		if c.x >= self.members.a.x-12 and c.x <= self.members.a.x+12 and c.y >= self.members.a.y-12 and c.y <= self.members.a.y+12 then
			c.got = true
			self.members.a.points = self.members.a.points +1
		end
		if c.x >= self.members.b.x-12 and c.x <= self.members.b.x+12 and c.y >= self.members.b.y-12 and c.y <= self.members.b.y+12 then
			c.got = true
			self.members.b.points = self.members.b.points +1
		end
	end

	if self.members.a.lives < 0 or self.members.b.lives < 0 then
		self.dead = true
	end

	if self.members.a.x_vol ~= 0 then self.members.a.x_vol = self.members.a.x_vol - (self.members.a.x_vol*.2) end
	if self.members.a.y_vol ~= 0 then self.members.a.y_vol = self.members.a.y_vol - (self.members.a.y_vol*.2) end
	if self.members.b.x_vol ~= 0 then self.members.b.x_vol = self.members.b.x_vol - (self.members.b.x_vol*.2) end
	if self.members.b.y_vol ~= 0 then self.members.b.y_vol = self.members.b.y_vol - (self.members.b.y_vol*.2) end
	
	self.members.a.forces = {}
	self.members.b.forces = {}

end

function player:giveHealth(t,h)
	if t=='both' then
		self.members.a.hp = self.members.a.hp + (h or self.members.a.stats.hp-self.members.a.hp)
		self.members.b.hp = self.members.b.hp + (h or self.members.b.stats.hp-self.members.b.hp)
		messages:new("Health Up!",self.members.a.x,self.members.a.y,'up',3,{0,128,90})
		messages:new("Health Up!",self.members.b.x,self.members.b.y,'up',3,{0,128,90})
	else
		self.members[t].hp = self.members[t].hp + (h or self.members[t].stats.hp-self.members[t].hp)
		messages:new("Health Up!",self.members[t].x,self.members[t].y,'up',3,{0,128,90})
	end
end
