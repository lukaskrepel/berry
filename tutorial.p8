-->8
--tutorial--
function init_tutorial()
 tut_time=200
 tut_countdown=tut_time
 tut_delay=40
 tutstrings={--add extra space for btns
  "press ❎ to jump ",
  "press 🅾️ to toggle minimap ",
  "⬅️➡️ to walk  ",
  "⬆️⬇️ to climb ladders  "
 }
 tutbool={true,true,true,true}--todo proper code
end

function update_tutorial()
 if p.state=="jump" then
  tutbool[1]=false
 elseif p.state=="walk" then
  tutbool[3]=false
 elseif p.state=="climbing" then
  tutbool[4]=false
 end
 --
 for i=1, #tutbool do
  if tutbool[i] then
   return
  end
 end
 tut_countdown-=0.5
end

function draw_tutorial(x,y)
 if tut_countdown<=0 then return end
 if tut_countdown<tut_time-tut_delay then
  y=y-tut_countdown+tut_time-tut_delay
 end
 --
 local tutstring=tutstrings[2]
 local longest_tut=0
 for i=1, #tutstrings do
  local chars=#tutstrings[i]
  if chars>longest_tut then
   longest_tut=chars
  end
 end
 local extra=0--sprite?
 local x2=x+extra+4*longest_tut+2
 local y2=y+10+4*#tutstrings
 local guicol=7
 local greyedcol=5
 local bgcol=0
 rect(x,y,x2,y2,guicol)
 line(x+1,y2+1,x2+1,y2+1,0)--shadow
 line(x2+1,y+1,x2+1,y2+1,0)--shadow
 rectfill(x+1,y+1,x2-1,y2-1,bgcol)
 local i=0
 for idx, str in pairs(tutstrings) do
  c=guicol
  if not tutbool[idx] then
   c=greyedcol
  end
  print(str,x+2,y+6*i+2,c)
  i+=1
 end
end