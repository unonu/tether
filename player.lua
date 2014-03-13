player = {}
player.__index = player

function player.make(number)
	local p = {}
	setmetatable(p, player)
	p.x, p.y = screen:getCentre('x'), screen:getCentre('y')
	p.number = number
	p.members = {}
		p.members.a = {
			name = 'a', 
			other = 'b', 
			x = screen:getCentre('x')/2, 
			y = screen:getCentre('y'), 
			x_vol = 0, 
			y_vol = 0, 
			rot = 0, 
			forces = {}, 
			speed = 1.5, 
			_points = 0, 
			points = 0, 
			stats = {hp = 16,  deaths = 0}, 
			hp = 16, 
			_hp = 16,
			immunity = 0, 
			lives = 3,
			_lives = 3, 
			spawned = true, 
			tether = false, 
			perks = {}, 
			attraction = 100, 
			target = {rot = 0,  scale = 1}, 
			lapse = 0, 
			color = {100, 255, 100}, 
			keys = {up = 'w',  down = 's',  left = 'a',  right = 'd',  tether = 'lshift'}, 
			timers = {spawn = 0, 
						hp = 0}, 
		}
		p.members.b = {
			name = 'b', 
			other = 'a', 
			x = screen:getCentre('x')*1.5, 
			y = screen:getCentre('y'), 
			x_vol = 0, 
			y_vol = 0, 
			rot = 0, 
			forces = {}, 
			speed = 1.5, 
			_points = 0, 
			points = 0, 
			stats = {hp = 16,  deaths = 0}, 
			hp = 16, 
			_hp = 16, 
			immunity = 0, 
			lives = 3,
			_lives = 3,
			spawned = true, 
			tether = false, 
			perks = {}, 
			attraction = 100, 
			target = {rot = 0,  scale = 1}, 
			lapse = 0, 
			color = {255, 100, 100}, 
			keys = {up = 'i',  down = 'k',  left = 'j',  right = 'l',  tether = 'return'}, 
			timers = {spawn = 0, 
						hp = 0}, 
		}

	if number > 0 then
	p.joystick = {}
		p.joystick.leftH = tonumber(joysticks[love.joystick.getName(number)].axes.leftH)
		p.joystick.leftV = tonumber(joysticks[love.joystick.getName(number)].axes.leftV)
		p.joystick.rightH = tonumber(joysticks[love.joystick.getName(number)].axes.rightH)
		p.joystick.rightV = tonumber(joysticks[love.joystick.getName(number)].axes.rightV)
		p.joystick.leftShoulder = tonumber(joysticks[love.joystick.getName(number)].buttons['leftShoulder'])
		p.joystick.rightShoulder = tonumber(joysticks[love.joystick.getName(number)].buttons['rightShoulder'])
	if not love.joystick.isOpen(number) then love.joystick.open(number) end
	end
	p.sounds = {}
		p.sounds.aHit = res.load("sound", "damage", "new")
		p.sounds.bHit = res.load("sound", "damage", "new")
		p.sounds.adanger = res.load("sound", "danger", "new")
		p.sounds.acritical = res.load("sound", "critical", "new")
		p.sounds.bdanger = res.load("sound", "danger", "new")
		p.sounds.bcritical = res.load("sound", "critical", "new")
		p.sounds.aDie = res.load("sound", "dead", "new")
		p.sounds.bDie = res.load("sound", "dead", "new")
	p.dead = false
	p.distance = 100
	p.tetherDistance = 100
	p.sync = {syncing = false, 
				percentage = 0, 
				synced = false, 
				}
	p.image = res.load("sprite", "player.png")
	p.imageLarge = res.load("sprite", "playerLarge.png")
	return p
end

-----------------------------------------------------------------------------------------------------------------------------------------------\
-----------------------------------------------------------------------------------------------------------------------------------------------/

function player:push(member, x, y, f)
	table.insert(self.members[member].forces,  {f or ((x or 0)^2+(y or 0)^2)^(.5), math.atan2(y or 0, x or 0)})
--	print(self.members[member].forces[1][1], self.members[member].forces[1][2])
end
function player:reverse(member, dir)
	if dir == 'x' then
--		print(self.members[member].x_vol)
		self.members[member].x_vol = -self.members[member].x_vol
--		print(self.members[member].x_vol)
	elseif dir == 'y' then
--		print(self.members[member].y_vol)
		self.members[member].y_vol = -self.members[member].y_vol
