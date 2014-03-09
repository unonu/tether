
intro = {}
intro.__index = intro

function intro.make(dt)
	local i = {}
	setmetatable(i,intro)
	i.slides = {res.load("image","orea.png"),}
	i.slide = 1
	i.timerUp = 0
	i.timerDown = dt
	i.delay = dt
	i.alpha = 0
	i.dt = dt
--print("slide 1")
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
	local m = {}
	setmetatable(m,mainmenu)
	m.menu = {"Start","Options","Credits","Quit"}
	m.menuIndex = 1
	m.colors = {r=255,g=0,b=0}
	m.timers = {fader = 120,
				screenR = screen.width,
				gameFade = {100,100,100,100,100,100,100},
				}
	love.graphics.setFont(fonts.large)
	love.audio.stop()

	m.ready = ready or false

	return m
end

function mainmenu:update(dt)
if self.ready then
	if self.timers.screenR > 0 then
		self.timers.screenR = self.timers.screenR - (self.timers.screenR/16)
	end
else
	for i =1,7 do
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

function mainmenu:draw()
if self.ready then
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(0,0,0)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.printf(m,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
	end
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
	-- love.graphics.printf("Tether",_x,-16+xy[2]+_y,screen.width,'center')local frac = (100-self.timers.gameFade[1])/100
	local frac = (100-self.timers.gameFade[1])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('T',(screen.width/2)-140+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[2])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)-100+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[3])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('t',(screen.width/2)-72+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[4])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('h',(screen.width/2)-36+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[5])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)-8+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[6])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('r',(screen.width/2)+22+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[7])/100
		love.graphics.setColor(255,255,255,255*frac)
end
end

function mainmenu:keypressed(k)
	if k ~= 'escape' then -- This is sorta messy
		if self.ready then
			if k == 'up' then
				if self.menuIndex > 1 then
					self.menuIndex = self.menuIndex-1
					screen:shake(.15,2)
				end
			elseif k == 'down' then
				if self.menuIndex < #self.menu then
					self.menuIndex = self.menuIndex+1
					screen:shake(.15,2)
				end
			elseif k == 'return' then
				if self.menu[self.menuIndex] == 'Start' then
					love.graphics.clear()
					screen:shake(.15,2)
					love.graphics.setColor(0,0,0)
					love.graphics.rectangle('fill',0,0,screen.width,screen.height)
					state = game.make()
				elseif self.menu[self.menuIndex] == 'Options' then
					state = options.make()
				elseif self.menu[self.menuIndex] == 'Credits' then
					state = credits.make()
				elseif self.menu[self.menuIndex] == 'Quit' then
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
			self.timers.gameFade = {100,100,100,100,100,100,100}
		else
			love.event.quit()
		end
	end
end

options = {}
options.__index = options

function options.make()
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
		if k == 'up' then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
				screen:shake(.15,2)
			end
		elseif k == 'down' then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
				screen:shake(.15,2)
			end
		elseif k == 'return' then
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

function game.make()
	local g = {}
	setmetatable(g,game)
	g.player = player.make(0)
	g.grabPlayer = false
	g.distance = 100
	g.quota = 8
	g.points = 0
	g.crystals = {}
	g.enemies = {}
	g.bullets = {}
	g.explosions = {}
	g.round = 1
	g.stats = {rocks = 0, enemies = 0, rocksRound = 0}
	g.pc = {r=255,g=0,b=0,timer = 0}
	g.canvases = {
		pauseBlur = love.graphics.newCanvas(),
		pauseCanvas = love.graphics.newCanvas(),
	}
	g.res = {	bullet = res.load("sprite","shot.png"),
				crystal = res.load("sprite","point.png"),
				target = res.load("sprite","target.png"),
				scoreBoardA = res.load("image","scoreboardBack.png"),
				scoreBoardB = res.load("image","scoreboardFront.png"),
				background = res.load("image","greyField.png"),
				healthbar = res.load("image","healthbar.png"),
			}
	g.sounds = {collect = res.load("sound","collect"),
				explosion = res.load("sound","explosion"),
			}
	g.music = res.load("music","music")
	g.music:rewind()
	g.music:play()

	g.pause = 1
	g.menu = {"Continue","Restart","Exit to Menu","Quit"}
	g.menuIndex = 1

	g.rocks = {}
	for i=1, 8 do
		table.insert(g.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100)))
	end

	screen:setBackground(g.res.background)
	messages:clear()
	messages:new("START!",screen:getCentre('x'),screen:getCentre('y'),"still",2,{255,255,255})
	
	return g
end

