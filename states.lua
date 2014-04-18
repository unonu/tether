
intro = {}
intro.__index = intro

function intro.make(dt)
	local i = {}
	setmetatable(i,intro)
	i.slides = {res.load("image","orea.png"),}
	i.slide = 1
	i.timerUp = 0
	i.timerDown = dt or 80
	i.delay = dt or 80
	i.alpha = 0
	i.dt = dt or 80
	return i
end

function intro:update(dt)
	if self.timerUp < self.dt then
		self.timerUp = self.timerUp + 1
		self.alpha = self.timerUp
	elseif self.delay > 0 then
		self.delay = self.delay - 1
	elseif self.timerDown > 0 then
		self.timerDown = self.timerDown - 1
		self.alpha = self.timerDown
	else
		self.timerUp = 0
		self.timerDown = self.dt
		self.delay = self.dt
		self.slide = self.slide + 1
	end
end

function intro:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle('fill',0,0,screen.width,screen.height)
	if self.slide <= #self.slides then
		love.graphics.setColor(255*self.alpha/self.dt,255*self.alpha/self.dt,255*self.alpha/self.dt,255*self.alpha/self.dt)
		love.graphics.draw(self.slides[self.slide],screen:getCentre('x')-(self.slides[self.slide]:getWidth()/2),screen:getCentre('y')-(self.slides[self.slide]:getHeight()/2))
	else
		love.timer.sleep(1)
		state = mainmenu.make()
	end
	love.graphics.curve(64,64,24,0,math.pi,16)
end

function intro:keypressed(k)
	state = mainmenu.make()
end
function intro:mousepressed(x,y,button)
	state = mainmenu.make()
end

mainmenu = {}
mainmenu.__index = mainmenu

function mainmenu.make(ready)
	love.graphics.setFont(fonts.large)
	love.audio.stop()
	local m = {}
	setmetatable(m,mainmenu)
	m.menu = {"Arcade","Options","Credits","Exit"}
	m.menuIndex = 1
	m.colors = {r=255,g=0,b=0}
	m.timers = {fader = 120,
				screenR = screen.width,
				gameFade = {100,100,100,100,100,100},
				idle = 0,
				bg = screen.width,
				tetherRise = (screen.height/2)-16,
				}
	m.res = {bg = res.load("image","titleArt.png"),}
	m.ready = ready or false

	return m
end

function mainmenu:update(dt)
if self.ready then
	if self.timers.screenR > 0 then
		self.timers.screenR = self.timers.screenR - (self.timers.screenR/16)
		if self.timers.screenR < screen.width*3/4 and self.timers.bg > 0 then
			-- self.timers.bg = self.timers.bg - (self.timers.bg/24)
			self.timers.bg = math.max(0,self.timers.bg-64)
			if self.timers.bg == 0 then
				screen:flash(1,20,{255,255,255},'full')
			end
		end
	end
	if self.timers.tetherRise > 0 then
		self.timers.tetherRise = self.timers.tetherRise - (self.timers.tetherRise/16)
	end
else
	for i =1,6 do
		if i == 1 then
			if self.timers.gameFade[i] > 0 then
				self.timers.gameFade[i] = self.timers.gameFade[i] - (self.timers.gameFade[i]/12)
			end
		else
			if self.timers.gameFade[i-1] < 60 and self.timers.gameFade[i] > 0 then
				self.timers.gameFade[i] = self.timers.gameFade[i] - (self.timers.gameFade[i]/12)
			end
		end
	end
	
end
	self.timers.idle = self.timers.idle + 1
	if self.timers.idle > 3600 then state = intro.make() end
end

