crystal = {}
crystal.__index = crystal

function crystal.make(x,y)
	local c = {}
	setmetatable(c, crystal)
	c.x,c.y = x,y
	c._x,c._y = x,y
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

	if state.player.distance > math.max(state.player.members.a.attraction,state.player.members.b.attraction)/2 then
		local p = state.player:closest(self.x,self.y)
		local x,y = p.x,p.y
		if ((self.x-x)^2+(self.y-y)^2)^.5 <= p.a then
			local r = math.atan2(self.y-y, self.x-x)
			self.x = self.x - ((math.cos(r)*p.a/((self.x-x)^2+(self.y-y)^2)^.5))
			self.y = self.y - ((math.sin(r)*p.a/((self.x-x)^2+(self.y-y)^2)^.5))
		end
	end

	if self.got then love.audio.rewind(state.sounds.collect);love.audio.play(state.sounds.collect) end
end


--


health = {}
health.__index = health

function health.make(x,y)
	local c = {}
	setmetatable(c, health)
	c.x,c.y = x,y
	c.sound = res.load("sound","collect")
	c.got = false
	c.dead = false
	c.life = 1200
	c.r = 24
	c.intro = 0

	ring.make(x,y,180,.4,0,255,0,128)

	table.insert(state.drops,c)
end

function health:draw()
	love.graphics.setColor(255,255,255,255*(math.min(self.life,200)/200))
	if self.intro < 1 then
		love.graphics.setColor(255,255,255,self.intro*255)
	end
	love.graphics.draw(state.res.health,self.x,self.y,0,1+(1-self.intro),1+(1-self.intro),12,12)
end

function health:update(dt)
	if self.intro < 1 then self.intro = self.intro + .1 end
	if self.life > 0 then
		self.life = self.life - 1
	else
		self.dead = true
	end
	if self.got then love.audio.rewind(state.sounds.collect);love.audio.play(state.sounds.collect) end
end

function health:trigger(member)
	state.player:giveHealth(member,4)
	self.got = true
end