function game:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.res.background,0,0,0,screen.width/1280,screen.height/720)

	--round
	love.graphics.setColor(255,255,255,200)
	love.graphics.setFont(fonts.roundNumbers)
	love.graphics.print(self.round,screen:getCentre('x')-(fonts.roundNumbers:getWidth(self.round)/2),
		screen:getCentre('y')-(fonts.roundNumbers:getWidth(self.round)/2))

if self.pause == 1 then
	love.graphics.setFont(fonts.small)
	--------------------------------
	for i,r in ipairs(self.rocks) do
		r:draw()
	end
	
	for i,c in ipairs(self.crystals) do
		c:draw()
	end
		love.graphics.setColor(255,0,0)
	for i,e in ipairs(self.enemies) do
		e:draw()
	end
	
	self.player:draw()

	for i,b in ipairs(self.bullets) do
		love.graphics.setColor(255,math.random(0,2)*128,math.random(0,255))
		b:draw()
	end
	
	for i, p in ipairs(particles) do
		love.graphics.draw(p)
	end
	----------------------
	messages:draw()

--	for i,p in ipairs(self.player) do
			love.graphics.setColor(255,255,255)
		love.graphics.draw(self.res.scoreBoardA)
		love.graphics.setFont(fonts.small)

		--hp
			love.graphics.setColor(self.player.members.a.color)
		love.graphics.rectangle("fill",0,screen.height-12,self.player.members.a.hp/self.player.members.a.stats.hp*screen.width/2,12)
			love.graphics.setColor(self.player.members.b.color)
		love.graphics.rectangle("fill",screen.width,screen.height-12,-self.player.members.b.hp/self.player.members.b.stats.hp*screen.width/2,12)

			love.graphics.setColor(255,255,255)
		for i=1,self.player.members.a.lives do
			love.graphics.circle("fill",0+12*i,6,5,4)
		end
		for i=1,self.player.members.b.lives do
			love.graphics.circle("fill",screen.width-12*i,6,5,4)
		end
		love.graphics.draw(self.res.scoreBoardB)

			love.graphics.setColor(255,200,0)
			love.graphics.setFont(fonts.largeOutline)
			love.graphics.push()
			love.graphics.translate(2,18)
			if self.player.members.a.points ~= self.player.members.a._points then
				love.graphics.scale(1.5)
			love.graphics.print(self.player.members.a.points,0,0)
				love.graphics.scale(.75)
			else
			love.graphics.print(self.player.members.a.points,0,0)
			end
			love.graphics.pop()
			love.graphics.push()
			love.graphics.translate(screen.width-(fonts.largeOutline:getWidth(self.player.members.b.points))-2,18)
			if self.player.members.b.points ~= self.player.members.b._points then
				love.graphics.scale(1.5)
			love.graphics.print(self.player.members.b.points,0,0)
				love.graphics.scale(.75)
			else
			love.graphics.print(self.player.members.b.points,0,0)
			end
			love.graphics.pop()

