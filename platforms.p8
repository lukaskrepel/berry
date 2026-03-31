-->8
--platforms--
platforms={}

local cloud_tiles={[80]=true,[81]=true,[82]=true}

function is_cloud_tile(t)
 return cloud_tiles[t]==true
end

function init_platforms()
 platforms={}
 local visited={}
 for ty=0,63 do
  for tx=0,127 do
   local tile=mget(tx,ty)
   if is_cloud_tile(tile) and not visited[ty*128+tx] then
    local plat={
     base_x=tx*8,
     base_y=ty*8,
     tiles={},
     phase=((tx*7+ty*13)%32)/32
    }
    local cx=tx
    while cx<128 and is_cloud_tile(mget(cx,ty)) and not visited[ty*128+cx] do
     visited[ty*128+cx]=true
     add(plat.tiles,mget(cx,ty))
     mset(cx,ty,0)
     cx+=1
    end
    plat.y=plat.base_y
    plat.prev_y=plat.base_y
    plat.t=0
    add(platforms,plat)
   end
  end
 end
end

function update_platforms()
 if abs(ctx-cx)>0 or abs(cty-cy)>0 then return end
 for plat in all(platforms) do
  plat.prev_y=plat.y
  plat.t+=1/60
  plat.y=plat.base_y+sin(plat.t*0.08+plat.phase)*4
 end
end

function draw_platforms()
 for plat in all(platforms) do
  for i=1,#plat.tiles do
   spr(plat.tiles[i],plat.base_x+(i-1)*8,plat.y)
  end
 end
end

function is_on_moving_platform(unit)
 if unit.vy<0 then return false,nil end
 local foot_y=unit.y+unit.vy+8
 local px1=unit.x
 local px2=unit.x+7
 for plat in all(platforms) do
  local plat_right=plat.base_x+#plat.tiles*8-1
  if px2>=plat.base_x and px1<=plat_right then
   if foot_y>=plat.y and foot_y<plat.y+4 and unit.y+7<plat.y+1 then
    return true,plat
   end
  end
 end
 return false,nil
end
