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
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setColor(255,255,255)
	print('Loading...')
	local stime = love.timer.getTime()
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Stealing Identity",0,0)
		love.graphics.present()
	love.window.setIcon(love.image.newImageData('res/sprites/rock1.png'))
		love.graphics.clear()
	-------------------------
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Forgeing Paperwork",0,0)
		love.graphics.present()
	initFS()
		love.graphics.clear()
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Exterminating Mice",0,0)
		love.graphics.present()
	love.mouse.setVisible(false)
		love.graphics.clear()
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Hiring Scribes",0,0)
		love.graphics.present()
	fonts = loadFonts()
	love.graphics.setFont(fonts.small)
		love.graphics.clear()
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Adjusting Hearing Aid",0,0)
		love.graphics.present()
	love.audio.setVolume(1.0) -- 0.-1.
		love.graphics.clear()
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Outsourcing Artwork",0,0)
		love.graphics.present()
	res.init()
		love.graphics.clear()
		love.graphics.print("Loading...",love.graphics.getWidth()/2-40,love.graphics.getHeight()/2)
		love.graphics.print("Heightening Definition",0,0)
		love.graphics.present()
	screen.init(1280,720,false,true,0)
	print(ansicolors.yellow..'Done Loading. Took '..(love.timer.getTime()-stime)..' seconds to load.\n'..ansicolors.clear)

	state = intro.make(80)
	_state = nil
	-------------------------
end

function love.update(dt)
	if (state.name or tostring(state)) ~= _state then
		print(ansicolors.yellow.."Changing State: "..(_state or "NIL").." to "..(state.name or tostring(state))..ansicolors.clear)
		_state = state.name or tostring(state)
	end
	-------------------------
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
	love.graphics.points(love.mouse.getPosition())
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