--		print(self.members[member].y_vol)
	end
end

function player:closest(x, y)
	if ((self.members.a.x-x)^2+(self.members.a.y-y)^2)^(.5) <= ((self.members.b.x-x)^2+(self.members.b.y-y)^2)^(.5) then
		return {x=self.members.a.x, y=self.members.a.y}
	else
		return {x=self.members.b.x, y=self.members.b.y}
	end
end

function player:drawMember(member, x, y, s)
	if member.spawned then
	--drawing
	if not love.keyboard.isDown(member.keys.up, member.keys.down, member.keys.left, member.keys.right) or state.grabPlayer then --stationary
	-- if member.x_vol == 0 and member.y_vol == 0 then --stationary
			member.rot = member.rot-(math.pi/128)
		--tether effect
		if self.distance < self.tetherDistance then
			love.graphics.setColor(14, 59, 255, 128*(60-member.timers.spawn)/60)
			if s then
				love.graphics.draw(self.imageLarge, res.quads["playerLarge3"], x or member.x, y or member.y, member.rot, 1, 1, 144, 144)
			else
				love.graphics.draw(self.image, res.quads["player3"], x or member.x, y or member.y, member.rot, 1, 1, 24, 24)
			end
		else
			love.graphics.setColor(0, 0, 0, 128*(60-member.timers.spawn)/60)
			if s then
				love.graphics.draw(self.imageLarge, res.quads["playerLarge3"], x or member.x, y or member.y, member.rot, 1, 1, 144, 144)
			else
				love.graphics.draw(self.image, res.quads["player3"], x or member.x, y or member.y, member.rot, 1, 1, 24, 24)
			end
		end
		--player
		love.graphics.setColor(member.color[1], member.color[2], member.color[3], 255-math.random(0, math.max(0, member.immunity*255))*(60-member.timers.spawn)/60)
		if s then
			love.graphics.draw(self.imageLarge, res.quads["playerLarge1"], x or member.x, y or member.y, member.rot, 1, 1, 144, 144)
		else
			love.graphics.draw(self.image, res.quads["player1"], x or member.x, y or member.y, member.rot, 1, 1, 24, 24)
		end
	else --moving
			member.rot = math.atan2(member.y_vol, member.x_vol)+(math.pi/2)
		--tether effect
		if self.distance < self.tetherDistance then
			love.graphics.setColor(14, 59, 255, 128*(60-member.timers.spawn)/60)
			if s then
				love.graphics.draw(self.imageLarge, res.quads["playerLarge4"], x or member.x, y or member.y, member.rot, 1, 1, 144, 144)
			else
				love.graphics.draw(self.image, res.quads["player4"], x or member.x, y or member.y, member.rot, 1, 1, 24, 24)
			end
		else
			love.graphics.setColor(0, 0, 0, 128*(60-member.timers.spawn)/60)
			if s then
				love.graphics.draw(self.imageLarge, res.quads["playerLarge4"], x or member.x, y or member.y, member.rot, 1, 1, 144, 144)
			else
				love.graphics.draw(self.image, res.quads["player4"], x or member.x, y or member.y, member.rot, 1, 1, 24, 24)
			end
		end
		--player
		love.graphics.setColor(member.color[1], member.color[2], member.color[3], 255-math.random(0, math.max(0, member.immunity*255))*(60-member.timers.spawn)/60)
		if s then
			love.graphics.draw(self.imageLarge, res.quads["playerLarge2"], x or member.x, y or member.y, member.rot, 1, 1, 144, 144)
		else
			love.graphics.draw(self.image, res.quads["player2"], x or member.x, y or member.y, member.rot, 1, 1, 24, 24)
		end
	end

	love.graphics.setColor(255, 255, 255, 128)
	for i=1, member.lives do
		love.graphics.circle("fill", member.x - 20 - (i*14), member.y - 24, 5, 4)
	end
	love.graphics.setFont(fonts.boom)
	love.graphics.print(member.points, member.x + 20, member.y + 20)

	if member.hp <= member.stats.hp/4 and member.hp > member.stats.hp/8 then love.graphics.print("Low HP", (x or member.x)+12, (y or member.y)-26) end
	if member.hp <= member.stats.hp/8 then love.graphics.print("Very Low HP!", (x or member.x)+12, (y or member.y)-26) end
end
end

