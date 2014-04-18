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
require("shaders")
require("scores")
require("ansicolours")

function love.load()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,love.window.getWidth(),love.window.getHeight())
	love.graphics.setColor(255,255,255)
	love.graphics.print("Loading...",love.window.getWidth()/2-40,love.window.getHeight()/2)
	love.graphics.present()
	print('Loading...')
	local stime = love.timer.getTime()
	love.window.setIcon(love.image.newImageData('res/sprites/rock1.png'))
	-------------------------
	initFS()
	love.mouse.setVisible(false)
	fonts = loadFonts()
	love.graphics.setFont(fonts.small)
	love.audio.setVolume(0) -- 0.-1.
	res.init()
	screen.init(1280,720,false,false,0)
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

	screen:draw()
	if state.draw then
		state:draw()
	end
	screen:drawFlash()
	
	if screen.abberating then screen:releaseChromaticFilter() end

	love.graphics.setPointSize(2)
	love.graphics.setColor(255,255,255,128)
	love.graphics.point(love.mouse.getPosition())
	love.graphics.setColor(0,0,0,128)
	love.graphics.rectangle("line",love.mouse.getX()-2,love.mouse.getY()-2,4,4)
	love.graphics.setPointSize(1)
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