elseif self.pause == 2 then
	local xy = screen:getCentre()
		love.graphics.setColor(self.pc.r,self.pc.g,self.pc.b)


	love.graphics.draw(self.canvases.pauseBlur)
							print("drew blur canvas")


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
		love.graphics.setColor(255,255,255)
	love.graphics.draw(self.canvases.pauseBlur)
	--------------
	
	--------------
		love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,xy[2]-((#self.menu/2)*72)-16,screen.width*(self.pc.timer/30),((#self.menu)*72))
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(fonts.large)
	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
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
if self.pause == 1 then
	distance = 100 + (100*math.floor(self.points/8))
		if self.player.dead then
			print("You lasted "..self.round.." rounds.")
			print("Player 1 had "..self.player.members.a.points.." points.")
			print("Player 2 had "..self.player.members.b.points.." points.")
			state = heaven.make(self.player,self.round,self.stats.rocks,self.stats.enemies)
			return
		end
		self.player:update(dt)
	for i,e in ipairs(self.enemies) do
		e:update(dt)
		if e.hp <= 0 or e.kill then
			if e.drop then
			for ii=0, (e.bounty or math.random(9,17)) do
				table.insert(self.crystals, crystal.make(e.x+math.random(-48,48),e.y+math.random(-48,48)))
			end
			end
			table.remove(self.enemies,i)
--			if e.class == 'drone' then
--				table.insert(self.enemies,enemy.make())
--			end
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
			if math.fmod(self.stats.rocks,8) > 0 then messages:new(8-math.fmod(self.stats.rocks,8).." left",r.x,r.y,'up',2,{255,24,15},'boomMedium') end
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
				-- love.graphics.setCanvas(self.canvases.pauseCanvas)
				print("drew pause canvas")
						love.graphics.setCanvas(self.canvases.pauseBlur)
						-- love.graphics.setShader(shader)
							-- love.graphics.draw(self.canvases.pauseCanvas)
				self:draw()
							print("drew pause canvas to blur")
						-- love.graphics.setShader()
						love.graphics.setCanvas()

		self.pause = 3
		love.audio.pause()
	elseif k == 'backspace' then
		self.player.members.a.hp = 0	
		self.player.members.b.hp = 0	
	end
elseif self.pause == 2 then
	if k == 'escape' or k == 'return' then
		self.pause = 1
		love.audio.resume()
	end
elseif self.pause == 3 then
	if k == 'up' then
		if self.menuIndex > 1 then
			self.menuIndex = self.menuIndex-1
			screen:shake(.15,2)
		end
	elseif k == 'down' then
		if self.menuIndex < #self.menu then
			self.menuIndex = self.menuIndex+1
			screen:shake(.15,2)
		end
	elseif k == 'return' then
		if self.menu[self.menuIndex] == 'Continue' then
--			screen:shake(.15,2)
			love.audio.resume()
			self.pause = 1
		elseif self.menu[self.menuIndex] == 'Restart' then
			screen:shake(.15,2)
			state = game.make()
		elseif self.menu[self.menuIndex] == 'Exit to Menu' then
			screen:shake(.15,2)
			state = mainmenu.make(true)
		elseif self.menu[self.menuIndex] == 'Quit' then
			print("You lasted "..self.round.." rounds.")
			print("Player 1 had "..self.player.members.a.points.." points.")
			print("Player 2 had "..self.player.members.b.points.." points.")
			state = heaven.make(self.player,self.round,self.stats.rocks,self.stats.enemies)
		end
	elseif k == 'escape' then
		self.pause = 1
	end
end
end

heaven = {}
heaven.__index = heaven

function heaven.make(player,rounds,rocks,enemies)
	love.audio.stop()
	messages:clear()
	local h = {}
	setmetatable(h,heaven)
	h.player = player
	h.player.members.a.spawned = true
	h.player.members.b.spawned = true
	h.grabPlayer = true
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
	h.enemies = enemies
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
	h.winnerIndex = 1
	h.loserIndex = 1
	h.winnerConfirm = false
	h.loserConfirm = false

	h.timers = {slideWinner = {0,0,0,20},
				slideLoser = {0,0,0,20},
				gameFade = {100,100,100,100,100,100,100,100,100},
				wY = screen.height,
				lY = 0}

	if love.filesystem.exists("records/highScores.txt") then
		h.record = love.filesystem.newFile("records/highScores.txt",'w')
	else
		h.record = love.filesystem.newFile("records/highScores.txt",'w')
		h.record:write("#high scores")
	end

	h.res = {grad = res.load("image","healthbar.png")}

	return h
end

function heaven:draw()
if self.ready then
		love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	local xy = screen:getCentre()
		love.graphics.setFont(fonts.boom)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.printf(m,0,256+(screen:getCentre('x')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
	end

		love.graphics.setFont(fonts.large)
		love.graphics.push()
		love.graphics.translate((screen.width/2)-96,screen.height/2)

	--confirm tether
		love.graphics.setColor(math.random(14,77),math.random(59,155),255)
	if self.winnerConfirm then
		love.graphics.draw(self.res.grad,-64,44,-math.pi/2,48,16)
	end
	if self.loserConfirm then
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
	love.graphics.draw(self.player.imageLarge,res.quads["playerLarge2"],-64,16,0,.5,.5,144,144)
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
	love.graphics.draw(self.player.imageLarge,res.quads["playerLarge2"],256,16,-math.pi,.5,.5,144,144)
	love.graphics.print(self.characters[4][self.loserName[1]],96,0+self.timers.slideLoser[1])
	love.graphics.print(self.characters[5][self.loserName[2]],128,0+self.timers.slideLoser[2])
	love.graphics.print(self.characters[6][self.loserName[3]],160,self.timers.slideLoser[3])

		love.graphics.pop()

else
	-- 	love.graphics.setColor(0,0,0)
	-- love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	-- 	love.graphics.setColor(255,0,0)
	-- if self.winner[1] then
	-- 		love.graphics.setFont(fonts.large)
	-- 	love.graphics.printf(self.winner[1]..' won with '..self.winner[2]..' points.\nI guess congratulations are in order.',0,screen:getCentre('y')-(fonts.large:getHeight(self.winner[1]..' won with '..self.winner[2]..' points.\nI guess congratulations are in order.')/2),screen.width,'center')
	-- 		love.graphics.setFont(fonts.small)
	-- 	love.graphics.printf("Destroyed "..self.rocks.." rocks, and vapourised "..self.enemies.." enemies.",0,screen:getCentre('y')+(fonts.large:getHeight(self.winner[1]..' won with '..self.winner[2]..' points.\nI guess congratulations are in order.')*2),screen.width,'center')
	-- else
	-- 		love.graphics.setFont(fonts.large)
	-- 	love.graphics.printf("IT WAS A TIE!?\n"..self.winner[2]..' points were gathered.',0,screen:getCentre('y')-(fonts.large:getHeight("IT WAS A TIE!?\n"..self.winner[2]..' points were gathered.')/2),screen.width,'center')
	-- 		love.graphics.setFont(fonts.small)
	-- 	love.graphics.printf("Destroyed "..self.rocks.." rocks, and vapourised "..self.enemies.." enemies.",0,screen:getCentre('y')+(fonts.large:getHeight("IT WAS A TIE!?\n"..self.winner[2]..' points were gathered.')*2),screen.width,'center')
	-- end
	-- love.graphics.setBackgroundColor(0,0,0)

	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)

	self.player:draw()

	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
	-- love.graphics.printf("Game Over",_x,-16+xy[2]+_y,screen.width,'center')
	local frac = (100-self.timers.gameFade[1])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('G',(screen.width/2)-140+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[2])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('a',(screen.width/2)-100+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[3])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('m',(screen.width/2)-72+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[4])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)-36+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[5])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print(' ',(screen.width/2)-8+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[6])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('O',(screen.width/2)+22+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[7])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('v',(screen.width/2)+62+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[8])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)+90+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[9])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('r',(screen.width/2)+118+_x,-16+_y + ((screen.height/2)*frac))