function mainmenu:draw()
if self.ready then
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	love.graphics.draw(self.res.bg,self.timers.bg,-self.timers.bg*4/7)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(0,0,0)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.printf(m,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
	end

		love.graphics.translate(0,96)
		love.graphics.setColor(0,0,0)
	love.graphics.print('Tether',(screen.width/2)-90,self.timers.tetherRise)
		love.graphics.translate(0,-96)

	if self.timers.screenR > 0 then
			love.graphics.setColor(0,0,0)
		love.graphics.circle("fill",screen.width,screen.height,self.timers.screenR,self.timers.screenR)
	end
else
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	local xy = screen:getCentre()
		love.graphics.setColor(255,255,255)
	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
	local frac = (100-self.timers.gameFade[1])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('T',(screen.width/2)-90+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[2])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)-50+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[3])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('t',(screen.width/2)-22+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[4])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('h',(screen.width/2)+6+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[5])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)+34+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[6])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('r',(screen.width/2)+62+_x,-16+_y + ((screen.height/2)*frac))
end
end

function mainmenu:keypressed(k)
	if k ~= 'escape' then -- This is sorta messy
		if self.ready then
			if k == 'w' or k == 'up' then
				if self.menuIndex > 1 then
					self.menuIndex = self.menuIndex-1
				end
			elseif k == 's' or k == 'down' then
				if self.menuIndex < #self.menu then
					self.menuIndex = self.menuIndex+1
				end
			elseif k == 'return' or k =='lshift' or k == 'kp0' then
				if self.menu[self.menuIndex] == 'Arcade' then
					love.graphics.clear()
					love.graphics.setColor(0,0,0)
					love.graphics.rectangle('fill',0,0,screen.width,screen.height)
					state = game.make()
				elseif self.menu[self.menuIndex] == 'Options' then
					state = options.make()
				elseif self.menu[self.menuIndex] == 'Credits' then
					state = credits.make()
				elseif self.menu[self.menuIndex] == 'Exit' then
					love.event.quit()
				end
			end
		end
		self.ready = true
	else
		if self.ready then
			self.ready = false
			self.timers.fader = 120
			self.timers.screenR = screen.width
			self.timers.gameFade = {100,100,100,100,100,100}
			self.timers.bg = screen.width
			self.timers.tetherRise = (screen.height/2)-16
			screen:clearEffects('flash')
		else
			love.event.quit()
		end
	end
	self.timers.idle = 0
end

options = {}
options.__index = options

function options.make()
	screen:clearEffects('flash')
	local o = {}
	setmetatable(o,options)
	o.menu = {"Fullscreen","Music","Back"}
	o.timers = {}
	o.menuIndex = 1
	o.timers = {}
		o.timers.fader = 120
		o.timers.screenR = 0
		o.timers.screenR = 0
		o.timers.colors = {r=255,g=0,b=0}
		o.timers.screenR = 0

	return o
end

function options:update(dt)
	if self.timers.screenR < screen.width then
		self.timers.screenR = self.timers.screenR + (((screen.width)-self.timers.screenR)/16)
	end
	if self.timers.colors.r > 0 and self.timers.colors.g < 255 and self.timers.colors.b == 0 then
		self.timers.colors.r = self.timers.colors.r -1
		self.timers.colors.g = self.timers.colors.g +1
	elseif self.timers.colors.r == 0 and self.timers.colors.g > 0 and self.timers.colors.b < 255 then
		self.timers.colors.g = self.timers.colors.g -1
		self.timers.colors.b = self.timers.colors.b +1
	elseif self.timers.colors.r < 255 and self.timers.colors.g == 0 and self.timers.colors.b > 0 then
		self.timers.colors.b = self.timers.colors.b -1
		self.timers.colors.r = self.timers.colors.r +1
	end
end

