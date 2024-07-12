-->8
--plants--
function init_plants()
 plants={}
end

function create_plant(x,y)
 local plant={
  act=true,
  tx=flr(x),
  ty=flr(y),
  stage=1,
  timer=0,
  grows=5
 }
 mset(plant.tx,plant.ty,96)
 add(plants,plant)
end

function update_plants()
 for i=1,#plants do
  local plant=plants[i]
  if plant.act then
   if plant.timer <= plant.grows then
    plant.timer+=1
   else
    local x=plant.tx
    local y=plant.ty
    if plant.stage<3 then
     plant.stage+=1
     mset(x,y,mget(x,y)+1)
     plant.timer=0
    elseif plant.stage==3 then
     plant.act=false
     if not hit_t(x * 8,(y-1) * 8,7,7,flags.ground) then
      create_plant(x,y-1)
     end
    end
   end
  end
 end
end