function player:draw()
	love.graphics.setFont(fonts.boomMedium)
	if self.members.a.tether and self.members.b.tether then
		if self.distance <= self.tetherDistance then
			love.graphics.setLineWidth(math.floor(24-24*self.distance/self.tetherDistance))
			love.graphics.setColor(math.random(14, 77), math.random(59, 155), 255, 255-(128*self.distance/self.tetherDistance))
			love.graphics.line(self.members.a.x, self.members.a.y, self.members.b.x, self.members.b.y)
			--sync
			love.graphics.setColor(255, 255, 255, 190)
			love.graphics.print("SYNCING "..(self.sync.percentage*100)..'%', 
				(self.members.a.x-(self.members.a.x-self.members.b.x)/2)-fonts.boomMedium:getWidth("SYNCING "..(self.sync.percentage*100)..'%')/2, 
				-24+self.members.a.y-(self.members.a.y-self.members.b.y)/2)

			love.graphics.setLineWidth(3)
			love.graphics.setColor(255, 255, 255, 24)

			love.graphics.circle("fill", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, (self.tetherDistance/2)*self.sync.percentage, 32)
			love.graphics.circle("line", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, (self.tetherDistance/2), 32)
		else
			love.graphics.setColor(255, 0, 0, 120)
			love.graphics.circle("line", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, (self.tetherDistance/2), 32)
		end
	else
		if self.distance <= self.tetherDistance then
			love.graphics.setLineWidth(3)
			love.graphics.setColor(14, 59, 255, 24)
			love.graphics.stippledLine(self.members.a.x, self.members.a.y, self.members.b.x, self.members.b.y, 8, 8)
			--sync
			love.graphics.circle("line", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, (self.tetherDistance/2), 32)
		end
		love.graphics.setLineWidth(1)
		love.graphics.setColor(0, 0, 0, 16)
		love.graphics.stippledLine(self.members.a.x, self.members.a.y, self.members.b.x, self.members.b.y, 8, 8)
		--sync
		love.graphics.circle("line", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
			self.members.a.y-(self.members.a.y-self.members.b.y)/2, 50, 32)
	end
	love.graphics.setLineWidth(1)


	--------------
	-- A member --
	--------------
	self:drawMember(self.members.a)

	--------------
	-- B member --
	--------------
	self:drawMember(self.members.b)
end

function player:updateMember(member, dt)
if member.timers.spawn == 0 then
	if not member.spawned then self:centre(member.name); member.spawned = true end
	if member.lives == 0 and member._lives ~= member.lives then messages:new("LAST LIFE!", member.x, member.y, 'up', -1, {255,0,0}, 'boomMedium') end

	member._lives = member.lives

	member._points = member.points
if not state.grabPlayer then
	if love.keyboard.isDown(member.keys.tether) then member.tether = true else member.tether = false end
	if love.keyboard.isDown(member.keys.right) and not love.keyboard.isDown(member.keys.left, member.keys.up, member.keys.down) then 
		member.x_vol = math.round(member.x_vol +.8*member.speed, 4) end
	if love.keyboard.isDown(member.keys.left) and not love.keyboard.isDown(member.keys.right, member.keys.up, member.keys.down) then 
		member.x_vol = math.round(member.x_vol -.8*member.speed, 4) end
	if love.keyboard.isDown(member.keys.down) and not love.keyboard.isDown(member.keys.up, member.keys.left, member.keys.right) then 
		member.y_vol = math.round(member.y_vol +.8*member.speed, 4) end
	if love.keyboard.isDown(member.keys.up) and not love.keyboard.isDown(member.keys.down, member.keys.left, member.keys.right) then 
		member.y_vol = math.round(member.y_vol -.8*member.speed, 4) end

	if love.keyboard.isDown(member.keys.right) and love.keyboard.isDown(member.keys.up, member.keys.down) then 
		member.x_vol = math.round(member.x_vol +.6*member.speed, 4) end
	if love.keyboard.isDown(member.keys.left) and love.keyboard.isDown(member.keys.up, member.keys.down) then 
		member.x_vol = math.round(member.x_vol -.6*member.speed, 4) end
	if love.keyboard.isDown(member.keys.down) and love.keyboard.isDown(member.keys.left, member.keys.right) then 
		member.y_vol = math.round(member.y_vol +.6*member.speed, 4) end	
	if love.keyboard.isDown(member.keys.up) and love.keyboard.isDown(member.keys.left, member.keys.right) then 
		member.y_vol = math.round(member.y_vol -.6*member.speed, 4) end
	-- 
	if member.x < 0 then self:push(member.name, -member.x) end
	if member.x > screen.width then self:push(member.name, screen.width-member.x) end
	if member.y < 0 then self:push(member.name, 0, -member.y) end
	if member.y > screen.height then self:push(member.name, 0, screen.height-member.y) end
