-- music system
music_enabled = true
current_track = -1
new_track = 0
current_speed = 20
beat = false
prev_tick = 0

upper_level_track = 0
lower_level_track = 4

function init_music()
    -- initialize music system
    music(new_track)
end

function update_music()
    new_track = world_track()
    if new_track == current_track then return end
    -- Check if we're on a music tick (stat(56) returns current music tick)
    local current_tick = stat(55)
    if current_tick != previous_tick then
        printh("tick changed: " .. current_tick)
        play_music(new_track)
        current_track = new_track
        previous_tick = current_tick
    end
end

function play_music(track_id)
    if not music_enabled then return end
    if current_track == track_id then return end
    current_track = track_id
    printh("starting music track_id: " .. track_id)
    -- start music from pattern 4, reserving channels 2 and 3
    -- by setting bits 2 and 3, whose values are 4 and 8, totaling 12
    music(track_id, 1000, 12)
    printh("current_track: " .. current_track)
end

function stop_music()
    music(-1)
    current_track = -1
end

function toggle_music()
    music_enabled = not music_enabled
    if not music_enabled then
        stop_music()
    elseif current_track != -1 then
        music(current_track)
    end
end

function world_track()
    if my == 3 then
        return lower_level_track
    end
    return upper_level_track
end