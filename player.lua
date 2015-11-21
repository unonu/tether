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
			vol = 0,
			rot = 0,
			forces = {},
			speed = 1.2,
			_points = 0,
			points = 0,
			stats = {hp = 10, energy = 64, deaths = 0, speed = 1.2},
			hp = 10,
			_hp = 0,
			immunity = 0,
			lives = 2,
			_lives = 2,
			energy = 64,
			spawned = true,
			tether = false,
			perks = {},
			attraction = 200,
			target = {rot = 0,  scale = 1},
			lapse = 0,
			items = {nil,nil,nil,nil,nil},
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
			vol = 0,
			rot = 0,
			forces = {},
			speed = 1.2,
			_points = 0,
			points = 0,
			stats = {hp = 10, energy = 64, deaths = 0, speed = 1.2},
			hp = 10,
			_hp = 0,
			immunity = 0,
			lives = 2,
			_lives = 2,
			energy = 64,
			spawned = true,
			tether = false,
			perks = {},
			attraction = 200,
			target = {rot = 0,  scale = 1},
			lapse = 0,
			items = {nil,nil,nil,nil,nil},
			color = {244, 92, 28},
			keys = {up = 'p',  down = ';',  left = 'l',  right = '\'',  tether = 'rshift'},
			timers = {spawn = 0,
						hp = 0},
		}

	if number > 0 then
	p.joystick = {
		leftH = tonumber(joysticks[love.joystick.getName(number)].axes.leftH),
		leftV = tonumber(joysticks[love.joystick.getName(number)].axes.leftV),
		rightH = tonumber(joysticks[love.joystick.getName(number)].axes.rightH),
		rightV = tonumber(joysticks[love.joystick.getName(number)].axes.rightV),
		leftShoulder = tonumber(joysticks[love.joystick.getName(number)].buttons['leftShoulder']),
		rightShoulder = tonumber(joysticks[love.joystick.getName(number)].buttons['rightShoulder']),
	}
	if not love.joystick.isOpen(number) then love.joystick.open(number) end
	end
	p.sounds = {
		aHit = res.load("sound", "damage", "new"),
		bHit = res.load("sound", "damage", "new"),
		adanger = res.load("sound", "danger", "new"),
		acritical = res.load("sound", "critical", "new"),
		bdanger = res.load("sound", "danger", "new"),
		bcritical = res.load("sound", "critical", "new"),
		aDie = res.load("sound", "dead", "new"),
		bDie = res.load("sound", "dead", "new"),
		aEngage = res.load("sound", "tetherEngage", "new"),
		bEngage = res.load("sound", "tetherEngage", "new"),
		tether = res.load("sound", "tether"),
		tetherStart = res.load("sound", "tetherStart"),
		tetherEnd = res.load("sound", "tetherEnd"),
	}
	p.dead = false
	p.distance = 100
	p.tetherDistance = 300
	p.wasTethered = false
	p.syncDistance = 150
	p.sync = {syncing = false,
				percentage = 0,
				synced = false,
				}
	p.image = res.load("sprite", "player.png")
	p.imageLarge = res.load("sprite", "playerLarge.png")
	p.tetherImage = res.load("image","tether.png")
	p.gradient = res.load("image","healthbar.png")
	return p
end

-----------------------------------------------------------------------------------------------------------------------------------------------\
-----------------------------------------------------------------------------------------------------------------------------------------------/

function player:push(member, x, y, f)
	table.insert(self.members[member].forces,  {f or ((x or 0)^2+(y or 0)^2)^(.5), math.atan2(y or 0, x or 0)})
end
function player:reverse(member, dir)
	if dir == 'x' then
		self.members[member].x_vol = -self.members[member].x_vol
	elseif dir == 'y' then
		self.members[member].y_vol = -self.members[member].y_vol
	end
end

function player:closest(x, y)
	if ((self.members.a.x-x)^2+(self.members.a.y-y)^2)^(.5) <= ((self.members.b.x-x)^2+(self.members.b.y-y)^2)^(.5) then
		return {x=self.members.a.x, y=self.members.a.y, a = self.members.a.attraction}, self.members.a
	else
		return {x=self.members.b.x, y=self.members.b.y, a = self.members.b.attraction}, self.members.b
	end
end

