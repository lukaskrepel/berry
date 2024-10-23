-->8
--pickups--
function init_pickups()
 printh("init_pickups")
 berries=0
 pickups={}
 for ty=0,64 do
  for tx=0,128 do
   local tile=mget(tx,ty)
   if fget(tile,2) then
    local pickup={
     tx=tx,
     ty=ty,
     x=tx * 8,
     y=ty * 8,
     active=true
    }
    add(pickups,pickup)
    mset(tx,ty,mget(tx,ty-1))
   end
  end
 end
end

function update_pickups()
 for i=1,#pickups do
  local pickup=pickups[i]
  if pickup.active then
   local amplitude=1.5
   local frequency=0.5
   local phase=pickup.tx / 8
   pickup.y=pickup.ty * 8+amplitude * sin((time() * frequency+phase) % 1)
   if abs(p.x-pickup.x) <= 4 and abs(p.y-pickup.y) <= 4 then
    sfx(2)
    pickup.active=false
    berries+=1
    spawn_particles(pickup.x+4,pickup.y+4)
    pixelmap[pickup.tx][pickup.ty]=pixelmap[pickup.tx][pickup.ty-1]
   end
  end
 end
end

function draw_pickups()
 for i=1,#pickups do
  local pickup=pickups[i]
  if pickup.active then
   spr(16,pickup.x,pickup.y)
  end
 end
end