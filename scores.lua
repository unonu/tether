--high scores
function loadScores(path)
	local scores = {}
	for l in love.filesystem.lines(path) do
		if l:sub(1,1) ~= "#" then
			local s = {}
			local i = l:find('|')
			s.name = l:sub(1,l:find('|'))
			s.winnerPoints = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.loserPoints = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.winnerLives = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.loserLives = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.rounds = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.lives = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.enemies = tonumber(l:sub(i+1,l:find('|',i+1)-1))
				i = l:find('|',i+1)
			s.time = tonumber(l:sub(i+1))
			s.index = #scores+1
			table.insert(scores,s)
		end
	end
	scores.last = scores[#scores]
	return scores
end

function sortScoresCombo(a,b)
	if a.winnerPoints+a.loserPoints > b.winnerPoints+b.loserPoints then
		return true
	elseif a.winnerPoints+a.loserPoints == b.winnerPoints+b.loserPoints then
		return a.name < b.name
	end
end

function sortScoresTime(a,b)
	if a.time > b.time then
		return true
	elseif a.time == b.time then
		return a.name > b.name
	end
end

function drawScores(scores,limit,scol)
	for i, s in ipairs(scores) do
		if math.fmod(i,2) == 1 then
			love.graphics.setColor(255,255,255,128)
		else
			love.graphics.setColor(128,128,128,128)
		end
		if s.index == scores.last.index and scol then
			love.graphics.setColor(unpack(scol))
		end
		love.graphics.rectangle("fill",0,(i-1)*40,screen.width,40)
		love.graphics.setColor(255,255,255,128)
		love.graphics.line(0,(i-1)*40,screen.width,(i-1)*40)
		love.graphics.setColor(255,255,255)
		love.graphics.print(i..'. '..s.name,4,(i-1)*40)
		love.graphics.print(s.winnerPoints+s.loserPoints,272,(i-1)*40)
		if i == (limit or 100) then break end
	end
end

function findScore(scores,index)
	for i,s in ipairs(scores) do
		if s.index == index then
			return i
		end
	end
	return -1
end