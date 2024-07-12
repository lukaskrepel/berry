-->8
--collision--
function hit_t(x,y,w,h,f)
 if w<=1 and h<=1 then
  coords={x,y,x,y}
  add(drawdebug,coords)
  return fget(mget(x/8,y/8),f)
 end
 w-=1
 h-=1
 coords={x,y,(x+w),(y+h)}
 add(drawdebug,coords)
 collide=false
 for i=x,x+w,w do
  if fget(mget(i/8,y/8),f) or
   fget(mget(i/8,(y+h)/8),f) then
   collide=true
  end
 end
 for i=y,y+h,h do
  if fget(mget(x/8,i/8),f) or
     fget(mget((x+w)/8,i/8),f) then
   collide=true
  end
 end
 return collide
end

function hit_t_below(x,y,w,h,f)
 w-=1
 h-=1
 y=y+h+1
 h=0
 coords={x,y,(x+w),(y+h)}
 add(drawdebug,coords)
 collide=false
 for i=x,x+w,w do
  if fget(mget(i/8,(y+h)/8),f) then
   collide=true
  end
 end
 return collide
end