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

function rounder()
--	if #state.rocks == 0 then
--		state.round = state.round+1
--		state.players[1].tetherDistance = state.players[1].tetherDistance + 50
--		state.enemies = {}
--		state.bullets = {}
--		for i=1, 8 do
--			table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100)))
--		end
--		if state.round > 2 then
--			for i = 1, math.min((state.round-1)^2,6) do
--				table.insert(state.enemies,enemy.make())
--			end
--		end
--		if state.round > 0 then
--			for i = 1, math.min(math.random(1,((state.round-1)^2)),math.random(6,8)) do
--				local ident = math.random(1,#state.rocks)
----				table.insert(state.enemies,sentry.make(state.rocks[ident].x,state.rocks[ident].y))
--				state.rocks[ident].sentry = sentry.make(state.rocks[ident].x,state.rocks[ident].y)
--			end
--		end
--	end
	local progress = {}
	progress[1],progress[2] = math.modf(state.stats.rocksRound/state.quota)
--	print(state.round,progress[1],progress[2])
	if progress[1] == 1 then
		state.round = state.round+1
		state.stats.rocksRound = 0
		messages:new("ROUND "..state.round.."!",screen:getCentre('x'),screen:getCentre('y'),"still",2,{255,255,0},'boomLarge')
		for i,e in ipairs(state.enemies) do
			e.kill = true
		end
--		if math.fmod(state.round,10) == 9 then
--			state.quota = 8
--		end
		if state.round == 6 then
			for i,p in ipairs(state.players) do
				if p.members.a.stats.deaths == 0 and p.members.a.hp == p.members.a.stats.hp then
					messages:new('Untouchable!',p.members.a.x,p.members.a.y,'up',2,{255,24,15},'boom')
					p.members.a.immunity = 20
				elseif p.members.a.stats.deaths == 0 then
					messages:new('Survivor!',p.members.a.x,p.members.a.y,'up',2,{255,24,15},'boom')
					p.members.a.immunity = 15
				end
				if p.members.b.stats.deaths == 0 and p.members.b.hp == p.members.b.stats.hp then
					messages:new('Untouchable!',p.members.b.x,p.members.b.y,'up',2,{255,24,15},'boom')
					p.members.b.immunity = 20
				elseif p.members.b.stats.deaths == 0 then
					messages:new('Survivor!',p.members.b.x,p.members.b.y,'up',2,{255,24,15},'boom')
					p.members.b.immunity = 15
				end
			end
		elseif state.round == 10 then
			state.quota = -1
			state.players[1].members.a.x,state.players[1].members.a.y = screen:getCentre('x')/2,screen:getCentre('y')
			state.players[1].members.b.x,state.players[1].members.b.y = screen:getCentre('x')*1.5,screen:getCentre('y')
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
--	if #state.rocks < 8 then
----		if math.random(0,1) == 1 then
----			local x = math.random(0,1)*screen.width
----			table.insert(state.rocks,rock.make(x-(50*math.sign(1-x)),math.random(0,screen.height)))
----		else
----			local y = math.random(0,1)*screen.height
----			table.insert(state.rocks,rock.make(math.random(0,screen.width),y-(50*math.sign(1-y))))
----		end
--		if state.round <= 2 then
--			table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100)))
--		elseif state.round > 2 and state.round <= 4 then
--			if state.round == 4 then
--				for i,p in ipairs(state.players) do
--					if p.members.a.deaths == 0 then
--						message:new('Survivor!',p.members.a.x,p.members.a.y,'up',2,{255,24,15},'small')
--						p.members.a.immunity = 5
--					end
--					if p.members.b.deaths == 0 then
--						message:new('Survivor!',p.members.b.x,p.members.b.y,'up',2,{255,24,15},'small')
--						p.members.b.immunity = 5
--					end
--				end
--			end
--			table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true))
--		elseif state.round > 4 then
--		end
--	end
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
--		state.round = 10
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

