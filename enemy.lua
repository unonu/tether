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
	
	for i,t in ipairs(state.tethers) do
		--[[if the distance between projection's x and y and the rock's x and y
		is less than the sum of their radii, then collision]]
		local proj = math.projection(t.x1,t.y1,self.x,self.y,t.x2,t.y2)
		local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
		if math.dist(self.x,self.y,projX,projY) <= self.r+t.width
			and self.x+self.r >= math.min(t.x1,t.x2) and self.y+self.r >= math.min(t.y1,t.y2)
			and self.x-self.r <= math.max(t.x1,t.x2) and self.y-self.r <= math.max(t.y1,t.y2) then
			self.hp = self.hp - t.strength
			sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
			screen:shake(.15, 4, false)
		end
	end

	if self.hp <= 0 then
		state.points = state.points + 1
	end
	if self.fire > 0 then self.fire = self.fire - 1 else self.fire = self.fireLimit end
	
	if self.fire == 0 then
		local closest = state.player:closest(self.x,self.y)
		local x,y = self.x,self.y
		bullet.make(x,y,math.atan2(y-closest.y,x-closest.x),6,0,'enemy')
	end
end

sentry = {}
sentry.__index = sentry

function sentry.make(x,y,p,s,h)
	local e = {}
	setmetatable(e,sentry)
	e.x,e.y = x,y
	e.r = 24
	e.rot = math.random(-math.pi,math.pi)
	e.orbit = 32
	e._hp = h or 128
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
	e.parent = p or 1
	e.s = s or 1
	e.r = e.r*e.s

	e.birth = 0
	e.intro = 0
	
	return e
end

function sentry:draw(rockRot,a)
	if self.shield ~= self._shield then
		love.graphics.setColor(255,255,255,math.min(a,math.random(0,128)))
		self._shield = self.shield
	elseif self.birth > 1 and self.birth < 2 then
		love.graphics.setColor(255,0,0,255*(1-self.birth))
	else
		love.graphics.setColor(255,0,0,math.min(a,math.random(128,164))*self.shield)
	end
	if self.birth > 1 then
		love.graphics.circle("fill",self.x,self.y,34*self.s,36)
			love.graphics.setColor(0,0,0,math.min(a,128))
	end
	love.graphics.setLineWidth(4*self.s)
	love.graphics.curve(self.x,self.y,32*self.s,0,math.pi*self.intro,36)
		love.graphics.setColor(255,255,255,a)
	local sf = math.min(1,self.birth)*self.s
	love.graphics.draw(self.image,res.quads["sentry1"],self.x,self.y,rockRot,-1*sf,1*sf,17,17)
	love.graphics.draw(self.image,res.quads["sentry2"],self.x,self.y,self.rot-math.pi,-1*sf,1*sf,12,8)
end

function sentry:update(dt,shoot)
	if self.birth < 1 then self.birth = math.min(1,self.birth + .02) 
	elseif self.intro < 2 then self.intro = math.min(2,self.intro + .04)
	elseif self.birth < self.intro then self.birth = math.min(self.intro,self.birth + .02) end

	if not shoot then
	if self.fire > 0 then self.fire = self.fire - 1 else self.fire = self.fireLimit end
	
	if self.fire == 0 then
		-- local closest = state.player:closest(self.x,self.y)
		-- bullet.make(self.x,self.y,math.atan2(self.y-closest.y,self.x-closest.x),4,30,"sentry")
		bullet.make(self.x,self.y,self.rot,4,30,"sentry")
	end
	end

	if self.parent > 0 then
		for i,t in ipairs(state.tethers) do
			--[[if the distance between projection's x and y and the rock's x and y
			is less than the sum of their radii, then collision]]
			local proj = math.projection(t.x1,t.y1,self.x,self.y,t.x2,t.y2)
			local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
			if math.dist(self.x,self.y,projX,projY) <= self.r+t.width
				and self.x+self.r >= math.min(t.x1,t.x2) and self.y+self.r >= math.min(t.y1,t.y2)
				and self.x-self.r <= math.max(t.x1,t.x2) and self.y-self.r <= math.max(t.y1,t.y2) then
				self.hp = self.hp - t.strength
				sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
				screen:shake(.15, 4, false)
			end
		end
	end

	self.shield = self.hp/self._hp

	if self.hp <= 0 then
		state.points = state.points + 1
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

