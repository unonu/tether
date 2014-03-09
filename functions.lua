-------------------------------------------------------------------
--	Functions Functions Functions Functions Functions Func...	--
-------------------------------------------------------------------

function drawBack()
	for i=0, math.floor((screen.width+100)/48) do
	for ii=0, math.floor((screen.height+100)/48) do
		if ((i/2)-math.floor(i/2) > 0 and (ii/2)-math.floor(ii/2) == 0) or ((i/2)-math.floor(i/2) == 0 and (ii/2)-math.floor(ii/2) > 0) then
			love.graphics.setColor(190,190,190)
		else
			love.graphics.setColor(210,210,210)
		end
		love.graphics.rectangle('fill', -50+(i*48)+(((love.mouse.getX())-(screen.width/2))/16),-50+(ii*48)+(((love.mouse.getY())-(screen.height/2))/16),48,48)
	end
	end
end

function colorExtreme( table,m )
	local t ={}
	for i,v in ipairs(table) do
		if v >= m then t[i] = 255
		else t[i] = 0 end
	end
	return t
end

function love.graphics.stippledLine( x1,y1,x2,y2,l,g )
	local ang = math.atan2((y2-y1),(x2-x1))
	local x_dist = math.cos(ang)
	local y_dist = math.sin(ang)
	for i=0, math.floor(((x2-x1)^2+(y2-y1)^2)^.5/(l+g)) do
		love.graphics.line(x1+(i*x_dist*(l+g)),y1+(i*y_dist*(l+g)),x1+(i*x_dist*(l+g))+(x_dist*l),y1+(i*y_dist*(l+g))+(y_dist*l))
	end
end

function rounder()
	local progress = {}
	progress[1],progress[2] = math.modf(state.stats.rocksRound/state.quota)
	if progress[1] == 1 then
		state.round = state.round+1
		state.stats.rocksRound = 0
		messages:clear()
		messages:new("ROUND "..state.round.."!",screen:getCentre('x'),screen:getCentre('y'),"still",2,{255,255,0},'boomLarge')
		for i,e in ipairs(state.enemies) do
			e.kill = true
		end
		if state.round == 6 then
			if state.player.members.a.stats.deaths == 0 and state.player.members.a.hp == state.player.members.a.stats.hp then
				messages:new('Untouchable!',state.player.members.a.x,state.player.members.a.y,'up',2,{255,24,15},'boom')
				state.player.members.a.immunity = 20
			elseif state.player.members.a.stats.deaths == 0 then
				messages:new('Survivor!',state.player.members.a.x,state.player.members.a.y,'up',2,{255,24,15},'boom')
				state.player.members.a.immunity = 15
			end
			if state.player.members.b.stats.deaths == 0 and state.player.members.b.hp == state.player.members.b.stats.hp then
				messages:new('Untouchable!',state.player.members.b.x,state.player.members.b.y,'up',2,{255,24,15},'boom')
				state.player.members.b.immunity = 20
			elseif state.player.members.b.stats.deaths == 0 then
				messages:new('Survivor!',state.player.members.b.x,state.player.members.b.y,'up',2,{255,24,15},'boom')
				state.player.members.b.immunity = 15
			end
		elseif state.round == 10 then
			state.quota = -1
			state.player.members.a.x,state.player.members.a.y = screen:getCentre('x')/2,screen:getCentre('y')
			state.player.members.b.x,state.player.members.b.y = screen:getCentre('x')*1.5,screen:getCentre('y')
			for i,r in ipairs(state.rocks) do
				r.hp = 0
			end
			for i,e in ipairs(state.enemies) do
				e.kill = true
			end
			table.insert(state.enemies,torrent.make(screen:getCentre('x'),screen:getCentre('y'),256))
			messages:new('DEFEAT THE BOSS!',screen:getCentre('x'),screen:getCentre('y')+48,"still",2,{255,255,255},'boomMedium')
		end
	end
	--
	--
	if state.round <= 2 then
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100))) end
	elseif state.round > 2 and state.round <= 4 then
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
	elseif state.round > 4 and state.round <= 6 then
		if #state.enemies < 3 then
			for i = 1, 3-#state.enemies do
				table.insert(state.enemies,enemy.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
	elseif state.round > 6 and state.round <= 8 then
		if #state.enemies < 6 then
			for i = 1, 6-#state.enemies do
				table.insert(state.enemies,enemy.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,3)) end
	elseif state.round == 9 then
		if #state.enemies < 9 then
			for i = 1, 9-#state.enemies do
				table.insert(state.enemies,enemy.make())
			end
		end
		if #state.rocks < 14 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,3)) end
	elseif state.round == 10 then
		if #state.rocks < 6 and math.random(0,200) == math.random(0,200) then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),false,3)) end
		if #state.enemies == 0 then
			state.round = 11
		end
	elseif state.round > 10 and state.round <= 12 then
		if #state.enemies < 6 then
			-- for i = 1, 4-#state.enemies do
			-- 	table.insert(state.enemies,enemy.make())
			-- end
			for i = 1, 2-#state.enemies do
				table.insert(state.enemies,dash.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,3)) end
	end
