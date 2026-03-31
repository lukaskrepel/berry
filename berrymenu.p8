function init_berrymenu()
 local cols=7
 local rows=ceil(#pickups/cols)
 omenu={
  cols=cols,
  rows=rows,
  x=66,
  y=2,
  w=(4+1)*cols+2, -- berry icon is 4px wide; stride of 5 is intentional
  h=(6+1)*rows+2,
  txt={"how to play:","-find berries","-bring them ⌂ ","-eat pie!","-sleep! "},
  col={11,8,12,10,11}
 }
 oven={x=2*8,y=8*8,draw=true}
end

function update_berrymenu()
 oven.draw=p.x<=48 and p.y<=64
 if oven.draw then
  oven.draw=true--corner
  if berries==#pickups then
   door.closed=true
   pie.active=true
  end
 end
end

function draw_berrymenu()
 if not oven.draw then
  return
 end
 local checks={
  berries==#pickups,
  berries==#pickups,
  pie.eaten,
  p.state=="sleep"
 }
 local txtbox_y=omenu.y+omenu.h+3
 drawtextbox(omenu.x,txtbox_y,omenu.txt,omenu.col,2)
 -- draw checkboxes over the leading space on each task line
 for i=1,4 do
  local bx=omenu.x+2
  local by=txtbox_y+6*(i+1)-4
  if checks[i] then
   rectfill(bx,by+1,bx+2,by+3,omenu.col[i+1])
  end
 end
 --
 rect(omenu.x,omenu.y,omenu.x+omenu.w,omenu.y+omenu.h,7)
 rectfill(omenu.x+1,omenu.y+1,omenu.x+omenu.w-1,omenu.y+omenu.h-1,0)
 line(omenu.x+1,omenu.y+omenu.h+1,omenu.x+omenu.w+1,omenu.y+omenu.h+1,0)--shadow
 line(omenu.x+omenu.w+1,omenu.y+1,omenu.x+omenu.w+1,omenu.y+omenu.h+1,0)--shadow
 for i=1,#pickups do
  if pickups[i].active then
   for j=0,15 do pal(j,5) end
  end
  local bx=i
  local by=0
  while bx>omenu.cols do
   bx-=omenu.cols
   by+=(6+1)
  end
  spr(16,omenu.x+(bx-1)*(4+1),omenu.y+1+by)
  pal()
 end
end