options = {}
options.__index = options

function options.make()
love.graphics.setFont(fonts.large)
	screen:clearEffects('flash')
	local o = {}
	setmetatable(o,options)
	o.menu = {"Fullscreen","Music","Back"}
	-- o.timers = {}
	o.menuIndex = 1
	o.timers = {
		fader = 120,
		screenR = 0,
		-- screenR = 0,
		colors = {r=255,g=0,b=0},
		-- screenR = 0,
	}
	o.sounds = {
		tock = res.load("sound","menuTock"),
		distort = res.load("sound","distortTock"),
		click = res.load("sound","menuClick"),
	}
	o.name = "Options"

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
	local autxt = love.audio.getVolume() == 1 and ' is ON' or ' is OFF'
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255,255*self.timers.screenR/screen.width)
		else
			love.graphics.setColor(128,128,128,255*self.timers.screenR/screen.width)
		end
		if m ==  'Music' then
			love.graphics.printf(m..autxt,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)*self.timers.screenR/screen.width),screen.width,'center')
		else
			love.graphics.printf(m,0,(screen:getCentre('y')-((#self.menu/2)*72))+(72*(i-1)*self.timers.screenR/screen.width),screen.width,'center')
		end
	end
end

function options:keypressed(k)
	if k ~= 'escape' then
	self.ready = true
		if k == 'w' or k == 'up' then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
				-- love.audio.rewind(self.sounds.click)
				-- love.audio.play(self.sounds.click)
			else
				screen:shake(.15,2,false)
				-- love.audio.rewind(self.sounds.distort)
				-- love.audio.play(self.sounds.distort)
			end
		elseif k == 's' or k == 'down' then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
				-- love.audio.rewind(self.sounds.click)
				-- love.audio.play(self.sounds.click)
			else
				screen:shake(.15,2,false)
				-- love.audio.rewind(self.sounds.distort)
				-- love.audio.play(self.sounds.distort)
			end
		elseif k == 'return' or k =='lshift' or k == 'kp0' then
			if self.menu[self.menuIndex] == 'Fullscreen' then
				screen.toggleFullscreen()
			elseif self.menu[self.menuIndex] == 'Music' then
				love.audio.setVolume(math.abs(love.audio.getVolume()-1))
				-- print(love.audio.getVolume())
			elseif self.menu[self.menuIndex] == 'Back' then
				state = mainmenu.make(true)
			end
		end
	else
		state = mainmenu.make(true)
	end
end