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

	local pixelcode = [[
	
	extern vec2 size;

	vec2 clamp(vec2 pos) {
		number x = pos.x;
		number y = pos.y;
		if (x < 0.0) x = 0.0;
		if (y < 0.0) y = 0.0;
		if (x > 1.0) x = 1.0;
		if (y > 1.0) y = 1.0;
		return vec2(x, y);
	}

	vec4 effect ( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
		number distance = 1.0;
		number num = 0.0;
		vec4 averagecolor = vec4(0.0, 0.0, 0.0, 0.0);
		for (number x = -6.0 ; x <= 6.0; x++)
		for (number y = -6.0 ; y <= 6.0; y++) {
			vec4 color = Texel(texture, clamp(vec2(texture_coords.x + x/size.x, texture_coords.y + y/size.y)));
			if (color.a > 0.0) {
				num = num + 1.0;
				averagecolor.r = (averagecolor.r + color.r);
				averagecolor.g = (averagecolor.g + color.g);
				averagecolor.b = (averagecolor.b + color.b);
				averagecolor.a = (averagecolor.a + color.a);
				number x1 = x/size.x;
				number y1 = y/size.y;
				number dist = sqrt( x1*x1 + y1*y1 ) * 200;
				if (dist < distance) {
					distance = dist;
				}
			}
		}
		return vec4(averagecolor.r / num, averagecolor.g / num, averagecolor.b / num, averagecolor.a / num - distance);
	}
	]]

    local vertexcode = [[
        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]]

    shader = love.graphics.newShader(pixelcode, vertexcode)
	shader:send('size',{1280,720})



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
