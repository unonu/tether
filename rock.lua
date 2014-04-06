rock = {}
rock.__index = rock

function rock.make(x,y,s,p)
	local r = {}
	setmetatable(r,rock)
	r.id = #state.rocks + 1
	-- r.dhp = 48
	r.kill = false
	r.killTimer = 90
	r.x,r.y = x,y
	r.x_vol = 0
	r.y_vol = 0
	r.r = 24
	r.s = math.random(1,2)/10
	r._hp = 36
	if s and math.random(1,(p or 1))==1 then
		r.sentry = sentry.make(x,y,r.id)
		r._hp = 48
		r.sentryNum = nil
	end
	r.hp = r._hp
	r.image = res.load("sprite","rock"..math.random(1,3)..".png")
	r.forces = {{r.s,math.random(0,2*math.pi)}}
	r.timers = {}
	r.timers.birth = 0
	r.rot = (math.random()-.5)*math.pi
	r.a_vol = (math.random()-.5)/200
	r.heat = 0

	r.p = love.graphics.newParticleSystem(res.load("sprite","particle.png"),6)
		r.p:setEmitterLifetime(2)
		r.p:setParticleLifetime(2)
		r.p:setEmissionRate(1)
		r.p:setSpeed(48,32)
		r.p:setRadialAcceleration(-24,-8,-24,8)
		r.p:setAreaSpread("uniform",2,2) --set to radius of object
		r.p:setSpread(math.pi/6) --raidans
		r.p:setSpin(-math.pi,-math.pi,0)
		r.p:setSizes(1,1,0)
		r.p:setColors(237,143-(143*r.heat),77-(77*r.heat))
		r.p:setPosition(0,0)
		r.p:setDirection(0)
		r.p:stop()

	return r
end

function rock:draw()
	love.graphics.draw(self.p)
	if self.timers.birth < 31 then
		self.timers.birth = self.timers.birth + 1
		love.graphics.setColor(237,143-(143*self.heat),77-(77*self.heat),self.timers.birth*8)
	else
		love.graphics.setColor(237,143-(143*self.heat),77-(77*self.heat))
	end
	love.graphics.draw(self.image,self.x,self.y,self.rot,1,1,50,50)
	love.graphics.point(self.x,self.y)
	if self.sentry then
		love.graphics.setColor(255,0,0)
		self.sentry:draw(self.rot,math.min(255,self.timers.birth*8))
	end
end

function rock:update(dt)
	for i,b in ipairs(state.bullets) do
		if b.life > 10 and b.x >= self.x-self.r and b.x <= self.x+self.r and b.y >= self.y-self.r and b.y <= self.y+self.r then
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
	if (self.y-24 < 0 and self.y_vol < 0) or (self.y+24 > screen.height and self.y_vol > 0) then
		self.y_vol = -self.y_vol
	end

	self.x = self.x + self.x_vol
	self.y = self.y + self.y_vol
	self.p:setPosition(self.x,self.y)
	self.p:setDirection(math.atan2(self.y_vol,self.x_vol)-math.pi)
	self.p:setColors(237,143-(143*self.heat),77-(77*self.heat))

	if self.x >= state.player.members.a.x - self.r - 12 and
	self.x <= state.player.members.a.x + self.r + 12 and
	self.y >= state.player.members.a.y - self.r - 12 and
	self.y <= state.player.members.a.y + self.r + 12 then
		state.player:push('a',self.x - state.player.members.a.x,self.y - state.player.members.a.y,-.5)
	end
	if self.x >= state.player.members.b.x - self.r - 12 and
	self.x <= state.player.members.b.x + self.r + 12 and
	self.y >= state.player.members.b.y - self.r - 12 and
	self.y <= state.player.members.b.y + self.r + 12 then
		state.player:push('b',self.x - state.player.members.b.x,self.y - state.player.members.b.y,-.5)
	end
	
	for i,r in ipairs(state.rocks) do
		if self.id ~= r.id then
			if self.x >= r.x - 2*r.r and
			self.x <= r.x + 2*r.r and
			self.y >= r.y - 2*r.r and
			self.y <= r.y + 2*r.r then
				local px,py = self.x_vol,self.y_vol
				self.x_vol = r.x_vol
				self.y_vol = r.y_vol
				r.x_vol = px
				r.y_vol = py
			end
		end
	end

	self.heat = 1-(self.hp/self._hp)
	if self.hp < self._hp and self.hp >= self._hp/2 then
			self.p:setEmissionRate(math.ceil(6*self.heat)/2)
		self.p:start()
	elseif self.hp < self._hp/2 and self.hp > 0 then
		self.p:setEmissionRate(math.ceil(6*self.heat)/2)
		self.p:start()
	elseif self.hp <= 0 then
		cloud.make(self.x,self.y,170,120,85,128)
		wave.make(self.x,self.y,150,2,255,255,255,48)
		love.audio.rewind(state.sounds.explosion);love.audio.play(state.sounds.explosion)
		screen:shake(1,8,false)
		state.points = state.points + 1
	end

	self.p:update(dt)


	if self.sentry then
		self.sentry.x, self.sentry.y = self.x, self.y
		self.sentry:update(dt)
		if self.sentry.hp > 0 then
			if self.hp < self._hp then
				self.sentry.hp = self.sentry.hp - (self._hp - self.hp)
			end
				self.hp = self._hp
		else
			self.sentry = nil
		end
	end

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
			if math.floor((((m.x-self.x)^2)+((m.y-self.y)^2))^.5) <= m.attraction and m.spawned then
				self.x = self.x + math.round(math.abs(math.cos(math.atan2((m.y-self.y),(m.x-self.x)))*m.attraction)/((m.x-self.x)),1)
				self.y = self.y + math.round(math.abs(math.sin(math.atan2((m.y-self.y),(m.x-self.x)))*m.attraction)/((m.y-self.y)),1)
			end
		end
	end
	if self.got then love.audio.rewind(state.sounds.collect);love.audio.play(state.sounds.collect) end
end
