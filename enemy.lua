drone = {}
drone.__index = drone

function drone.make()
	local e = {}
	setmetatable(e,drone)
	if math.random(0,1) == 0 then
		local x = math.random(0,1)*screen.width
		e.x,e.y = x-(512*math.sign(1-x)),math.random(0,screen.height)
	else
		local y = math.random(0,1)*screen.height
		e.x,e.y = math.random(0,screen.width),y-(512*math.sign(1-y))
	end
	e._x = e.x-math.random(0,128)
	e._y = e.y-math.random(0,128)
	e.r = math.pi
	e.orbit = math.random(192,256)

	e.image = res.load("sprite","drone.png")

	e.class = 'drone'
	e.drop = true
	e.speed = (math.random()+1)*128
	e.dir = math.rsign()
	e.hp = 2
	e.kill = false
	e.collideable = false
	e.fireLimit = math.random(60,200)
	e.fire = e.fireLimit
	
	return e
end

function drone:draw()
	love.graphics.setColor(255,0,0)
	local rot = math.atan2(self.y-state.player:closest(self.x,self.y).y,self.x-state.player:closest(self.x,self.y).x)
	love.graphics.draw(self.image,self.x,self.y,rot-(math.pi/2),1,1,24,24)
end

function drone:update(dt)
	if self.x < 0 or self.y < 64 or self.x > screen.width or self.y > screen.height then
		self.dir = -self.dir
	end
	self.r = self.r-math.min(0-(math.pi/self.speed),0)*self.dir
	if self._x < state.player:closest(self.x,self.y).x then
		self._x = self._x+1
	end
	if self._x > state.player:closest(self.x,self.y).x then
		self._x = self._x-1
	end
	if self._y < state.player:closest(self.x,self.y).y then
		self._y = self._y+1
	end
	if self._y > state.player:closest(self.x,self.y).y then
		self._y = self._y-1
	end
	
	self.x = self._x + (math.cos(self.r)*self.orbit)
	self.y = self._y + (math.sin(self.r)*self.orbit)
	
	if self.hp <= 0 then
		state.points = state.points + 1
	end
	if self.fire > 0 then self.fire = self.fire - 1 else self.fire = self.fireLimit end
	
	if self.fire == 0 then
		local closest = state.player:closest(self.x,self.y)
		local x,y = self.x,self.y
		bullet.make(x,y,math.atan2(y-closest.y,x-closest.x),6,'enemy')
	end
end

sentry = {}
sentry.__index = sentry

function sentry.make(x,y)
	local e = {}
	setmetatable(e,sentry)
	e.x,e.y = x,y
	e.r = 24
	e.rot = math.random(-math.pi,math.pi)
	e.orbit = 32
	e._hp = 86
	e.hp = e._hp
	e.dir = math.rsign()
	e.fireLimit = 320
	e.fire = math.random(80,e.fireLimit)
	e.drop = false
	e.collideable = false
	e.class = 'sentry'
	e.image = res.load("sprite","sentry.png")
	e.shield = 1
	e._shield = 1
	
	return e
end

function sentry:draw(rockRot,a)
	if self.shield ~= self._shield then
		love.graphics.setColor(255,255,255,math.min(a,math.random(0,128)))
		self._shield = self.shield
	else
		love.graphics.setColor(255,0,0,math.min(a,math.random(128,164))*self.shield)
	end
	love.graphics.circle("fill",self.x,self.y,34,36)
		love.graphics.setColor(0,0,0,math.min(a,128))
	love.graphics.circle("line",self.x,self.y,32,36)
		love.graphics.setColor(255,255,255,a)
	love.graphics.draw(self.image,res.quads["sentry1"],self.x,self.y,rockRot,-1,1,17,17)
		-- love.graphics.setColor(255,0,0,a)
	love.graphics.draw(self.image,res.quads["sentry2"],self.x,self.y,self.rot-math.pi,-1,1,12,8)
end

function sentry:update(dt)
	if self.hp <= 0 then
		state.points = state.points + 1
	end

	self.shield = self.hp/self._hp

	if self.fire > 0 then self.fire = self.fire - 1 else self.fire = self.fireLimit end
	
	if self.fire == 0 then
		local closest = state.player:closest(self.x,self.y)
		local x,y = self.x+math.cos(self.rot)*self.orbit,self.y+math.sin(self.rot)*self.orbit
		bullet.make(x,y,math.atan2(y-closest.y,x-closest.x),4,'enemy')
	end
	self.rot = self.rot + (math.pi/128)*self.dir
