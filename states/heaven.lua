heaven = {}
heaven.__index = heaven

function heaven.make(player,rounds,rocks,enemies,time,name1,name2)
	love.graphics.setFont(fonts.large)
	love.audio.stop()
	love.keyboard.setKeyRepeat(true)
	messages:clear()
	local h = {}
	setmetatable(h,heaven)
	h.player = player
	h.player.members.a.spawned = true
	h.player.members.b.spawned = true
	h.grabPlayer = true
	h.screen = love.graphics.newCanvas()
		--
		love.graphics.setCanvas(h.screen)
		love:draw()
		love.graphics.setCanvas()
	screen:clearEffects()
	screen:shake(.8,3)
	h.winner = 'a'
	h.loser = 'b'
	h.tie = false
	if player.members.a.points > player.members.b.points then
		h.winner = 'a'; h.loser = 'b'
	elseif player.members.a.points > player.members.b.points then
		h.winner = 'b'; h.loser = 'a'
	else
		h.tie = true
	end
	h.rocks = rocks
	h.rounds = rounds
	h.enemies = enemies
	h.time = time
	h.ready = false
	h.menu = {"Restart","Main Menu"}
	h.menuIndex = 1
	h.name = "      "
	h.characters = {{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
						'0','1','2','3','4','5','6','7','8','9','!','?','.',',','-','_','&','#','/',' '},
					}
	h.winnerName = {1,1,1}
	h.loserName = {1,1,1}
	if name1 and h.winner == 'a' then
		h.winnerName = name1
		h.loserName = name2
	elseif name1 and h.winner == 'b' then
		h.winnerName = name2
		h.loserName = name1
	end
	h.winnerIndex = 1
	h.loserIndex = 1
	h.winnerConfirm = false
	h.loserConfirm = false
	h.confirm = false

	h.timers = {slideWinner = {0,0,0,20},
				slideLoser = {0,0,0,20},
				gameFade = {100,100,100,100,100,100,100,100,100},
				wY = screen.height,
				lY = 0,
				winnerFlyin = 1,
				loserFlyin = -1,
				pc = {r=0,g=0,b=255,timer = 0},}

	if not love.filesystem.exists("records/highScores.txt") then
		print("No high scores found. Making")
		h.record = love.filesystem.newFile("records/highScores.txt",'w')
		h.record:write("#high scores!\n#name|points|points|lives|lives|rounds|rocks|enemies")
		h.record:close()
	end
	h.record = "records/highScores.txt"
	h.scores = {}

	h.res = {grad = res.load("image","healthbar.png"),}

	return h
end