function player:drawMember(member, hud, x, y, s)
if member.spawned then

	local otherRot = math.atan2(member.y-self.members[member.other].y,member.x-self.members[member.other].x)+(math.pi/2)

	if hud == nil or hud then

		--hp
		love.graphics.setLineWidth(8)
		love.graphics.setColor(255,255,255,64)
		love.graphics.curve(member.x,member.y,52,-math.pi/2,(-(member._hp/member.stats.hp)*math.pi*2)-(math.pi/2),32)
		love.graphics.setColor(member.color[1],member.color[2],member.color[3],64)
		love.graphics.curve(member.x,member.y,52,-math.pi/2,(-(member.hp/member.stats.hp)*math.pi*2)-(math.pi/2),32)

		--energy
		if member.tether then
			love.graphics.setColor(230,230,255,math.random(200,255))
		else
			love.graphics.setColor(96,96,255,96)
		end
		if member.energy < member.stats.energy/4 then love.graphics.setColor(255,0,0,math.random(200,255)) end
		love.graphics.setLineWidth(4)
		love.graphics.curve(member.x,member.y,72,0,math.pi*(member.energy/member.stats.energy),member.stats.energy)

	end

	--drawing
	if not love.keyboard.isDown(member.keys.up, member.keys.down, member.keys.left, member.keys.right) or state.grabPlayer then --stationary
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
			if member.tether then
				love.graphics.setColor(14, 59, 255, 128*(60-member.timers.spawn)/60)
				love.graphics.draw(self.gradient,member.x,member.y,otherRot,6,12)
			end

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
			if member.tether then
				love.graphics.setColor(14, 59, 255, 128*(60-member.timers.spawn)/60)
				love.graphics.draw(self.gradient,member.x,member.y,otherRot,6,12)
			end

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

	love.graphics.setColor(255, 255, 255, 164)
	for i=1, member.lives do
		love.graphics.circle("fill", member.x - 20 - (i*14), member.y - 24, 5, 4)
	end
	love.graphics.setFont(fonts.boom)
	love.graphics.print(member.points, member.x + 20, member.y + 20)
	if member.energy <= 0 then
		love.graphics.setColor(255, 0, 0, 164)
		love.graphics.print("NO ENERGY", member.x -100, member.y + 20)
	end


	if member.hp <= member.stats.hp/4 and member.hp > member.stats.hp/8 then love.graphics.print("LOW HP", (x or member.x)+20, (y or member.y)-32) end
	if member.hp <= member.stats.hp/8 then love.graphics.print("VERY LOW HP!", (x or member.x)+20, (y or member.y)-32) end
end
end

function player:draw(hud)
	love.graphics.setFont(fonts.medium)

if hud == nil or hud then

	if self.members.a.tether and self.members.b.tether then
		--sync
		if self.distance <= self.syncDistance then
			love.graphics.setColor(255, 255, 255, 190)
			love.graphics.print("SYNCING "..(self.sync.percentage*100)..'%',
				(self.members.a.x-(self.members.a.x-self.members.b.x)/2)-fonts.medium:getWidth("SYNCING %")/2,
				-24+self.members.a.y-(self.members.a.y-self.members.b.y)/2)

			love.graphics.setLineWidth(1)
			love.graphics.setColor(255, 255, 255, 120)
			love.graphics.circle("fill", self.members.a.x-(self.members.a.x-self.members.b.x)/2,
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, (self.syncDistance/2)*self.sync.percentage, 64)
			love.graphics.setLineWidth(2)
		else
			love.graphics.setColor(255,0,0, 24)
			love.graphics.setLineWidth(1)
		end
			love.graphics.circle("line", self.members.a.x-(self.members.a.x-self.members.b.x)/2,
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, self.syncDistance/2, 64)
		--tether
		if self.distance <= self.tetherDistance then
			love.graphics.setLineWidth(math.floor(24-24*self.distance/self.tetherDistance))
			love.graphics.setColor(math.random(14, 77), math.random(59, 155), 255, 255-(128*self.distance/self.tetherDistance))
			love.graphics.line(self.members.a.x, self.members.a.y, self.members.b.x, self.members.b.y)
			love.graphics.setColor(200,255,255,120)
			love.graphics.setShader(shaders.chromaticAberation)
			love.graphics.draw(self.tetherImage,self.members.a.x,self.members.a.y,math.atan2(self.members.a.y-self.members.b.y,self.members.a.x-self.members.b.x)-math.pi,self.distance,love.graphics.getLineWidth()/24,0,12)
			love.graphics.setShader()
			love.graphics.setColor(0,0,255,24)
			love.graphics.setLineWidth(2)
		else
			love.graphics.setColor(255, 0, 0, 190-(math.random()*100))
			love.graphics.print("TOO FAR",
				(self.members.a.x-(self.members.a.x-self.members.b.x)/2)-fonts.medium:getWidth("TOO FAR")/2,
				-24+self.members.a.y-(self.members.a.y-self.members.b.y)/2)
			love.graphics.setColor(255, 0, 0, 24)
			love.graphics.setLineWidth(1)
		end
			love.graphics.circle("line", self.members.a.x-(self.members.a.x-self.members.b.x)/2,
				self.members.a.y-(self.members.a.y-self.members.b.y)/2, (self.tetherDistance/2), 64)

	else
		if self.distance <= self.tetherDistance then
			love.graphics.setLineWidth(3)
			love.graphics.setColor(14, 59, 255, 24)
		else
			love.graphics.setLineWidth(1)
			love.graphics.setColor(255, 0, 0, 16)
		end
		love.graphics.stippledLine(self.members.a.x, self.members.a.y, self.members.b.x, self.members.b.y, 8, 8)
	end