end

dash = {}
dash.__index = dash

function dash.make()
	local e = {}
	setmetatable(e,dash)

	if math.random(0,1) == 0 then
		local x = math.random(0,1)*screen.width
		e.x,e.y = x-(512*math.sign(1-x)),math.random(0,screen.height)
	else
		local y = math.random(0,1)*screen.height
		e.x,e.y = math.random(0,screen.width),y-(512*math.sign(1-y))
	end

	e.r = math.random(0,2)*math.pi
	e.timer = 16
	e.locked = false
	e.r = 16
	e.rot = 0
	e.hp = 2
	e.dir = math.rsign()
	e.fireLimit = 256
	e.fire = e.fireLimit
	e.drop = true
	e.bounty = math.random(8,12)
	e.class = 'dash'
	e.image = res.load("sprite","dash.png")
	e.grad = res.load("image","healthbar.png")
	e.aimgle = math.pi/2
	e.v = 0
	e.collideable = true
	e.damage = 4

	return e
end

function dash:update( dt )
	--
	-- print(self.r,self.x,self.y)
	if not self.locked then
		self.r = math.round(math.loop(-math.pi,self.r-(math.pi/256),math.pi),2)
	end
	if math.round(math.atan2(self.y-state.player:closest(self.x,self.y).y,
		self.x-state.player:closest(self.x,self.y).x),1) >= math.loop(-math.pi,self.r-(math.pi/48),math.pi)
	and math.round(math.atan2(self.y-state.player:closest(self.x,self.y).y,
		self.x-state.player:closest(self.x,self.y).x),1) <= math.loop(-math.pi,self.r+(math.pi/48),math.pi) then
		self.locked = true
	end
	if self.locked then
		if self.v == 0 then self.timer = self.timer -1 end
		if self.timer < 0 then
			self.timer = 16
			self.v = 32
		end
		if self.v > 0 then
			self.x = self.x - math.cos(self.r)*self.v
			self.y = self.y - math.sin(self.r)*self.v
			self.v = self.v-1
			if self.v == 0 then
				self.locked = false
				self.aimgle = math.pi/2
			end
		end
		if self.aimgle > 0 then self.aimgle= self.aimgle-(math.pi/24) end
	end
	-- for i,r in ipairs(state.rocks) do
	-- 	if self.x >= r.x-r.r and self.x <= r.x+r.r and self.y >= r.y-r.r and self.y <= r.y+r.r then
	-- 		r.hp = 0
	-- 	end
	-- end
end

function dash:draw()
	if self.locked then
		love.graphics.setColor(255,255,255,32)
		love.graphics.arc("fill",self.x,self.y,-600,self.r-self.aimgle,self.r+self.aimgle,6)
		love.graphics.setColor(255,0,0)
		love.graphics.draw(self.grad,self.x,self.y,self.r+self.aimgle+math.pi/2,4,32,0)
		love.graphics.draw(self.grad,self.x,self.y,self.r-self.aimgle+math.pi/2,4,32,1)
		
	else
		love.graphics.setColor(255,255,255,32)
		love.graphics.arc("fill",self.x,self.y,-600,self.r-(math.pi/48),self.r+(math.pi/48),6)
	end
	love.graphics.setColor(255,0,0)
	love.graphics.draw(self.image,self.x,self.y,self.r-math.pi/2,1,1,10,24)
end

keeper = {}
keeper.__index = keeper

function keeper.make()
	local k = {}
	setmetatable(k,keeper)
	-- k.x
	-- k.y
	-- k.x_vol
	-- k.y_vol
	-- k.prime
	-- k.cooldown

	return k
end

function keeper:draw()
	love.graphics.draw()
end

function keeper:update(dt)

end

quirk = {}
lec = {}
rockling = {}
dap = {}
clone = {}
undead = {}

--------------------------------------------------------------
-- BOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSS --
--------------------------------------------------------------

torrent = {}
torrent.__index = torrent

