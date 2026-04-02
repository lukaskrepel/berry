-->8
--dust--

dust_max        = 50
dust_spawn_rnd  = 0.5   -- chance to spawn each frame (0=never, 1=always)
dust_wobble_x   = 0.08  -- horizontal drift amplitude (sin-based)
dust_wobble_y   = 0.06  -- vertical drift amplitude (cos-based)
dust_spd_min    = 0.004
dust_spd_max    = 0.012
dust_life_base  = 180
dust_life_rnd   = 180
dust_size_max   = 1.5
dust_colors     = {8,10,11,12,14}

function init_spore_particles()
 dust={}
end

function update_spore_particles()
  if not cy==3 then return end

  for d in all(dust) do
    d.x += sin(d.t * d.spd + d.px) * dust_wobble_x
    d.y += cos(d.t * d.spd + d.py) * dust_wobble_y
    d.t -= 1
    if d.t <= 0 then
      del(dust, d)
    end
  end

  if #dust < dust_max and rnd(1) < dust_spawn_rnd then
    add(dust, {
      x   = 3*128 + rnd(128*5),
      y   = 3*128 + rnd(128*1),
      px  = rnd(32),
      py  = rnd(32),
      spd = dust_spd_min + rnd(dust_spd_max - dust_spd_min),
      c   = rnd(dust_colors),
    })
    local d = dust[#dust]
    d.t  = flr(dust_life_base + rnd(dust_life_rnd))
    d.mt = d.t
  end
end

function draw_spore_particles()
  if not cy==3 then return end
  for d in all(dust) do
    local life_frac = d.t / d.mt
    local r = -dust_size_max * sin(life_frac * 0.5 * 3.14159)
    circfill(d.x, d.y, r, d.c)
  end
end