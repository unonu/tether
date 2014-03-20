require("functions")
require("res")
require("player")
require("maths")
require("rock")
require("enemy")
require("bullet")
require("states")
require("rounder")
require("drops")
require("particles")
require("scores")
require("ansicolours")

function love.load()
	print('Loading...')
	local stime = love.timer.getTime()
	love.window.setIcon(love.image.newImageData('res/sprites/rock1.png'))
	-------------------------
	initFS()
	-- love.mouse.setVisible(false)
	fonts = loadFonts()
	love.graphics.setFont(fonts.small)
	love.audio.setVolume(0) -- 0.-1.
	res.init()
	screen.init(1920,1080,true,false,2)
	print(ansicolors.yellow..'Done Loading. Took '..(love.timer.getTime()-stime)..' seconds to load.\n'..ansicolors.clear)

	state = intro.make(80)
	-------------------------
end

function love.update(dt)
	if state.update then
		state:update(dt)
	end
	screen:update()
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

	-- screen:capFPS()
	-- love.graphics.print(love.timer.getFPS(),0,0)
	-- local frames = love.timer.getFPS()
	-- if frames < 24 then print("Dropping frames fast:"..frames) end
end

function love.keypressed(k)
	if state.keypressed then
		state:keypressed(k)
	end
end

function love.mousepressed(x,y,button)
	if state.mousepressed then
		state:mousepressed(x,y,button)
	end
end
