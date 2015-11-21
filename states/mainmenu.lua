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
	m.sounds = {tock = res.load("sound","menuTock"),
				distort = res.load("sound","distortTock"),
				click = res.load("sound","menuClick"),
				}
	m.ready = ready or false
	m.name = "Main Menu"

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
love.graphics.setFont(fonts.large)
if self.ready then
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	-- love.graphics.draw(self.res.bg,self.timers.bg,-self.timers.bg*4/7)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(0,0,0,255*(1-(self.timers.tetherRise/((screen.height/2)-16))))
		else
			love.graphics.setColor(128,128,128,255*(1-(self.timers.tetherRise/((screen.height/2)-16))))
		end
		love.graphics.printf(m,0 + ((-1)^i)*(48+(i*128))*((self.timers.tetherRise/((screen.height/2)-16))),(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)),screen.width,'center')
	end

		love.graphics.translate(0,96)
		love.graphics.setColor(0,0,0)
		-- if (math.floor(math.random(0,100)/100)*math.random(4,6)) ~= 0 then
		-- 	love.graphics.setShader(shaders.chromaticAberation)
		-- 	love.graphics.setColor(255,255,255)
		-- end
	love.graphics.setFont(fonts.tether)
	love.graphics.print('tether',(screen.width/2)-fonts.tether:getWidth('tether')/2,self.timers.tetherRise)
		love.graphics.setShader()
		love.graphics.translate(0,-96)

	if self.timers.screenR > 0 then
			love.graphics.setColor(0,0,0)
		love.graphics.circle("fill",screen.width,screen.height,self.timers.screenR,self.timers.screenR)
	end
else
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	love.graphics.setFont(fonts.tether)
	local xy = screen:getCentre()
		love.graphics.setColor(255,255,255)
	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
	local frac = (100-self.timers.gameFade[1])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('t',478+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[2])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',538+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[3])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('t',586+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[4])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('h',647+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[5])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',705+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[6])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('r',754+_x,-16+_y + ((screen.height/2)*frac))
end
end

function mainmenu:keypressed(k)
	if k ~= 'escape' then -- This is sorta messy
		if self.ready then
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
			elseif k == 'return' or k =='lshift' or k == 'kp0' then
				love.audio.rewind(self.sounds.tock)
				love.audio.play(self.sounds.tock)
				if self.menu[self.menuIndex] == 'Arcade' then
					love.graphics.clear()
					love.graphics.setColor(255,255,255)
					love.graphics.rectangle('fill',0,0,screen.width,screen.height)
					state = instructions.make()
				elseif self.menu[self.menuIndex] == 'Options' then
					state = options.make()
				elseif self.menu[self.menuIndex] == 'Credits' then
					state = credits.make()
				elseif self.menu[self.menuIndex] == 'Exit' then
					love.event.quit()
				end
			end
		else
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