------------------------------------------------------>
	if member.tether and self.distance > self.tetherDistance then
		self:push(member.other, member.x-self.members[member.other].x, member.y-self.members[member.other].y, math.round(48/math.abs(self.distance), 2))
		self:push(member.name, self.members[member.other].x-member.x, self.members[member.other].y-member.y, math.round(32/math.abs(self.distance), 2))
	end
end
------------------------------------------------------>
	if member._hp ~= member.hp then member._hp = member._hp - (member._hp - member.hp)/12 end
	if member.hp <= member.stats.hp/4 and member.hp > member.stats.hp/8 then
		if not screen.flashing then screen:flash(1, 5, colorExtreme(member.color, 255), "edge") end
		love.audio.play(self.sounds.adanger)
		if member.lapse > 1200 and member.lives <= 1 then -- should I make this constant a stat?
			member.lapse = 0
			self:giveHealth(member.name)
		end
	end
	if member.hp <= member.stats.hp/8 then
		if not screen.flashing then screen:flash(1, 10, colorExtreme(member.color, 255), "edge") end
		if math.random(1, 3) == 2 then screen:aberate(math.random(1, 3), math.random(0, 2)) end
		love.audio.play(self.sounds.acritical)
		if member.lapse > 1200 and member.lives <= 1 then -- should I make this constant a stat?
			member.lapse = 0
			self:giveHealth(member.name)
		end
	end
	if member.hp <= 0 then
		member.lives = member.lives - 1
		member.stats.deaths = member.stats.deaths +1
		member.hp = member.stats.hp
		screen:shake(1, 12)
		for ii=1,  math.min(member.points, 100) do
			table.insert(state.crystals,  crystal.make(member.x+math.random(-48, 48), member.y+math.random(-48, 48)))
		end
		member.points = math.max(0, member.points-100)
		messages:new("Player "..self.number.." died", member.x, member.y, 'up', -1, {0, 128, 90}, 'boomMedium')
		print(member.lives.." lives left.")
		member.immunity = 18
		member.timers.spawn = 60
		member.spawned = false
		love.audio.play(self.sounds.aDie)
	end
	

	if member.immunity > 0 then member.immunity = member.immunity - .1;else member.immunity = 0 end
end

	--timers
	if member.target.rot < math.pi*2 then
		member.target.rot = member.target.rot+(math.pi/120)
	else
		member.target.rot = 0
	end
	if member.target.scale > 1 then
		member.target.scale = member.target.scale - .2
	end

	if member.timers.spawn > 0 then member.timers.spawn = member.timers.spawn - 1 end
end

