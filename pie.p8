function init_pie()
 pie={x=20,y=59,active=false,eaten=false}
 bed={x=20,y=44,active=false}
 door={x=7,y=8,s=125,closed=false}
 fade=0
 fadepat={…,░,▒,█}
 -- fadepat={0x0000,
 --          0x8000,
 --          0x8020,
 --          0xa020,
 --          0xa0a0,
 --          0xa4a0,
 --          0xa4a1,
 --          0xa5a1,
 --          0xa5a5,
 --          0xe5a5,
 --          0xe5b5,
 --          0xf5b5,
 --          0xf5f5,
 --          0xfdf5,
 --          0xfdf7,
 --          0xfff7,
 --          0xffff}
end

function update_pie()
 if pie.active and not pie.eaten then
  if abs(p.x-pie.x) <= 4 and abs(p.y-pie.y) <= 8 then
   sfx(2)
   pie.active=false
   pie.eaten=true
   bed.active=true
  end
 end
 if bed.active then
  if abs(p.x-bed.x) <= 4 and abs(p.y-bed.y) <= 4 then
   sfx(2)
   bed.active=false
   p.state="sleep"
  end
 end
end

function draw_pie()
 if pie.active and not pie.eaten then
  spr(32,pie.x,pie.y)
  spawn_particles(pie.x+4,pie.y+6)
 end
 if door.closed then
  mset(door.x,door.y,door.s)
 end
end

function draw_fade()
 if p.state=="sleep" then
  fade+=0.03
  local wait=5
  if fade>wait+1 then
   fillp(fadepat[flr(fade-wait)])
   rectfill(0,0,128,128,0)
  end
  if fade>=#fadepat+wait+2 then
   local endtext={"delicious","    berrypie!","thank you for","♥ playing ♥"}
   drawtextbox(37,47,endtext,{11,8,12,10})
  end
 end
end