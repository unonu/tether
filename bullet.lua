bullet = {}
bullet.__index = bullet

function bullet.make(x,y,d,s,tl,owner)
	local b = {}
	setmetatable(b,bullet)
	b.x,b.y = x,y
	b.d = d
	b.s = s
	b.life = 0
	b.tl = tl or 0
	b.owner = owner or "none"
	local garbage
	garbage, b.target = state.player:closest(x,y)
	
	table.insert(state.bullets,b)
end

function bullet:draw()
	love.graphics.draw(state.res.bullet,self.x,self.y,self.d-(math.pi/2),1,1,9,18)
end

function bullet:update(dt)
	self.life = self.life+1
	if self.life < self.tl then
		self.d = math.atan2(self.y-self.target.y,self.x-self.target.x)
	end
	self.x = self.x-self.s*math.cos(self.d)
	self.y = self.y-self.s*math.sin(self.d)
end