function options:draw()
	if self.timers.screenR < screen.width then
			love.graphics.setColor(self.timers.colors.r,self.timers.colors.g,self.timers.colors.b)
		love.graphics.circle("fill",screen:getCentre('x'),screen:getCentre('y'),self.timers.screenR,self.timers.screenR)
	end
	local autxt = ''
	if love.audio.getVolume() == 1 then
			autxt = ' is ON'
	else
			autxt = ' is OFF'
	end
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(128,128,128)
		end
		if m ==  'Music' then
			love.graphics.printf(m..autxt,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
		else
			love.graphics.printf(m,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
		end
	end
end

function options:keypressed(k)
	if k ~= 'escape' then
	self.ready = true
		if k == 'w' or k == 'up' then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
			end
		elseif k == 's' or k == 'down' then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
			end
		elseif k == 'return' or k =='lshift' or k == 'kp0' then
			if self.menu[self.menuIndex] == 'Fullscreen' then
				screen.toggleFullscreen()
			elseif self.menu[self.menuIndex] == 'Music' then
				love.audio.setVolume(math.abs(love.audio.getVolume()-1))
				print(love.audio.getVolume())
			elseif self.menu[self.menuIndex] == 'Back' then
				state = mainmenu.make(true)
			end
		end
	else
		state = mainmenu.make(true)
	end
end

game = {}
game.__index = game

function game.make(name1,name2)
	screen:clearEffects('flash')
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
		pauseCanvas = love.graphics.newCanvas(),
	}
	g.res = {	bullet = res.load("sprite","shot.png"),
				crystal = res.load("sprite","point.png"),
				target = res.load("sprite","target.png"),
				scoreBoardA = res.load("image","scoreboardBack.png"),
				scoreBoardB = res.load("image","scoreboardFront.png"),
				background = res.load("image","greyField.png"),
				healthbar = res.load("image","healthbar.png"),
				itemRing = res.load("image","itemRing.png"),
				health = res.load("sprite","health.png"),
			}
	g.sounds = {collect = res.load("sound","collect"),
				explosion = res.load("sound","explosion"),
			}
	g.music = res.load("music","music")
	g.music:rewind()
	g.music:play()

	g.pause = 1
	g.menu = {"Continue","Restart","Resign","Exit to Menu"}
	g.menuIndex = 1

	g.rocks = {}

	g.drops = {}

	screen:setBackground(g.res.background)
	messages:clear()
	messages:new("START!",screen:getCentre('x'),screen:getCentre('y'),"still",2,{255,255,255},'boomLarge')
	g.time = {elapsed = 0,
				startTime = love.timer.getTime(),
				hours = 0,
				minutes = 0,
				seconds = 0,
			}

	g.timers = {intro = {0,1,"state.timers.intro[1] = (state.timers.intro[1] + (state.timers.intro[2]-state.timers.intro[1])/24)"}}
	
	return g
end

function game:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.res.background,0,0,0,screen.width/1280,screen.height/720)

if self.pause == 1 then
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

		--items

		-- love.graphics.push()
		-- love.graphics.translate(-10,screen.height-116)
		-- for i=1,5 do
		-- 	if self.player.members.a.items[i] then
		-- 		love.graphics.setColor(255,255,255)
		-- 	else
		-- 		love.graphics.setColor(255,255,255,128)
		-- 	end
		-- 	if i < 3 then
		-- 		love.graphics.draw(self.res.itemRing,i*58,0)
		-- 	else
		-- 		love.graphics.draw(self.res.itemRing,(i*58)-145,58)
		-- 	end
		-- end
		love.graphics.pop()
		if self.cinematic then
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill",0,0,screen.width,86)
			love.graphics.rectangle("fill",0,screen.height-86,screen.width,86)
		end
