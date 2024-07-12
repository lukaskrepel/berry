-->8
--gui--
function draw_gui(r1x,r1y)
 local guistring=berries .. "/" .. #pickups
 local r2x=r1x+7+4 * #guistring
 local r2y=r1y+9
 local guicol=7
 local bgcol=0
 rect(r1x,r1y,r2x,r2y,guicol)
 line(r1x+1,r2y+1,r2x+1,r2y+1,0)--shadow
 line(r2x+1,r1y+1,r2x+1,r2y+1,0)--shadow
 rectfill(r1x+1,r1y+1,r2x-1,r2y-1,bgcol)
 print(guistring,r1x+7,r1y+3,guicol)
 spr(16,r1x,r1y+1)
end