end

	--------------
	-- A member --
	--------------
	self:drawMember(self.members.a,hud)

	--------------
	-- B member --
	--------------
	self:drawMember(self.members.b,hud)
end

function player:updateMember(member, dt)
if member.timers.spawn == 0 then
	if not member.spawned then self:centre(member.name); member.spawned = true; print(member.spawned) end
	if member.lives == 0 and member._lives ~= member.lives then messages:new("LAST LIFE!", member.x, member.y, 'up', -1, {255,0,0}, 'medium') end

	member._lives = member.lives

	member._points = member.points
	member.tether = false

if not state.grabPlayer then
	if love.keyboard.isDown(member.keys.tether) then
		if member.energy > 0 then
			member.tether = true;
			member.energy = member.energy - .1
		else
			member.tether = false
		end
	else
		member.energy = math.min(member.stats.energy,member.energy + .2)
	end

	if love.keyboard.isDown(member.keys.right) and not love.keyboard.isDown(member.keys.left, member.keys.up, member.keys.down) then
		member.x_vol = math.max(member.x_vol +.6*member.speed, -.3*member.x_vol +.3*member.speed) end
	if love.keyboard.isDown(member.keys.left) and not love.keyboard.isDown(member.keys.right, member.keys.up, member.keys.down) then
		member.x_vol = math.min(member.x_vol -.6*member.speed, -.3*member.x_vol -.3*member.speed) end
	if love.keyboard.isDown(member.keys.down) and not love.keyboard.isDown(member.keys.up, member.keys.left, member.keys.right) then
		member.y_vol = math.max(member.y_vol +.6*member.speed, -.3*member.y_vol +.3*member.speed) end
	if love.keyboard.isDown(member.keys.up) and not love.keyboard.isDown(member.keys.down, member.keys.left, member.keys.right) then
		member.y_vol = math.min(member.y_vol -.6*member.speed, -.3*member.y_vol -.3*member.speed) end

	if love.keyboard.isDown(member.keys.right) and love.keyboard.isDown(member.keys.up, member.keys.down) then
		member.x_vol = math.round(member.x_vol +.42*member.speed, 4) end
	if love.keyboard.isDown(member.keys.left) and love.keyboard.isDown(member.keys.up, member.keys.down) then
		member.x_vol = math.round(member.x_vol -.42*member.speed, 4) end
	if love.keyboard.isDown(member.keys.down) and love.keyboard.isDown(member.keys.left, member.keys.right) then
		member.y_vol = math.round(member.y_vol +.42*member.speed, 4) end
	if love.keyboard.isDown(member.keys.up) and love.keyboard.isDown(member.keys.left, member.keys.right) then
		member.y_vol = math.round(member.y_vol -.42*member.speed, 4) end
	--
	if member.x < 0 then self:push(member.name, -member.x/2) end
	if member.x > screen.width then self:push(member.name, (screen.width-member.x)/2) end
	if member.y < 0 then self:push(member.name, 0, -member.y/2) end
	if member.y > screen.height then self:push(member.name, 0, (screen.height-member.y)/2) end

	if member.x > self.members[member.other].x-24 and
	member.x < self.members[member.other].x+24 and
	member.y > self.members[member.other].y-24 and
	member.y < self.members[member.other].y+24 and
	(member.x ~= self.members[member.other].x or
	member.y ~= self.members[member.other].y) then
		self:push(member.other, member.x-self.members[member.other].x, member.y-self.members[member.other].y, -1)
		self:push(member.name, self.members[member.other].x-member.x, self.members[member.other].y-member.y, -1)
	end

