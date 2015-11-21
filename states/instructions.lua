instructions = {}
instructions.__index = instructions

function instructions.make()
	local i = {}
	setmetatable(i, instructions)
	i.name = "Instructions"
	i.strings = {
	[[Use the WASD and LP;' to move your craft.]],
	[[Press left and right SHIFT to activate your tether apparatus.
Both players must tether at the same time to complete the effect.]],
	[[Ready?]]
	}
	i.index = 1
	i.res = {joystick0 = res.load("image","joystickU.png"),
			joystick1 = res.load("image","joystickR.png"),
			joystick2 = res.load("image","joystickD.png"),
			joystick3 = res.load("image","joystickL.png"),
			background = res.load("image","greyField.png")}
	i.timers = {
		joystick = 0
	}
	love.graphics.setFont(fonts.medium)
	screen:setBackground(i.res.background)

	return i
end

function instructions:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.res.background,0,0,0,screen.width/1280,screen.height/720)

	love.graphics.printf(self.strings[self.index],0,(screen.height/2) - (fonts.medium:getHeight(self.strings[self.index])/2),screen.width,"center")
	-- if self.index == 1 then
	-- 	local image = self.res["joystick"..math.floor(self.timers.joystick)]
	-- 	love.graphics.draw(image,560-image:getWidth()/2,(screen.height/2)-45)
	-- end
end

function instructions:update()
	self.timers.joystick = (self.timers.joystick + .02)%4
	if self.index == 0 then
		state = game.make()
	end
end

function instructions:keypressed(k)
	if k == "escape" then
		self.index = 0
	else
		self.index = (self.index + 1)%(#self.strings + 1)

	end
end