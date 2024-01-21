pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--bepis-man
--by extor

--music chart by melody man
--https://www.youtube.com/watch?v=q1-_vxcmews
function _init()

 street = {b_w = 160,
           h_w = 20,
           lin = {0.1, 
                  0.15, 
                  0.2,
                  0.25,
                  0.3}
          }
          
 world = {y = 0,
          hor = 40,
          new_hor = 40,
          cen = 64,
          bas = 64,
          y_mod = 20,
          bas_min = 0,
          bas_max = 128,
          tile_l = 50,
          last_tile = -5}
          
 message = {txt = "",
            tme = 0
            }
            
 sys = {bps_t = 0,
        lives = 3,
        curr_chk = 0,
        bps_chk = 0,
        time_left = 15,
        event_time = 2.5,
        restart = false,
        finish = false,
        lvl_time = 60,
        lvl_lght = 128,
        time_start = 0,
        show_end = false,
        game_over = false,
        in_game = false,
        show_splash = true,
        show_title = false
       }
       
 results = {bps = 0,
            tim = 0 
       }
       
 title = {
          s_time = 0,
          logo_d = 150,
          bump = false,
          y = 0
         }
 
           
 bp = {x = 64, y = 0}
 objs = {}
 decor = {}
 clouds = {}
 --make_tree(25, 30)
-- make_sewer_guy(75, 130)
-- make_tree(80, 50)
-- make_car(30, 70)
-- make_house(110,50,true)
-- make_lamp(80,20,false)
-- make_t_light(20,20,true)
-- make_letter_box(10, 10,true)
-- make_bin(50, 20)
-- make_walker(100,30,true)
-- make_side_car(0,30,false)
-- make_crossing(130,150,7,6)
 --make_truck(50, 80)
 --make_bepis(50,120)
 make_bp()
 populate_tile(0)
 populate_tile(1)
 populate_tile(2)
 make_cloud()
 make_cloud()
 make_cloud()
 sfx(12)
end

function _update60()
 if sys.event_time < time() and
    sys.show_splash then
  sys.show_splash = false
  sys.show_title = true
  title.s_time = time()
 end 
 
 if sys.show_title and 
    not title.bump then
  title.y += 0.5
  world.y = title.y
  if title.y > title.logo_d then
   title.y = title.logo_d
   world.y = 0
   title.bump = true
   sfx(1)
  end
 end
 
 if sys.show_title and btn(🅾️) then
  sys.show_title = false
  sys.in_game = true
  sys.time_start = time()
  music(1)
 end

 if sys.in_game then
	 if not sys.show_end and 
	    not sys.game_over then
		 for o in all(objs) do
		  o:update()
		 end
		 
		 spawn_world()
		
		 world.bas = x_to_bas(bp.x_pos)
		 world.y = bp.y-5
		 
		 bp.x_pos = mid(28, 
		            bp.x_pos, 
		            72)
		            
		 update_lvl()
		 check_time()
		 destroy_hidden(objs)
		 destroy_hidden(decor)
		 
		 check_events()
		
		 qsort(objs, y_desc)
		end
	end
end


function _draw()
 cls()
 if sys.show_splash then
  sspr(0,64,80,16,25,50)
 end
 if sys.show_title then
  draw_street(street, world, true)
  draw_title()
  local frame_x = 8+8*flr((time()*10)%4)
  local frame_y = 0
  if title.bump then
   frame_y = 16
   frame_x = 32
  end
  sspr(frame_x, frame_y,
       8, 16,
       56, 60,
       16,32,
       false, false)
  if title.bump then
   draw_txt("press 🅾️!", 48,75)
  end
 end
 
 if sys.in_game then
	 if not sys.show_end and 
	    not sys.game_over then
		 draw_sky()
		 draw_street(street, world,false)
		 for d in all(decor) do
		  d:draw()
		 end
		 for o in all(objs) do
		  o:draw()
		 end
		 draw_hud()
		 draw_message()
	 elseif sys.game_over then
	  draw_bg()
	  draw_txt("game over!", 46,30)
	  draw_txt("restart to try again", 28,70)  
	 else
	  draw_bg()
	  draw_txt("results!", 46,25)
	  spr(23, 80, 59)
	  draw_txt("bepis: "..results.bps, 40,60)
	  draw_txt("time:  "..results.tim, 40,70)
	  draw_txt("score: "..results.scr, 40,85)
	  draw_txt("thanks for playing!", 28,110)
	 end
	end
-- print(world.last_tile, 0, 22, 5) 
-- print('cpu:'..stat(1), 0, 30, 5)
-- print(bp.y, 0 ,0,5)
end
-->8
--utils

--by jonbro
--https://www.lexaloffle.com/bbs/?tid=2171
fill_tri = function(a,b,c,col)
color(col)
    if (b.y-a.y > 0) dx1=(b.x-a.x)/(b.y-a.y) else dx1=0;
    if (c.y-a.y > 0) dx2=(c.x-a.x)/(c.y-a.y) else dx2=0;
    if (c.y-b.y > 0) dx3=(c.x-b.x)/(c.y-b.y) else dx3=0;
    local e = {x=a.x, y=a.y};
    local s = {x=a.x, y=a.y}
    if (dx1 > dx2) then
        while(s.y<=b.y) do
            s.y+=1;
            e.y+=1;
            s.x+=dx2;
            e.x+=dx1;
            line(s.x,s.y,e.x,s.y);
        end
        e.x = b.x
        e.y = b.y
        while(s.y<=c.y) do
            s.y+=1;
            e.y+=1;
            s.x+=dx2;
            e.x+=dx3;
            line(s.x,s.y,e.x,s.y);
        end
    else
        while(s.y<b.y)do
            s.y+=1;e.y+=1;s.x+=dx1;e.x+=dx2;
            line(s.x,s.y,e.x,e.y);
        end
        s.x=b.x
        s.y=b.y
        while(s.y<=c.y)do
            s.y+=1;e.y+=1;s.x+=dx3;e.x+=dx2;
            line(s.x,s.y,e.x,e.y);
        end
    end
end

function draw_q(a,b,c,d,col)
 --rectfill(a.x,a.y,b.x,d.y,col)
 a.y-=1
 b.y-=2
 fill_tri(a,b,c,col)
 
 a.y-=1
 b.y+=1
 fill_tri(b,c,d,col)
 
 a.y+=2
 b.y+=1
end

function sum(lista, i)
 local s = 0
 for j = 1, i do
  s += lista[j]
 end
 return s
end

function x_to_bas(x)
 return -(x-28)*(2.9)+128
end

function get_hor_x(x)
 local res = x
 res = world.cen + (x*0.35) - 18
 return res
end

function get_bas_x(x)
 local res = x
 res = world.bas + (x*2.65) - 130
 return res
end

-- common comparators
function  ascending(a,b) return a<b end
function descending(a,b) return a>b end
function y_desc(a,b) return a.y > b.y end