------------------------------------------------------>
	member.speed = member.stats.speed
	if member.tether then
		if self.distance > self.tetherDistance then
			self:push(member.other, member.x-self.members[member.other].x, member.y-self.members[member.other].y, math.round(12/math.abs(self.distance), 2))
			self:push(member.name, self.members[member.other].x-member.x, self.members[member.other].y-member.y, math.round(32/math.abs(self.distance), 2))
		-- else
		-- 	if self.members[member.other].tether then
		-- 		local angle = math.abs(math.atan2(member.y-self.members[member.other].y, member.x-self.members[member.other].x))
		-- 		member.x = math.clamp( self.members[member.other].x - math.cos(angle)*self.tetherDistance, member.x, self.members[member.other].x + math.cos(angle)*self.tetherDistance)
		-- 		member.y = math.clamp( self.members[member.other].y - math.sin(angle)*self.tetherDistance, member.y, self.members[member.other].y + math.sin(angle)*self.tetherDistance)
		-- 	end
		end
		member.speed = member.stats.speed/2
	end
end
------------------------------------------------------>
	if member._hp ~= member.hp then member._hp = member._hp - (member._hp - member.hp)/12 end
	if member.hp <= member.stats.hp/4 and member.hp > member.stats.hp/8 then
		if not screen.flashing then screen:flash(1, 5, colorExtreme(member.color, 255), "edge") end
		love.audio.play(self.sounds.adanger)
		-- if member.lapse > 1200 and member.lives <= 1 then -- should I make this constant a stat?
		-- 	member.lapse = 0
		-- 	self:giveHealth(member.name)
		-- end
	end
	if member.hp <= member.stats.hp/8 then
		if not screen.flashing then screen:flash(1, 10, colorExtreme(member.color, 255), "edge") end
		if math.random(1, 3) == 2 then screen:aberate(math.random(1, 3), math.random(0, 2)) end
		love.audio.play(self.sounds.acritical)
		-- if member.lapse > 1200 and member.lives <= 1 then -- should I make this constant a stat?
		-- 	member.lapse = 0
		-- 	self:giveHealth(member.name)
		-- end
	end
	if member.hp <= 0 then
		member.lives = member.lives - 1
		member.stats.deaths = member.stats.deaths +1
		member.hp = member.stats.hp
		shimmer.make(member.x,member.y,member.rot)
		screen:shake(1, 12)
		for ii=1,  math.min(member.points, 100) do
			table.insert(state.crystals,  crystal.make(member.x+math.random(-64, 64), member.y+math.random(-64, 64)))
		end
		member.points = math.max(0, member.points-100)
		messages:new("Player "..self.number.." died", member.x, member.y, 'up', -1, {0, 128, 90}, 'medium')
		print(member.lives.." lives left.")
		member.immunity = 18
		member.timers.spawn = 60
		member.spawned = false
		love.audio.play(self.sounds.aDie)
	end

	member.hp = math.min(member.stats.hp, member.hp + (member.hp/(member.stats.hp*600)))

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

	if member.timers.spawn > 0 then member.timers.spawn = member.timers.spawn - 1; member.tether = false end
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
	if self.members.a.spawned and self.members.b.spawned then
		local tetherSrength = self.tetherDistance/self.distance
		if self.members.a.tether and self.members.b.tether and self.distance <= self.tetherDistance then

			makeTether(self.members.a.x,self.members.a.y,self.members.b.x,self.members.b.y,
						math.floor(24-24*self.distance/self.tetherDistance),tetherSrength)
			love.audio.play(self.sounds.tether)
			self.wasTethered = true

			if self.distance <= self.syncDistance then
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
			if self.wasTethered then
				love.audio.stop(self.sounds.tether)
				love.audio.rewind(self.sounds.tether)
				love.audio.rewind(self.sounds.tetherEnd)
				love.audio.play(self.sounds.tetherEnd)
				self.wasTethered = false
			end
		end
	end
	if self.sync.syncing and (self.members.a.vol <= 1 and self.members.b.vol <= 1) then
		if self.sync.percentage < 1 then self.sync.percentage = self.sync.percentage + .002
		else messages:new("SYNCED!", self.members.a.x-(self.members.a.x-self.members.b.x)/2,
			self.members.a.y-(self.members.a.y-self.members.b.y)/2, 'up', 1, {255, 0, 0})
			self.sync.synced = true
			state.syncState = true
		end
	else
		self.sync.percentage = 0
	end


	-------------
	-- Collide --
	-------------
	self.members.a.lapse = self.members.a.lapse + 1
	self.members.b.lapse = self.members.b.lapse + 1

	for i, b in ipairs(state.bullets) do
		local remove = false
		if self.members.a.immunity == 0 and b.owner ~= 'player' and b.x >= self.members.a.x-8 and b.x <= self.members.a.x+8 and b.y >= self.members.a.y-8 and b.y <= self.members.a.y+8 then
			self.members.a.hp = self.members.a.hp - 1
			self.members.a.immunity = 4
			-- self.members.a.lapse = 0
			self:push('a', math.cos(b.d), math.sin(b.d), -1)
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.a.color, 255), "edge") end
			love.audio.rewind(self.sounds.aHit);love.audio.play(self.sounds.aHit)
			remove = true
		end
		if self.members.b.immunity == 0 and b.owner ~= 'player' and b.x >= self.members.b.x-8 and b.x <= self.members.b.x+8 and b.y >= self.members.b.y-8 and b.y <= self.members.b.y+8 then
			self.members.b.hp = self.members.b.hp - 1
			self.members.b.immunity = 4
			-- self.members.b.lapse = 0
			self:push('b', math.cos(b.d), math.sin(b.d), -1)
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.b.color, 255), "edge") end
			love.audio.rewind(self.sounds.bHit);love.audio.play(self.sounds.bHit)
			remove = true
		end
		if remove then table.remove(state.bullets, i) end
	end
	for i, b in ipairs(state.enemies) do
		if self.members.a.immunity == 0 and b.collideable and
		((math.dist(b._x or b.x,b._y or b.y, self.members.a.x,self.members.a.y) < math.dist(b._x or b.x,b._y or b.y,b.x,b.y) and
		math.dist(self.members.a.x,self.members.a.y,b._x or b.x,b._y or b.y) < math.dist(b._x or b.x,b._y or b.y,b.x,b.y)) or
		(b.x >= self.members.a.x-6 and b.x <= self.members.a.x+6 and b.y >= self.members.a.y-6 and b.y <= self.members.a.y+6)) then
			self.members.a.hp = self.members.a.hp - b.damage
			self.members.a.lapse = 0
			screen:shake(.5, 4)
			if not screen.flashing then screen:flash(1, 20, colorExtreme(self.members.a.color, 255), "edge") end
			love.audio.rewind(self.sounds.aHit);love.audio.play(self.sounds.aHit)
		end
		if self.members.b.immunity == 0 and b.collideable and
		((math.dist(b._x or b.x,b._y or b.y, self.members.b.x,self.members.b.y) < math.dist(b._x or b.x,b._y or b.y,b.x,b.y) and
		math.dist(self.members.b.x,self.members.b.y,b._x or b.x,b._y or b.y) < math.dist(b._x or b.x,b._y or b.y,b.x,b.y)) or
		(b.x >= self.members.b.x-6 and b.x <= self.members.b.x+6 and b.y >= self.members.b.y-6 and b.y <= self.members.b.y+6)) then
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
	for i, c in ipairs(state.drops) do
		if c.x >= self.members.a.x-c.r and c.x <= self.members.a.x+c.r and c.y >= self.members.a.y-c.r and c.y <= self.members.a.y+c.r then
			c:trigger('a')
		end
		if c.x >= self.members.b.x-c.r and c.x <= self.members.b.x+c.r and c.y >= self.members.b.y-c.r and c.y <= self.members.b.y+c.r then
			c:trigger('b')
		end
	end

	if self.members.a.lives < 0 or self.members.b.lives < 0 then
		self.dead = true
	end

	if not state.grabPlayer then
	--position,  velocity and acceleration
	for i, f in ipairs(self.members.a.forces) do self.members.a.x_vol = math.round(self.members.a.x_vol + math.cos(f[2])*f[1], 4) end
	for i, f in ipairs(self.members.a.forces) do self.members.a.y_vol = math.round(self.members.a.y_vol + math.sin(f[2])*f[1], 4) end
	self.members.a.x = self.members.a.x + self.members.a.x_vol
	self.members.a.y = self.members.a.y + self.members.a.y_vol
	for i, f in ipairs(self.members.b.forces) do self.members.b.x_vol = math.round(self.members.b.x_vol + math.cos(f[2])*f[1], 4) end
	for i, f in ipairs(self.members.b.forces) do self.members.b.y_vol = math.round(self.members.b.y_vol + math.sin(f[2])*f[1], 4) end
	self.members.b.x = self.members.b.x + self.members.b.x_vol
	self.members.b.y = self.members.b.y + self.members.b.y_vol

	if self.members.a.x_vol ~= 0 then self.members.a.x_vol = math.trunc(self.members.a.x_vol - (self.members.a.x_vol*.07), 4) end
	if self.members.a.y_vol ~= 0 then self.members.a.y_vol = math.trunc(self.members.a.y_vol - (self.members.a.y_vol*.07), 4) end
	if self.members.b.x_vol ~= 0 then self.members.b.x_vol = math.trunc(self.members.b.x_vol - (self.members.b.x_vol*.07), 4) end
	if self.members.b.y_vol ~= 0 then self.members.b.y_vol = math.trunc(self.members.b.y_vol - (self.members.b.y_vol*.07), 4) end

	if math.abs(self.members.a.x_vol) < .001 then self.members.a.x_vol = 0 end
	if math.abs(self.members.a.y_vol) < .001 then self.members.a.y_vol = 0 end
	if math.abs(self.members.b.x_vol) < .001 then self.members.b.x_vol = 0 end
	if math.abs(self.members.b.y_vol) < .001 then self.members.b.y_vol = 0 end

	self.members.a.vol = (self.members.a.x_vol^2 + self.members.a.y_vol^2)^.5
	self.members.b.vol = (self.members.b.x_vol^2 + self.members.b.y_vol^2)^.5

	self.members.a.forces = {}
	self.members.b.forces = {}
	end

