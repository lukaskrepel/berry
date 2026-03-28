-- music system
start_track = 0

function init_music()
    -- initialize music system
	instruments={true,true,true,true}
	update_instruments()
    music(start_track)
end

function update_music()
    update_instruments()
	
end

function stop_music()
    music(-1)
end

function update_instruments()
	-- melody
	-- base
	-- drums
	-- extra
	-- TODO this is a placeholder, adjust instruments based on game state, e.g. player position, events, etc.
    if oven.draw == true then
        instruments = {false, false, false, true}--start area -- only extra
    elseif my == 3 then
    	instruments = {false, true, false, false} --lowest level -- only base
    elseif my == 2 then
        instruments = {false, true, true, false} --mid level -- drums and bass
    else
        instruments = {true, true, true, false} --top level -- melody, bass and drums, no extra
    end
	adaptive_music()
end

function adaptive_music()
	for i=0x3100,0x3140,4 do
		if instruments[1] then
			poke(i,peek(i)&0b10111111)
		else
			poke(i,peek(i)|0b01000000)
		end
		if instruments[2] then
			poke(i+1,peek(i+1)&0b10111111)
		else
			poke(i+1,peek(i+1)|0b01000000)
		end
		if instruments[3] then
			poke(i+2,peek(i+2)&0b10111111)
		else
			poke(i+2,peek(i+2)|0b01000000)
		end
		if instruments[4] then
			poke(i+3,peek(i+3)&0b10111111)
		else
			poke(i+3,peek(i+3)|0b01000000)
		end
	end
end