-->8
--camera--
function draw_sky()
 local patgrad={█,…,░,▒,░,…,█}
 local skygrad={1,2,5,0,0}
 local div=128/#patgrad
 for ry=0,3 do
  local col1=skygrad[mid(1,ry+1,#skygrad-1)]
  local col2=skygrad[mid(2,ry+2,#skygrad)]
  for i=1,#patgrad do
   x1=0
   x2=128*8
   y1=ry*128+(div*(i-1))
   y2=y1+(div)
   fillp(█)
   rectfill(x1,y1,x2,y2,col1)
   if i>1 and i<#patgrad then
    fillp(patgrad[i])
    rectfill(x1,y1,x2,y2,col2)
   end
   if i==flr(#patgrad/2) then
    col1,col2=col2,col1
   end
  end
 end
 fillp(█)
end