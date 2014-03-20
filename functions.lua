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


function table.getIndex(t,item)
	if t and #t ~= nil then
		for i=1,#t do
			if t[i] == item then return i end
		end
	elseif t then
		for i,s in pairs(t) do
			if s == item then return i end
		end
	else return nil end
end

function table.compare(t1,t2)
	if #t1 == #t2 then
		for i=1,#t1 do
			if t1[i] ~= t2[i] then return false end
		end
		return true
	end
end

function splitString(str,del)
	local t = {}
	local c = 0
	while c do
		table.insert(t,str:sub(c+1,((str:find(del or ' ',c+1)) or 0)-1))
		c = str:find(del or  ' ',c+1)
	end
	return t
end

function atoi(s)
	local i = 0
	for c in s:gmatch("%d") do i = i*10+c end
	return i
end

function colorExtreme( table,m )
	local t ={}
	for i,v in ipairs(table) do
		if v >= m then t[i] = 255
		else t[i] = 0 end
	end
	return t
end


function hexToCol(h)
	local t
	for c in h:gmatch(".") do
		t = (t or '')..c..','
	end
	t = t:gsub("%a",function (s) return s:lower():byte()-87 end)
	t = splitString(t,",")
	return {t[2]*16+t[3],t[4]*16+t[5],t[6]*16+t[7]}
end

function love.graphics.stippledLine( x1,y1,x2,y2,l,g )
	local ang = math.atan2((y2-y1),(x2-x1))
	local x_dist = math.cos(ang)
	local y_dist = math.sin(ang)
	for i=0, math.floor(((x2-x1)^2+(y2-y1)^2)^.5/(l+g)) do
		love.graphics.line(x1+(i*x_dist*(l+g)),y1+(i*y_dist*(l+g)),x1+(i*x_dist*(l+g))+(x_dist*l),y1+(i*y_dist*(l+g))+(y_dist*l))
	end
end

function love.graphics.curve(x,y,r,b,e,s)
	local points = {}
	local step = ((e-b))/s
	for i = 1, (s*2)+2, 2 do
		points[i] = x + math.cos(b+(step*(i-1)/2))*r
		points[i+1] = y + math.sin(b+(step*(i-1)/2))*r
	end
	love.graphics.line(unpack(points))
end

function initFS(name)
	print(ansicolors.yellow.."INIT FIlesystem, please hold..."..ansicolors.clear)
	if not love.filesystem.exists("tether") then
		print("Couldn\'t find save directory")
		love.filesystem.setIdentity('tether')
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
function screen.init(w,h,f,v,a)
	local s = {}
	setmetatable(s,screen)
	s.width = w or 1280
	s.height = h or 720
	s.flags = {fullscreen = f or false,
				fullscreentype = "desktop",
				vsync = v or "false",
				fsaa = a or 0,
				resizable = false,
				borderless = true,
				centered = true,
				display = 1,
				minwidth = 16,
				minheight = 9,}
	love.window.setMode(s.width,s.height,s.flags)
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
	s.fullscreen = f or false
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

--no clue how this works anymore
function screen:flash(period,speed,color,mode)
	if mode then self:setFlashMode(mode) end
	self.timers.flashDuration = period or 1
	self.timers.flashPeriod = {100,100}
	self.flashSpeed = speed or 1
	self.colors.flash = color or {255,255,255}
end

function screen:setFlashMode(mode)
	self.flashMode = mode
end

function screen:clearEffects(a)
	if not a then
		self.timers.shake = 0
		self.timers.chrome = 0
		self.timers.flashPeriod = {0,0}
		self.timers.flashDuration = 0
	else
		if a == 'flash' then
			self.timers.flashPeriod = {0,0}
			self.timers.flashDuration = 0
		elseif a == 'shake' then
			self.timers.shake = 0
		elseif a =='chrome' then
			self.timers.chrome = 0
		end
	end
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
		--green
			love.graphics.translate(4*self.focus,-4*self.focus)
			love.graphics.setColorMask( false, true, false)
			love.graphics.draw(self.canvases.buffer)
		--blue
			love.graphics.translate(4*self.focus,4*self.focus)
			love.graphics.setColorMask( false, false, true)
			love.graphics.draw(self.canvases.buffer)
	love.graphics.pop()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColorMask()
	self.canvases.buffer:clear()
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
	m.life = math.max(((life or -1)*60),-1)
	m.color = color or {255,255,255}
	m.font = font or 'medium'
	
	print("sending message: "..text)
	table.insert(self.messages,m)
end

function messages:draw()
	for i,m in ipairs(self.messages) do
		love.graphics.setColor(m.color[1],m.color[2],m.color[3],(m.color[4] or math.min(255*m.life/60,255)))
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
		-- elseif m.mode == 'still' then
		end
			if m.life > 0 then
				m.life = m.life - 1
			elseif m.life == 0 then
				table.remove(self.messages,i)
			end
	end
	love.graphics.setFont(fonts.small)
end

function messages:clear()
	self.messages = {}
end
