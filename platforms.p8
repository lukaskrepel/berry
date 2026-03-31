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

function is_on_bouncing_mushroom(unit)
 if unit.vy<0 then return false end
 local bty=flr((unit.y+unit.vy+8)/8)
 for _,btx in ipairs({flr(unit.x/8),flr((unit.x+7)/8)}) do
  for bt in all(bouncing_tiles) do
   if bt.tx==btx and bt.ty==bty then return true end
  end
 end
 return false
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

-- mushroom squish animation
bouncing_tiles={}

function start_mushroom_bounce(ux,uy,uvy)
 local bty=flr((uy+uvy+8)/8)
 -- check bouncing_tiles too, since animating tiles are mset to 0
 local function is_bouncy_at(btx)
  if fget(mget(btx,bty),4) then return true end
  for bt in all(bouncing_tiles) do
   if bt.tx==btx and bt.ty==bty then return true end
  end
  return false
 end
 -- find any bouncy tile touched by the player
 local hit_tx=nil
 for _,btx in ipairs({flr(ux/8),flr((ux+7)/8)}) do
  if is_bouncy_at(btx) then hit_tx=btx break end
 end
 if not hit_tx then return end
 -- walk left and right to find the full connected group
 local lx=hit_tx
 while lx>0 and is_bouncy_at(lx-1) do lx-=1 end
 local rx=hit_tx
 while rx<127 and is_bouncy_at(rx+1) do rx+=1 end
 -- squish each tile; reset t if already animating so all stay in sync
 for btx=lx,rx do
  local found=nil
  for bt in all(bouncing_tiles) do
   if bt.tx==btx and bt.ty==bty then found=bt break end
  end
  if found then
   found.t=0
  else
   local tile=mget(btx,bty)
   mset(btx,bty,0)
   add(bouncing_tiles,{tx=btx,ty=bty,tile=tile,t=0,dur=36})
  end
 end
end

function update_bouncing_tiles()
 for bt in all(bouncing_tiles) do
  bt.t+=1
  if bt.t>=bt.dur then
   mset(bt.tx,bt.ty,bt.tile)
   del(bouncing_tiles,bt)
  end
 end
end

function draw_bouncing_tiles()
 for bt in all(bouncing_tiles) do
  local prog=bt.t/bt.dur
  local s=flr(-sin(prog*3)*3*(1-prog))
  local sn=bt.tile
  local ssx=(sn%16)*8
  local ssy=flr(sn/16)*8
  sspr(ssx,ssy,8,8,bt.tx*8,bt.ty*8+s,8,8-s)
 end
end
