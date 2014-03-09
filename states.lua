
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
	m.effects = {}
		m.effects.fader = 120
		m.effects.screenR = screen.width
		m.colors = {r=255,g=0,b=0}
	love.graphics.setFont(fonts.large)
	love.audio.stop()

	m.ready = ready or false

	return m
end

function mainmenu:update(dt)
if self.ready then
	if self.effects.screenR > 0 then
		self.effects.screenR = self.effects.screenR - (self.effects.screenR/16)
	end
else
	
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
	if self.effects.screenR > 0 then
			love.graphics.setColor(0,0,0)
		love.graphics.circle("fill",screen.width,screen.height,self.effects.screenR,self.effects.screenR)
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
	love.graphics.printf("Tether",_x,-16+xy[2]+_y,screen.width,'center')
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
			self.effects.fader = 120
			self.effects.screenR = screen.width
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
	o.effects = {}
	o.menuIndex = 1
	o.effects = {}
		o.effects.fader = 120
		o.effects.screenR = 0
		o.effects.screenR = 0
		o.effects.colors = {r=255,g=0,b=0}
		o.effects.screenR = 0

	return o
end

function options:update(dt)
	if self.effects.screenR < screen.width then
		self.effects.screenR = self.effects.screenR + (((screen.width)-self.effects.screenR)/16)
	end
	if self.effects.colors.r > 0 and self.effects.colors.g < 255 and self.effects.colors.b == 0 then
		self.effects.colors.r = self.effects.colors.r -1
		self.effects.colors.g = self.effects.colors.g +1
	elseif self.effects.colors.r == 0 and self.effects.colors.g > 0 and self.effects.colors.b < 255 then
		self.effects.colors.g = self.effects.colors.g -1
		self.effects.colors.b = self.effects.colors.b +1
	elseif self.effects.colors.r < 255 and self.effects.colors.g == 0 and self.effects.colors.b > 0 then
		self.effects.colors.b = self.effects.colors.b -1
		self.effects.colors.r = self.effects.colors.r +1
	end
end

function options:draw()
	if self.effects.screenR < screen.width then
			love.graphics.setColor(self.effects.colors.r,self.effects.colors.g,self.effects.colors.b)
		love.graphics.circle("fill",screen:getCentre('x'),screen:getCentre('y'),self.effects.screenR,self.effects.screenR)
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
	g.player = player.make(-1)
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
	self.player:drawA(150,150,'Large')
	self.player:drawB(screen.width-150,screen.height-150,'Large')
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
		self.player:update(dt)
		if self.player.dead then
			print("You lasted "..self.round.." rounds.")
			print("Player 1 had "..self.player.members.a.points.." points.")
			print("Player 2 had "..self.player.members.b.points.." points.")
			state = heaven.make(ppp,self.round,self.stats.rocks,self.stats.enemies)
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
			love.event.quit()
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
						'0','1','2','3','4','5','6','7','8','9','!','?',',','.','-','_','&','#','/',},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?',',','.','-','_','&','#','/',},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?',',','.','-','_','&','#','/',},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?',',','.','-','_','&','#','/',},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?',',','.','-','_','&','#','/',},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?',',','.','-','_','&','#','/',},
					}
	h.winnerName = {1,1,1}
	h.loserName = {1,1,1}
	h.winnerIndex = 1
	h.loserIndex = 1


	h.record = love.filesystem.newFile("records/highScores",'r')


	return h
end

function heaven:draw()
if self.ready then
		love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	local xy = screen:getCentre()
		love.graphics.setFont(fonts.large)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.printf(m,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
	end

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
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setColor(255,255,255)
	love.graphics.print(h.characters[1][winnerName])
end
end

function heaven:update(dt)

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
	elseif k == self.player.members[self.winner].keys.right then
		if self.winnerIndex < 3 then self.winnerIndex = self.winnerIndex + 1 end
	elseif k == self.player.members[self.winner].keys.left then
		if self.winnerIndex > 1 then self.winnerIndex = self.winnerIndex - 1 end
	elseif k == self.player.members[self.loser].keys.right then
		if self.loserIndex < 3 then self.loserIndex = self.loserIndex + 1 end
	elseif k == self.player.members[self.loser].keys.left then
		if self.loserIndex > 1 then self.loserIndex = self.loserIndex - 1 end
	--choose the character for the name column
	elseif k == self.player.members[self.winner].keys.up then
			self.winnerName[winnerIndex] = math.loop(1,self.winnerName[winnerIndex] + 1,#self.winnerName[winnerIndex])
	elseif k == self.player.members[self.winner].keys.down then
			self.winnerName[winnerIndex] = math.loop(1,self.winnerName[winnerIndex] - 1,#self.winnerName[winnerIndex])
	elseif k == self.player.members[self.loser].keys.up then
			self.loserName[loserIndex] = math.loop(1,self.loserName[loserIndex] + 1,#self.loserName[loserIndex])
	elseif k == self.player.members[self.loser].keys.down then
			self.loserName[loserIndex] = math.loop(1,self.loserName[loserIndex] - 1,#self.loserName[loserIndex])
	elseif k == 'return' then
		if self.menu[self.menuIndex] == 'Restart' then
			screen:shake(.15,2)
			state = game.make()
		elseif self.menu[self.menuIndex] == 'Main Menu' then
			state = mainmenu.make(true)
		end
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
	local f = love.filesystem.newFile("/res/credits/credits.txt",'r')
	local y = 0
	for l in f:lines() do
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