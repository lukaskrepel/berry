-->8
--util--
-- linear interpolation
function lerp(a,b,t)
 local v=a+(b-a)*t
 if abs(v-b)<=0.25 then
  v=b
 end
 return v
end

function drawtextbox(x,y,strings,cols)
 local longest_tut=0
 for i=1, #strings do
  local chars=#strings[i]
  if chars>longest_tut then
   longest_tut=chars
  end
 end
 local extra=0--sprite?
 local x2=x+extra+4*longest_tut+2
 local y2=y+10+4*#strings
 local guicol=7
 local greyedcol=5
 local bgcol=0
 rect(x,y,x2,y2,guicol)
 line(x+1,y2+1,x2+1,y2+1,0)--shadow
 line(x2+1,y+1,x2+1,y2+1,0)--shadow
 rectfill(x+1,y+1,x2-1,y2-1,bgcol)
 for idx, str in pairs(strings) do
  print(str,x+2,y+6*idx-4,cols[idx])
 end
end