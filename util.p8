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