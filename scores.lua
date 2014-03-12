--high scores
function loadScores(path)
	local scores = {}
	for l in love.filesystem.lines(path) do
		if l:sub(1,1) ~= "#" then
			local s = {}
			local i = l:find('|')
			s.name = l:sub(1,l:find('|'))
			print(l:sub(i+1,l:find('|',i+1)-1))
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
			table.insert(scores,s)
		end
	end
	return scores
end

function sortScoresCombo(a,b)
	if a.winnerPoints+a.loserPoints < b.winnerPoints+b.loserPoints then
		return false
	elseif a.winnerPoints+a.loserPoints == b.winnerPoints+b.loserPoints then
		return a.name > b.name
	end
end

function sortScoresTime(a,b)
	if a.time < b.time then
		return false
	elseif a.time == b.time then
		return a.name > b.name
	end
end

function drawScores(scores,limit)
	for i, s in ipairs(scores) do
		if math.fmod(i,2) == 1 then
			love.graphics.setColor(255,255,255,128)
		else
			love.graphics.setColor(128,128,128,128)
		end
		love.graphics.rectangle("fill",0,(i-1)*58,screen.width,58)
		love.graphics.setColor(0,0,0,128)
		love.graphics.line(0,(i-1)*58,screen.width,(i-1)*58)
		love.graphics.print(i..'. '..s.name,4,(i-1)*58)
		love.graphics.print(s.winnerPoints+s.loserPoints,272,(i-1)*58)
		if i == (limit or 100) then break end
	end
end