-- function loadJoystickConfigs()
-- 	love.filesystem.setIdentity("tether")
-- 	configuredJoysticks = love.filesystem.getDirectoryItems("joysticks")
-- 	print("Found these joystick config files:")
-- 		for i,j in ipairs(configuredJoysticks) do
-- 			print('\t'..j)
-- 		end
-- 	joystickConfigurations = {}
-- 	for i,j in ipairs(configuredJoysticks) do
-- 	if string.sub(j,-1) ~= '~' and string.sub(j,0,1) ~= '~' then
-- --		print(j)
-- 		local file = love.filesystem.newFile("joysticks/"..j)
-- --		print(love.filesystem.exists("joysticks/"..j))
-- 		file:open('r')
-- 		local conf = {}
-- 		local target = 'buttons'
-- 		for l in file:lines() do
-- --			print(l)
-- --			print(string.sub(l,-1))
-- 			if string.sub(l,0,1) == "#" then target = string.sub(l,2); conf[target]={} else
-- 				conf[target][string.sub(l,string.find(l,'=')+2)] = string.sub(l,1,string.find(l,'=')-2)
-- 				conf[target][string.sub(l,1,string.find(l,'=')-2)] = string.sub(l,string.find(l,'=')+2)
-- 			end
-- 		end
-- 		if joysticks[string.sub(j,0,-5)] then
-- 			joysticks[string.sub(j,0,-5)] = conf
-- 		end
-- 	end
-- 	end
-- end

-- function loadJoysticks()
-- 	print(ansicolors.yellow..'Attempting to load joysticks...'..ansicolors.clear)
-- 	if love.joystick.getNumJoysticks() > 0 then
-- 		joysticks = {}
-- 		for i=1, love.joystick.getNumJoysticks() do
-- 			love.joystick.open(i)
-- 			joysticks[love.joystick.getName(i)] = {}
-- --			print(love.joystick.getName(i))
-- 		end
-- 		loadJoystickConfigs()
-- 		if #configuredJoysticks > 0 then
-- 			for i,j in pairs(joysticks) do
-- --				for ii,jj in ipairs(configuredJoysticks) do
-- ----					print(i,jj)
-- --					if i..".joy" == jj then
-- --						print(i,ansicolors.green.."*Ready*"..ansicolors.clear)
-- --					else
-- --						print(i,ansicolors.red.."*Not Ready*"..ansicolors.clear)
-- --					end
-- --					break
-- --				end
-- 				if j == {} then
-- 					print(i,ansicolors.red.."*Not Ready*"..ansicolors.clear)
-- 				else
-- 					print(i,ansicolors.green.."*Ready*"..ansicolors.clear)
-- 				end
-- 			end
-- 		else
-- 			print(ansicolors.red.."No controller confiurations found!\nRunning configurator-inator"..ansicolors.clear)
-- 		end
-- 	else
-- 		print("No joysticks... yuck")
-- 	end
-- end

function loadJoysticks()
	print(love.joystick.getJoystickCount())
	for i,j in ipairs(love.joystick.getJoysticks()) do
		print(j:getName(),j:isGamepad(),j:isVibrationSupported(),j:getAxisCount(),j:getButtonCount(),j:getHatCount(),j:getHat(1))
	end
	print(ansicolors.yellow..'Attempting to load joysticks...'..ansicolors.clear)
	local joysticks = love.joystick.getJoysticks()
	for i,j in ipairs(joysticks) do
		if j:isGamepad() == false and love.filesystem.exists('res/joysticks/'..j:getName()..'.joy') then
			print('found config for '..j:getName())
			local file,guid = love.filesystem.newFile('res/joysticks/'..j:getName()..'.joy','r'),j:getGUID()
			-- print(file:open('r'),file:isOpen())
			local target = ''
			for l in file:lines() do
				if string.sub(l,1,1) == '#' then
					target = string.sub(l,2)
					print(l)
				else
					if target ~= 'hat' then
						print(string.sub(l,1,string.find(l,'=')-2),tonumber(string.sub(l,string.find(l,'=')+2)))
						love.joystick.setGamepadMapping(guid,string.sub(l,1,string.find(l,'=')-2),target,tonumber(string.sub(l,string.find(l,'=')+2)))--finish this line
					else
						print(string.sub(l,1,string.find(l,'=')-2),string.sub(l,string.find(l,'=')+2))
						-- love.joystick.setGamepadMapping(guid,string.sub(l,1,string.find(l,'=')-2),target,1,string.sub(l,string.find(l,'=')+2))
					end
				end
			end
			print('finished loop')
		end
		print('a')
	end
	print('b')
	return joysticks
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
--	love.graphics.setColor(255,255,255)
--	love.graphics.draw(self.images.background,0,0)
	if self.timers.shake ~= 0 then
		self.shakeing = true
