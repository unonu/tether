function rounder()
	local progress = {}
	--per round
	progress[1],progress[2] = math.abs(math.modf(state.stats.rocksRound/state.quota))
	if progress[1] == 1 then
		state.player:givePoints('both',100)
		state.round = state.round+1
		state.stats.rocksRound = 0
		-- state.player.tetherDistance = 100 + state.round*4
		messages:clear()
		messages:new("ROUND "..state.round.."!",screen:getCentre('x'),screen:getCentre('y'),"still",2,{255,255,0},'boomLarge')
		for i,e in ipairs(state.enemies) do
			e.kill = true
		end
		
		if state.round == -1 then
		elseif state.round == 10 then
			state.quota = -1
			state.boss = true
			state.grabPlayer = true
			state.player.members.a.x,state.player.members.a.y = screen:getCentre('x')/2,screen:getCentre('y')
			state.player.members.b.x,state.player.members.b.y = screen:getCentre('x')*1.5,screen:getCentre('y')
			state.player:giveHealth('both',8)
			state.rocks = {}
			state.enemies = {}
			screen:flash(1,20,{255,255,255},"full")
			table.insert(state.enemies,torrent.make(screen:getCentre('x'),screen:getCentre('y'),512))
			messages:new('DEFEAT THE BOSS!',screen:getCentre('x'),screen:getCentre('y')+48,"still",3,{255,255,255},'boomLarge')
			state.objective = "BOSS"
		elseif state.round == 11 then
			state.objective = nil
			state.quota = 6
			state.boss = false
			state.grabPlayer = false
			state.player:giveHealth('both',16)
		elseif state.round == 16 then
			if state.player.members.a.stats.deaths == 0 and state.player.members.a.hp == state.player.members.a.stats.hp then
				messages:new('UNTOUCHABLE!',state.player.members.a.x,state.player.members.a.y,'up',2,{255,24,15},'medium')
				state.player.members.a.immunity = 40
			elseif state.player.members.a.stats.deaths == 0 then
				messages:new('SURVIVOR!',state.player.members.a.x,state.player.members.a.y,'up',2,{255,24,15},'medium')
				state.player.members.a.immunity = 20
			end
			if state.player.members.b.stats.deaths == 0 and state.player.members.b.hp == state.player.members.b.stats.hp then
				messages:new('UNTOUCHABLE!',state.player.members.b.x,state.player.members.b.y,'up',2,{255,24,15},'medium')
				state.player.members.b.immunity = 40
			elseif state.player.members.b.stats.deaths == 0 then
				messages:new('SURVIVOR!',state.player.members.b.x,state.player.members.b.y,'up',2,{255,24,15},'medium')
				state.player.members.b.immunity = 20
			end
		elseif state.round == 21 then
			state.objective = nil
			state.quota = 10
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 31 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 41 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 51 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 61 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 71 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 81 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 91 then
			state.objective = nil
			state.quota = 12
			state.boss = false
			state.grabPlayer = false
		elseif state.round == 101 then
			state.objective = "REACH INFINITY"
			state.quota = -1
			state.boss = true
			state.grabPlayer = false
		end
	end
	--
	--durring round
	--first cycle
	if state.round <= 2 then
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100))) end
		if math.random(0,10000) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 2 and state.round <= 4 then
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,3)) end
		if math.random(0,10000) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 4 and state.round <= 6 then
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,10000) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 6 and state.round <= 8 then
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
		if math.random(0,10000) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round == 9 then
		if #state.rocks < 14 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
		if math.random(0,10000) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round == 10 then
		if #state.rocks < 6 and math.random(0,200) == math.random(0,200) then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),false,3)) end
		if #state.enemies == 0 then
			state.stats.rocksRound = state.quota
		end
	--second cycle
	elseif state.round > 10 and state.round <= 11 then
		if #state.enemies < 1 then
			for i = 1, 1-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 11 and state.round <= 14 then
		if #state.enemies < 2 then
			for i = 1, 2-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 14 and state.round <= 16 then
		if #state.enemies < 4 then
			for i = 1, 4-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round >16 and state.round <= 18 then
		if #state.enemies < 6 then
			for i = 1, 6-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round == 19 then
		if #state.enemies < 8 then
			for i = 1, 8-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round == 20 then
		if #state.rocks < 8 and math.random(0,200) == math.random(0,200) then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),false,3)) end
		if #state.enemies == 0 then
			state.stats.rocksRound = state.quota
		end
	--third cycle
	elseif state.round > 20 and state.round <= 21 then
		if #state.enemies < 2 then
			for i = 1, 2-#state.enemies do
				table.insert(state.enemies,dash.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 21 and state.round <= 24 then
		if #state.enemies < 6 then
			for i = 1, 2-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
			for i = 1, 4-#state.enemies do
				table.insert(state.enemies,dash.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,1)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round > 24 and state.round <= 26 then
		if #state.enemies < 8 then
			for i = 1, 4-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
			for i = 1, 4-#state.enemies do
				table.insert(state.enemies,dash.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round >26 and state.round <= 28 then
		if #state.enemies < 10 then
			for i = 1, 4-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
			for i = 1, 6-#state.enemies do
				table.insert(state.enemies,dash.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round == 29 then
		if #state.enemies < 14 then
			for i = 1, 6-#state.enemies do
				table.insert(state.enemies,drone.make())
			end
			for i = 1, 8-#state.enemies do
				table.insert(state.enemies,dash.make())
			end
		end
		if #state.rocks < 8 then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),true,2)) end
		if math.random(0,9500) == 1 then health.make(math.random(24,screen.width-24),math.random(24,screen.height-24)) end
	elseif state.round == 30 then
		if #state.rocks < 8 and math.random(0,200) == math.random(0,200) then table.insert(state.rocks,rock.make(math.random(100, screen.width-100),math.random(100, screen.height-100),false,3)) end
		if #state.enemies == 0 then
			state.stats.rocksRound = state.quota
		end
	end
end