function player:update()
	self.distance = ((self.members.a.x-self.members.b.x)^2+(self.members.a.y-self.members.b.y)^2)^(.5)

	--------------
	-- A member --
	--------------
	self:updateMember(self.members.a, dt)

	--------------
	-- B member --
	--------------
	self:updateMember(self.members.b, dt)

	------------
	-- Tether --
	------------
	local tetherSrength = (math.floor(24-24*self.distance/self.tetherDistance))/12
	if self.members.a.tether and self.members.b.tether then
		if self.distance <= self.tetherDistance then
			for i, r in ipairs(state.enemies) do
				if math.checkIntersect({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x-r.r, r.y-r.r}, {r.x+r.r, r.y+r.r})
				or math.checkIntersect({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x-r.r, r.y+r.r}, {r.x+r.r, r.y-r.r}) then
				-- if math.getPerpDistance({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y}) <= r.r then
					local perp_x,  perp_y = math.getPerpIntercept({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y})
				-- print(r.x, r.y, perp_x, perp_y)
				-- if math.dist(r.x, r.y, perp_x, perp_y) <= r.r
				-- and math.checkIntersect({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y}, {perp_x, perp_y}) then
					local int_x,  int_y = math.getIntercept({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y}, {perp_x, perp_y})
					sparks.make(int_x, int_y, math.random(130, 140), math.random(230, 240), 255, 255-(128*self.distance/self.tetherDistance))
					r.hp = r.hp - tetherSrength
					screen:shake(.15, 3, false)
				end
			end
			-- print("------------")
			for i, r in ipairs(state.rocks) do
				if math.checkIntersect({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x-r.r, r.y-r.r}, {r.x+r.r, r.y+r.r})
				or math.checkIntersect({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x-r.r, r.y+r.r}, {r.x+r.r, r.y-r.r}) then
				-- if math.getPerpDistance({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y}) <= r.r then
					local perp_x,  perp_y = math.getPerpIntercept({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y})
				-- print(r.x, r.y, perp_x, perp_y)
				-- if math.dist(r.x, r.y, perp_x, perp_y) <= r.r
				-- and math.checkIntersect({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y}, {perp_x, perp_y}) then
					local int_x,  int_y = math.getIntercept({self.members.a.x, self.members.a.y}, {self.members.b.x, self.members.b.y}, {r.x, r.y}, {perp_x, perp_y})
					sparks.make(int_x, int_y, math.random(130, 140), math.random(230, 240), 255, 255-(128*self.distance/self.tetherDistance))
					r.hp = r.hp - tetherSrength
					screen:shake(.15, 3, false)
				end
			end
			self.sync.syncing = true
		else
			if self.sync.syncing then
			messages:new("DE-SYNCED", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, 'up', 1, {255, 0, 0})
			end
			self.sync.syncing = false
			self.sync.synced = false
		end
	else
		if self.sync.syncing then
		messages:new("DE-SYNCED", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
			self.members.a.y-(self.members.a.y-self.members.b.y)/2, 'up', 1, {255, 0, 0})
		end
		self.sync.syncing = false
		self.sync.synced = false
	end
	if self.sync.syncing and (self.members.a.x_vol ~= 0 or self.members.a.y_vol ~= 0) and (self.members.b.x_vol ~= 0 or self.members.b.y_vol ~= 0) then
		if self.sync.percentage < 1 then self.sync.percentage = self.sync.percentage + .001 
		else messages:new("SYNCED!", self.members.a.x-(self.members.a.x-self.members.b.x)/2, 
			self.members.a.y-(self.members.a.y-self.members.b.y)/2, 'up', 1, {255, 0, 0}); self.sync.synced = true end
	else
		self.sync.percentage = 0
	end

	-------------
	-- Collide --
	-------------
	self.members.a.lapse = self.members.a.lapse + 1
	self.members.b.lapse = self.members.b.lapse + 1

	for i, b in ipairs(state.bullets) do
		if self.members.a.immunity == 0 and b.owner == 'enemy' and b.x >= self.members.a.x-6 and b.x <= self.members.a.x+6 and b.y >= self.members.a.y-6 and b.y <= self.members.a.y+6 then
			self.members.a.hp = self.members.a.hp - 1
			self.members.a.lapse = 0
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.a.color, 255), "edge") end
			love.audio.rewind(self.sounds.aHit);love.audio.play(self.sounds.aHit)
			table.remove(state.bullets, i)
		end
		if self.members.b.immunity == 0 and b.owner == 'enemy' and b.x >= self.members.b.x-12 and b.x <= self.members.b.x+12 and b.y >= self.members.b.y-12 and b.y <= self.members.b.y+12 then
			self.members.b.hp = self.members.b.hp - 1
			self.members.b.lapse = 0
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.b.color, 255), "edge") end
			love.audio.rewind(self.sounds.bHit);love.audio.play(self.sounds.bHit)
			table.remove(state.bullets, i)
		end
	end
	for i, b in ipairs(state.enemies) do
		if self.members.a.immunity == 0 and b.collideable and b.x >= self.members.a.x-6 and b.x <= self.members.a.x+6 and b.y >= self.members.a.y-6 and b.y <= self.members.a.y+6 then
			self.members.a.hp = self.members.a.hp - b.damage
			self.members.a.lapse = 0
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.a.color, 255), "edge") end
			love.audio.rewind(self.sounds.aHit);love.audio.play(self.sounds.aHit)
		end
		if self.members.b.immunity == 0 and b.collideable and b.x >= self.members.b.x-12 and b.x <= self.members.b.x+12 and b.y >= self.members.b.y-12 and b.y <= self.members.b.y+12 then
			self.members.b.hp = self.members.b.hp - b.damage
			self.members.b.lapse = 0
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.b.color, 255), "edge") end
			love.audio.rewind(self.sounds.bHit);love.audio.play(self.sounds.bHit)
		end
	end
	for i, c in ipairs(state.crystals) do
		if c.x >= self.members.a.x-12 and c.x <= self.members.a.x+12 and c.y >= self.members.a.y-12 and c.y <= self.members.a.y+12 then
			c.got = true
			self.members.a.points = self.members.a.points +1
		end
		if c.x >= self.members.b.x-12 and c.x <= self.members.b.x+12 and c.y >= self.members.b.y-12 and c.y <= self.members.b.y+12 then
			c.got = true
			self.members.b.points = self.members.b.points +1
		end
	end

	if self.members.a.lives < 0 or self.members.b.lives < 0 then
		self.dead = true
	end

	if not state.grabPlayer then
	--position,  velocity and acceleration
	for i, f in ipairs(self.members.a.forces) do self.members.a.x_vol = math.round(self.members.a.x_vol + math.cos(f[2])*f[1], 4) end
	for i, f in ipairs(self.members.a.forces) do self.members.a.y_vol = math.round(self.members.a.y_vol + math.sin(f[2])*f[1], 4) end
	if math.abs(self.members.a.x_vol) < .001 then self.members.a.x_vol = 0 end
	if math.abs(self.members.a.y_vol) < .001 then self.members.a.y_vol = 0 end
	self.members.a.x = self.members.a.x + self.members.a.x_vol
	self.members.a.y = self.members.a.y + self.members.a.y_vol
	for i, f in ipairs(self.members.b.forces) do self.members.b.x_vol = math.round(self.members.b.x_vol + math.cos(f[2])*f[1], 4) end
	for i, f in ipairs(self.members.b.forces) do self.members.b.y_vol = math.round(self.members.b.y_vol + math.sin(f[2])*f[1], 4) end
	if math.abs(self.members.b.x_vol) < .001 then self.members.b.x_vol = 0 end
	if math.abs(self.members.b.y_vol) < .001 then self.members.b.y_vol = 0 end
	self.members.b.x = self.members.b.x + self.members.b.x_vol
	self.members.b.y = self.members.b.y + self.members.b.y_vol

	if self.members.a.x_vol ~= 0 then self.members.a.x_vol = math.trunc(self.members.a.x_vol - (self.members.a.x_vol*.2), 4) end
	if self.members.a.y_vol ~= 0 then self.members.a.y_vol = math.trunc(self.members.a.y_vol - (self.members.a.y_vol*.2), 4) end
	if self.members.b.x_vol ~= 0 then self.members.b.x_vol = math.trunc(self.members.b.x_vol - (self.members.b.x_vol*.2), 4) end
	if self.members.b.y_vol ~= 0 then self.members.b.y_vol = math.trunc(self.members.b.y_vol - (self.members.b.y_vol*.2), 4) end
	
	self.members.a.forces = {}
	self.members.b.forces = {}
	end

