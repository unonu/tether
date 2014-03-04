------------------------------------------------------------------------------------------------------------------------------------------------------
-- Behold, before you lies the whirling infinite. Bits and pieces of half forgotten dreams. What is it: reality? Or is it simply wishfull thinking? --
--                         PARTICLES

particles = {}

cloud = {}
function cloud.make(x,y,r,g,b,a)
	local c = love.graphics.newParticleSystem(res.load("sprite","particle.png"),48)
	c:setPosition(x,y)
--	c:setGravity(0)
--	c:setSpread(math.pi*2)
--	c:stop()
	
	c:setEmissionRate(512)
	c:setSpeed(120, 80)
	c:setGravity(0,0)
--	c:setSize(1, 2)
	c:setColors(r or 255,g or 255,b or 255,a or 255)
--	c:setPosition(400, 300)
	c:setLifetime(16)
	c:setParticleLife(24)
	c:setDirection(0)
	c:setSpread(math.pi*2)
	c:setSpin(0,2)
	c:setRotation(0,math.pi*2)
	
	table.insert(particles, c)
end

sparks = {}
function sparks.make(x,y,r,g,b,a)
	local c = love.graphics.newParticleSystem(res.load("sprite","sparks.png"),24)
	c:setPosition(x,y)
--	c:setGravity(0)
--	c:setSpread(math.pi*2)
--	c:stop()
	
	c:setEmissionRate(12)
	c:setSpeed(120, 80)
	c:setGravity(0,0)
--	c:setSize(1, 2)
	c:setColors(r or 255,g or 255,b or 255,a or 255)
--	c:setPosition(400, 300)
	c:setLifetime(16)
	c:setParticleLife(24)
	c:setDirection(0)
	c:setSpread(math.pi*2)
	c:setSpin(0,6)
	c:setRotation(0,math.pi*2)
	
	table.insert(particles, c)
end
