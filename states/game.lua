game = {}
game.__index = game

function game.make(name1,name2)
	screen:clearEffects('flash')
	particles = {}
	local g = {}
	setmetatable(g,game)
	g.player = player.make(0)
	if name1 then
		print(name2[1],name1[1])
		g.name1 = name1
		g.name2 = name2
	end
	g.grabPlayer = false
	g.distance = 100
	g.quota = 4
	g.points = 0
	g.crystals = {}
	g.enemies = {}
	g.bullets = {}
	g.explosions = {}
	g.tethers = {}
	g.round = 1
	g.objective = nil
	g.cinematic = false
	g.boss = false
	g.stats = {rocks = 0, enemies = 0, rocksRound = 0}
	g.pc = {r=255,g=0,b=0,timer = 0}
	g.canvases = {
		pauseBuffer = love.graphics.newCanvas(),
		pauseCanvas = love.graphics.newCanvas(),
		motionBlur = love.graphics.newCanvas(),
	}
	g.blurSample = 3
	g.res = {
		bullet = res.load("sprite","shot.png"),
		crystal = res.load("sprite","point.png"),
		target = res.load("sprite","target.png"),
		scoreBoardA = res.load("image","scoreboardBack.png"),
		scoreBoardB = res.load("image","scoreboardFront.png"),
		background = res.load("image","greyField.png"),
		healthbar = res.load("image","healthbar.png"),
		itemRing = res.load("image","itemRing.png"),
		health = res.load("sprite","health.png"),
	}
	g.sounds = {
		collect = res.load("sound","collect"),
		explosion = res.load("sound","explosion"),
		tock = res.load("sound","menuTock"),
		distort = res.load("sound","distortTock"),
		click = res.load("sound","menuClick"),
	}
	love.audio.setVolume(1.0)
	g.music = res.load("music","music")
	g.music:rewind()
	g.music:setVolume(0.5)
	g.music:play()

	g.pause = 1
	g.menu = {"Continue","Restart","Resign","Exit to Menu"}
	g.menuIndex = 1

	g.rocks = {}

	g.drops = {}

	screen:setBackground(g.res.background)
	messages:clear()
	messages:new("START!",screen:getCentre('x'),screen:getCentre('y'),"still",2,{255,255,255},'boomLarge')
	g.time = {
		elapsed = 0,
		startTime = love.timer.getTime(),
		hours = 0,
		minutes = 0,
		seconds = 0,
	}

	g.timers = {
		intro = {0,1,"state.timers.intro[1] = (state.timers.intro[1] + (state.timers.intro[2]-state.timers.intro[1])/24)"},
		colors = {r=255,g=0,b=0},
		death = {0},
	}

	g.name = "Main Game"

	g.syncState = false

	return g
end

function game:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.res.background,0,0,0,screen.width/1280,screen.height/720)

if self.pause == 1 then

