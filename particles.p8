-->8
--particles--
function init_particles()
 particles={}
end

function update_particles()
 for p in all(particles) do
  if not p.t then
   p.t=p.st
  end
  p.x+=p.sx * (p.t / p.st)
  p.y+=p.sy * (p.t / p.st)
  p.r=p.sr * (p.t / p.st)
  p.t -= 1
  if p.t==0 then
   del(particles,p)
  end
 end
end

function draw_particles()
 for p in all(particles) do
  circfill(p.x,p.y,p.r,p.c)
 end
end

function spawn_particles(tx,ty)
 for i=1,5 do
  add(particles,{
   x=tx,
   y=ty,
   sx=rnd(2)-1,
   sy=rnd(2)-1,
   c=rnd({8,10,11,12,14}),
   st=30,
   sr=2
  })
 end
end

function dust_particles(px,py)
 -- local pc=pget(px,py)
 -- if not fget(mget(px / 8,py / 8),1) or pc==0 then pc=7 end
 pc=7
 for i=1,3 do
  add(particles,{
   x=px,
   y=py,
   sx=rnd(1)-0.5,
   sy=-rnd(0.5),
   c=pc,
   st=15,
   sr=1.5
  })
 end
end