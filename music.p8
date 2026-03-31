-- music system
start_track = 0

melody = true
bass = true
drums = true
extra = true

function init_music()
    -- initialize music system
	melody = false
	bass = false
	drums = false
	extra = true
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
	prev_instruments = {melody, bass, drums, extra}
	if not tut_finished then
		melody = false
		bass = false
		drums = false
		extra = true
	else
		cave_area = (my == 3 and mx <= 3) or(mx == 0 and my == 1)
		mushroom_area = my == 3 and mx >= 4
		secret_area = (my == 2 and mx <= 1) or (my == 1 and mx == 1)
		mountain_area = mx == 7 and my <= 2
		world_area = not cave_area and not mushroom_area and not secret_area and not mountain_area
	end
	--
	melody = world_area or mountain_area
	bass = world_area or secret_area or cave_area or mountain_area
	drums = world_area or secret_area or mushroom_area
	extra = berries == #pickups or not tut_finished

	adaptive_music()
	if prev_instruments[1] != melody or prev_instruments[4] != extra then
		music(start_track)
	end
end

function adaptive_music()
	for i=0x3100,0x3140,4 do
		if melody then
			poke(i,peek(i)&0b10111111)
		else
			poke(i,peek(i)|0b01000000)
		end
		if bass then
			poke(i+1,peek(i+1)&0b10111111)
		else
			poke(i+1,peek(i+1)|0b01000000)
		end
		if drums then
			poke(i+2,peek(i+2)&0b10111111)
		else
			poke(i+2,peek(i+2)|0b01000000)
		end
		if extra then
			poke(i+3,peek(i+3)&0b10111111)
		else
			poke(i+3,peek(i+3)|0b01000000)
		end
	end
end