function torrent.make(x,y,hp,intro)
	local t = {}
	setmetatable(t,torrent)
	t.x = x
	t.y = y
	t.r = 8+(hp*.2)
	t.class = 'torrent'
	t.shield = 100
	t.primed = false
	t.drop = true
	t.stats = {}
	t.stats.hp = hp
	t.hp = hp
	t.bounty = 201
	t.collideable = false
	t._hp = hp
	t.x_vol = 0
	t.y_vol = 0
	t.forces = {{2,math.random(0,3.13)}}
	t.timers = {}
		t.timers.moves = 3
		t.timers.cooldown = 0
		t.timers.pause = 100
		t.timers.fire = 0
		t.timers.intro = math.floor((screen.height/2)+(2*t.r))
	t.intro = intro or false
	
	return t
end

function torrent:draw()
if self.timers.intro == 0 then
		love.graphics.setColor(255,0,0)
	love.graphics.circle('fill',self.x,self.y,48,6)
	if self.hp ~= self._hp then
		love.graphics.setColor(255,255,255,255)
		self._hp = self.hp
	else
		love.graphics.setColor(0,255,12)
	end
	love.graphics.circle('fill',self.x,self.y,48*(self.hp/self.stats.hp),6)
else
		love.graphics.setColor(255,0,0)
	love.graphics.circle('fill',self.x,(screen.height/2)-self.timers.intro,48,6)
	if self.hp ~= self._hp then
		love.graphics.setColor(255,255,255,255)
		self._hp = self.hp
	else
		love.graphics.setColor(0,255,12)
	end
	love.graphics.circle('fill',(screen.height/2)-self.x,self.timers.intro,48*(self.hp/self.stats.hp),6)
end
end

function torrent:update(dt)
if self.timers.intro == 0 then
	self.r = 8+(self.hp*.2)
	if self.timers.cooldown <= 0 then
		self.timers.pause = self.timers.pause-1
--		print('a')
	else
		self.timers.cooldown = self.timers.cooldown -1
--		print('b',self.timers.cooldown)
		if self.timers.moves == 0 then self.timers.moves = math.random(3,5) end
	end
	-----------------------------
	if self.timers.pause <= 0 and self.timers.cooldown <= 0 then
		self.timers.pause = 100*(self.hp/self.stats.hp)
		table.insert(self.forces,{math.random(96,128),math.random(0,3.13)})
		self.timers.moves = self.timers.moves - 1
--		print('c')
		self.timers.fire = math.random(32,48)
	end
	if self.timers.moves == 0 and self.timers.cooldown == 0 then
		self.timers.cooldown = math.floor(150+((self.hp/self.stats.hp)*100))
--		print('d')
	end
	if self.timers.pause > 0 and self.timers.fire > 0 then
		if math.fmod(self.timers.fire,4) == 0 then
			bullet.make(self.x,self.y,math.atan2(self.y-state.player:closest(self.x,self.y).y,self.x-state.player:closest(self.x,self.y).x),4,'enemy')
		end
		self.timers.fire = self.timers.fire - 1
--	else
--		self.fire =
	end
	-----------------------------
	-----------------------------
		if self.x < 0 then table.insert(self.forces,{-self.x,0}) end
		if self.x > screen.width then table.insert(self.forces,{screen.width-self.x,0}) end
		if self.y < 64 then table.insert(self.forces,{64-self.y,math.pi/2}) end
		if self.y > screen.height then table.insert(self.forces,{screen.height-self.y,math.pi/2}) end
	for i,f in ipairs(self.forces) do self.x_vol = self.x_vol + math.cos(f[2])*f[1] end
	for i,f in ipairs(self.forces) do self.y_vol = self.y_vol + math.sin(f[2])*f[1] end
--	print(self.x_vol,self.y_vol)
	self.x = self.x + self.x_vol
	self.y = self.y + self.y_vol
	if self.x_vol ~= 0 then self.x_vol = math.round(self.x_vol - (self.x_vol*.2),2) end
	if self.y_vol ~= 0 then self.y_vol = math.round(self.y_vol - (self.y_vol*.2),2) end
	self.forces = {}
else
	self.timers.intro = self.timers.intro - 1
	if self.timers.intro == 0 then state.grabPlayer = false end
end
end