end

function initFS(name)
	print(ansicolors.yellow.."INIT FIlesystem, please hold..."..ansicolors.clear)
	if not love.filesystem.exists("tether") then
		print("Couldn\'t find save directory")
		love.filesystem.setIdentity('tether')
	end
	if not love.filesystem.exists("joysticks") then
		love.filesystem.createDirectory("joysticks")
		-- love.filesystem.newFileData('res/joysticks')
	end
	if not love.filesystem.exists("records") then
		love.filesystem.createDirectory("records")
	end
	if not love.filesystem.exists("config") then
		love.filesystem.setIdentity('tether')
		local config = love.filesystem.newFile("config")
		config:open('w')
		config:write("#Config File")
		config:close()
	end
end

------------------------
-- Screens
-------------------

screen = {}
screen.__index = screen
function screen.init(w,h)
	local s = {}
	setmetatable(s,screen)
	s.width = w or 1280
	s.height = h or 720
	love.window.setMode(s.width,s.height)
	s.images = {}
		s.images.flash = res.load("image","flash.png")
		s.images.background = res.load("image","background.png")
	s.timers = {}
		s.timers.shake = 0
		s.timers.chrome = 0
		s.timers.flashPeriod = {0,0}
		s.timers.flashDuration = 0
	s.colors = {}
		s.colors.flash = {255,255,255}
	s.delta = nil
	s.flashing = false
	s.modes = love.window.getFullscreenModes()
	s.abberating = false
	s.shaking = false
	s.canvases = {}
		s.canvases.buffer = love.graphics.newCanvas()
		s.canvases.red = love.graphics.newCanvas()
		s.canvases.green = love.graphics.newCanvas()
		s.canvases.blue = love.graphics.newCanvas()
	s.focus = 0
	s.flashMode = "edge"
	s.flashSpeed = 1
	s.background = {255,255,255}
	s.fps = 1/60
	s.fullscreen = false
	table.sort(s.modes, function(a, b) return a.width*a.height < b.width*b.height end)
	s.chromeWhenShake = true
	
	s.next_time = love.timer.getTime()
	screen = s
end

function screen:draw()
	if self.timers.shake ~= 0 then
		self.shakeing = true
		self.timers.shake = self.timers.shake - 1
		self.timers.shake = math.max(self.timers.shake,-1)
		love.graphics.translate(math.random(-self.delta,self.delta),math.random(-self.delta,self.delta))
		if self.chromeWhenShake then
			self.timers.chrome = self.timers.shake
		end
	else self.shaking = false
	end
	
	if self.timers.chrome ~= 0 then
		if self.chromeWhenShake and self.timers.shake > 0 then
			self.focus = math.random(-self.delta,self.delta)
		else
			self.timers.chrome = self.timers.chrome - 1
			self.timer = math.max(self.timers.shake,-1)
		end
	else
		self.focus = 0
	end
end

function screen:drawFlash()
	if self.timers.flashDuration ~= 0 then
		self.flashing = true
		if self.flashMode == "full" then
			love.graphics.setColor(self.colors.flash[1],self.colors.flash[2],self.colors.flash[3],math.max(self.timers.flashPeriod[1]/self.timers.flashPeriod[2]*255,0))
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		elseif self.flashMode == "edge" then
			love.graphics.setColor(self.colors.flash[1],self.colors.flash[2],self.colors.flash[3],math.max(self.timers.flashPeriod[1]/self.timers.flashPeriod[2]*128,0))
			love.graphics.draw(self.images.flash,0,0,0,self.width/256,self.height/256)
		else
			print("[WARNING]: (Screen) Unsupported flash mode. Doing nothing.")
		end
		if self.timers.flashPeriod[1] > 0 then
			self.timers.flashPeriod[1] = self.timers.flashPeriod[1] - (.1*self.flashSpeed)
		else
			self.timers.flashPeriod[1] = self.timers.flashPeriod[2]
			self.timers.flashDuration = self.timers.flashDuration - 1
		end
	else
		self.flashing = false
	end
end