-- a: array to be sorted in-place
-- c: comparator (optional, defaults to ascending)
-- l: first index to be sorted (optional, defaults to 1)
-- r: last index to be sorted (optional, defaults to #a)
-- by felice
-- https://www.lexaloffle.com/bbs/?pid=50434#p50434
function qsort(a,c,l,r)
 c,l,r=c or ascending,l or 1,r or #a
 if l<r then
  if c(a[r],a[l]) then
   a[l],a[r]=a[r],a[l]
  end
 local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
 while k<=rp do
  if c(a[k],p) then
   a[k],a[lp]=a[lp],a[k]
   lp+=1
   elseif not c(a[k],q) then
    while c(q,a[rp]) and k<rp do
     rp-=1
    end
    a[k],a[rp]=a[rp],a[k]
    rp-=1
    if c(a[k],p) then
     a[k],a[lp]=a[lp],a[k]
     lp+=1
    end
   end
   k+=1
  end
  lp-=1
  rp+=1
  a[l],a[lp]=a[lp],a[l]
  a[r],a[rp]=a[rp],a[r]
  qsort(a,c,l,lp-1       )
  qsort(a,c,  lp+1,rp-1  )
  qsort(a,c,       rp+1,r)
 end
end

function do_collisions()
 for o in all(objs) do
  if o.coll and 
     bp.y < o.y+0.5 and
     bp.y > o.y-0.5 and
     abs(bp.j_h) < o.h and 
     bp.x_pos < o.x+o.size_x/4.5 and
     bp.x_pos > o.x-o.size_x/4.5 then
   o:collide()
  end
 end
end

function draw_txt(txt,x,y)
 print(txt, x+1, y+1, 0)
 print(txt, x, y, 7)
end

function get_point_y(_y)
 local top_y = world.hor
 local bot_y = 128
 
 if (_y-world.y-100) > 0 then
  _y = world.y+100
 end
 
 local mod = get_mod(_y)
 mod =(top_y + (bot_y-top_y)*mod)
 return mod
end

function get_mod(_y)
 local top_y = world.hor
 local bot_y = 128
 local mod = abs(_y-world.y-100)  
 mod =( (1.2^((mod+20)/10)-1.44)*13.4)/100 
 return mod
end

function set_car_c(t)
 pal(10, t.l)
 pal(9, t.d)
end

function destroy_hidden(objs)
 for o in all(objs) do
  if world.y-50 > o.y then
   del(objs, o)
  end
 end
end

function trigger_end(_endy)
 if not sys.finish then
  bp.playing = false
  sys.finish = true
  results.bps = sys.bps_t
  results.tim = flr((time()-sys.time_start)*100)/100
  results.scr = results.bps*10 + flr(500-results.tim)
  sys.event_time = time()+2.9
  display_message("finish!", 3)
 end
 bp.sp -= 0.004
 bp.x_pos = move_towards(bp.x_pos, 50, 0.5)
 if bp.y > _endy-3 then
  bp.sp = 0
 end
end

function move_towards(_v, _r, _s)
 if _v < _r then
  _v += _s
  if _v > _r then
   _v = _r
  end
 else
  _v -= _s
  if _v < _r then
   _v = _r
  end
 end 
 return _v
end

function set_checkpoint(_y,_bps)
 display_message("checkpoint!", 2)
 sys.curr_chk = _y
 sys.bps_chk = _bps
end

function check_time()
 if sys.event_time < time() then
	 if sys.time_left > 0 then
	  sys.time_left = sys.lvl_time-time()+sys.time_start
	 elseif sys.time_left <= 0 and not sys.restart then
	  sys.time_left = 0 
	  sys.restart = true
	  sys.event_time = time()+2.9
	  trip_bp()
	  display_message("out of time!", 3)
	 end
	end
end

function check_events()
 if sys.event_time < time() then
  if sys.restart then
   sys.lives -= 1
   if sys.lives < 0 then
    sys.game_over = true
   else
	   sys.restart = false
	   sys.time_left = 60
	   sys.lvl_time += 60
	   world.hor = 40
		  objs = {}
		  make_bp()
	   world.last_tile = flr(sys.curr_chk/world.tile_l)
	   bp.y = sys.curr_chk
	   sys.bps_t = sys.bps_chk
	   world.y = sys.curr_chk
	   for i = 0,3 do
	    add_objects_to_tile(world.last_tile+1,i)
	    add_objects_to_tile(world.last_tile+2,i)
	   end
	  end
  end
  if sys.finish then
   sys.show_end = true
  end
 end
end
-->8
--map functions

function draw_obj(t)
 if world.y > t.y-100 and 
    world.y < t.y then
 
  local top_x = get_hor_x(t.x)
  local bot_x = get_bas_x(t.x)
  local top_y = world.hor
  local bot_y = 128
  local mod = get_mod(t.y)
  
  local d_point= {x=(top_x + (bot_x-top_x)*mod) ,
                  y=(top_y + (bot_y-top_y)*mod)} 

  local size_x = t.size_x*0.2 + t.size_x * mod
  local size_y = t.size_y*0.2 + t.size_y * mod
  local mod_x = size_x/2
  d_point.x -= size_x/2 
  d_point.y -= size_y-2
    
  sspr(t.sp_x, t.sp_y,
	      t.sp_w, t.sp_h,
	      d_point.x, d_point.y,
	      size_x,size_y,
	      t.f, false)
	end
end

function make_crossing(_y1,_y2,_c1,_c2)
 add(decor, {
       y=_y1, y2=_y2, 
       col1=_c1, col2=_c2,
       draw = function (self)
        if world.y > self.y-100 and 
           world.y < self.y2 then
         draw_crossing(self)
        end
       end
     })
end

function make_checkpoint(_x,_y)
 add(objs, {
       size_x = 32, size_y = 64,
       sp_x = 24, sp_y = 32,
       sp_w = 8, sp_h = 16,
       x=_x, y=_y, f=false,
       draw = function (self)
        draw_obj(self)
       end,
       update = function (self)
								if self.y-bp.y < 5 then
								 set_checkpoint(self.y,sys.bps_t)
								 del(objs, self)
								end
       end
     })
end

function make_vending(_y)
 add(objs, {
       size_x = 16, size_y = 32,
       sp_x = 0, sp_y = 32,
       sp_w = 8, sp_h = 16,
       x=50, y=_y, f=false,
       draw = function (self)
        palt(14,true)
        palt(0,false)
        draw_obj(self)
        palt()
       end,
       update = function (self)
								if self.y-bp.y < 30 then
								 trigger_end(self.y)
								end
       end
     })
end

function make_building(_y)
 add(objs, {
       size_x = 350, size_y = 130,
       sp_x = 8, sp_y = 32,
       sp_w = 16, sp_h = 8,
       x=-15, y=_y, f=false,
       draw = function (self)
        draw_obj(self)
       end,
       update = function (self)

       end
     })
end

function make_house(_x,_y,_flip)
 add(objs, {
       size_x = 80, size_y = 60,
       sp_x = 104, sp_y = 0,
       sp_w = 24, sp_h = 16,
       x=_x, y=_y, f=_flip,
       draw = function (self)
        draw_obj(self)
       end,
       update = function (self)

       end
     })
end

function make_t_light(_x,_y,_flip)
 add(objs, {
       size_x = 20, size_y = 60,
       sp_x = 120, sp_y = 16,
       sp_w = 8, sp_h = 16,
       x=_x, y=_y, f=_flip,
       draw = function (self)
        draw_obj(self)
       end,
       update = function (self)

       end
     })
end

function make_lamp(_x,_y,_flip)
 add(objs, {
       size_x = 20, size_y = 60,
       sp_x = 96, sp_y = 0,
       sp_w = 8, sp_h = 16,
       x=_x, y=_y, f=_flip,
       draw = function (self)
        draw_obj(self)
       end,
       update = function (self)

       end
     })
end

function make_letter_box(_x,_y,_flip)
 add(objs, {
       size_x = 16, size_y = 16,
       sp_x = 88, sp_y = 16,
       sp_w = 8,  sp_h = 8,
       x=_x, y=_y, f=_flip,
       draw = function (self)
        draw_obj(self)
       end,
       update = function (self)

       end
     })
end

function make_end(_y)
 make_building(_y+45)
 make_vending(_y+40)
 make_tree(70, _y+55)
 make_tree(90, _y+62)
 make_tree(110, _y+70)
 make_tree(68, _y+63)
 make_crossing(_y,_y+30,7,6)
 make_crossing(_y+31,_y+50,15,15)
 make_crossing(_y+51,_y+150,11,11)
end

function make_cloud()
 add(clouds, {
	     x = rnd(128), y = world.hor+5,
	     size = flr(rnd(5))+1, 
	     var = rnd(3),
	     movx = rnd(0.5)-0.25,
	     movy = rnd(0.1)
	    })
end

function draw_sky()
 local sky_c = 12
 rectfill(0,0,128,128,sky_c)
 for c in all(clouds) do
  c.x += c.movx
  c.y -= c.movy
  if c.x < -10 or c.x > 138 or c.y < -5 then
   del(clouds, c)
   make_cloud()
  end
  for i = c.size,0,-1 do
   circfill(c.x+i*5,c.y,8-i*2+c.var,7) 
   circfill(c.x-i*5,c.y,8-i*2+c.var,7) 
  end 
 end
end

function draw_crossing(_c)
 local b1 = get_point_y(_c.y)
 local b2 = get_point_y(_c.y2)
 rectfill(0, b1, 128, b2,_c.col1)

 local p1 = get_point_y(_c.y+2)
 local p2 = get_point_y(_c.y2-2)
 rectfill(0, p1, 128, p2,_c.col2)
end


function draw_street(s, w, _r)
 local h_cen = w.cen
 local b_cen = w.bas
 local h_s_l = {x=h_cen-s.h_w/2, y=w.hor}
 local h_s_r = {x=h_cen+s.h_w/2, y=w.hor}
 local b_s_c = {x=b_cen, y=128}
 local b_s_l = {x=b_cen-s.b_w/2, y=128}
 local b_s_r = {x=b_cen+s.b_w/2, y=128}
 local l_y =  w.y%w.y_mod
 
 local vtl = {x= h_s_l.x, y= h_s_l.y} 
 local vtr = {x= h_s_r.x, y= h_s_r.y} 
 local vbl = {x= b_s_l.x, y= b_s_l.y} 
 local vbr = {x= b_s_r.x, y= b_s_r.y} 
 vtl.x-=10   vtr.x+=10
 vbl.x-=50  vbr.x+=50
 
 if not _r then
	 clip(0,w.hor, 128, 128-w.hor+1)
	 
	 --dibujo horizonte
	 rectfill(0,w.hor,128,128,11)
 
  draw_q(vtl, vtr, vbl, vbr, 15)
 end
 
 --dibujo calle
 draw_q(h_s_l, h_s_r, b_s_l, b_s_r, 5)
 
 h_s_l.x+=1    h_s_r.x-=1
 b_s_l.x+=3    b_s_r.x-=3
 
 draw_q(h_s_l, h_s_r, b_s_l, b_s_r, 6)
 
 --lineas de calle
 local l_h_w = s.h_w / 45 
 local l_b_w = s.b_w / 45
 
 local h_l_l = {x=h_cen-l_h_w, y=w.hor}
 local h_r_l = {x=h_cen+l_h_w, y=w.hor}
 local b_l_l = {x=b_cen-l_b_w, y=128}
 local b_r_l = {x=b_cen+l_b_w, y=128}
 
 for i=1, 5 do
  local base = sum(street.lin,i-1)
  local total = base + (street.lin[i] * l_y)/w.y_mod
 
  local mod_top = total
  local mod_bot = total*1.2

  local top_left = {x=(h_l_l.x + (b_l_l.x-h_l_l.x)*mod_top) ,
                    y=(h_l_l.y + (b_l_l.y-h_l_l.y)*mod_top)}
  local top_right= {x=(h_r_l.x + (b_r_l.x-h_r_l.x)*mod_top) ,
                    y=(h_r_l.y + (b_r_l.y-h_r_l.y)*mod_top)} 
  local bot_left = {x=(h_l_l.x + (b_l_l.x-h_l_l.x)*mod_bot) ,
                    y=(h_l_l.y + (b_l_l.y-h_l_l.y)*mod_bot)}
  local bot_right= {x=(h_r_l.x + (b_r_l.x-h_r_l.x)*mod_bot) ,
                    y=(h_r_l.y + (b_r_l.y-h_r_l.y)*mod_bot)}

  draw_q(top_left, top_right, bot_left, bot_right, 7)
 end

 clip()
end

function update_lvl()
 if world.hor != world.new_hor then
  if world.hor > world.new_hor then
   world.hor -= 0.1
   if world.hor < world.new_hor then
    world.hor = world.new_hor
   end
  else
   world.hor += 0.1
   if world.hor > world.new_hor then
    world.hor = world.new_hor
   end
  end
  
 end
end

--map_tiles
straight = 96
crossing = 97
up_horizon = 98
down_horizon = 99
sewer_guys = 101
walker = 102
truck = 117
car_front = 118
car_side = 119
bep_left = 112
bep_mid = 113
bep_right = 114
bep_rl = 115
bep_lr = 116
ending = 100
checkpoint = 103

function spawn_world()
 local tile = flr(world.y/world.tile_l)
 if world.last_tile < tile then
  local tile_pos = tile+2
  for i = 0,3 do
   add_objects_to_tile(tile_pos,i)
  end
   
  world.last_tile = tile
 end
end

function add_objects_to_tile(_px,_py)
 local new_tile = mget(_px,_py)
 local _y = _px*50
 if new_tile == crossing then
  make_crossing(_y+10,_y+40,7,6)
  make_t_light(18,_y+43,true)
  make_t_light(82,_y+7,false)
 elseif new_tile == up_horizon then
  move_hor(-5)
  populate_tile(_px)
 elseif new_tile == down_horizon then
  move_hor(5)
  populate_tile(_px)
 elseif new_tile == car_front then
  make_car(25+rnd(50),_y+rnd(25))
  make_car(25+rnd(50),_y+25+rnd(25))
 elseif new_tile == car_side then
  local d = flr(rnd(2))
  make_side_car(-45+d*220-rnd(60),
                _y+15+rnd(10), 
                d==1)
  d = flr(rnd(2))
  make_side_car(-45+d*220-rnd(60),
                _y+25+rnd(10), 
                d==1)
 elseif new_tile == truck then
  make_truck(180+rnd(15),_y+15+rnd(15))
 elseif new_tile == sewer_guys then
  make_sewer_guy(25+rnd(50), _y+rnd(15))
  make_sewer_guy(25+rnd(50), _y+15+rnd(15))
  make_sewer_guy(25+rnd(50), _y+30+rnd(20))
 elseif new_tile == walker then
  local d = flr(rnd(2))
  make_walker(rnd(15)+d*90, _y+rnd(15), d==1)
  d = flr(rnd(2))
  make_walker(rnd(15)+d*90, _y+15+rnd(15), d==1)
  d = flr(rnd(2))
  make_walker(rnd(15)+d*90, _y+30+rnd(20), d==1)
 elseif new_tile == bep_left then
  for i = 1, 5 do
   make_bepis(30, _y+i*10)
  end
 elseif new_tile == bep_mid then
  for i = 1, 5 do
   make_bepis(50, _y+i*10)
  end
 elseif new_tile == bep_right then
  for i = 1, 5 do
   make_bepis(70, _y+i*10)
  end
 elseif new_tile == bep_lr then
  for i = 1, 5 do
   make_bepis(20+i*10, _y+i*10)
  end
 elseif new_tile == bep_rl then
  for i = 1, 5 do
   make_bepis(80-i*10, _y+i*10)
  end
 elseif new_tile == straight then
  populate_tile(_px)
 elseif new_tile == ending then
  make_end(_y)
 elseif new_tile == checkpoint then
  make_checkpoint(25, _y+30)
  populate_tile(_px)
 end
end

function populate_tile(tile_pos)
 local _y = tile_pos*50
 for i = 1, 2 do
  make_lamp(18, _y + 20 * i,true)
  make_lamp(82, _y + 20 * i)
 end
 for i = 1, 5 do
  local iy = (_y+i*10)+rnd(10)
  local rand = flr(rnd(10))
  if rand == 9 then
   make_letter_box(15, iy,true)
  elseif rand == 8 then
   make_bin(15, iy)
  elseif rand <= 7 and
         rand >= 6 then
   make_house(-20,iy,false)
  elseif rand <= 5 and
         rand >= 2 then
   make_tree(-5, iy)
  end
 end
 for i = 1, 5 do
  local iy = (_y+i*10)+rnd(10)
  local rand = flr(rnd(10))
  if rand == 9 then
   make_letter_box(85, iy,false)
  elseif rand == 8 then
   make_bin(85, iy)
  elseif rand <= 7 and
         rand >= 6 then
   make_house(120,iy,true)
  elseif rand <= 5 and
         rand >= 2 then
   make_tree(105, iy)
  end
 end
end

function move_hor(_d)
 world.new_hor = world.hor + _d
end
-->8
--bepisman functions

function make_bp()
 bp = {
       size_x=16, size_y=32,
       sp_x = 8, sp_y = 0,
       sp_w = 8, sp_h = 16,
       x_pos= 50, sp = 0,
       x = 64,   y = 0,
       j_h = 0,  j_d = 0, 
       jump = false, slide = false,
       lose = false, idle = true,
       playing = true,
       draw = function (self)
         draw_bp(self)
       end,
       update = function (self)
        update_bp()
       end
     }
 add(objs, bp)
end

function update_bp()
 if not bp.lose and bp.playing then
 
  if bp.sp < 0.5 then
 	 bp.sp += 0.01
 	end
	 
	 if btn(➡️) and not bp.slide then
	  bp.x_pos += 0.5
	 end
	
	 if btn(⬅️) and not bp.slide then
	  bp.x_pos -= 0.5
	 end
	 
	 if btnp(🅾️) and bp.idle then
	  bp.sl_t = time()+0.5
	  bp.slide = true
	  bp.idle = false
	  sfx(3)
	 end
	 
	 if btnp(❎) and bp.idle then
	  bp.j_d = -2.5
	  bp.jump = true
	  bp.idle = false
	  sfx(2)
	 end
	 
	 if bp.slide and 
	    bp.sl_t < time() then
	  bp.slide = false
	  bp.idle = true
	 end 
	 
	 do_collisions()
	  
	end
	
	if bp.lose and
	    bp.time < time() then
  bp.lose = false
  bp.idle = true
 end
	
	
	
	if bp.jump then
  bp.j_d += 0.15
  bp.j_h += bp.j_d
  if bp.j_h > 0 then
   bp.jump = false
   bp.idle = true
   bp.j_h = 0
  end
 end
 
 if bp.lose and
	    bp.sp > 0 then
  bp.sp -= 0.02
  bp.sp = max(bp.sp,0)
 end
 
 bp.y += bp.sp
end

function trip_bp()
 bp.lose = true
 bp.idle = false
 bp.slide = false
 bp.time = time()+3
 sfx(1)
end

function draw_bp(bp)
 local frame_x = flr((time()*10)%4)
 local frame_y = 0
 
 if bp.idle then
  frame_x = 8+8*frame_x  
 end 
 if bp.jump then
  frame_y = 16
  if bp.j_d < 0 then
   frame_x = 8
  else
   frame_x = 16
  end
 end
 if bp.slide then
  frame_y = 16
  frame_x = 24
 end
 if bp.lose then
  frame_y = 16
  frame_x = 32
 end
 if not bp.playing 
    and bp.sp == 0 then
  frame_x = 0
  frame_y = 16
 end
 
 
 bp.sp_x = frame_x
 bp.sp_y = frame_y
-- draw_obj(bp)
 sspr(frame_x, frame_y,
       8, 16,
       56, 90+bp.j_h,
       16,32,
       false, false)
      
end
-->8
--hud functions

function draw_hud()
 draw_time()
 draw_bps()
 draw_lives()
 draw_lvl_sts()
end

function draw_time()
 draw_txt(flr(sys.time_left), 60, 5, 0)
end

function draw_bps()
 draw_txt(sys.bps_t, 20, 5)
 spr(23, 10, 4)
 spr(16, 35, 4)
end

function draw_lives()
 draw_txt(sys.lives, 106, 112)
 sspr(0, 16, 8, 16, 110, 105)
end

function draw_lvl_sts()
 local _x = 80
 local _y = 12
 local time_lvl = flr((time()-sys.time_start)*100)/100
 local frame = flr((time()*5)%2)
 local prog = flr(world.y/world.tile_l)/128
 line(_x+1,_y-1,_x+43,_y-1,0)
 line(_x+1,_y-3,_x+1,_y-1,0)
 line(_x+43,_y-3,_x+43,_y-1,0)
 line(_x+22,_y-3,_x+22,_y-1,0)
 line(_x,_y-2,_x+42,_y-2,7)
 line(_x,_y-4,_x,_y-2,7)
 line(_x+42,_y-4,_x+42,_y-2,7)
 line(_x+21,_y-4,_x+21,_y-2,7)
 line(_x+7,_y-3,_x+7,_y-2,7)
 line(_x+14,_y-3,_x+14,_y-2,7)
 line(_x+28,_y-3,_x+28,_y-2,7)
 line(_x+35,_y-3,_x+35,_y-2,7)
 draw_txt("s", _x-1,_y-9)
 draw_txt("g", _x+41,_y-9)
 draw_txt("total", _x,_y)
 draw_txt(time_lvl, _x+28, _y)
 spr(53+frame,_x+(38*prog),_y-10) 
end

function display_message(_tx, _tm)
 message.txt = _tx
 message.tme = time()+_tm
end

function draw_message()
 if message.tme > time() then
  local l = #message.txt
  local _y = 25
  rectfill(64-3*l,_y,64+3*l,_y+15,1)
  draw_txt(message.txt, 64-2*l,_y+5)
 end
end

function draw_bg()
 rectfill(0,0,128,40,4)
 rectfill(0,52,128,128,3)
 rectfill(0,40,128,52,6)
end

function draw_title()
 local _d = title.logo_d - title.y 
 local _size = 0
 if _d < 50 then
  _size = 1-_d/50
 end
 sspr(96,32,32,24,
      64-_size*32,
      18+_size*10,
      64*_size,
      48*_size)
end
-->8
--objects functions

car_colors={
            {l=10,d=9},
            {l=8,d=2},
            {l=11,d=3},
            {l=12,d=1},
            {l=14,d=2},
           }

function make_tree(_x,_y)
 add(objs, {
       size_x = 42, size_y = 42,
       sp_x = 40, sp_y = 0,
       sp_w = 16, sp_h = 16,
       x = _x,       y = _y,
       h = 32,    coll = true,
       f = false,
       draw = function (self)
         draw_obj(self)
       end,
       update = function (self)

       end,
       collide = function (self)
         trip_bp()
         del(objs, self)
       end
     })
end

function make_bin(_x,_y)
 add(objs, {
       size_x = 16, size_y = 16,
       sp_x = 56, sp_y = 0,
       sp_w = 8,  sp_h = 8,
       x = _x,       y = _y,
       h = 8,    coll = true,
       f = false,
       draw = function (self)
         draw_obj(self)
       end,
       update = function (self)

       end,
       collide = function (self)
         trip_bp()
         del(objs, self)
       end
     })
end

function make_bepis(_x,_y)
 add(objs, {
       size_x = 16, size_y = 16,
       sp_x = 56, sp_y = 8,
       sp_w = 8,  sp_h = 8,
       x = _x,       y = _y,
       h = 8,     coll = true,
       f = false,
       draw = function (self)
         draw_obj(self)
       end,
       update = function (self)

       end,
       collide = function (self)
         sys.bps_t += 1
         sys.lvl_time += 0.7
         sfx(0)
         del(objs, self)
       end
     })
end

function make_walker(_x,_y,_flip)
 add(objs, {
       size_x = 16, size_y = 30,
       sp_x = 72, sp_y = 16,
       sp_w = 8,  sp_h = 16,
       x = _x,       y = _y,
       h = 24,    coll = true,
       f = _flip,
       draw = function (self)
         local frame_x = flr((time()*5)%2)
         self.sp_x = 72+8*frame_x 
         draw_obj(self)
       end,
       update = function (self)
         if self.f then
          self.x -= 0.2
         else
          self.x += 0.2
         end
       end,
       collide = function (self)
         trip_bp()
         del(objs, self)
       end
     })
end

function make_car(_x,_y)
 add(objs, {
       size_x = 30, size_y = 30,
       sp_x = 56,  sp_y = 16,
       sp_w = 16,  sp_h = 16,
       x = _x,        y = _y,
       h = 16,     coll = true,
       p = flr(rnd(5))+1,
       draw = function (self)
         set_car_c(car_colors[self.p])
         draw_obj(self)
         pal()
       end,
       update = function (self)
         self.y -= 0.2
       end,
       collide = function (self)
         trip_bp()
         del(objs, self)
       end
     })
end

function make_sewer_guy(_x,_y)
 add(objs, {
       size_x = 16, size_y = 16,
       sp_x = 40, sp_y = 16,
       sp_w = 8,  sp_h = 8,
       x = _x,       y = _y,
       h = 10,    coll = true,
       draw = function (self)
         if self.y-world.y < 40 then
          self.sp_x = 48
         end
         draw_obj(self)
       end,
       update = function (self)
         
       end,
       collide = function (self)
         trip_bp()
         del(objs, self)
       end
     })
end

function make_side_car(_x,_y,_flip)
 add(objs, {
       size_x = 55, size_y = 36,
       sp_x = 96,  sp_y = 16,
       sp_w = 24,  sp_h = 16,
       x = _x,        y = _y,
       h = 16,     coll = true,
       f = _flip,
       p = flr(rnd(5))+1,
       draw = function (self)
         set_car_c(car_colors[self.p])
         draw_obj(self)
         pal()
       end,
       update = function (self)
         if self.f then
          self.x -= 0.5
         else
          self.x += 0.5
         end
       end,
       collide = function (self)
         trip_bp()
         del(objs, self)
       end
     })
end

function make_truck(_x,_y)
 add(objs, {
       size_x = 120, size_y = 60,
       sp_x = 64,  sp_y = 0,
       sp_w = 32,  sp_h = 16,
       x = _x,        y = _y,
       h = 30,     coll = true,
       draw = function (self)
         draw_obj(self)
       end,
       update = function (self)
         if self.x > 50 then
          self.x -= 1
         end
       end,
       collide = function (self)
         if bp.x_pos > self.x+13 or
            bp.x_pos < self.x then
          trip_bp()
          del(objs, self)
         end
         if bp.x_pos < self.x+13 and
            bp.x_pos > self.x and
            not bp.slide then
          trip_bp()
          del(objs, self)
         end
       end
     })
end
__gfx__
0000000000000000000000000000000000000000000003b3b3b00000000000000000000000000000000000000000000000000000003333333333333333333300
000000000000000000000000000000000000000000033b3b33bb3b0000677700000000000000000000000000000000000000005003b3bb3b113bbb3bb3bb1b30
0070070000099000000990000009900000099000003b333bbb3b3bb00d666670000000000000bbbbbbbbbbbaaaaaaa9005555050033333116613333333316130
000770000049490000494900004949000049490003333bb3bbb3b3b00dddd66000000bbb330bb39493b3b3a9a9a9a9a955500550b3bb116666613bb3b316663b
0007700000449400004494000044940000449400033bb33b333bbb300d7676600000bccc330b3949493b679a679a67696a600050331166667766133333166613
00700700000440000004400000044000000440000333333b33bb3bb00076760000003ccc33033777773366666666699406000050116666777776613b31666663
00000000014499000044990000449990004499000b333b333b33b3b00076760000003ccc33033bbbbb3669696966965900000050066677777777661331666661
0000000001144490010444900114449001144090033b333b333bbb3000ddd60000003333330331b3b49565956464659400000050067777777777766116666660
00499a0001014040013140400101404001014940000333b333b3b300000bb3006bbb33333303131349494949494949490000005007ccc7777777776666666960
049999a000314040000140400301140003014000000003333333300000b333306333b33bb300111144444444444444440000005007ccccc77cc7777666169960
49499a9a000131000001310000113000001130000000004990000000003799106336b3333300566000000000566666440000005007ccccc77ccccc7761169960
466799970010010000100100001001000010010000000044900000000b737700636566333665605600000000650005640000005007ccccc77ccccc7761169960
53bb777b00100300001030000030010000130100000000449900000003773100665653666555056500000000565056500000005007777cc77ccccc7761169960
3b3bbbbb001001000001000000100100000010000000044449900000b7333000005650000000056500000000565056500000056607777777777ccc7761669960
03b3b3b0000300000003000000003000000030000000400404090000337310000005000000000050000000000500050000000566000007777777777766669900
003b3b00000100000001000000001000000010000000000000000000031100000000000000000000000000000000000000000566000000000007777766600000
000000000000000000000000000000000000000000000000099449900000000000000000000000000000000000dddd0000000000000000000000000000000000
00000000000000000000000000000000000000000000000045599554000000000000000000022200000222000dd7ccc000000000000000000000000000000050
00099000000990000009900000000000000000000000000049955994000000000000000000222220002222200d7ccccc00000000000000000000000005555050
004949000049490000494900000000000000000000000000044444400000aaaaaa9a00000222ff000222ff000dc1661c00000000000000000000000058250550
00449400004494000044940000000000010000300994499000f00f00000aaaaaaaa9a000022fff00022fff000dc1661c00000000000000000000000059450050
0004400000044000000440000000000000300100455995540f1ff1f0000511cc11115000002ff000002ff0000dc1cc1c000000aaaaaaaaa0000000005b350050
00499100014499000144990000099000011001304995599411ffff1100051cc1111c500000088000000880000dc1cc1c000000aa1611c1500000000005550050
044631300114449010144490004949001100001304444440011ff1100555cc1111c1555000e8880000e8880000c0000c00000a1a11611c150000000000000050
0403301000114004101140400044940911113311000000000000000000aaaaaaa9a9a9000e88880000e888000090000000000a1a116111c50000000000000050
0401101000014000000140000004400400111100000070000000700000aaaaa9aaaa9a0008f88800008e8f0000090000000aaaaaaa9aaaaaaaaaa00000000050
004113000001300000013000001449400001100000777000000770000aaaaaaaa9a9a9a00ffee80000e8ff000009000000aaaaaaaa9aa99aaaaaaa0000000050
000110000010100000100100001144000011190007070700000700000aaaaaa9aaaa9a9000111100001111000009a000044aaaaaaa9aaaaaaaaa440000000050
001003000010000000100100011114000011440000070000000770000aaaaaaaa9a9a9a00011d10000011100000a9000546a55aaaa9aaaaaaa55a45000000050
0010030000100000000300001131130001044040000770000007700004777555555777400011d10000110110000a90005565565aaa9aaaaaa556565000000566
0010010000030000000100001001300010000009077007000007000054777655556777450011d10005100015a009a90a00056550000000000565500000000566
001001000001000000000000000000000000000000000000000000000555555555555550005555500550005009a00a9000005500000000000055000000000566
ebbbb00e999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000333300333330333303333003333300
b3333000666666665222222000000000000000000000000000000000000000000000000000000000000000000000000000373730377773777733777337777300
73343000666666665222222000009880000000000000000000000000000000000000000000000000000000000000000000377343777733773733777337733000
37444006888888888888888000098888000000000000000000000000000000000000000000000000000000000000000003737733777343777343777333377300
73777006888888888888888800098888000000000000000000000000000000000000000000000000000000000000000003777343777773773443777337777300
37bbb0006c76c76c76c76c7000988888000000000000000000000000000000000000000000000000000000000000000003333444333334333443333443333300
773b300067c67c67c67c67c000900088000000000000000000000000000000000000000000000000000000000000000003333444334443333334443333443300
7333303b655655655655655000900080000000000000000000000000000000000000000000000000000000000000000003777343734437777773443777347730
37333000000000000000000009000800000000000000000000000000000000000000000000000000000000000000000003777343734377733377343777337730
33333049000000000000000009000000000000000000000000000000000000000000000000000000000000000000000003777737734377734377343777737730
76656000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000003777777734377733377343777737730
76566000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000003737773734377777777343773777730
76666000000000000000000090000000000000000000000000000000000000000000000000000000000000000000000037737773734377733377343773777733
70006000000000000000000090000000000000000000000000000000000000000000000000000000000000000000000037737773734377734377343773377773
70006000000000000000000090000000000000000000000000000000000000000000000000000000000000000000000037743734734377734377343774377773
e555500e000000000000000090000000000000000000000000000000000000000000000000000000000000000000000033343334334333334333343334333333
33333333336666333333333333333333330707336666666666622666333333330000000000000000000000000000000033343334334333334333343334333333
3333333333666633333333666633333333707033666664466662f666333988330000000000000000000000000000000003334333433433334333433343333330
66666666666666663333666666663333660707666666999466688666666988860000000000000000000000000000000000333433433433334333433433333300
66666666666666663366666666666633667070666666699666688666669888880000000000000000000000000000000000033343343343334334334333333000
666666666666666666666666666666666607076664466e6666688666669888860000000000000000000000000000000000000000000000000000000000000000
66666666666666666666663333666666667070669994666666611666669666660000000000000000000000000000000000000000000000000000000000000000
33333333336666336666333333336666330707336996666666611666393333330000000000000000000000000000000000000000000000000000000000000000
33333333336666336633333333333366337070336e66666666611666393333330000000000000000000000000000000000000000000000000000000000000000
63636363666666666666666666666663636666666666666666866666666866660000000000000000000000000000000000000000000000000000000000000000
64646464666666666666666666666664646666666666666668866666668886660000000000000000000000000000000000000000000000000000000000000000
666666666666666666666666666663666663666633363333888888a6688888660000000000000000000000000000000000000000000000000000000000000000
666666666363636366666666666664666664666633363333688ccaa666a8ca660000000000000000000000000000000000000000000000000000000000000000
666666666464646466666666666366666666636655333355aa8aaaaa6ac8cca60000000000000000000000000000000000000000000000000000000000000000
666666666666666666666666666466666666646660666600a0aaaa0aaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
666666666666666663636363636666666666666366666666666666669aaaaaa90000000000000000000000000000000000000000000000000000000000000000
66666666666666666464646464666666666666646666666666666666606666060000000000000000000000000000000000000000000000000000000000000000
00000aaaaaa00000000000000000000000000aaaaaa0000000000aaaaaa0000000000aaaaaa00000000000000000000000000000000000000000000000000000
000aaaaaaaaa0000000a00000000a000000aaaaaaaaaa000000aaaaaaaaaa000000aaaaaaaaaa000000000000000000000000000000000000000000000000000
00aaaaaaaaa90000000aa000000aa00000aaaaaaaaaaaa0000aaaaaaaaaaaa0000aaaaaaaaaaaa00000000000000000000000000000000000000000000000000
0aaaaaaaaa9000000009aa0000aa90000aaaaaaaaaaaaaa00aaaaaaaaaaaaaa00aaaaaa9aaaaaaa0000000000000000000000000000000000000000000000000
0aaaaaaaa90000000000aaa00aaa00000aaaaaaaaaaaaaa00aaaaaaaaaaaaaa00aaaaa909aaaaaa0000000000000000000000000000000000000000000000000
aaaaaaaa9000000000009aaaaaa900000999aaaaaaaa9990aaaaaaaaaaaaaaaaaaaaaaa0aaaaaaaa000000000000000000000000000000000000000000000000
aaaaaaaaaaaa000000000aaaaaa00000000099aaaa990000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000
aaaaaaaaaaaaaaa0000009aaaa900000000000aaaa000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000
aaaaaaaaaaaaaaa0000000aaaa000000000000aaaa000000aaaaaaaaaaaaaaaaaaaaaaaaaa999999000000000000000000000000000000000000000000000000
aaaaaaaaaaaa999000000aaaaaa00000000000aaaa000000aaaaaaaaaaaaaaaaaaaaaa9aaaa00000000000000000000000000000000000000000000000000000
aaaaaaaa9999000000000aaaaaa00000000000aaaa000000aaaaaaaaaaaaaaaaaaaaaa09aaa00000000000000000000000000000000000000000000000000000
9aaaaaaaa00000000000aaa99aaa00000000009aa90000009aaaaaaaaaaaaaa99aaaaa009aaa0000000000000000000000000000000000000000000000000000
0aaaaaaaaa0000000000aa9009aa00000000000aa00000000aaaaaaaaaaaaaa00aaaaa0009aa0000000000000000000000000000000000000000000000000000
09aaaaaaaaa00000000aa900009aa0000000000aa000000009aaaaaaaaaaaa9009aaaa00009aa000000000000000000000000000000000000000000000000000
009aaaaaaaaa0000000a90000009a0000000000aa0000000009aaaaaaaaaa900009aaa000009a000000000000000000000000000000000000000000000000000
00099999999000000009000000009000000000099000000000099999999990000009990000009000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000033333333000033333333330033333333003333333300003333333333000000000000000000000000000000000000
00000000000000000000000000000000000033333333000033333333330033333333003333333300003333333333000000000000000000000000000000000000
00000000000000000000000000000000000033773377330033777777773377777777333377777733337777777733000000000000000000000000000000000000
00000000000000000000000000000000000033773377330033777777773377777777333377777733337777777733000000000000000000000000000000000000
00000000000000000000000000000000000033777733443377777777333377773377333377777733337777333300000000000000000000000000000000000000
00000000000000000000000000000000000033777733443377777777333377773377333377777733337777333300000000000000000000000000000000000000
00000000000000000000000000000000003377337777333377777733443377777733443377777733333333777733000000000000000000000000000000000000
00000000000000000000000000000000003377337777333377777733443377777733443377777733333333777733000000000000000000000000000000000000
00000000000000000000000000000000003377777733443377777777773377773344443377777733337777777733000000000000000000000000000000000000
00000000000000000000000000000000003377777733443377777777773377773344443377777733337777777733000000000000000000000000000000000000
00000000000000000000000000000000003333333344444433333333334433333344443333333344443333333333000000000000000000000000000000000000
00000000000000000000000000000000003333333344444433333333334433333344443333333344443333333333000000000000000000000000000000000000
00000000000000000000000000000000003333333344444433334444443333333333334444443333333344443333000000000000000000000000000000000000
00000000000000000000000000000000003333333344444433334444443333333333334444443333333344443333000000000000000000000000000000000000
00000000000000000000000000000000003377777733443377334444337777777777773344443377777733447777330000000000000000000000000000000000
00000000000000000000000000000000003377777733443377334444337777777777773344443377777733447777330000000000000000000000000000000000
00000000000000000000000000000000003377777733443377334433777777333333777733443377777733337777330000000000000000000000000000000000
00000000000000000000000000000000003377777733443377334433777777333333777733443377777733337777330000000000000000000000000000000000
00000000000000000000000000000000003377777777337777334433777777334433777733443377777777337777330000000000000000000000000000000000
00000000000000000000000000000000003377777777337777334433777777334433777733443377777777337777330000000000000000000000000000000000
00000000000000000000000000000000003377777777777777334433777777333333777733443377777777337777330000000000000000000000000000000000
00000000000000000000000000000000003377777777777777334433777777333333777733443377777777337777330000000000000000000000000000000000
00000000000000000000000000000000003377337777773377334433777777777777777733443377773377777777330000000000000000000000000000000000
00000000000000000000000000000000003377337777773377334433777777777777777733443377773377777777330000000000000000000000000000000000
00000000000000000000000000000000337777337777773377334433777777333333777733443377773377777777333300000000000000000000000000000000
00000000000000000000000000000000337777337777773377334433777777333333777733443377773377777777333300000000000000000000000000000000
00000000000000000000000000000000337777337777773377334433777777334433777733443377773333777777773300000000000000000000000000000000
00000000000000000000000000000000337777337777773377334433777777334433777733443377773333777777773300000000000000000000000000000000
00000000000000000000000000000000337777443377334477334433777777334433777733443377774433777777773300000000000000000000000000000000
00000000000000000000000000000000337777443377334477334433777777334433777733443377774433777777773300000000000000000000000000000000
00000000000000000000000000000000333333443333334433334433333333334433333333443333334433333333333300000000000000000000000000000000
00000000000000000000000000000000333333443333334433334433333333334433333333443333334433333333333300000000000000000000000000000000
00000000000000000000000000000000333333443333334433334433333333334433333333443333334433333333333300000000000000000000000000000000
00000000000000000000000000000000333333443333334433334433333333334433333333443333334433333333333300000000000000000000000000000000
00000000000000000000000000000000003333334433333344333344333333334433333344333333443333333333330000000000000000000000000000000000
00000000000000000000000000000000003333334433333344333344333333334433333344333333443333333333330000000000000000000000000000000000
00000000000000000000000000000000005633333344333344333344333333334433333344333344333333333333650000000000000000000000000000000000
00000000000000000000000000000000055633333344333344333344333333334433333344333344333333333333655000000000000000000000000000000000
00000000000000000000000000000000556666333333443333443333443333334433334433334433333333333366665500000000000000000000000000000000
00000000000000000000000000000005566666333333443333443333443333334433334433334433333333333366666550000000000000000000000000000000
00000000000000000000000000000005666666666666666666666666661166666666336666666666666666666666666650000000000000000000000000000000
00000000000000000000000000000055666666666666666666666666661166666666336666666666666666666666666655000000000000000000000000000000
00000000000000000000000000000556666666666666666666666666666633666611666666666666666666666666666665500000000000000000000000000000
00000000000000000000000000005566666666666666666666666666666633666611666666666666666666666666666666550000000000000000000000000000
00000000000000000000000000005666666666666666666666666666661111666611336666666666666666666666666666650000000000000000000000000000
00000000000000000000000000055666666666666666666666666666661111666611336666666666666666666666666666655000000000000000000000000000
00000000000000000000000000556666666666666666666666666666111166666666113366666666666666666666666666665500000000000000000000000000
00000000000000000000000005566666666666666666666677767776777167766776113367777766676666666666666666666550000000000000000000000000
00000000000000000000000055666666666666666666666670707070700071007300111177000776670666666666666666666655000000000000000000000000
00000000000000000000000056666666666666666666666677707760771177717773111177076770670666666666666666666665000000000000000000000000
00000000000000000000000556666666666666666666666670007076700610701070666677060770660666666666666666666665500000000000000000000000
00000000000000000000005566666666666666666666666670667070777677107710666667777700676666666666666666666666550000000000000000000000
00000000000000000000055666666666666666666666666660666060600060011006666666000006660666666666666666666666655000000000000000000000
00000000000000000000556666666666666666666666666666666666666666111166666666666666666666666666666666666666665500000000000000000000
00000000000000000000556666666666666666666666666666666666666611111199666666666666666666666666666666666666665500000000000000000000
00000000000000000005566666666666666666666666666666666666666611111199666666666666666666666666666666666666666550000000000000000000
00000000000000000055666666666666666666666666666666666666666611114444666666666666666666666666666666666666666655000000000000000000
00000000000000000556666666666666666666666666666666666666666611114444666666666666666666666666666666666666666665500000000000000000
00000000000000000556666666666666666666666666666666666666661167444476446666666666666666666666666666666666666665500000000000000000
00000000000000005566666666666666666666666666666666666666661167444476446666666666666666666666666666666666666666550000000000000000
00000000000000055666666666666666666666666666666666666666116667777776669966666666666666666666666666666666666666655000000000000000
00000000000000556666666666666666666666666666666666666666116666666666669966666666666666666666666666666666666666665500000000000000
00000000000005556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665550000000000000
00000000000005566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666550000000000000
00000000000055666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666655000000000000
00000000000556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665500000000000
00000000005566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666550000000000
00000000055566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666555000000000
00000000055666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666655000000000
00000000556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665500000000
00000005566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666550000000
00000055566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666555000000
00000055666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666655000000
00000556666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666665500000
00005566666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666550000
00055566666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666555000
00555666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666655500
00556666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666665500
05566666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666666550
55566666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666666555
55666666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666666655
56666666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666666665
66666666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666667777776666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666677777777666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666677777777666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666677777777666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666667777666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666

__map__
6060606063606060606160606062606061606060636060616360606061606063606160606360606060616060636061606062606160606260606061606067606163616361606060626262606060606160606063606060616063606160606260606260606160606062606060616060606260606061606060636360606060606460
0000000071710072007300700074007171000073007200000070747200700071000000747200007000710074720000007000716672007374737400720070000070000072730072007200710071000000717673707400007100717700740073000074007100710072007300000000710071660000007070747300727300000000
0000000000006500650066006600760076000065007600770065000077006600667500766600657600770065650075006576006500007666006577006566657500770077006566656600656676007500007676000065770000007700666500006566006500660066760065757600760000660075650076006600006500000000
0000000000000000000000000000000000000066000000000065000077000000000000006600007600770000000000000066007700000076007600006600760000007677007600007600000000000000000000006666000000007700760000007600007700650076000000006500760000660000000000007600006600000000
__sfx__
00020000273102a3202d3303034028330203201931018300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000083500635004350033500620007200092001f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000275013750297500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300003661034610316102f6102c6102b61028610266102461022610206101f6101c6101a610196101761015610136100e6100b6100a6100661000000000000000000000000000000000000000000000000000
0116000009140091100e1000c1400c110091400e1400f14009140091100e1000c1400c110091400e1400f14009140091100e1000c1400c110091400e1400f14009140091100e1000c1400c110091400e1400f140
0116000021140003001f1402114221142211422114221145213002130021300213002130021300213002130000200002000010000100000000000000000000000000000000000000000000000000000000000000
491600002122021222000002422024222242222622027220212202122200000242202422224222262202722021220212220000024220242222422226220272202122021222000002422024222242222622027220
91160000212522125521252212552125521255000001e2521e2551e2551e2521e2551e2551e255000001f2521f2521f2551f2521f2551f2551f255000001e2521e2551e2551e2521e2551f2551f2550000000000
911600001c2521c2551c2521c2551c2551c255000001e2521e2551e2551e2521e2551e2551e255000002125221255212551f2551f2551e2551e2551c2551e2521e2551e2551c2521c2551a2551c2551e2551f252
0116000021140003001f140211422114221142211422114521140213001f14021140213001f140213002130021140003001f140211422114221142211422114521140213001f14021140213001f1402130021300
011600001861200000246120000018612000002461200000186120000024612000001861200000246120000018612000002461200000186120000024612000001861200000246120000018612000002461200000
011600000c32300000183230c3230c3030c32318323000000c32300000183230c3230c3030c32318323000000c32300000183230c3230c3030c32318323000000c32300000183230c3230c3030c3231832300000
011000002113221132211322113221132211321e1321e1321e1321e1321e1321e1321e1321e1321e1321e13500000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 04450a0b
01 04450a0b
00 04060a0b
00 04060a0b
00 04050a0b
00 04070a0b
00 04080a0b
00 04090a0b
02 04050a0b