end

function player:keypressed(k)
	if k == self.members.a.keys.tether then
		wave.make(self.members.a.x,self.members.a.y,15,1,104,149,255,128)
		love.audio.rewind(self.sounds.aEngage)
		love.audio.play(self.sounds.aEngage)
	elseif k == self.members.b.keys.tether then
		wave.make(self.members.b.x,self.members.b.y,15,1,104,149,255,128)
		love.audio.rewind(self.sounds.bEngage)
		love.audio.play(self.sounds.bEngage)
	end
end

function player:giveHealth(t, h)
	if t=='both' then
		self.members.a.hp = math.min(self.members.a.hp + (h or self.members.a.stats.hp-self.members.a.hp), 16)
		self.members.b.hp = math.min(self.members.b.hp + (h or self.members.b.stats.hp-self.members.b.hp), 16)
		messages:new("Health Up!", self.members.a.x, self.members.a.y, 'up', 3, {30, 255, 30})
		messages:new("Health Up!", self.members.b.x, self.members.b.y, 'up', 3, {30, 255, 30})
	else
		self.members[t].hp = math.min(self.members[t].hp + (h or self.members[t].stats.hp-self.members[t].hp), 16)
		messages:new("Health Up!", self.members[t].x, self.members[t].y, 'up', 3, {30, 255, 30})
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