end
end

function heaven:update(dt)
	for i = 1, 3 do
		if self.timers.slideWinner[i] > 0 then self.timers.slideWinner[i] = self.timers.slideWinner[i] - 2
		elseif self.timers.slideWinner[i] < 0 then self.timers.slideWinner[i] = self.timers.slideWinner[i] + 2 end
		if self.timers.slideLoser[i] > 0 then self.timers.slideLoser[i] = self.timers.slideLoser[i] - 2
		elseif self.timers.slideLoser[i] < 0 then self.timers.slideLoser[i] = self.timers.slideLoser[i] + 2 end
	end
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


	self.winnerConfirm = love.keyboard.isDown(self.player.members[self.winner].keys.tether)
	self.loserConfirm = love.keyboard.isDown(self.player.members[self.loser].keys.tether)
end

function heaven:keypressed(k)
if self.ready then
	if k == 'up' then
		-- if self.menuIndex > 1 then
		-- 	self.menuIndex = self.menuIndex-1
		-- end
	elseif k == 'down' then
		-- if self.menuIndex < #self.menu then
		-- 	self.menuIndex = self.menuIndex+1
		-- end
	--choose the name column to edit
	elseif k == self.player.members[self.winner].keys.right and not self.winnerConfirm then
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
	
	-- elseif k == 'return' then
	-- 	if self.menu[self.menuIndex] == 'Restart' then
	-- 		screen:shake(.15,2)
	-- 		state = game.make()
	-- 	elseif self.menu[self.menuIndex] == 'Main Menu' then
	-- 		state = mainmenu.make(true)
	-- 	end
	end
else
	if k == 'escape' then
		self.ready = true
	end
end
end

credits = {}
credits.__index = credits

function credits.make()
	local c = {}
	setmetatable(c,credits)
	c.offset = screen.height
	c.credits = {}
	local file = love.filesystem.newFile("/res/credits/credits.txt",'r')
	local y = 0
	for l in file:lines() do
		if l:sub(1,2) == '#!' then
			love.graphics.setFont(fonts[l:sub(3)])
			table.insert(c.credits,{l,0,0})
		else
			table.insert(c.credits,{l,love.graphics.getFont():getWidth(l),y})
			y = y + love.graphics.getFont():getHeight(l) + 4
		end
	end
	file:close()

	c.particles = {}
	c.files = {}
	local t = love.filesystem.getDirectoryItems("res/sprites/")
	print(#c.files)
	local removed = 0
	for i,f in ipairs(t) do 
		print(f)
		if f:sub(-4) == ".png" then
			print('i')
			table.insert(c.files,f)
		end
	end
	print(#c.files)

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

	love.graphics.print(#self.particles,0,0)
end

function credits:update(dt)
	if self.offset + self.credits[#self.credits][3] < -24 then
		state = mainmenu.make(true)
	end
	self.offset = self.offset - 1

	local i = math.random()
	if math.random(0,40) == 40 then
		print(math.random(1,#self.files))
		local o = {res.load("sprite",self.files[math.random(1,#self.files)]),math.random(0,screen.width),0,i,i/2,0,i*math.pi/100,math.random(64,196)}
		o[3] = -o[1]:getHeight()
		table.insert(self.particles,o)
	end

end

function credits:keypressed(k)
	state = mainmenu.make(true)
end