rock = {}
rock.__index = rock

function rock.make(x,y,s,p)
	local r = {}
	setmetatable(r,rock)
	r.hp = 48
	r._hp = 48
	r.kill = false
	r.killTimer = 90
	r.x,r.y = x,y
	r.x_vol = 0
	r.y_vol = 0
	r.r = 24
	r.s = math.random(1,2)/10
	if s and math.random(1,(p or 1))==1 then
	r.sentry = sentry.make(x,y)
	r.sentryNum = nil
	end
	r.image = res.load("sprite","rock"..math.random(1,3)..".png")
	r.forces = {{r.s,math.random(0,2*math.pi)}}
	r.timers = {}
	r.timers.birth = 0
	r.rot = (math.random()-.5)*math.pi
	r.a_vol = (math.random()-.5)/200

	r.p = love.graphics.newParticleSystem(res.load("sprite","particle.png"),1)
		r.p:setPosition(0,0)
		r.p:setEmissionRate(12)
		r.p:setSpeed(20, 60)
		r.p:setColors(170,120,85,128)
		r.p:setDirection(0)
		r.p:setSpread(math.pi/4)
		r.p:setSpin(0,2)
		r.p:setRotation(0,math.pi*2)
		r.p:stop()

	return r
end

function rock:draw()
	if self.timers.birth < 31 then
		self.timers.birth = self.timers.birth + 1
		love.graphics.setColor(237,143,77,self.timers.birth*8)
	else
		love.graphics.setColor(237,143,77)
	end
	love.graphics.draw(self.p)
	love.graphics.draw(self.image,self.x,self.y,self.rot,1,1,50,50)
	love.graphics.point(self.x,self.y)
	if self.sentry then
		love.graphics.setColor(255,0,0)
		self.sentry:draw()
	end
end

function rock:update(dt)
	for i,b in ipairs(state.bullets) do
		if b.x >= self.x-self.r and b.x <= self.x+self.r and b.y >= self.y-self.r and b.y <= self.y+self.r then
--			love.audio.rewind(self.sounds.aHit);love.audio.play(self.sounds.aHit)
			table.insert(self.forces,{-b.s/100,b.d})
			table.remove(state.bullets,i)
		end
	end

	for i,f in ipairs(self.forces) do self.x_vol = self.x_vol + math.cos(f[2])*f[1] end
	for i,f in ipairs(self.forces) do self.y_vol = self.y_vol + math.sin(f[2])*f[1] end
	self.rot = (self.rot - self.a_vol)
--

	if (self.x-24 < 0 and self.x_vol < 0) or (self.x+24 > screen.width and self.x_vol > 0) then
		self.x_vol = -self.x_vol
	end
	if (self.y-24 < 64 and self.y_vol < 0) or (self.y+24 > screen.height and self.y_vol > 0) then
		self.y_vol = -self.y_vol
	end

	self.x = self.x + self.x_vol
	self.y = self.y + self.y_vol

	if self.hp < self._hp and self.hp >= self._hp/2 then
		if self.p:getCount() == 0 then
			self.p:setBufferSize(5)
			self.p:setSpeed(4, 10)
		end
		self.p:setDirection(math.atan2(screen:getCentre('y')-self.y,screen:getCentre('x')-self.x))
		self.p:setEmissionRate(math.ceil(1-(self.hp/self._hp)))
	elseif self.hp < self._hp/2 and self.hp > 0 then
		if self.p:getCount() == 0 then
			self.p:setBufferSize(12*(1-(self.hp/self._hp)))
			self.p:setSpeed(10, 20)
		end
		self.p:setDirection(math.atan2(screen:getCentre('y')-self.y,screen:getCentre('x')-self.x))
		self.p:setEmissionRate(math.ceil((1-(self.hp/self._hp))*3))
	elseif self.hp <= 0 then
		cloud.make(self.x,self.y,170,120,85,128)
		love.audio.rewind(state.sounds.explosion);love.audio.play(state.sounds.explosion)
		screen:shake(1,8,false)
		state.points = state.points + 1
	end

	if self. sentry then
		self.sentry.x, self.sentry.y = self.x, self.y
		self.sentry:update(dt)
	end

	self.p:setPosition(self.x,self.y)
	self.p:start()
	self.p:update(dt)
	--
	if ((self.x_vol^2)+(self.y_vol^2))^(1.5) > self.s then
		self.x_vol = self.x_vol - (self.x_vol*.1)
		self.y_vol = self.y_vol - (self.y_vol*.1)
	end
	self.forces = {}
end

crystal = {}
crystal.__index = crystal

function crystal.make(x,y)
	local c = {}
	setmetatable(c, crystal)
	c.x,c.y = x,y
	c.sound = res.load("sound","collect")
	c.got = false
	c.dead = false
	c.life = 2400
	
	return c
end

function crystal:draw()
	love.graphics.setColor(255,255,0,255*(math.min(self.life,200)/200))
	love.graphics.draw(state.res.crystal,self.x,self.y,0,1,1,6,6)
end

function crystal:update(dt)
	if self.life > 0 then
		self.life = self.life - 1
	else
		self.dead = true
	end
	if state.player.distance > math.max(state.player.members.a.attraction,state.player.members.b.attraction) then
		for ii,m in pairs(state.player.members) do
			if math.floor((((m.x-self.x)^2)+((m.y-self.y)^2))^.5) <= m.attraction then
				self.x = self.x + math.round(math.abs(math.cos(math.atan2((m.y-self.y),(m.x-self.x)))*m.attraction)/((m.x-self.x)),1)
				self.y = self.y + math.round(math.abs(math.sin(math.atan2((m.y-self.y),(m.x-self.x)))*m.attraction)/((m.y-self.y)),1)
			end
		end
	end
	if self.got then love.audio.rewind(state.sounds.collect);love.audio.play(state.sounds.collect) end
end