--		print('shaking')
		self.timers.shake = self.timers.shake - 1
		self.timers.shake = math.max(self.timers.shake,-1)
		love.graphics.translate(math.random(-self.delta,self.delta),math.random(-self.delta,self.delta))
--		love.graphics.translate(-48,-48)
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
--		if self.timers.flashDuration > 0 then
--			self.timers.flashDuration = self.timers.flashDuration -.1
--		end
		if self.flashMode == "full" then
			love.graphics.setColor(self.colors.flash[1],self.colors.flash[2],self.colors.flash[3],math.max(self.timers.flashPeriod[1]/self.timers.flashPeriod[2]*255,0))
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		elseif self.flashMode == "edge" then
			love.graphics.setColor(self.colors.flash[1],self.colors.flash[2],self.colors.flash[3],math.max(self.timers.flashPeriod[1]/self.timers.flashPeriod[2]*255,0))
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
--	print('called shake')
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
	love.graphics.setCanvas(self.canvases.red)
			love.graphics.push()
			love.graphics.translate(-4*self.focus,0)
		if type(self.background) == 'table' then
			love.graphics.setColor(self.background[1],self.background[2],self.background[3])
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		else
			love.graphics.setColor(255,255,255)
			love.graphics.draw(self.background)
		end
--		love.graphics.rectangle("fill",0,0,self.width,self.height)
		love.graphics.setColor(255,0,0)
		love.graphics.draw(self.canvases.buffer)
			love.graphics.pop()
	love.graphics.setCanvas(self.canvases.green)
			love.graphics.push()
			love.graphics.translate(0,-4*self.focus)
		if type(self.background) == 'table' then
			love.graphics.setColor(self.background[1],self.background[2],self.background[3])
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		else
			love.graphics.setColor(255,255,255)
			love.graphics.draw(self.background)
		end
--		love.graphics.rectangle("fill",0,0,self.width,self.height)
		love.graphics.setColor(0,255,0)
		love.graphics.draw(self.canvases.buffer)
			love.graphics.pop()
	love.graphics.setCanvas(self.canvases.blue)
			love.graphics.push()
			love.graphics.translate(4*self.focus,0)
		if type(self.background) == 'table' then
			love.graphics.setColor(self.background[1],self.background[2],self.background[3])
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		else
			love.graphics.setColor(255,255,255)
			love.graphics.draw(self.background)
		end
--		love.graphics.rectangle("fill",0,0,self.width,self.height)
		love.graphics.setColor(0,0,255)
		love.graphics.draw(self.canvases.buffer)
			love.graphics.pop()
	love.graphics.setCanvas()
		love.graphics.setColor(255,255,255)
		love.graphics.setBlendMode("additive")
		love.graphics.draw(self.canvases.red)
		love.graphics.draw(self.canvases.green)
		love.graphics.draw(self.canvases.blue)
		love.graphics.setBlendMode("alpha")
	for i,c in pairs(self.canvases) do
		c:clear()
	end
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
