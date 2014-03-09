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
		c:setColors(r,g,b,a,math.clamp(0,r-24,255),math.clamp(0,g-24,255),math.clamp(0,b-24,255),math.clamp(0,a-24,255),math.clamp(0,r+24,255),math.clamp(0,g+24,255),math.clamp(0,b+24,255),math.clamp(0,a-24,255))
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