function screen:update()
	self.next_time = self.next_time + self.fps
	if love.graphics.getWidth() ~= screen.width then love.window.setMode(screen.width,screen.height) end
	if love.graphics.getHeight() ~= screen.height then love.window.setMode(screen.width,screen.height) end
	if self.timers.chrome == 0 then self.abberating = false else self.abberating = true end
end

function screen:shake(time,delta,chrome,deteriorate)
	if chrome == false then
		self.chromeWhenShake = false
	else
		self.chromeWhenShake = true
	end
	self.timers.shake = time*60
	self.delta = delta or 16
	self.delta = self.delta/2
end

function screen:aberate(time,focus)
	self.timers.chrome = time*60
	self.focus = focus or 1
end

function screen:flash(periods,speed,color,mode)
	if mode then self:setFlashMode(mode) end
	self.timers.flashDuration = periods or 1
	self.timers.flashPeriod = {100,100}
	self.flashSpeed = speed or 1
	self.colors.flash = color or {255,255,255}
end

function screen:setFlashMode(mode)
	self.flashMode = mode
end

function screen:clearEffects()
	self.timers.shake = 0
	self.timers.chrome = 0
	self.timers.flashPeriod = {0,0}
	self.timers.flashDuration = 0
end

function screen:setChromaticFilter()
	love.graphics.setCanvas(self.canvases.buffer)
end

function screen:setBackground(arg)
	self.background = arg
end

function screen:releaseChromaticFilter()
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode("additive")
	love.graphics.push()
		--red
			love.graphics.translate(-4*self.focus,0)
			love.graphics.setColorMask( true, false, false)
			love.graphics.draw(self.canvases.buffer)
		--blue
			love.graphics.translate(4*self.focus,-4*self.focus)
			love.graphics.setColorMask( false, true, false)
			love.graphics.draw(self.canvases.buffer)
		--green
			love.graphics.translate(4*self.focus,4*self.focus)
			love.graphics.setColorMask( false, false, true)
			love.graphics.draw(self.canvases.buffer)
	love.graphics.pop()
	love.graphics.setBlendMode("alpha")

	love.graphics.setColorMask()
end

function screen:capFPS()
	local cur_time = love.timer.getTime()
	if self.next_time <= cur_time then
		self.next_time = cur_time
		return
	end
	love.timer.sleep((self.next_time - cur_time))
end

function screen:getCentre(xory)
	if xory then
		if xory == 'x' then
			return (self.width/2)
		elseif xory == 'y' then
			return (self.height/2)
		end
	else
		local result = {self.width/2, self.height/2}
		return result
	end
end

function screen.toggleFullscreen()
	print(love.window.getFullscreen() == false)
	love.window.setFullscreen(love.window.getFullscreen() == false)
end

screen.setFullscreen = love.window.setFullscreen

---------------------------------------------
---------------------------------------------

messages = {}
messages.messages = {}
function messages:new(text,x,y,mode,life,color,font)
	local m = {}
	m.name = 'message'..(#messages+1)
	m.text = text
	m.x = x or 0
	m.y = y or 0
	m.mode = mode or 'still'
	m.life = math.max(((life or -1)*60)+255,-1)
	m.color = color or {255,255,255}
	m.font = font or 'boomMedium'
	
	print("sending message: "..text)
	table.insert(self.messages,m)
end

function messages:draw()
	for i,m in ipairs(self.messages) do
		love.graphics.setColor(m.color[1],m.color[2],m.color[3],math.min(m.life,255))
		love.graphics.setFont(fonts[m.font])
		love.graphics.print(m.text,m.x-(fonts[m.font]:getWidth(m.text)/2),m.y-(fonts[m.font]:getHeight(m.text)/2))
	end
end

function messages:update(dt)
	for i,m in ipairs(self.messages) do
		if m.mode == 'up' then
			m.y = m.y - 4
			if m.y < -fonts[m.font]:getHeight(m.text) then
				table.remove(self.messages,i)
			end
		elseif m.mode == 'down' then
			m.y = m.y + 4
			if m.y > screen.height+fonts[m.font]:getHeight(m.text) then
				table.remove(self.messages,i)
			end
		elseif m.mode == 'left' then
			m.x = m.x - 4
			if m.x < -fonts[m.font]:getWidth(m.text) then
				table.remove(self.messages,i)
			end
		elseif m.mode == 'right' then
			m.x = m.x + 4
			if m.x > screen.width+fonts[m.font]:getWidth(m.text) then
				table.remove(self.messages,i)
			end
		elseif m.mode == 'still' then
			if m.life > 0 then
				m.life = m.life -1
			elseif m.life == 0 then
				table.remove(self.messages,i)
			end
		end
	end
	love.graphics.setFont(fonts.small)
end

function messages:clear()
	self.messages = {}
end
