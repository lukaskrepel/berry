-->8
--minimap--
function init_fogmap(_dflt)
 seen={}
 local ret={} 
 for x=0,128 do
  ret[x]={}
  for y=0,64 do
   ret[x][y]=rnd({5,13})
  end
 end
 return ret
end

function mark_seen(mx,my)
 for i=1,#seen do
  if seen[i].x==mx and seen[i].y==my then
   return
  end
 end
 add(seen,{x=mx,y=my,fog=30})
end

function unfog()
 for i=1,#seen do
  local fogtile=seen[i]
  if fogtile.fog>0 then
   local mx=fogtile.x
   local my=fogtile.y
   local tx=mx*16
   local ty=my*16
   for x=tx,tx+15 do
    for y=ty,ty+15 do
      if rnd{true,false,false} then
       fogmap[x][y]=0
      end
    end
   end
   fogtile.fog-=1
  end
 end
end

function init_minimap()
 pcl=0--playercolor
 bcl=8--berrycolor
 cols,rows=0,0
 tcols,trows=0,0
 mmcols,mmrows=32,32--24,32
 minimap=false
 fogmap=init_fogmap()
 pixelmap=init_pixelmap()
 mmx,mmy=0,0
end

function init_pixelmap()
 local ret={}
 local default=0
 local mmc={
  player=10,
  grass=3,
  stone=12,
  stone_bg=1,
  cloud=7,
  treebark=4,
  plank=9,
  plank_bg=4,
  robo=6,
  robo_bg=13,
  darkstone=12,
  darkstone_bg=1,
  mushroom=11,
  mushroombark=3,
  ladder=14,
  roof=8,
  berry="berry"
 }
 local function assign_tiles()
  local mapping={}
  local function map_px(keys,value)
   for _,key in ipairs(keys) do
    mapping[key]=value
   end
  end
  map_px({1},mmc.player)
  map_px({64},mmc.grass)
  map_px({65,66,106,122},mmc.stone)
  map_px({67},mmc.stone_bg)
  map_px({69,70,71,72,86,88},mmc.mushroom)
  map_px({80,81,82},mmc.cloud)
  map_px({85},mmc.treebark)
  map_px({73,116},mmc.plank)
  map_px({75,90,91},mmc.plank_bg)
  map_px({74},mmc.plank)
  map_px({77,93,94,95,118,119},mmc.robo)--118,119 are kitchen
  map_px({78},mmc.robo_bg)
  map_px({109},mmc.roof)
  map_px({99,115},mmc.darkstone)
  map_px({100},mmc.darkstone_bg)
  map_px({101,102,103,105,121},mmc.mushroom)
  map_px({104,120},mmc.mushroombark)
  map_px({84,68,79,111},mmc.ladder)
  map_px({16},mmc.berry)
  return mapping
 end
 local tile_mapping=assign_tiles()
 for x=0,128 do
  ret[x]={}
  for y=0,64 do
   local tl=mget(x,y)
   local cl=tile_mapping[tl] or default
   ret[x][y]=cl
  end
 end
 return ret
end

function toggle_minimap(newstate)
 tutbool[2]=false
 if newstate==false then
  printh("minimap off")
  p.state="mapaway"
  sfx(5)
 else
  printh("minimap on")
  p.state="maplook"
  sfx(4)
  --
  local xoffset=mmrows/2+6
  if not p.face_right then
   xoffset*=-1
   xoffset-=2 --shadow on the right
  end
  --minimap next to player
  mmx=flr(p.x)+4+xoffset-mx*128
  mmy=flr(p.y)+4-my*128
  --keep on screen
  if mmx-(mmcols/2)<1 then mmx=(mmcols/2)+1 end--left
  if mmx>128-mmcols/2-4 then mmx=128-(mmcols/2)-4 end--right
  if mmy-(mmrows/2)<1 then mmy=(mmrows/2)+1 end--top
  if mmy>128-(mmrows/2)-4 then mmy=128-(mmrows/2)-4 end--bottom
  --
  mmx=flr(mmx)
  mmy=flr(mmy)
 end
end

function update_minimap()
 if p.sprite==10 then
  minimap=true
 elseif p.state=="mapaway" then
  minimap=false
 end
end

function draw_minimap()
 if minimap then
  tcols,trows=mmcols,mmrows
 else
  tcols,trows=0,0
 end
 --player
 ptx=flr((p.x+4)/8)
 pty=flr((p.y+4)/8)
 pcl+=1
 --
 cols=lerp(cols,tcols,0.1)
 rows=lerp(rows,trows,0.1)
 local dcols=flr(cols)
 local drows=flr(rows)
 --
 if dcols==tcols and dcols!= 0 then
  unfog()
 end
 --
 if drows<1 or dcols <1 then return end
 local ox=mid(0,flr(cx/8)-flr(drows/3)+flr(16/3),128-dcols)
 local oy=mid(0,flr(cy/8)-flr(drows/3)+flr(16/3),64-drows)
 local default=0
 --center
 -- local x=(128-cols)/2-1
 -- local y=(128-rows)/2-2
 -- mmx/mmy:
 local x=mmx-dcols/2
 local y=mmy-drows/2
 --alt
 if p.face_right then
  x=mmx-mmcols/2
 else
  x=mmx-dcols+mmcols/2
 end
 y=mmy-dcols

 --test test
 -- if p.face_right then
 --  x=mmx+dcols
 -- else
 --  x=mmx-dcols
 -- end
 --

 --
 local borderc=7
 line(x+1,y+drows+2,x+dcols+2,y+drows+2,0)--shadow
 line(x+dcols+2,y+1,x+dcols+2,y+drows+2,0)--shadow
 rect(x,y,x+dcols+1,y+drows+1,borderc)
 for r=0,drows-1 do
  for c=0,dcols-1 do
   local tx=flr(ox+c)
   local ty=flr(oy+r)
   cl=pixelmap[tx][ty]
   if tx==ptx and ty==pty then
    cl=pcl
   end
   if cl=="berry" then
    cl=bcl
    if (time()%1)<0.5 then
     cl=pixelmap[tx][flr(oy+r-1)]
    end
   end
   if fogmap[tx][ty]>0 then
    cl=fogmap[tx][ty]
   end
   pset(x+1+c,y+1+r,cl)
  end
 end
end