function dash:update(dt)
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

	for i,t in ipairs(state.tethers) do
		--[[if the distance between projection's x and y and the rock's x and y
		is less than the sum of their radii, then collision]]
		local proj = math.projection(t.x1,t.y1,self.x,self.y,t.x2,t.y2)
		local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
		if math.dist(self.x,self.y,projX,projY) <= self.r+t.width
			and self.x+self.r >= math.min(t.x1,t.x2) and self.y+self.r >= math.min(t.y1,t.y2)
			and self.x-self.r <= math.max(t.x1,t.x2) and self.y-self.r <= math.max(t.y1,t.y2) then
			self.hp = self.hp - t.strength
			sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
			screen:shake(.15, 4, false)
		end
	end
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
	k.x = 0
	k.y = 0
	-- k.x_vol
	-- k.y_vol
	-- k.prime
	-- k.cooldown

	return k
end

function keeper:draw()
	love.graphics.circle("fill",self.x,self.y,50,16)
end

function keeper:update(dt)
	for i,t in ipairs(state.tethers) do
		--[[if the distance between projection's x and y and the rock's x and y
		is less than the sum of their radii, then collision]]
		local proj = math.projection(t.x1,t.y1,self.x,self.y,t.x2,t.y2)
		local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
		if math.dist(self.x,self.y,projX,projY) <= self.r+t.width
			and self.x+self.r >= math.min(t.x1,t.x2) and self.y+self.r >= math.min(t.y1,t.y2)
			and self.x-self.r <= math.max(t.x1,t.x2) and self.y-self.r <= math.max(t.y1,t.y2) then
			self.hp = self.hp - t.strength
			sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
			screen:shake(.15, 4, false)
		end
	end
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

sentinel = {}
sentinel.__index = sentinel

function sentinel.make()
	local s = {}
	setmetatable(s,sentinel)
	s.core = nil
	s.rot = 0
	s.rotSpeed = 1
	s.rotDir = 1
	s.x,s.y = unpack(screen:getCentre())
	s.dir = 1
	s.members = {}
	s.arms = {}
	s.hp = 256
	s.drop = false
	s.kill = false
	s.r = 12
	s.invincible = true

	s.timers = {intro = 0,
				arm1Intro = 0,
				arm2Intro = 0,
				arm3Intro = 0,
				arm4Intro = 0,
				measure = 4,
				stage = 1,
				t = 0}
	state.cinematic = true

	return s
end

function sentinel:draw()
	for i,a in ipairs(self.arms) do
		for ii,m in ipairs(a) do
			if m[1] then 
				m[1]:draw(0,255)
			end
		end
	end

	if self.core then
		self.core:draw(0,255)
	end
end

