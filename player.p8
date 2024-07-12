-->8
--p--
function init_player()
 p={}
 for ty=0,64 do
  for tx=0,128 do
   local tile=mget(tx,ty)
   if tile==1 then
    mset(tx,ty,mget(tx,ty-1))
    p.x=tx * 8
    p.y=ty * 8
    break
   end
  end
 end
 p.speed=1
 p.jumpf=2.6
 p.vx=0
 p.vy=0
 p.on_ground=true
 p.face_right=true
 p.coyotet=8
 p.coyotetimer=0
 p.state="idle"
 p.animtimer=0
 p.frame_dur=8
 p.sprite=0
end


function draw_player()
 local anim={}
 p.anim_dur=0
 if p.state=="idle" then
  -- p.sprite=0
  anim={0}
 elseif p.state=="jump" then
  p.sprite=3
 elseif p.state=="walk" then
  anim={1,2}
  p.frame_dur=7
 elseif p.state=="falling" then
  p.sprite=4
 elseif p.state=="climbing" then
  local dist_anim={5,6}
  local anim_dist=6
  p.sprite=dist_anim[(flr(p.y/anim_dist)%#dist_anim)+1]
 elseif p.state=="maplook" then
  anim={8,9,10}
  p.frame_dur=10
  if p.sprite==anim[#anim] then
   anim={}--todo
   p.animtimer=0--todo
  end
 elseif p.state=="mapaway" then
  anim={10,9,8,0}
  p.frame_dur=10
  if p.animtimer>=#anim*p.frame_dur-1 then
   p.state="idle"--todo
   anim={}--todo
  end
 end
 if #anim>0 then
  p.animtimer+=1
  if p.animtimer>=#anim*p.frame_dur then
    p.animtimer=0
  end
  p.sprite=anim[flr(p.animtimer/p.frame_dur)+1]
 end
 spr(p.sprite,p.x,p.y,1,1,p.face_right)
end

function update_player()
 move_player()
 if p.x<0 then
  p.x=127*8
 end
 if p.x>127*8 then
  p.x=127*8--0
 end
 mark_seen(mx,my)
end

function kill_player()
 run()
end

function is_grounded(unit,f)
 if unit.vy<0 then return false end
 if hit_t_below(unit.x,unit.y+unit.vy,8,8,f) then
  return true
 end
 return false
end

function hit_ceiling(unit)
 return hit_t(unit.x,unit.y+unit.vy,8,1,1)
end

function move_player()
 local dy,dx=0,0
 local control=true
 --maplook
 if p.state=="mapaway" then
  return
 end -- todo?
 if p.state=="maplook" then
  if p.sprite==10 then--(last maplook frame)
   if btnp(🅾️) then
    toggle_minimap(false)
   end
  end
  return
 end
 if p.state=="idle" then
  if btnp(🅾️) then
   toggle_minimap(true)
   return
  end
 end
 --
 if control then
  if btn(⬆️) and not btn(⬇️) then dy=-1 elseif btn(⬇️) and not btn(⬆️) then dy=1 else dy=0 end
  if btn(⬅️) and not btn(➡️) then dx=-1 elseif btn(➡️) and not btn(⬅️) then dx=1 else dx=0 end
 end
 --
 if not (dx==0 and dy==0) or btn(❎) then end
 --
 if p.coyotetimer>0 then p.coyotetimer -= 1 end
 --
 local center=5
 if p.face_right then
  center=2
 end
 p.on_ladder=hit_t(p.x+p.vx+center,p.y+p.vy+3,0,0,flags.ladder)
 if p.state=="climbing" then
  if p.on_ladder==false or dx!=0 or btn(❎) then
   p.state="idle"
  end
 end
 if is_grounded(p,flags.bouncy) then
  bounce()
 end
 p.on_ground=is_grounded(p,flags.ground)
 p.on_platform=is_grounded(p,flags.platform)
 --
 --ladder
 if p.on_ladder and p.state=="idle" then
  if (dy>0 and not p.on_ground) or (dy<0 and not p.on_platform)then
   p.state="climbing"--start climbing
  end
 end
 if p.on_ladder and p.state=="climbing" then
  p.face_right=true
  p.x=flr((p.x+4)/8)*8
  p.vx=0
  if dy>0 then
   p.vy=p.speed*0.75
  elseif dy<0 then
   p.vy=p.speed*-1*0.75
  else
   p.vy=0
   --return
  end
 end
 --
 if p.vy>0 then
  if p.on_ground or p.on_platform then
   if p.state=="falling" then
    land()
   end
   if not p.state=="climbing" then
    p.vy=0
   end
  end
 end
 p.ceiling=hit_ceiling(p)
 --
 if dx<0 then
  p.vx=p.speed * -1
  p.face_right=false
 elseif dx>0 then
  p.vx=p.speed
  p.face_right=true
 else
  p.vx=0
  if (p.on_ground and p.state!="climbing") or (p.on_platform and p.state!="climbing") then
   p.state="idle"
  end
 end
 if dx != 0 and (p.on_ground or p.on_platform) then
  p.state="walk"
  p.y=ceil((p.y-4)/8)*8--todo
  p.vy=0
 end
 if btnp(❎) and (p.on_ground or p.on_platform or p.coyotetimer>0) then
  jump()
 end
 if hit_t(p.x+p.vx,p.y,8,8,flags.ground) then
  p.vx=0
 end
 p.x+=p.vx
 if not (p.on_ground or p.on_platform or p.state=="climbing") then
  p.vy+=gravity
 end
 -- max speed
 vymax=2
 if p.vy>vymax then p.vy=vymax end
 if p.ceiling then
  if p.vy<0 then
   printh("stick!")
   printh("aaa")
   p.y=ceil((p.y+p.vy) / 8) * 8
   p.vy=0
  end
 end
 --climb
 if p.state=="climbing" then
  if p.vy>0 then
   if is_grounded(p,flags.ground) then
    land()--land after climbing down
   end
  end
 else
  if not (p.on_ground or p.on_platform) then
   if p.vy>0 then
    if p.y % 8==0 then
     p.coyotetimer=p.coyotet
    end
    p.state="falling"
   end
  end
 end
 p.y+=p.vy
end

function jump()
 tutbool[1]=false--todo
 if not hit_t(p.x,p.y-4,7,8,flags.ground) then
  printh("-jump")
  p.state="jump"
  p.vy=p.jumpf * -1
  p.on_ground=false
  sfx(0)
  dust_particles(p.x+4,p.y+8)
 end
end

function bounce()
 if not hit_t(p.x,p.y-4,7,8,flags.ground) then
  printh("-bounce")
  p.state="jump"--todo bounce state?
  -- p.vy=p.jumpf * -1
  p.vy=p.vy*-1*2
  local minbounce=p.jumpf*-1*0.9
  if p.vy>minbounce then
   p.vy=minbounce
  end
  p.on_ground=false
  sfx(6)
  dust_particles(p.x+4,p.y+8)
 end
end

function land()
 printh("--land")
 p.state="idle"
 sfx(1)
 --p.on_ground=true
 dust_particles(p.x+4,p.y+8)
 if p.vy>0 then
  p.y=flr((p.y+p.vy) / 8) * 8
 end
 p.vy=0
end

function action()
 if berries>0 then
  local dir=0
  if not p.face_right then
   dir *= -1
  end
  local tx=(p.x+4) / 8+dir
  local ty=flr(p.y / 8)
  if mget(tx,ty)==0 then
   if mget(tx,ty+1)==64 then
    berries -= 1
    sfx(1)
    create_plant(tx,ty)
    spawn_particles((tx * 8)+4,(ty * 8)+8)
   end
  end
 end
end