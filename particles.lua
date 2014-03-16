------------------------------------------------------------------------------------------------------------------------------------------------------
-- Behold, before you lies the whirling infinite. Bits and pieces of half forgotten dreams. What is it? Reality? Or is it simply wishfull thinking? --
--                         PARTICLES

particles = {}

cloud = {}
function cloud.make(x,y,r,g,b,a)
	local c = love.graphics.newParticleSystem(res.load("sprite","particle.png"),40)
		c:setColors(r,g,b,a,math.clamp(0,r+24,0),math.clamp(0,g+24,0),math.clamp(0,b+24,0),0)
		c:setEmitterLifetime(5)
		c:setParticleLifetime(5)
		c:setEmissionRate(80)
		c:setSpeed(128,128)
		c:setRadialAcceleration(-24,-8,-24,8)
		c:setDirection(0)
		c:setAreaSpread("uniform",2,2) --set to radius of object
		c:setSpread(2*math.pi) --raidans
		c:setSpin(-math.pi,-math.pi,0)
		c:setPosition(x,y)
		c:setSizes(1,0)
		c:stop()
	
	table.insert(particles, c)
end

sparks = {}
function sparks.make(x,y,r,g,b,a)
	local c = love.graphics.newParticleSystem(res.load("sprite","spark.png"),40)
		c:setColors(r,g,b,a,math.clamp(0,r-24,255),math.clamp(0,g-24,255),math.clamp(0,b-24,255),
			math.clamp(0,a-24,255),math.clamp(0,r+24,255),math.clamp(0,g+24,255),math.clamp(0,b+24,255),math.clamp(0,a-24,255))
		c:setEmitterLifetime(.5)
		c:setParticleLifetime(.5)
		c:setEmissionRate(10)
		c:setSpeed(128,128)
		c:setRadialAcceleration(-24,-8,-24,8)
		c:setDirection(0)
		c:setAreaSpread("uniform",2,2) --set to radius of object
		c:setSpread(2*math.pi) --raidans
		c:setSpin(-math.pi,-math.pi,0)
		c:setPosition(x,y)
		c:setSizes(1,0)
		c:stop()
	
	table.insert(particles, c)
end

shimmer = {}
function shimmer.make(x,y,d,r,g,b,a)
	local c = love.graphics.newParticleSystem(res.load("sprite","sparkle.png"),10)
		c:setColors(r or 255, g or 255, b or 128, a or 255, r or 255, g or 255, b or 255, 0)
		c:setEmitterLifetime(4)
		c:setParticleLifetime(4)
		c:setEmissionRate(10)
		c:setSpeed(28,32)
		-- c:setRadialAcceleration(-24,-8,-24,8)
		-- c:setLinearAcceleration(math.cos(d),math.sin(d))
		c:setDirection(-math.pi/2)
		c:setAreaSpread("uniform",12,12) --set to radius of object
		c:setSpread(math.pi/3) --raidans
		c:setSpin(0,0,math.pi/4,math.pi/4,math.pi/4)
		c:setPosition(x,y)
		c:setSizes(1,1,0)
		c:stop()
	
	table.insert(particles, c)
end

residue = {}
function residue.make(x,y,l,t,r,g,b,a)
	local c = love.graphics.newParticleSystem(res.load("sprite","sparkle.png"),10)
		c:setColors(r or 255, g or 255, b or 128, a or 255, r or 255, g or 255, b or 255, 0)
		c:setEmitterLifetime(4)
		c:setParticleLifetime(4)
		c:setEmissionRate(10)
		c:setSpeed(28,32)
		-- c:setRadialAcceleration(-24,-8,-24,8)
		-- c:setLinearAcceleration(math.cos(d),math.sin(d))
		c:setDirection(t)
		c:setAreaSpread("uniform",l,l) --set to radius of object
		c:setSpread(math.pi/3) --raidans
		c:setSpin(0,0,math.pi/4,math.pi/4,math.pi/4)
		c:setPosition(x,y)
		c:setSizes(1,1,0)
		c:stop()
	
	table.insert(particles, c)
end

wave = {}
wave.__index = wave
function wave.make(x,y,l,s,r,g,b,a)
	local w = {}
	setmetatable(w,wave)
	w.x,w.y = x,y
	w._life = l or -1
	w.life = l or -1
	w.speed = s or 1
	w.scale = 0
	w.r = 0
	w.d = math.rsign()
	w.isActive = function (self) return self.life > 0 end
	w.color = {r or 255,g or 255,b or 255,a or 255}
	w.image = res.load("sprite","wave.png")
	wave.draw = function (self)
		love.graphics.setColor(self.color[1],self.color[2],self.color[3],(self.color[4]*self.life/self._life));
		 love.graphics.draw(self.image,self.x,self.y,self.r,self.scale,self.scale,64,64) end
	wave.update = function (self,dt) self.scale = self.scale + .1*self.speed;
		self.r = self.r + self.d*math.pi/(32*s); self.life = self.life - 1 end
	wave.start = function (self) end
 
	table.insert(particles,w)
end