function sentinel:update(dt)
	--intro animations
	if self.timers.intro < 600 then
		self.invincible = true
		if self.timers.intro == 0 then
			self.core = sentry.make(self.x,self.y,-1,3,4096)
			self.core.fireLimit = 100
			self.core.image = res.load("sprite","sentinel.png")
			self.core.draw = function (self,rockrot,a) 
				if self.shield ~= self._shield then
					love.graphics.setColor(255,255,255,math.min(a,math.random(0,128)))
					self._shield = self.shield
				elseif self.birth > 1 and self.birth < 2 then
					love.graphics.setColor(255,0,0,255*(1-self.birth))
				else
					love.graphics.setColor(255,0,0,math.min(a,math.random(128,164))*self.shield)
				end
				if self.birth > 1 then
					love.graphics.circle("fill",self.x,self.y,34*self.s,36)
						love.graphics.setColor(0,0,0,math.min(a,128))
				end
				love.graphics.setLineWidth(4*self.s)
				love.graphics.curve(self.x,self.y,32*self.s,0,math.pi*self.intro,36)
					love.graphics.setColor(255,255,255,a)
				local sf = math.min(1,self.birth)
				love.graphics.draw(self.image,res.quads["sentinel1"],self.x,self.y,rockRot,-1*sf,1*sf,50,51)
				love.graphics.draw(self.image,res.quads["sentinel2"],self.x,self.y,self.rot-math.pi,-1*sf,1*sf,39,24)
			end
		end
		if self.timers.intro == 100 then
			if self.core.hp == self.core._hp then
				self.arms[1] = {}
				self.arms[2] = {}
				self.arms[3] = {}
				self.arms[4] = {}
				print("a")
				table.insert(self.arms[1],{sentry.make(self.x,self.y,-1,1,1024),128,1})
				table.insert(self.arms[2],{sentry.make(self.x,self.y,-1,1,1024),128,2})
				table.insert(self.arms[3],{sentry.make(self.x,self.y,-1,1,1024),128,3})
				table.insert(self.arms[4],{sentry.make(self.x,self.y,-1,1,1024),128,4})
			end
		elseif self.timers.intro > 100 and self.timers.arm1Intro < 1 then
			self.timers.arm1Intro = self.timers.arm1Intro + .01
		end
		if self.timers.intro > 200 and self.timers.arm2Intro < 1 then
			self.timers.arm2Intro = self.timers.arm2Intro + .01
		end
		if self.timers.intro > 300 and self.timers.arm3Intro < 1 then
			self.timers.arm3Intro = self.timers.arm3Intro + .01
		end
		if self.timers.intro > 400 and self.timers.arm4Intro < 1 then
			self.timers.arm4Intro = self.timers.arm4Intro + .01
		end
		self.timers.intro = self.timers.intro+1
	else
		self.invincible = false
		state.cinematic = false
		state.grabPlayer = false

		--rotation
		if math.random(1,3000/self.timers.stage) == 1 then
			self.rotDir = -self.rotDir
		end
		self.rot = self.rot + (math.pi/256)*self.rotSpeed*self.rotDir

		if self.core.hp < self.core._hp*2/3 and self.timers.stage == 1 and #self.arms == 0 then
			for i=1,4 do
				self.arms[i] = {}
				self.timers["arm"..i.."Intro"] = 0
				table.insert(self.arms[i],{sentry.make(self.x,self.y,-1,1,1024),128,i})
				table.insert(self.arms[i],{sentry.make(self.x,self.y,-1,1,768),176,i})
			end
				self.timers.intro = 100
				self.timers.stage = 2
				self.rotSpeed = 1.3
				self.core.fireLimit = 50
		elseif self.core.hp < self.core._hp*1/3 and self.timers.stage == 2 and #self.arms == 0 then
			for i=1,4 do
				self.arms[i] = {}
				self.timers["arm"..i.."Intro"] = 0
				table.insert(self.arms[i],{sentry.make(self.x,self.y,-1,1,1024),128,i})
				table.insert(self.arms[i],{sentry.make(self.x,self.y,-1,1,768),176,i})
				table.insert(self.arms[i],{sentry.make(self.x,self.y,-1,1,512),224,i})
			end
				self.timers.intro = 100
				self.timers.stage = 3
				self.rotSpeed = 1.6
				self.core.fireLimit = 25
		end

	end

	if self.core then
		self.hp = self.core.hp
	end

	--spacing
	if #self.arms < self.timers.measure then
		self.timers.measure = math.max(self.timers.measure-(.02),#self.arms)
	elseif #self.arms > self.timers.measure then
		self.timers.measure = math.min(self.timers.measure+(.02),#self.arms)
	end
	------------------------------------------------------------------
	------------------------------------------------------------------
	if self.core then
		self.core.x,self.core.y = self.x,self.y
		self.core:update(dt,(#self.arms ~= 0))
		if #self.arms == 0 then
			for i,t in ipairs(state.tethers) do
				--[[if the distance between projection's x and y and the rock's x and y
				is less than the sum of their radii, then collision]]
				local proj = math.projection(t.x1,t.y1,self.core.x,self.core.y,t.x2,t.y2)
				local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
				if math.dist(self.core.x,self.core.y,projX,projY) <= self.core.r+t.width
					and self.core.x+self.core.r >= math.min(t.x1,t.x2) and self.core.y+self.core.r >= math.min(t.y1,t.y2)
					and self.core.x-self.core.r <= math.max(t.x1,t.x2) and self.core.y-self.core.r <= math.max(t.y1,t.y2) then
					self.core.hp = math.floor(self.core.hp - t.strength)
					sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
					screen:shake(.15, 5, false)
				end
			end
		end
	end
	for i,a in ipairs(self.arms) do
	if self.timers.intro > i*100 then
		for ii,m in ipairs(a) do
			m[1].x = self.x+m[2]*math.cos(self.rot+(m[3])*math.pi/2)*self.timers["arm"..i.."Intro"]
			m[1].y = self.y+m[2]*math.sin(self.rot+(m[3])*math.pi/2)*self.timers["arm"..i.."Intro"]

			m[1]:update(dt,(self.timers.intro < 600))
			if ii == #a and not self.invincible then
				for iii,t in ipairs(state.tethers) do
					--[[if the distance between projection's x and y and the rock's x and y
					is less than the sum of their radii, then collision]]
					local proj = math.projection(t.x1,t.y1,m[1].x,m[1].y,t.x2,t.y2)
					local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
					if math.dist(m[1].x,m[1].y,projX,projY) <= m[1].r+t.width
						and m[1].x+m[1].r >= math.min(t.x1,t.x2) and m[1].y+m[1].r >= math.min(t.y1,t.y2)
						and m[1].x-m[1].r <= math.max(t.x1,t.x2) and m[1].y-m[1].r <= math.max(t.y1,t.y2) then
						m[1].hp = m[1].hp - t.strength*2
						sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
						screen:shake(.15, 2, false)
					end
				end
			end
			if m[1].hp <= 0 then
				self.rotDir = -self.rotDir
				table.remove(a,ii)
			end
		end
		if #a == 0 then
			table.remove(self.arms,i)
		end
	end
	end


	if #self.arms == 0 and self.timers.intro > 100 then
		self.timers.t = self.timers.t+(.01*self.dir)
		if self.timers.t > 1 or self.timers.t < -1 then self.dir = -self.dir end
		--
		self.x = screen:getCentre('x') + self.timers.t*512
		self.y = screen:getCentre('y') + math.sin(math.pi*self.timers.t*self.dir)*self.timers.stage*64
	else
		if self.x ~= screen:getCentre('x') then
			self.x = math.floor(self.x+(screen:getCentre('x')-self.x)/12)
		end
		if self.y ~= screen:getCentre('y') then
			self.y = math.floor(self.y+(screen:getCentre('y')-self.y)/12)
		end
		self.timers.t = 0
	end
end

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
			bullet.make(self.x,self.y,math.atan2(self.y-state.player:closest(self.x,self.y).y,self.x-state.player:closest(self.x,self.y).x),4,4,'enemy')
		end
		self.timers.fire = self.timers.fire - 1
--	else
--		self.fire =
	end

	for i,t in ipairs(state.tethers) do
		--[[if the distance between projection's x and y and the rock's x and y
		is less than the sum of their radii, then collision]]
		local proj = math.projection(t.x1,t.y1,self.x,self.y,t.x2,t.y2)
		local projX, projY = t.x1+math.cos(t.angle)*proj,t.y1+math.sin(t.angle)*proj
		if math.dist(self.x,self.y,projX,projY) <= self.r+t.width
			and self.x+self.r >= math.min(t.x1,t.x2) and self.y+self.r >= math.min(t.y1,t.y2)
			and self.x-self.r <= math.max(t.x1,t.x2) and self.y-self.r <= math.max(t.y1,t.y2) then
			self.hp = self.hp - t.strength
			sparks.make(projX, projY, math.random(130, 140), math.random(230, 240), 255, 255*(t.strength/6))
			screen:shake(.15, 4, false)
		end
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

