-->8
--tutorial--
function init_tutorial()
 tut_time=600
 tut_countdown=tut_time
 tut_delay=40
 tutstrings={--add extra space for btns
  "press ❎ to jump ",
  "press 🅾️ to toggle minimap ",
  "⬅️➡️ to walk  ",
  "⬆️⬇️ to climb ladders  "
 }
 tutbool={true,true,true,true}
 tut_finished=false
end

function update_tutorial()
 if p.state=="jump" then
  tutbool[1]=false
 elseif p.state=="walk" then
  tutbool[3]=false
 elseif p.state=="climbing" then
  tutbool[4]=false
 end
 if not tutbool[1] and not tutbool[2] and not tutbool[3] and not tutbool[4] then
  tut_finished=true
  tut_countdown-=1
 else
  tut_countdown=tut_time
 end
end

function draw_tutorial(x,y)
 if tut_countdown<=0 then return end
 if tut_countdown<tut_time-tut_delay then
  y=y-tut_countdown+tut_time-tut_delay
 end
 --
 local tutcols={11,8,12,10}
 for idx, col in pairs(tutcols) do
  if not tutbool[idx] then
   tutcols[idx]=5
  end
 end
 drawtextbox(x,y,tutstrings,tutcols)
end