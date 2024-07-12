pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
 printh("---init---")
 gravity=0.2
 init_player()
 init_minimap()
 init_cam()
 init_pickups()
 init_particles()
 init_tutorial()
 mx,my=0,0--todo
 flags={
  player=0,
  ground=1,
  berry=2,
  platform=5,
  ladder=3,
  bouncy=4
 }
 debug=false
end

function _update60()
 drawdebug={}
 drawdist=0
 draw=abs(ctx-cx)<=drawdist and abs(cty-cy)<=drawdist
 if draw then
  update_player()
 end
 update_minimap()
 update_pickups()
 update_particles()
 update_cam()
 update_tutorial()
end

function _draw()
 cls(0)
 draw_sky()
 draw_world()
 draw_particles()
 draw_pickups()
 draw_player()
 draw_debug_col(2,11)
 camera()
 draw_gui(1,1)
 draw_minimap()
 draw_tutorial(10,96)
 draw_debug_var(1,13)
end

function draw_world()
 map(0,0,0,0,128,64)
end