function player:giveLife(t,l)
	if t=='both' then
		self.members.a.lives = math.min(self.members.a.lives + (h or 1), 6)
		self.members.b.lives = math.min(self.members.b.lives + (h or 1), 6)
		messages:new("Extra Life!", self.members.a.x, self.members.a.y, 'up', 3, {255,255,255})
		messages:new("Extra Life!", self.members.b.x, self.members.b.y, 'up', 3, {255,255,255})
	else
		self.members[t].lives = math.min(self.members[t].lives + (h or 1), 6)
		messages:new("Extra Life!", self.members[t].x, self.members[t].y, 'up', 3, {255,255,255})
	end
end

function player:centre(m)
	self.members[m].x, self.members[m].y = screen:getCentre('x'), screen:getCentre('y')
end

function makeTether(x1,y1,x2,y2,w,s,l)
	local t = {}
	t.x1 = x1
	t.x2 = x2
	t.y1 = y1
	t.y2 = y2
	t.length = ((x1-x2)^2+(y1-y2)^2)^.5
	t.width = w/2
	t.strength = s
	t.angle = math.atan2(y2-y1,x2-x1)
	t.life = l or 2
	--[[ maybe I'll want colours to affect effects so add
	that here. Do any necessary math here.]]
	table.insert(state.tethers,t)
end