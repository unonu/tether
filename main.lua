require("functions")
require("res")
require("player")
require("maths")
require("rock")
require("enemy")
require("bullet")
require("states")
require("particles")
require("ansicolours")

function love.load()
	print('Loading...')
	local stime = love.timer.getTime()
	love.window.setIcon(love.image.newImageData('res/sprites/rock1.png'))
	-------------------------
--	love.graphics.setBackgroundColor(255,255,255)
	initFS()
	joysticks = loadJoysticks()
	-- print(joysticks[1]:getGamepadMapping('triggerleft'))
	-- love.joystick.setGamepadMapping(joysticks[1]:getGUID(),'dpup','hat',1,'u')
	-- print(joysticks[1]:getGamepadMapping('dpup'))
	-- love.joystick.setGamepadMapping(joysticks[1]:getGUID(),'dpright','hat',1,'r')
	-- print(joysticks[1]:getGamepadMapping('dpright'))
	--
	-- love.joystick.setGamepadMapping(joysticks[1]:getGUID(),'dpdown','hat',1,'d')
	-- print(joysticks[1]:getGamepadMapping('dpdown'))
	-- love.joystick.setGamepadMapping(joysticks[1]:getGUID(),'dpup','hat',1,'l')
	-- print(joysticks[1]:getGamepadMapping('dpup'))
	-- loadJoysticks()
	love.mouse.setVisible(false)
	fonts = loadFonts()
	love.graphics.setFont(fonts.small)
	love.audio.setVolume(0) -- 0.-1.
--	love.keyboard.setKeyRepeat(0,2)
	res.init()
	screen.init()
	print(ansicolors.yellow..'Done Loading. Took '..(love.timer.getTime()-stime)..' seconds to load.\n'..ansicolors.clear)
	state = intro.make(80)
	-------------------------
end

function love.update(dt)
	if state.update then
		state:update(dt)
	end
	screen:update()
	-- print(joysticks[1]:getHat(1))
	-- print(joysticks[1]:getGamepadAxis('leftx'))
	-- print(joysticks[1]:getGamepadAxis('rightx'))
end

function love.draw()
	if screen.abberating then screen:setChromaticFilter() end

--	screen:drawShake()
	screen:draw()
	if state.draw then
		state:draw()
	end
	screen:drawFlash()
	
	if screen.abberating then screen:releaseChromaticFilter() end
	screen:capFPS()
	--love.graphics.print(love.timer.getFPS(),0,0)
end

function love.keypressed(k)
	if state.keypressed then
		state:keypressed(k)
	end
end

-- function love.joystickpressed(joystick, button)
-- 	print(joystick:isGamepadDown(button))
-- 	print(joystick:getName(),button)
-- end

-- function love.joystickreleased(joystick,button)
-- 	print(joystick:getName(),button)
-- 	if state.joystickpressed then
-- 		state:joystickpressed(joystick, )
-- 	end
-- end
function love.gamepadpressed(joystick,button)
	print(button)
	if state.gamepadpressed then
		state:gamepadpressed(joystick,button)
	end
end

function love.gamepadreleased(joystick,button)
	print(button)
	if state.gamepadreleased then
		state:gamepadreleased(joystick,button)
	end
end

function love.mousepressed(x,y,button)
	if state.mousepressed then
		state:mousepressed(x,y,button)
	end
end
