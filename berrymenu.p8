function init_berrymenu()
 local cols=7
 local rows=ceil(#pickups/cols)
 omenu={
  cols=cols,
  rows=rows,
  x=1+8*2,
  y=8*3,
  w=(4+1)*cols+2,
  h=(6+1)*rows+2,
  txt={"how to berrypie:","find "..#pickups.." berries", "bring them ⌂","bake! eat!"}
 }
 oven={x=2*8,y=8*8,draw=false}
end

function update_berrymenu()
 oven.draw=(p.x<=56 and p.y<=64 and p.y>=48)--corner
 -- if abs(p.x-oven.x) <= 4 and abs(p.y-oven.y) <= 4 then
  -- oven.draw=true
 -- else
  -- oven.draw=false
 -- end
end

function draw_berrymenu()
 if not oven.draw then
  return
 end
 local x=omenu.x --todo
 local y=omenu.y --todo
 local w=omenu.w --todo
 local h=omenu.h --todo
 local rows=omenu.rows --todo
 local cols=omenu.cols --todo
 --
 drawtextbox(x+w+3,y,omenu.txt,{11,8,12,10})
 --
 rect(x,y,x+w,y+h,7)
 rectfill(x+1,y+1,x+w-1,y+h-1, 0)
 line(x+1,y+h+1,x+w+1,y+h+1,0)--shadow
 line(x+w+1,y+1,x+w+1,y+h+1,0)--shadow
 for i=1,#pickups do
  if pickups[i].active then
   for j=0,15 do pal(j,5) end
  end
  local bx=i
  local by=0
  while bx>cols do
   bx-=cols
   by+=(6+1)
  end
  spr(16,x+(bx-1)*(4+1),y+1+by)
  pal()
 end
end