if not self.syncState then
	--normal game
	love.graphics.push()
	love.graphics.translate((screen.width/2)*(1-self.timers.intro[1]),(screen.height/2)*(1-self.timers.intro[1]))
	love.graphics.scale(self.timers.intro[1],self.timers.intro[1])

	--round
	love.graphics.setColor(255,255,255,200)
	love.graphics.setFont(fonts.roundNumbers)
	love.graphics.print(self.round,screen:getCentre('x')-(fonts.roundNumbers:getWidth(self.round)/2),
		screen:getCentre('y')-(fonts.roundNumbers:getHeight(self.round)/2))
	love.graphics.setColor(147,147,147,200)
	love.graphics.setFont(fonts.medium)
	love.graphics.print("ROUND",screen:getCentre('x')-(fonts.roundNumbers:getWidth(self.round)/2)-22,
		screen:getCentre('y')+(fonts.roundNumbers:getHeight(self.round)/2),-math.pi/2)
	if self.objective then
		love.graphics.print(self.objective,screen:getCentre('x')-fonts.medium:getWidth(self.objective)/2,
			screen:getCentre('y')+4+(fonts.roundNumbers:getHeight(self.round))/2)
	else
		local remainder = self.quota-math.fmod(self.stats.rocksRound,self.quota)
		love.graphics.print(remainder.." LEFT",screen:getCentre('x')-fonts.medium:getWidth(remainder.." LEFT")/2,
			screen:getCentre('y')+4+(fonts.roundNumbers:getHeight(self.round))/2)
	end
	--time
	local time = love.graphics.fillJustify(self.time.hours,1,0)..':'..love.graphics.fillJustify(self.time.minutes,1,0)..':'..love.graphics.fillJustify(self.time.seconds,1,0)
	love.graphics.print(time, screen:getCentre('x')-fonts.medium:getWidth(time)/2, 32)


	love.graphics.setFont(fonts.small)
	--------------------------------
	for i,r in ipairs(self.rocks) do
		r:draw()
	end
	for i,c in ipairs(self.crystals) do
		c:draw()
	end
	for i,c in ipairs(self.drops) do
		c:draw()
	end
	for i,e in ipairs(self.enemies) do
		e:draw()
	end

	self.player:draw()

	for i,b in ipairs(self.bullets) do
		love.graphics.setColor(255,math.random(0,2)*128,math.random(0,255))
		b:draw()
	end

	for i, p in ipairs(particles) do
		if type(p) == "table" then
			p:draw()
		else
			love.graphics.draw(p)
		end
	end
	----------------------
	messages:draw()

		love.graphics.pop()
		if self.cinematic then
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill",0,0,screen.width,86)
			love.graphics.rectangle("fill",0,screen.height-86,screen.width,86)
		end

else

	--syncState
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(self.timers.colors.r,self.timers.colors.g,self.timers.colors.b)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	love.graphics.setBlendMode("alpha")

	love.graphics.setShader(shaders.monochrome)
	self.player:draw(false)
	love.graphics.setShader()

	love.graphics.push()
	love.graphics.translate(-10,screen.height-116)
	for i=1,5 do
		if self.player.members.a.items[i] then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(255,255,255,128)
		end
		if i < 3 then
			love.graphics.draw(self.res.itemRing,i*58,0)
		else
			love.graphics.draw(self.res.itemRing,(i*58)-145,58)
		end
	end
	love.graphics.pop()

end

elseif self.pause == 2 then
	local xy = screen:getCentre()
		love.graphics.setColor(self.pc.r,self.pc.g,self.pc.b)

	love.graphics.draw(self.canvases.pauseBuffer)

	--------------
	self.player:drawMember(self.player.members.a,false,150,150,'Large')
	self.player:drawMember(self.player.members.b,false,screen.width-150,screen.height-150,'Large')
	--------------
		love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,xy[2]-48,screen.width*(self.pc.timer/30),96)
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(fonts.large)
	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
	love.graphics.printf("PAUSED",_x,-16+xy[2]+_y,screen.width,'center')