elseif self.pause == 2 then
	local xy = screen:getCentre()
		love.graphics.setColor(self.pc.r,self.pc.g,self.pc.b)

	love.graphics.draw(self.canvases.pauseCanvas)

	--------------
	self.player:drawMember(self.player.members.a,150,150,'Large')
	self.player:drawMember(self.player.members.b,screen.width-150,screen.height-150,'Large')
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
		love.graphics.setColor(self.pc.r,self.pc.g,self.pc.b)
	love.graphics.draw(self.canvases.pauseCanvas)	
	--------------
		love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,xy[2]-((#self.menu/2)*72)-16,screen.width*(self.pc.timer/30),((#self.menu)*72))
	love.graphics.stippledLine(screen.width,xy[2]-((#self.menu/2)*72)-32,screen.width - screen.width*(self.pc.timer/30),xy[2]-((#self.menu/2)*72)-32,12,12)
	love.graphics.stippledLine(screen.width,xy[2]+((#self.menu/2)*72),screen.width - screen.width*(self.pc.timer/30),xy[2]+((#self.menu/2)*72),12,12)
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(fonts.large)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.printf(m,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
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
	self.pc.timer = 0
else
	if self.pc.r > 0 and self.pc.g < 255 and self.pc.b == 0 then
		self.pc.r = self.pc.r -1
		self.pc.g = self.pc.g +1
	elseif self.pc.r == 0 and self.pc.g > 0 and self.pc.b < 255 then
		self.pc.g = self.pc.g -1
		self.pc.b = self.pc.b +1
	elseif self.pc.r < 255 and self.pc.g == 0 and self.pc.b > 0 then
		self.pc.b = self.pc.b -1
		self.pc.r = self.pc.r +1
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
		love.graphics.setCanvas(self.canvases.pauseCanvas)
			self:draw()
		love.graphics.setCanvas()
		self.pause = 3
		love.audio.pause()
	elseif k == 'backspace' then
		self.player.members.a.hp = 0	
		self.player.members.b.hp = 0	
	end
elseif self.pause == 2 then
	if k == 'escape' or k == 'return' or k =='lshift' then
		self.pause = 1
		love.audio.resume()
	end
elseif self.pause == 3 then
	if k == 'w' or k == 'up' then
		if self.menuIndex > 1 then
			self.menuIndex = self.menuIndex-1
			screen:shake(.15,2,false)
		end
	elseif k == 's' or k == 'down' then
		if self.menuIndex < #self.menu then
			self.menuIndex = self.menuIndex+1
			screen:shake(.15,2,false)
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
	end
end
end

heaven = {}
heaven.__index = heaven

function heaven.make(player,rounds,rocks,enemies,time,name1,name2)
	love.graphics.setFont(fonts.large)
	love.audio.stop()
	love.keyboard.setKeyRepeat(true)
	messages:clear()
	local h = {}
	setmetatable(h,heaven)
	h.player = player
	h.player.members.a.spawned = true
	h.player.members.b.spawned = true
	h.grabPlayer = true
	h.screen = love.graphics.newCanvas()
		--
		love.graphics.setCanvas(h.screen)
		love:draw()
		love.graphics.setCanvas()
	screen:clearEffects()
	screen:shake(.8,3)
	h.winner = 'a'
	h.loser = 'b'
	h.tie = false
	if player.members.a.points > player.members.b.points then
		h.winner = 'a'; h.loser = 'b'
	elseif player.members.a.points > player.members.b.points then
		h.winner = 'b'; h.loser = 'a'
	else
		h.tie = true
	end
	h.rocks = rocks
	h.rounds = rounds
	h.enemies = enemies
	h.time = time
	h.ready = false
	h.menu = {"Restart","Main Menu"}
	h.menuIndex = 1
	h.name = "      "
	h.characters = {{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					}
	h.winnerName = {1,1,1}
	h.loserName = {1,1,1}
	if name1 and h.winner == 'a' then
		h.winnerName = name1
		h.loserName = name2
	elseif name1 and h.winner == 'b' then
		h.winnerName = name2
		h.loserName = name1
	end
	h.winnerIndex = 1
	h.loserIndex = 1
	h.winnerConfirm = false
	h.loserConfirm = false
	h.confirm = false

	h.timers = {slideWinner = {0,0,0,20},
				slideLoser = {0,0,0,20},
				gameFade = {100,100,100,100,100,100,100,100,100},
				wY = screen.height,
				lY = 0,
				winnerFlyin = 1,
				loserFlyin = -1,
				pc = {r=0,g=0,b=255,timer = 0},}

	if not love.filesystem.exists("records/highScores.txt") then
		print("No high scores found. Making")
		h.record = love.filesystem.newFile("records/highScores.txt",'w')
		h.record:write("#high scores\n#name|points|points|lives|lives|rounds|rocks|enemies")
		h.record:close()
	end
	h.record = "records/highScores.txt"
	h.scores = {}

	h.res = {grad = res.load("image","healthbar.png"),}

	return h
end

function heaven:draw()
if self.ready and (not self.confirm or self.timers.winnerFlyin > -1.5) then
		love.graphics.setColor(24,24,24)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	
		love.graphics.setFont(fonts.large)
		love.graphics.push()
		love.graphics.translate((screen.width/2)-96,screen.height/2)

	--confirm tether
		love.graphics.setColor(math.random(14,77),math.random(59,155),255)
	if self.winnerConfirm or self.timers.winnerFlyin < -0.1 then
		love.graphics.draw(self.res.grad,-64,44,-math.pi/2,48,16)
	end
	if self.loserConfirm or self.timers.winnerFlyin < -0.1 then
		love.graphics.draw(self.res.grad,256,-4,math.pi/2,48,16)
	end

	--winner
		love.graphics.setColor(255,255,255)
	if not self.winnerConfirm then
		love.graphics.setColor(128,128,128,128)
	love.graphics.print(self.characters[1][math.loop(1,self.winnerName[1] + 1,#self.characters[1])],0,20+self.timers.slideWinner[1])
	love.graphics.print(self.characters[1][math.loop(1,self.winnerName[1] - 1,#self.characters[1])],0,-20+self.timers.slideWinner[1])

	love.graphics.print(self.characters[2][math.loop(1,self.winnerName[2] + 1,#self.characters[2])],32,20+self.timers.slideWinner[2])
	love.graphics.print(self.characters[2][math.loop(1,self.winnerName[2] - 1,#self.characters[2])],32,-20+self.timers.slideWinner[2])

	love.graphics.print(self.characters[3][math.loop(1,self.winnerName[3] + 1,#self.characters[3])],64,20+self.timers.slideWinner[3])
	love.graphics.print(self.characters[3][math.loop(1,self.winnerName[3] - 1,#self.characters[3])],64,-20+self.timers.slideWinner[3])

		love.graphics.setColor(255,255,255,128)
		love.graphics.rectangle("fill",((self.winnerIndex-1)*32),42,28,4)
		love.graphics.setColor(unpack(self.player.members[self.winner].color))
	end
	love.graphics.draw(self.player.imageLarge,res.quads["playerLarge2"],-64,16+((screen.height/2)*self.timers.winnerFlyin),0,.5,.5,144,144)
	love.graphics.print(self.characters[1][self.winnerName[1]],0,0+self.timers.slideWinner[1])
	love.graphics.print(self.characters[2][self.winnerName[2]],32,0+self.timers.slideWinner[2])
	love.graphics.print(self.characters[3][self.winnerName[3]],64,self.timers.slideWinner[3])


	--loser
		love.graphics.setColor(255,255,255)
	if not self.loserConfirm then
		love.graphics.setColor(128,128,128,128)
	love.graphics.print(self.characters[4][math.loop(1,self.loserName[1] + 1,#self.characters[1])],96,20+self.timers.slideLoser[1])
	love.graphics.print(self.characters[4][math.loop(1,self.loserName[1] - 1,#self.characters[1])],96,-20+self.timers.slideLoser[1])

	love.graphics.print(self.characters[5][math.loop(1,self.loserName[2] + 1,#self.characters[2])],128,20+self.timers.slideLoser[2])
	love.graphics.print(self.characters[5][math.loop(1,self.loserName[2] - 1,#self.characters[2])],128,-20+self.timers.slideLoser[2])

	love.graphics.print(self.characters[6][math.loop(1,self.loserName[3] + 1,#self.characters[3])],160,20+self.timers.slideLoser[3])
	love.graphics.print(self.characters[6][math.loop(1,self.loserName[3] - 1,#self.characters[3])],160,-20+self.timers.slideLoser[3])
		
		love.graphics.setColor(255,255,255,128)
		love.graphics.rectangle("fill",96+((self.loserIndex-1)*32),42,28,4)
		love.graphics.setColor(unpack(self.player.members[self.loser].color))
	end
	love.graphics.draw(self.player.imageLarge,res.quads["playerLarge2"],256,16+((screen.height/2)*self.timers.loserFlyin),-math.pi,.5,.5,144,144)
	love.graphics.print(self.characters[4][self.loserName[1]],96,0+self.timers.slideLoser[1])
	love.graphics.print(self.characters[5][self.loserName[2]],128,0+self.timers.slideLoser[2])
	love.graphics.print(self.characters[6][self.loserName[3]],160,self.timers.slideLoser[3])

		love.graphics.pop()
elseif self.ready and self.confirm then	
		love.graphics.setFont(fonts.large)
		love.graphics.push()
		love.graphics.translate((screen.width/2),8)

		--name
		love.graphics.setColor(self.timers.pc.r,self.timers.pc.g,self.timers.pc.b)
		local tag = findScore(self.scores,#self.scores)..". "..self.name.." "..(self.player.members.a.points + self.player.members.b.points)
		love.graphics.print(tag,-fonts.large:getWidth(tag)/2,0)

		love.graphics.pop()

		love.graphics.push()
		love.graphics.translate(0,62)
	drawScores(self.scores,15,self.timers.pc.r,self.timers.pc.g,self.timers.pc.b)
		love.graphics.pop()

	love.graphics.setColor(0,0,0,220)
	love.graphics.rectangle("fill",0,screen.height-36,screen.width,36)
	local x = 12
		love.graphics.setFont(fonts.medium)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.print(m,0+x,screen.height-34)
		x = x+love.graphics.getFont():getWidth(m)+24
	end
	if self.timers.pc.r > 0 and self.timers.pc.g < 255 and self.timers.pc.b == 0 then
		self.timers.pc.r = self.timers.pc.r -1
		self.timers.pc.g = self.timers.pc.g +1
	elseif self.timers.pc.r == 0 and self.timers.pc.g > 0 and self.timers.pc.b < 255 then
		self.timers.pc.g = self.timers.pc.g -1
		self.timers.pc.b = self.timers.pc.b +1
	elseif self.timers.pc.r < 255 and self.timers.pc.g == 0 and self.timers.pc.b > 0 then
		self.timers.pc.b = self.timers.pc.b -1
		self.timers.pc.r = self.timers.pc.r +1
	end
	if self.timers.pc.timer < 30 then self.timers.pc.timer = self.timers.pc.timer +1 end

elseif not self.ready then

	local frac = (100-self.timers.gameFade[1])/100

	-- love.graphics.setColor(255,0,0)
	-- love.graphics.draw(self.screen)

	love.graphics.setColor(0,0,0)
	love.graphics.circle("fill",screen:getCentre('x'),screen:getCentre('y'),screen.width*frac,36)

	love.graphics.setShader(shaders.monochrome)
	self.player:draw()
	love.graphics.setShader()

	love.graphics.setFont(fonts.large)

	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('G',(screen.width/2)-142+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[2])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('a',(screen.width/2)-102+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[3])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('m',(screen.width/2)-74+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[4])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)-38+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[5])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print(' ',(screen.width/2)-10+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[6])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('O',(screen.width/2)+18+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[7])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('v',(screen.width/2)+58+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[8])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)+86+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[9])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('r',(screen.width/2)+114+_x,-16+_y + ((screen.height/2)*frac))

end
end

function heaven:update(dt)
if self.ready then
if not self.confirm then
	if self.timers.winnerFlyin > 0 then self.timers.winnerFlyin = self.timers.winnerFlyin - .1 end
	if self.timers.loserFlyin < 0 then self.timers.loserFlyin = self.timers.loserFlyin + .1 end

	for i = 1, 3 do
		if self.timers.slideWinner[i] > 0 then self.timers.slideWinner[i] = self.timers.slideWinner[i] - 2
		elseif self.timers.slideWinner[i] < 0 then self.timers.slideWinner[i] = self.timers.slideWinner[i] + 2 end
		if self.timers.slideLoser[i] > 0 then self.timers.slideLoser[i] = self.timers.slideLoser[i] - 2
		elseif self.timers.slideLoser[i] < 0 then self.timers.slideLoser[i] = self.timers.slideLoser[i] + 2 end
	end

	self.winnerConfirm = love.keyboard.isDown(self.player.members[self.winner].keys.tether)
	self.loserConfirm = love.keyboard.isDown(self.player.members[self.loser].keys.tether)
	self.confirm = (self.winnerConfirm and self.loserConfirm)

	if self.confirm then
		self.winnerConfirm = false
		self.loserConfirm = false
		self.name = self.characters[1][self.winnerName[1]]..self.characters[2][self.winnerName[2]]..self.characters[3][self.winnerName[3]]..
						self.characters[4][self.loserName[1]]..self.characters[5][self.loserName[2]]..self.characters[6][self.loserName[3]]
		local toAppend = ('\n'..self.name.."|"..self.player.members[self.winner].points.."|"..self.player.members[self.loser].points.."|"..
							self.player.members[self.winner].lives.."|"..self.player.members[self.loser].lives.."|"..
							self.rounds.."|"..self.rocks.."|"..self.enemies.."|"..self.time)
		print("Adding score to record.")
		love.filesystem.append(self.record,toAppend)
		self.scores = loadScores(self.record)
		table.sort(self.scores,sortScoresCombo)
		love.keyboard.setKeyRepeat(false)
	end
else
	if self.timers.winnerFlyin > -1.5 then self.timers.winnerFlyin = self.timers.winnerFlyin - .1 end
	if self.timers.loserFlyin < 1.5 then self.timers.loserFlyin = self.timers.loserFlyin + .1 end

	if self.winnerConfirm or self.loserConfirm then
		if self.menu[self.menuIndex] == 'Restart' then
			screen:shake(.15,2)
			if self.winner == 'a' then
				state = game.make(self.winnerName,self.loserName)
			else
				state = game.make(self.loserName,self.winnerName)
			end
		elseif self.menu[self.menuIndex] == 'Main Menu' then
			state = mainmenu.make(true)
		end
	end
end
else
	for i =1,9 do
		if i == 1 then
			if self.timers.gameFade[i] > 0 then
				self.timers.gameFade[i] = self.timers.gameFade[i] - (self.timers.gameFade[i]/12)
			end
		else
			if self.timers.gameFade[i-1] < 60 and self.timers.gameFade[i] > 0 then
				self.timers.gameFade[i] = self.timers.gameFade[i] - (self.timers.gameFade[i]/12)
			end
		end
	end
end
end

function heaven:keypressed(k)
if self.ready and not self.confirm then
	--choose the name column to edit or the menu item
	if k == self.player.members[self.winner].keys.right and not self.winnerConfirm then
			if self.winnerIndex < 3 then self.winnerIndex = self.winnerIndex + 1 end
	elseif k == self.player.members[self.winner].keys.left and not self.winnerConfirm then
			if self.winnerIndex > 1 then self.winnerIndex = self.winnerIndex - 1 end
	elseif k == self.player.members[self.loser].keys.right and not self.loserConfirm then
			if self.loserIndex < 3 then self.loserIndex = self.loserIndex + 1 end
	elseif k == self.player.members[self.loser].keys.left then
			if self.loserIndex > 1 then self.loserIndex = self.loserIndex - 1 end
	--choose the character for the name column
	elseif k == self.player.members[self.winner].keys.up and not self.winnerConfirm then
			self.winnerName[self.winnerIndex] = math.loop(1,self.winnerName[self.winnerIndex] - 1,#self.characters[self.winnerIndex])
			self.timers.slideWinner[self.winnerIndex] = -self.timers.slideWinner[4]
			screen:shake(.15,2)
	elseif k == self.player.members[self.winner].keys.down and not self.winnerConfirm then
			self.winnerName[self.winnerIndex] = math.loop(1,self.winnerName[self.winnerIndex] + 1,#self.characters[self.winnerIndex])
			self.timers.slideWinner[self.winnerIndex] = self.timers.slideWinner[4]
			screen:shake(.15,2)
	elseif k == self.player.members[self.loser].keys.up and not self.loserConfirm then
			self.loserName[self.loserIndex] = math.loop(1,self.loserName[self.loserIndex] - 1,#self.characters[self.loserIndex+3])
			self.timers.slideLoser[self.loserIndex] = -self.timers.slideLoser[4]
			screen:shake(.15,2)
	elseif k == self.player.members[self.loser].keys.down and not self.loserConfirm then
			self.loserName[self.loserIndex] = math.loop(1,self.loserName[self.loserIndex] + 1,#self.characters[self.loserIndex+3])
			self.timers.slideLoser[self.loserIndex] = self.timers.slideLoser[4]
			screen:shake(.15,2)
	end
elseif self.ready and self.confirm then
	if k == self.player.members[self.winner].keys.right then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.winner].keys.left then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.loser].keys.right then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.loser].keys.left then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.winner].keys.tether then
		self.winnerConfirm = not self.winnerConfirm
	elseif k == self.player.members[self.loser].keys.tether then
		self.loserConfirm = not self.loserConfirm
	end
else
	if self.timers.gameFade[9] < .01 then
		self.ready = true
	end
end
end

credits = {}
credits.__index = credits

function credits.make()
	screen:clearEffects('flash')
	local c = {}
	setmetatable(c,credits)
	c.offset = screen.height
	c.credits = {}
	local file = "res/credits/credits.txt"
	local y = 0
	for l in love.filesystem.lines(file) do
		if l:sub(1,2) == '#!' then
			love.graphics.setFont(fonts[l:sub(3)])
			table.insert(c.credits,{l,0,0})
		else
			table.insert(c.credits,{l,love.graphics.getFont():getWidth(l),y})
			y = y + love.graphics.getFont():getHeight(l) + 4
		end
	end

	c.particles = {}
	c.files = {}
	local t = love.filesystem.getDirectoryItems("res/sprites/")
	local removed = 0
	for i,f in ipairs(t) do
		if f:sub(-4) == ".png" then
			table.insert(c.files,f)
		end
	end

	return c
end

function credits:draw()
	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	love.graphics.setColor(255,255,255)

	for i,o in ipairs(self.particles) do
		love.graphics.setColor(128,128,128,o[8])
		love.graphics.draw(o[1],o[2],o[3],o[6],o[4],o[4],o[1]:getWidth()/2,o[1]:getHeight()/2)
		if o[3]-o[1]:getHeight()/2 > screen.height then table.remove(self.particles,i) end
		o[3] = o[3]+o[5]
		o[6] = o[6]-o[7]
	end

	love.graphics.setColor(255,255,255)
	for i,l in ipairs(self.credits) do
		if l[1]:sub(1,2) == '#!' then
			love.graphics.setFont(fonts[l[1]:sub(3)])
		elseif l[1]:sub(1,2) == '#?' then
			love.graphics.setColor(unpack(hexToCol(l[1]:sub(3))))
		else
			love.graphics.print(l[1],screen:getCentre('x')-(l[2]/2),self.offset + l[3])
		end
	end

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(fonts.small)
	love.graphics.print("Questions, complaints or suggestions should be directed to unonuorea@gmail.com",4,screen.height-24)
end

function credits:update(dt)
	if self.offset + self.credits[#self.credits][3] > -24 then
		-- state = mainmenu.make(true)
	self.offset = self.offset - 1
	end

	local i = math.random()
	if math.random(0,40) == 40 then
		-- makes random sprites: image,x,y,fall speed,scale,rotation,direction/speed,alpha
		local o = {res.load("sprite",self.files[math.random(1,#self.files)]),math.random(0,screen.width),0,i,i/2,0,i*math.pi/100*math.rsign(),math.random(64,196)}
		o[3] = -o[1]:getHeight()
		table.insert(self.particles,o)
	end

end

function credits:keypressed(k)
	state = mainmenu.make(true)
end