function heaven:draw()
if self.ready and (not self.confirm or self.timers.winnerFlyin > -1.5) then
		love.graphics.setColor(24,24,24)
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)

		love.graphics.setFont(fonts.large)
		love.graphics.push()
		love.graphics.translate((screen.width/2)-96,screen.height/2)

	--confirm tether
		love.graphics.setColor(math.random(14,77),math.random(59,155),255)
	if self.winnerConfirm or self.timers.winnerFlyin < -0.1 then
		love.graphics.draw(self.res.grad,-64,44,-math.pi/2,48,16)
	end
	if self.loserConfirm or self.timers.winnerFlyin < -0.1 then
		love.graphics.draw(self.res.grad,256,-4,math.pi/2,48,16)
	end

	--winner
		love.graphics.setColor(255,255,255)
	if not self.winnerConfirm then
		love.graphics.setColor(128,128,128,128)
	love.graphics.print(self.characters[1][math.loop(1,self.winnerName[1] + 1,#self.characters[1])],0,20 + self.timers.slideWinner[1])
	love.graphics.print(self.characters[1][math.loop(1,self.winnerName[1] - 1,#self.characters[1])],0,-20 + self.timers.slideWinner[1])

	love.graphics.print(self.characters[2][math.loop(1,self.winnerName[2] + 1,#self.characters[2])],32,20 + self.timers.slideWinner[2])
	love.graphics.print(self.characters[2][math.loop(1,self.winnerName[2] - 1,#self.characters[2])],32,-20 + self.timers.slideWinner[2])

	love.graphics.print(self.characters[3][math.loop(1,self.winnerName[3] + 1,#self.characters[3])],64,20 + self.timers.slideWinner[3])
	love.graphics.print(self.characters[3][math.loop(1,self.winnerName[3] - 1,#self.characters[3])],64,-20 + self.timers.slideWinner[3])

		love.graphics.setColor(255,255,255,128)
		love.graphics.rectangle("fill",((self.winnerIndex-1)*32),42,28,4)
		love.graphics.setColor(unpack(self.player.members[self.winner].color))
	end
	love.graphics.draw(self.player.imageLarge,res.quads["playerLarge2"],-64,16+((screen.height/2)*self.timers.winnerFlyin),0,.5,.5,144,144)
	love.graphics.print(self.characters[1][self.winnerName[1]],0,0+self.timers.slideWinner[1])
	love.graphics.print(self.characters[2][self.winnerName[2]],32,0+self.timers.slideWinner[2])
	love.graphics.print(self.characters[3][self.winnerName[3]],64,self.timers.slideWinner[3])


	--loser
		love.graphics.setColor(255,255,255)
	if not self.loserConfirm then
		love.graphics.setColor(128,128,128,128)
	love.graphics.print(self.characters[4][math.loop(1,self.loserName[1] + 1,#self.characters[1])],96,20 + self.timers.slideLoser[1])
	love.graphics.print(self.characters[4][math.loop(1,self.loserName[1] - 1,#self.characters[1])],96,-20 + self.timers.slideLoser[1])

	love.graphics.print(self.characters[5][math.loop(1,self.loserName[2] + 1,#self.characters[2])],128,20 + self.timers.slideLoser[2])
	love.graphics.print(self.characters[5][math.loop(1,self.loserName[2] - 1,#self.characters[2])],128,-20 + self.timers.slideLoser[2])

	love.graphics.print(self.characters[6][math.loop(1,self.loserName[3] + 1,#self.characters[3])],160,20 + self.timers.slideLoser[3])
	love.graphics.print(self.characters[6][math.loop(1,self.loserName[3] - 1,#self.characters[3])],160,-20 + self.timers.slideLoser[3])

		love.graphics.setColor(255,255,255,128)
		love.graphics.rectangle("fill",96+((self.loserIndex-1)*32),42,28,4)
		love.graphics.setColor(unpack(self.player.members[self.loser].color))
	end
	love.graphics.draw(self.player.imageLarge,res.quads["playerLarge2"],256,16+((screen.height/2)*self.timers.loserFlyin),-math.pi,.5,.5,144,144)
	love.graphics.print(self.characters[4][self.loserName[1]],96,0+self.timers.slideLoser[1])
	love.graphics.print(self.characters[5][self.loserName[2]],128,0+self.timers.slideLoser[2])
	love.graphics.print(self.characters[6][self.loserName[3]],160,self.timers.slideLoser[3])

		love.graphics.pop()
elseif self.ready and self.confirm then
		love.graphics.setFont(fonts.large)
		love.graphics.push()
		love.graphics.translate((screen.width/2),8)

		--name
		love.graphics.setColor(self.timers.pc.r,self.timers.pc.g,self.timers.pc.b)
		local tag = findScore(self.scores,#self.scores)..". "..self.name.." "..(self.player.members.a.points + self.player.members.b.points)
		love.graphics.print(tag,-fonts.large:getWidth(tag)/2,0)

		love.graphics.pop()

		love.graphics.push()
		love.graphics.translate(0,62)
	drawScores(self.scores,15,{self.timers.pc.r,self.timers.pc.g,self.timers.pc.b})
		love.graphics.pop()

	love.graphics.setColor(0,0,0,220)
	love.graphics.rectangle("fill",0,screen.height-36,screen.width,36)
	local x = 12
		love.graphics.setFont(fonts.medium)
	for i,m in ipairs(self.menu) do
		if self.menuIndex == i then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(128,128,128)
		end
		love.graphics.print(m,0+x,screen.height-34)
		x = x+love.graphics.getFont():getWidth(m)+24
	end
	if self.timers.pc.r > 0 and self.timers.pc.g < 255 and self.timers.pc.b == 0 then
		self.timers.pc.r = self.timers.pc.r -1
		self.timers.pc.g = self.timers.pc.g +1
	elseif self.timers.pc.r == 0 and self.timers.pc.g > 0 and self.timers.pc.b < 255 then
		self.timers.pc.g = self.timers.pc.g -1
		self.timers.pc.b = self.timers.pc.b +1
	elseif self.timers.pc.r < 255 and self.timers.pc.g == 0 and self.timers.pc.b > 0 then
		self.timers.pc.b = self.timers.pc.b -1
		self.timers.pc.r = self.timers.pc.r +1
	end
	if self.timers.pc.timer < 30 then self.timers.pc.timer = self.timers.pc.timer +1 end

elseif not self.ready then

	local frac = (100-self.timers.gameFade[1])/100

	-- love.graphics.setColor(255,0,0)
	-- love.graphics.draw(self.screen)

	love.graphics.setColor(0,0,0)
	love.graphics.circle("fill",screen:getCentre('x'),screen:getCentre('y'),screen.width*frac,36)

	love.graphics.setShader(shaders.monochrome)
	self.player:draw()
	love.graphics.setShader()

	love.graphics.setFont(fonts.large)

	local _x,_y = (math.floor(math.random(0,100)/100)*math.random(4,6)),(math.floor(math.random(0,100)/100)*math.random(4,6))
		if _x ~= 0 or _y ~= 0 then
			screen:aberate(.1,math.rsign(1))
		end
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('G',(screen.width/2)-142+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[2])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('a',(screen.width/2)-102+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[3])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('m',(screen.width/2)-74+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[4])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)-38+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[5])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print(' ',(screen.width/2)-10+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[6])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('O',(screen.width/2)+18+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[7])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('v',(screen.width/2)+58+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[8])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('e',(screen.width/2)+86+_x,-16+_y + ((screen.height/2)*frac))
	frac = (100-self.timers.gameFade[9])/100
		love.graphics.setColor(255,255,255,255*frac)
	love.graphics.print('r',(screen.width/2)+114+_x,-16+_y + ((screen.height/2)*frac))

end
end

function heaven:update(dt)
if self.ready then
if not self.confirm then
	if self.timers.winnerFlyin > 0 then self.timers.winnerFlyin = self.timers.winnerFlyin - .1 end
	if self.timers.loserFlyin < 0 then self.timers.loserFlyin = self.timers.loserFlyin + .1 end

	for i = 1, 3 do
		if self.timers.slideWinner[i] > 0 then self.timers.slideWinner[i] = self.timers.slideWinner[i] - 2
		elseif self.timers.slideWinner[i] < 0 then self.timers.slideWinner[i] = self.timers.slideWinner[i] + 2 end
		if self.timers.slideLoser[i] > 0 then self.timers.slideLoser[i] = self.timers.slideLoser[i] - 2
		elseif self.timers.slideLoser[i] < 0 then self.timers.slideLoser[i] = self.timers.slideLoser[i] + 2 end
	end

	self.winnerConfirm = love.keyboard.isDown(self.player.members[self.winner].keys.tether)
	self.loserConfirm = love.keyboard.isDown(self.player.members[self.loser].keys.tether)
	self.confirm = (self.winnerConfirm and self.loserConfirm)

	if self.confirm then
		self.winnerConfirm = false
		self.loserConfirm = false
		self.name = self.characters[1][self.winnerName[1]]..self.characters[2][self.winnerName[2]]..self.characters[3][self.winnerName[3]]..
						self.characters[4][self.loserName[1]]..self.characters[5][self.loserName[2]]..self.characters[6][self.loserName[3]]
		local toAppend = ('\n'..self.name.."|"..self.player.members[self.winner].points.."|"..self.player.members[self.loser].points.."|"..
							self.player.members[self.winner].lives.."|"..self.player.members[self.loser].lives.."|"..
							self.rounds.."|"..self.rocks.."|"..self.enemies.."|"..self.time)
		print("Adding score to record.")
		love.filesystem.append(self.record,toAppend)
		self.scores = loadScores(self.record)
		table.sort(self.scores,sortScoresCombo)
		love.keyboard.setKeyRepeat(false)
	end
else
	if self.timers.winnerFlyin > -1.5 then self.timers.winnerFlyin = self.timers.winnerFlyin - .1 end
	if self.timers.loserFlyin < 1.5 then self.timers.loserFlyin = self.timers.loserFlyin + .1 end

	if self.winnerConfirm or self.loserConfirm then
		if self.menu[self.menuIndex] == 'Restart' then
			screen:shake(.15,2)
			if self.winner == 'a' then
				state = game.make(self.winnerName,self.loserName)
			else
				state = game.make(self.loserName,self.winnerName)
			end
		elseif self.menu[self.menuIndex] == 'Main Menu' then
			state = mainmenu.make(true)
		end
	end
end
else
	for i =1,9 do
		if i == 1 then
			if self.timers.gameFade[i] > 0 then
				self.timers.gameFade[i] = self.timers.gameFade[i] - (self.timers.gameFade[i]/12)
			end
		else
			if self.timers.gameFade[i-1] < 60 and self.timers.gameFade[i] > 0 then
				self.timers.gameFade[i] = self.timers.gameFade[i] - (self.timers.gameFade[i]/12)
			end
		end
	end
end
end

function heaven:keypressed(k)
if self.ready and not self.confirm then
	--choose the name column to edit or the menu item
	if k == self.player.members[self.winner].keys.right and not self.winnerConfirm then
			if self.winnerIndex < 3 then self.winnerIndex = self.winnerIndex + 1 end
	elseif k == self.player.members[self.winner].keys.left and not self.winnerConfirm then
			if self.winnerIndex > 1 then self.winnerIndex = self.winnerIndex - 1 end
	elseif k == self.player.members[self.loser].keys.right and not self.loserConfirm then
			if self.loserIndex < 3 then self.loserIndex = self.loserIndex + 1 end
	elseif k == self.player.members[self.loser].keys.left then
			if self.loserIndex > 1 then self.loserIndex = self.loserIndex - 1 end
	--choose the character for the name column
	elseif k == self.player.members[self.winner].keys.up and not self.winnerConfirm then
			self.winnerName[self.winnerIndex] = math.loop(1,self.winnerName[self.winnerIndex] - 1,#self.characters[self.winnerIndex])
			self.timers.slideWinner[self.winnerIndex] = -self.timers.slideWinner[4]
			screen:shake(.15,2)
	elseif k == self.player.members[self.winner].keys.down and not self.winnerConfirm then
			self.winnerName[self.winnerIndex] = math.loop(1,self.winnerName[self.winnerIndex] + 1,#self.characters[self.winnerIndex])
			self.timers.slideWinner[self.winnerIndex] = self.timers.slideWinner[4]
			screen:shake(.15,2)
	elseif k == self.player.members[self.loser].keys.up and not self.loserConfirm then
			self.loserName[self.loserIndex] = math.loop(1,self.loserName[self.loserIndex] - 1,#self.characters[self.loserIndex+3])
			self.timers.slideLoser[self.loserIndex] = -self.timers.slideLoser[4]
			screen:shake(.15,2)
	elseif k == self.player.members[self.loser].keys.down and not self.loserConfirm then
			self.loserName[self.loserIndex] = math.loop(1,self.loserName[self.loserIndex] + 1,#self.characters[self.loserIndex+3])
			self.timers.slideLoser[self.loserIndex] = self.timers.slideLoser[4]
			screen:shake(.15,2)
	end
elseif self.ready and self.confirm then
	if k == self.player.members[self.winner].keys.right then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.winner].keys.left then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.loser].keys.right then
			if self.menuIndex < #self.menu then
				self.menuIndex = self.menuIndex+1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.loser].keys.left then
			if self.menuIndex > 1 then
				self.menuIndex = self.menuIndex-1
				screen:shake(.15,2)
			end
	elseif k == self.player.members[self.winner].keys.tether then
		self.winnerConfirm = not self.winnerConfirm
	elseif k == self.player.members[self.loser].keys.tether then
		self.loserConfirm = not self.loserConfirm
	end
else
	if self.timers.gameFade[9] < .01 then
		self.ready = true
	end
end
end