elseif self.pause == 3 then
	local xy = screen:getCentre()
	love.graphics.setShader()

	-- 	love.graphics.setCanvas(self.canvases.pauseCanvas)
	-- love.graphics.draw(self.canvases.pauseBuffer)

	-- 	love.graphics.setShader(shaders.blurX)
	-- love.graphics.draw(self.canvases.pauseCanvas)

	-- 	love.graphics.setShader(shaders.blurY)
	-- love.graphics.draw(self.canvases.pauseCanvas)
	-- 	love.graphics.setShader()
	-- 	love.graphics.setCanvas()
	-- love.graphics.draw(self.canvases.pauseCanvas)

		love.graphics.setBlendMode("multiplicative")
	love.graphics.setColor(128 + self.pc.r/2,128 + self.pc.g/2,128 + self.pc.b/2)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
		love.graphics.setBlendMode("alpha")
	--------------
		love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,xy[2]-((#self.menu/2)*72)-16,screen.width*(self.pc.timer/30),((#self.menu)*72))
	love.graphics.stippledLine(screen.width,xy[2]-((#self.menu/2)*72)-32,screen.width - screen.width*(self.pc.timer/30),xy[2]-((#self.menu/2)*72)-32,12,12)
	love.graphics.stippledLine(screen.width,xy[2]+((#self.menu/2)*72),screen.width - screen.width*(self.pc.timer/30),xy[2]+((#self.menu/2)*72),12,12)
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(fonts.large)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255,255*(self.pc.timer/30))
		else
			love.graphics.setColor(128,128,128,255*(self.pc.timer/30))
		end
		love.graphics.printf(m,0 + ((-1)^i)*(48+(i*128))*(1-(self.pc.timer/30)),(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
	end
end
end

function game:update(dt)
	for i,t in pairs(self.timers) do
		if type(t[3]) == "number" then
			t[1] = math.min(t[1]+t[3],t[2])
		elseif type(t[3]) == "string" then
			assert(loadstring(t[3]))()
		end
	end

if self.pause == 1 then

	--normal game
if not self.syncState then

	self.time.elapsed = love.timer.getTime()-self.time.startTime
	self.time.seconds = math.floor(self.time.elapsed)-(60*self.time.minutes)-(3600*self.time.hours)
	if self.time.seconds > 59.99 then self.time.seconds = 0; self.time.minutes = self.time.minutes + 1 end
	if self.time.minutes > 59.99 then self.time.minutes = 0; self.time.hours = self.time.hours + 1 end

	self.player:update(dt)
	if self.player.dead then
		print("You lasted "..self.round.." rounds.")
		print("Player 1 had "..self.player.members.a.points.." points.")
		print("Player 2 had "..self.player.members.b.points.." points.")
		state = heaven.make(self.player,self.round,self.stats.rocks,self.stats.enemies,self.time.elapsed,self.name1,self.name2)
		return
	end

	for i,e in ipairs(self.enemies) do
		e:update(dt)
		if e.hp <= 0 or e.kill then
			if e.drop then
			for ii=0, (e.bounty or math.random(9,17)) do
				table.insert(self.crystals, crystal.make(e.x+math.random(-48,48),e.y+math.random(-48,48)))
			end
			end
			table.remove(self.enemies,i)
			self.stats.enemies = self.stats.enemies +1
		end
	end
	for i,r in ipairs(self.rocks) do
		r:update(dt)
		if r.hp <= 0 then
			for ii=0, math.random(9,17) do
				table.insert(self.crystals, crystal.make(r.x+math.random(-48,48),r.y+math.random(-48,48)))
			end
			self.stats.rocks = self.stats.rocks +1
			self.stats.rocksRound = self.stats.rocksRound +1
			table.remove(self.rocks,i)
		end
	end
	for i,b in ipairs(self.bullets) do
		b:update(dt)
		if b.x > screen.width+48 or b.x < -48 or b.y > screen.height+48 or b.y < -48 then
			table.remove(self.bullets,i)
		end
	end
	for i,c in ipairs(self.crystals) do
		c:update(dt)
		if c.got or c.dead then
			table.remove(self.crystals,i)
		end
	end
	for i,c in ipairs(self.drops) do
		c:update(dt)
		if c.got or c.dead then
			table.remove(self.drops,i)
		end
	end

	for i,t in ipairs(self.tethers) do
		t.life = t.life - 1
		if t.life == 0 then
			table.remove(self.tethers,i)
		end
	end

	messages:update(dt)

	if #self.explosions > 0 then
		screen.shake(screen.fps,#self.explosions*2)
	end

	rounder()

	for i, p in ipairs(particles) do
		p:start()
		p:update(dt)
		if not p:isActive() then
			table.remove(particles,i)
		end
	end

else
	--synce state
	if self.timers.colors.r > 0 and self.timers.colors.g < 255 and self.timers.colors.b == 0 then
		self.timers.colors.r = self.timers.colors.r - 1
		self.timers.colors.g = self.timers.colors.g + 1
	elseif self.timers.colors.r == 0 and self.timers.colors.g > 0 and self.timers.colors.b < 255 then
		self.timers.colors.g = self.timers.colors.g - 1
		self.timers.colors.b = self.timers.colors.b + 1
	elseif self.timers.colors.r < 255 and self.timers.colors.g == 0 and self.timers.colors.b > 0 then
		self.timers.colors.b = self.timers.colors.b - 1
		self.timers.colors.r = self.timers.colors.r + 1
	end
	self.grabPlayer = true

end
	self.pc.timer = 0

else
	if self.pc.r > 0 and self.pc.g < 255 and self.pc.b == 0 then
		self.pc.r = self.pc.r - 1
		self.pc.g = self.pc.g + 1
	elseif self.pc.r == 0 and self.pc.g > 0 and self.pc.b < 255 then
		self.pc.g = self.pc.g - 1
		self.pc.b = self.pc.b + 1
	elseif self.pc.r < 255 and self.pc.g == 0 and self.pc.b > 0 then
		self.pc.b = self.pc.b - 1
		self.pc.r = self.pc.r + 1
	end
	if self.pc.timer < 30 then self.pc.timer = self.pc.timer +1 end
end
end

function game:keypressed(k)
if self.pause == 1 then
	self.player:keypressed(k)
	if k == 'x' then
		self.stats.rocks = self.stats.rocks+self.quota
		self.stats.rocksRound = self.quota
		print(self.stats.rocks,self.stats.rocksRound)
		self.rocks = {}
	elseif k == 'm' then
		love.audio.rewind(self.music)
		love.audio.play(self.music)
	elseif k == 'M' then
		love.audio.setVolume(math.abs(love.audio.getVolume()-1))
	elseif k == 'escape' then
		love.graphics.setCanvas(self.canvases.pauseBuffer)
			love.draw()
		love.graphics.setCanvas()
		screen:clearEffects()
		self.pause = 3
		love.audio.pause()
		love.audio.rewind(self.sounds.tock)
		love.audio.play(self.sounds.tock)
	elseif k == 'backspace' then
		self.player.members.a.hp = 0
		self.player.members.b.hp = 0
	end
elseif self.pause == 2 then
	if k == 'escape' or k == 'return' or k =='lshift' then
		self.pause = 1
		love.audio.resume()
		love.audio.rewind(self.sounds.tock)
		love.audio.play(self.sounds.tock)
	end
elseif self.pause == 3 then
	if k == 'w' or k == 'up' then
		if self.menuIndex > 1 then
			self.menuIndex = self.menuIndex-1
			love.audio.rewind(self.sounds.click)
			love.audio.play(self.sounds.click)
		else
			screen:shake(.15,2,false)
			love.audio.rewind(self.sounds.distort)
			love.audio.play(self.sounds.distort)
		end
	elseif k == 's' or k == 'down' then
		if self.menuIndex < #self.menu then
			self.menuIndex = self.menuIndex+1
			love.audio.rewind(self.sounds.click)
			love.audio.play(self.sounds.click)
		else
			screen:shake(.15,2,false)
			love.audio.rewind(self.sounds.distort)
			love.audio.play(self.sounds.distort)
		end
	elseif k == 'return' or k =='lshift' then
		if self.menu[self.menuIndex] == 'Continue' then
			love.audio.resume()
			self.pause = 1
		elseif self.menu[self.menuIndex] == 'Restart' then
			screen:shake(.15,2,false)
			state = game.make()
		elseif self.menu[self.menuIndex] == 'Exit to Menu' then
			screen:shake(.15,2,false)
			state = mainmenu.make(true)
		elseif self.menu[self.menuIndex] == 'Resign' then
			print("You lasted "..self.round.." rounds.")
			print("Player 1 had "..self.player.members.a.points.." points.")
			print("Player 2 had "..self.player.members.b.points.." points.")
			state = heaven.make(self.player,self.round,self.stats.rocks,self.stats.enemies,self.time.elapsed,self.name1,self.name2)
		end
	elseif k == 'escape' then
		self.pause = 1
		love.audio.resume()
		love.audio.rewind(self.sounds.tock)
		love.audio.play(self.sounds.tock)
	end
end
end