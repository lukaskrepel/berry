-->8
--debug--
function draw_debug_col()
 if not debug then return end
 --
 mset(0,8,63)
 mset(1,8,63)
 --
 for i=1,#drawdebug do
  local coords=drawdebug[i]
  local c=rnd(15)
  line(coords[1],coords[2],coords[1],coords[4],c)
  line(coords[1],coords[4],coords[3],coords[4],c)
  line(coords[3],coords[2],coords[3],coords[4],c)
  line(coords[1],coords[2],coords[3],coords[2],c)
 end
end

function draw_debug_var(x,y)
 if not debug then return end
 local c=11
 local strings={
  state=p.state,
  mxy=mx..","..my,
  mmxy=mmx..","..mmy,
  minimap=(minimap and 'true' or 'false'),
  -- ground=(p.on_ground and 'true' or 'false'),
  -- ceil=(p.ceiling and 'true' or 'false'),
  -- ladder=(p.on_ladder and 'true' or 'false'),
  -- bottom_y=bottom_y,
  -- platform=(p.on_platform and 'true' or 'false'),
 }
 local i=0
 for k,v in pairs(strings) do
  local varstring=k .. ":" .. v
  rectfill(x,y+6*i,x+4*#varstring,y+6*i+6,0)
  print(varstring,x+1,y+6*i+1,c)
  i+=1
 end
end