// LilRobbsGirlfriend REV F - Easy Assembly / Friendly Shell (mm)
// Prototype only: full CAD visualization + printed fit-check pieces.
// Wheel/tire/motor proxies are NOT printable purchased-wheel replacement parts.
part="assembly"; wheel_d=96; exploded=0; $fn=32;
baseL=250; baseW=204; baseZ=30;
// Spacer height changes to keep floor clearance ~8 mm for each wheel band.
function axle_for(d)= d==69 ? 57 : d==96 ? 69 : 76;
module rr(x,y,z,r=10){hull()for(i=[-1,1],j=[-1,1])translate([i*(x/2-r),j*(y/2-r),0])cylinder(h=z,r=r);}
module drill_slot(x,y,l=12,r=2.05){translate([x,y,0])hull(){translate([0,-l/2,-2])cylinder(h=14,r=r);translate([0,l/2,-2])cylinder(h=14,r=r);}}
module tub(right=false){
 difference(){
  union(){
   difference(){rr(125,204,50,16);translate([0,0,4])rr(117,196,49,13);}
   // Two posts per segment, aligned to x=+/-39 in assembled deck
   for(y=[-76,76])translate([right?-23.5:23.5,y,5])cylinder(h=46,r=5);
  }
  for(y=[-76,76])translate([right?-23.5:23.5,y,43])cylinder(h=12,r=1.5);
  // M4 splice plate through-holes in bottom
  for(y=[-64,64])translate([right?-25:25,y,-1])cylinder(h=8,r=2.3);
  // 4 holes for each of the two motor brackets (fits 60x56 interface plate)
  for(side=[-1,1],x=[-18,18],y=[-14,14])
    drill_slot((right?30:-30)+x,side*70+y,7,2.05);
  // Two sidewall screws into overlapping cosmetic shell skirt
  for(side=[-1,1])translate([0,side*100,48])rotate([90,0,0])cylinder(h=12,r=1.8,center=true);
  for(y=[-38,0,38])translate([right?64:-64,y,33])cube([12,15,5],center=true);
 }
}
module chassis_front(){tub(false);}
module chassis_rear(){tub(true);}
// M4 bridge strip above chassis floor; captured with washer + locknut
module bridge(){difference(){rr(80,22,4,6);for(x=[-25,25])translate([x,0,-1])cylinder(h=7,r=2.3);}}
module riser(h=9){difference(){rr(60,56,h,7);for(x=[-18,18],y=[-14,14])translate([x,y,-1])cylinder(h=h+3,r=2.15);} }
module motor_interface(){
 // Flat through-bolt interface: slot dimensions generic, finish hole pattern on actual bracket
 difference(){rr(60,56,5,7); for(x=[-18,18],y=[-14,14])hull(){translate([x,y-5,-1])cylinder(h=8,r=2.05);translate([x,y+5,-1])cylinder(h=8,r=2.05);}}
}
module deck(){difference(){rr(112,168,4,10);for(x=[-39,39],y=[-76,76])translate([x,y,-1])cylinder(h=7,r=1.8);for(x=[-29,0,29],y=[-50,50])translate([x,y,-1])cube([9,7,7],center=false);}}
module battery_cradle(){difference(){rr(164,87,21,8);translate([0,0,4])rr(158,81,22,6);for(x=[-51,51])translate([x,0,0])cube([12,95,30],center=true);}}
module cowl(){
 difference(){
  hull(){rr(124,198,2,22);translate([0,0,43])rr(103,161,2,26);}
  translate([0,0,-2])hull(){rr(117,191,2,19);translate([0,0,40])rr(97,154,2,23);}
  // Cosmetic shell fits down into chassis 6 mm; cross-hole for M3 sidewall fixing
  for(side=[-1,1])translate([0,side*98,4])rotate([90,0,0])cylinder(h=12,r=1.8,center=true);
 }
}
module spine(){difference(){rr(27,170,4,11);for(y=[-68,68])translate([0,y,-1])cylinder(h=7,r=2.1);}}
module neck(){difference(){cylinder(h=30,r1=30,r2=26);translate([0,0,-1])cylinder(h=32,r=21);}}
module head_blank(){
 difference(){hull(){rr(113,96,64,29);translate([0,0,13])rr(115,96,54,29);}
  translate([0,0,3])hull(){rr(107,90,62,26);translate([0,0,13])rr(109,90,52,26);}
 }
}
module head_front(){difference(){intersection(){head_blank();translate([-60,-50,-1])cube([120,51,90]);} for(x=[-30,0,30])translate([x,-49,42])rotate([90,0,0])cylinder(h=12,r=(x==0?9:11),center=true);}}
module head_cap(){ union(){rr(115,96,5,29);translate([0,0,-2])rr(107,88,2,26);} }
module head_rear(){intersection(){head_blank();translate([-60,0,-1])cube([120,50,90]);}}
module face(){difference(){rr(100,54,3,20); for(x=[-30,30])translate([x,0,-1])cylinder(h=5,r=12);translate([0,0,-1])cylinder(h=5,r=9);}}
module eye(){difference(){cylinder(h=3,r=13.5);translate([0,0,-1])cylinder(h=5,r=10);}}
module camera_ring(){difference(){cylinder(h=3,r=11);translate([0,0,-1])cylinder(h=5,r=8);}}
module grille(){difference(){rr(76,28,3,8);for(x=[-25:10:25],y=[-8,0,8])translate([x,y,-1])cylinder(h=5,r=1.8);}}
module strap_guide(){
 // PRINTED GUIDE ONLY. Purchase fabric/webbing carry strap fixed to a metal structural member.
 difference(){rr(90,32,12,12);rr(75,19,14,8);}
}
module clip(){ // simple nonstructural cable tie anchor
 difference(){rr(22,13,5,4);translate([0,0,-1])cube([13,4,7],center=true);}
}
module wheel_proxy(d=96,w=36){
 color([.12,.15,.19])rotate([90,0,0])difference(){cylinder(h=w,r=d/2,center=true);cylinder(h=w+1,r=9,center=true);}
 color([.43,.47,.5])rotate([90,0,0])difference(){cylinder(h=w+2,r=d*.245,center=true);cylinder(h=w+3,r=9,center=true);}
 color([.15,.17,.21])rotate([90,0,0])for(a=[0:45:315])rotate([0,0,a])translate([0,0,0])cube([d*.1,w+2,d*.45],center=true);
}
module motor_proxy(){ color([.29,.31,.33])rotate([90,0,0])cylinder(h=64,r=18.5,center=true);}
module assembly(d=96,ex=0){
 // two printable tub halves mounted at common z and joined with two bridges
 color([.28,.55,.72])translate([-62.5,0,baseZ])chassis_front();
 color([.26,.49,.67])translate([62.5,0,baseZ])chassis_rear();
 color([.24,.32,.38])for(y=[-64,64])translate([0,y,baseZ+5])bridge();
 color([.22,.28,.33])translate([0,0,baseZ+5])battery_cradle();
 color([.59,.67,.73])translate([0,0,baseZ+51+ex*.4])deck();
 color([.90,.92,.92]){
  translate([-62.5,0,baseZ+44+ex])cowl();translate([62.5,0,baseZ+44+ex])cowl();
  translate([0,0,baseZ+91+ex*1.5])spine();
  translate([0,0,baseZ+97+ex*1.8])neck();
  translate([0,0,baseZ+128+ex*2])head_front();
  translate([0,0,baseZ+128+ex*2])head_rear();
  translate([0,0,baseZ+196+ex*2.25])head_cap();
  translate([0,0,baseZ+201+ex*2.5])strap_guide();
 }
 color([.12,.18,.24])translate([0,-49,baseZ+170+ex*2])rotate([90,0,0])face();
 color([.10,.76,1])for(x=[-30,30])translate([x,-53,baseZ+170+ex*2])rotate([90,0,0])eye();
 color([.45,.65,.79])translate([0,-53,baseZ+170+ex*2])rotate([90,0,0])camera_ring();
 for(x=[-92,92],y=[-128,128]){
   translate([x,y,axle_for(d)])wheel_proxy(d,d==69?26:d==96?36:43);
   translate([x,sign(y)*88,axle_for(d)])motor_proxy();
 }
}
if(part=="chassis_front") chassis_front();
else if(part=="chassis_rear")chassis_rear();
else if(part=="splice_bridge")bridge();
else if(part=="motor_interface")motor_interface();
else if(part=="riser_small")riser(9);
else if(part=="riser_medium")riser(21);
else if(part=="riser_large")riser(28);
else if(part=="electronics_deck")deck();
else if(part=="battery_cradle")battery_cradle();
else if(part=="body_cowl")cowl();
else if(part=="center_spine")spine();
else if(part=="neck")neck();
else if(part=="head_front")head_front();
else if(part=="head_rear")head_rear();
else if(part=="head_cap")head_cap();
else if(part=="face")face();
else if(part=="eye_ring")eye();
else if(part=="camera_ring")camera_ring();
else if(part=="speaker_grille")grille();
else if(part=="strap_guide")strap_guide();
else if(part=="cable_clip")clip();
else if(part=="assembly")assembly(wheel_d,0);
else if(part=="exploded")assembly(wheel_d,45);
