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
 local tutcols={11,8,12,10}
 for idx, str in pairs(tutcols) do
  if not tutbool[idx] then
   tutcols[idx]=5
  end
 end
 drawtextbox(x,y,tutstrings,tutcols)
end