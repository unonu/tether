enemy = {}
enemy.__index = enemy

function enemy.make()
	local e = {}
	setmetatable(e,enemy)
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
	e.dist = math.random(192,256)

	e.image = res.load("sprite","enemy.png")

	e.class = 'drone'
	e.drop = true
	e.speed = math.random(1,3)*192
	e.dir = math.rsign()
	e.hp = 2
	e.kill = false
	e.fireLimit = 200
	e.fire = e.fireLimit
	
	return e
end

function enemy:draw()
	local rot = math.atan2(self.y-state.players[1]:closest(self.x,self.y).y,self.x-state.players[1]:closest(self.x,self.y).x)
	love.graphics.draw(self.image,self.x,self.y,rot-(math.pi/2),1,1,24,24)
end

function enemy:update(dt)
	if self.x < 0 or self.y < 64 or self.x > screen.width or self.y > screen.height then
		self.dir = -self.dir
	end
	self.r = self.r-math.min(0-(math.pi/self.speed),0)*self.dir
	if self._x < state.players[1]:closest(self.x,self.y).x then
		self._x = self._x+1
	end
	if self._x > state.players[1]:closest(self.x,self.y).x then
		self._x = self._x-1
	end
	if self._y < state.players[1]:closest(self.x,self.y).y then
		self._y = self._y+1
	end
	if self._y > state.players[1]:closest(self.x,self.y).y then
		self._y = self._y-1
	end
	
	self.x = self._x + (math.cos(self.r)*self.dist)
	self.y = self._y + (math.sin(self.r)*self.dist)
	
	if self.hp <= 0 then
		state.points = state.points + 1
	end
	if self.fire > 0 then self.fire = self.fire - 1 else self.fire = self.fireLimit end
	
	if self.fire == 0 then
		bullet.make(self.x,self.y,math.atan2(self.y-state.players[1]:closest(self.x,self.y).y,self.x-state.players[1]:closest(self.x,self.y).x),4,'enemy')
	end
end

sentry = {}
sentry.__index = sentry

function sentry.make(x,y)
	local e = {}
	setmetatable(e,sentry)
	e.x,e.y = x,y
	e.r = 8
	e.rot = 0
	e.hp = 12
	e.dir = math.rsign()
	e.fireLimit = 256
	e.fire = e.fireLimit
	e.drop = false
	e.class = 'sentry'
	e.image = res.load("sprite","sentry.png")
	
	return e
end

function sentry:draw()
	love.graphics.draw(self.image,self.x+math.cos(self.rot)*32,self.y+math.sin(self.rot)*32,self.rot-math.pi,-1,1,12,12)
end

function sentry:update(dt)
	self.rot = self.rot + (math.pi/128)*self.dir
--	screen:shake(.15,4,false)
	if self.hp <= 0 then
		state.points = state.points + 1
	end
	if self.fire > 0 then self.fire = self.fire - 1 else self.fire = self.fireLimit end
	
	if self.fire == 0 then
		bullet.make(self.x+math.cos(self.rot)*24,self.y+math.sin(self.rot)*24,math.atan2(self.y-state.players[1]:closest(self.x,self.y).y,self.x-state.players[1]:closest(self.x,self.y).x),4,'enemy')
	end
end

dash = {}
dash.__index = dash

function dash.make()
	local d = {}
	setmetatable(d,dash)

	if math.random(0,1) == 0 then
		local x = math.random(0,1)*screen.width
		d.x,d.y = x-(512*math.sign(1-x)),math.random(0,screen.height)
	else
		local y = math.random(0,1)*screen.height
		d.x,d.y = math.random(0,screen.width),y-(512*math.sign(1-y))
	end

	d.r = math.random(0,2)*math.pi
	d.timer = 200

	return d
end

function dash:update( dt )
	if self.timer > 75 then
		self.r = math.loop(0,self.r+(math.pi/128),2)
	if self.timer < 50 then
		self.x = self.x + math.cos(self.r)*4
		self.y = self.y + math.sin(self.t)*4
	end
	if self.timer < 0 then self.timer = 200 end

	self.timer = self.timer-1
end

function dash:draw()
	love.graphics.arc("fill",self.x,self.y,24,self.r-(math.pi/12),self.r+(math.pi/12),2)
end

--------------------------------------------------------------
-- BOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSSBOSS --
--------------------------------------------------------------

torrent = {}
torrent.__index = torrent

function torrent.make(x,y,hp)
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
	t._hp = hp
	t.x_vol = 0
	t.y_vol = 0
	t.forces = {{2,math.random(0,3.13)}}
	t.timers = {}
		t.timers.moves = 3
		t.timers.cooldown = 0
		t.timers.pause = 100
		t.timers.fire = 32
	
	return t
end

function torrent:draw()
		love.graphics.setColor(255,0,0)
	love.graphics.circle('fill',self.x,self.y,48,6)
	if self.hp ~= self._hp then
		love.graphics.setColor(255,255,255,255)
		self._hp = self.hp
	else
		love.graphics.setColor(0,255,12)
	end
	love.graphics.circle('fill',self.x,self.y,48*(self.hp/self.stats.hp),6)
end

function torrent:update(dt)
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
			bullet.make(self.x,self.y,math.atan2(self.y-state.players[1]:closest(self.x,self.y).y,self.x-state.players[1]:closest(self.x,self.y).x),4,'enemy')
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
end

