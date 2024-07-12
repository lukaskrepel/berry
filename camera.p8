-->8
--camera--
function init_cam()
 cx=flr((p.x+3)/128)*128
 cy=flr((p.y+8)/128)*128
 ctx=cx
 cty=cy
end

function update_cam()
 mx=flr((p.x+3)/128)
 my=flr((p.y+8)/128)
 ctx=mx*128
 cty=my*128
 t=0.2
 if not (octx==ctx and octy==cty) then
  sfx(3)
  octx=ctx
  octy=cty
 end
 cx=lerp(cx,ctx,t)
 cy=lerp(cy,cty,t)
 camera(cx,cy)
end