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

	wave.make(x,y,180,.4,0,255,0,128)

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