end

function player:giveHealth(t, h)
	if t=='both' then
		self.members.a.hp = math.min(self.members.a.hp + (h or self.members.a.stats.hp-self.members.a.hp), 16)
		self.members.b.hp = math.min(self.members.b.hp + (h or self.members.b.stats.hp-self.members.b.hp), 16)
		messages:new("Health Up!", self.members.a.x, self.members.a.y, 'up', 3, {0, 128, 0})
		messages:new("Health Up!", self.members.b.x, self.members.b.y, 'up', 3, {0, 128, 0})
	else
		self.members[t].hp = math.min(self.members[t].hp + (h or self.members[t].stats.hp-self.members[t].hp), 16)
		messages:new("Health Up!", self.members[t].x, self.members[t].y, 'up', 3, {0, 128, 0})
	end
end

function player:givePoints(t, h)
	if t=='both' then
		self.members.a.points = self.members.a.points + (h or 0)
		self.members.b.points =self.members.b.points + (h or 0)
		messages:new("+"..h, self.members.a.x, self.members.a.y, 'up', 3, {128, 128, 0})
		messages:new("+"..h, self.members.b.x, self.members.b.y, 'up', 3, {128, 128, 0})
	else
		self.members[t].points = self.members[t].points + (h or 0)
		messages:new("+"..h, self.members[t].x, self.members[t].y, 'up', 3, {128, 128, 0})
	end
end

function player:centre(m)
	self.members[m].x, self.members[m].y = screen:getCentre('x'), screen:getCentre('y')
end