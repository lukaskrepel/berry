-->8
--savegame--
function init_savegame()
 cartdata("berry_v1")
 menuitem(1,"new game",function()
  dset(0,0)
  run()
 end)
end

function save_game()
 dset(0,1)
 dset(1,p.x)
 dset(2,p.y)
 for i=1,#pickups do
  if 2+i<=61 then
   dset(2+i, pickups[i].active and 0 or 1)
  end
 end
 save_seen_rooms(62,63)
end

function load_game()
 if dget(0)==0 then return end
 local sx,sy=dget(1),dget(2)
 if sx!=p.x or sy!=p.y then
  skip_tutorial()
 end
 p.x=sx
 p.y=sy
 init_cam()
 for i=1,#pickups do
  if 2+i<=61 then
   if dget(2+i)==1 then
    pickups[i].active=false
    berries+=1
    pixelmap[pickups[i].tx][pickups[i].ty]=pixelmap[pickups[i].tx][pickups[i].ty-1]
   end
  end
 end
 load_seen_rooms(62,63)
end
