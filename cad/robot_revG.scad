// LilRobbsGirlfriend REV G — two driven rear wheels, two passive front omni wheels.
// Concept CAD only (millimeters). Purchased wheels/motors/electronics are dimensional proxies.
// NOT a verified motor mount, safe autonomous platform, final wiring plan, or fitted enclosure.
// Battery allowance uses published Bioenno BLF-12045W 76x57x71mm (verify exact delivered pack).
// Visual forward is toward -X. Positive Z is up. Wheel rotation axes run along Y.
// Assembly: part="assembly"; individual printable modules selected through part.
part="assembly"; explode=0; show_electronics=false; $fn=28;
bodyL=244; bodyW=174; shellSplit=1; tireD=85; omniD=100;
rearX=49; frontX=-79; wheelY=114;
rearZ=52.5; frontZ=60;  // both nominally leave 10 mm ground clearance

module rr2d(x,y,r=12){hull() for(a=[-1,1],b=[-1,1]) translate([a*(x/2-r),b*(y/2-r)]) circle(r=r);}
module plate(x,y,h,r=9){linear_extrude(h) rr2d(x,y,r);}
module rounded_shell_shape(inner=false){
 // Rounded body tapers toward the top, with a broad shoulder that reads as a companion robot.
 r=inner?15:18; inset=inner?3:0;
 hull() for(z=[47,107], a=[-1,1],b=[-1,1])
 translate([(z==47?0:5) + a*((z==47?239:211)/2-r-inset), b*((z==47?172:148)/2-r-inset),z]) sphere(r=r,$fn=20);
}
module enclosure_outline(){rounded_shell_shape(false);}
module enclosure_cavity(){rounded_shell_shape(true);}
module body_section(front=true){intersection(){difference(){enclosure_outline();enclosure_cavity();translate([-130,-100,-5])cube([260,200,44]);
 // small passive cooling vents on both sides, not a finished thermal solution
 for(x=[32,49,66],z=[77,90])translate([x,0,z])rotate([90,0,0])cylinder(h=210,r=3,center=true,$fn=16);
}
 if(front)translate([-125,-110,25])cube([124,220,124]);
 else translate([1,-110,25])cube([125,220,124]);}}
module split_tub(){difference(){
 union(){difference(){translate([0,0,12])plate(238,170,35,18);translate([0,0,20])plate(230,162,36,15);}
 // Joined floor lip along center seam for removable M4 splice plates
 for(y=[-65,65]) translate([0,y,13])plate(67,26,3,5);
 }
 for(y=[-65,65],x=[-25,25]) translate([x,y,10])cylinder(h=13,r=2.2);
 // Wiring channels and service pass-throughs
 translate([-24,-12,10])cube([22,24,13]);
 }}
module tub_front(){intersection(){split_tub();translate([-125,-110,0])cube([124,220,75]);}}
module tub_rear(){intersection(){split_tub();translate([1,-110,0])cube([125,220,75]);}}
module splice_plate(){difference(){plate(75,26,4,5);for(x=[-25,25])translate([x,0,-1])cylinder(h=7,r=2.2);}}
module motor_test_mount(){ // FIT CHECK ONLY; purchased metal load-bearing bracket required
 difference(){plate(59,58,5,8);
 for(x=[-18,18],y=[-14,14])translate([x,y,-1])hull(){translate([0,-5,0])cylinder(h=8,r=2.1);translate([0,5,0])cylinder(h=8,r=2.1);}
 }}
module omni_test_mount(){ // bracket shell only; wheel hub/axle/bearings NOT designed
 difference(){union(){plate(40,40,7,6);for(y=[-13,13])translate([0,y,6])plate(13,12,34,4);}
 for(x=[-12,12])translate([x,0,-1])cylinder(h=10,r=2.2);
 }}
module electronics_shelf(){difference(){plate(100,77,4,9);
 // Pi 5 58 x 49 mm mounting holes pattern; temporary 2.8mm pilot bores
 for(x=[-29,29],y=[-24.5,24.5])translate([x,y,-1])cylinder(h=7,r=1.4);
 // ties for ESP32 / motor-driver / cable routes
 for(x=[-42,0,42])translate([x,-3,-1])cube([5,7,7]);
 for(x=[-44,44],y=[-33,33])translate([x,y,-1])cylinder(h=7,r=1.75);}}
module battery_tray(){ // allowance cavity 84x65; pack is 76x57 footprint, needs retention strap
 difference(){plate(103,80,21,10);translate([0,0,4])plate(85,66,20,7);
 for(x=[-45,45])translate([x,0,7])cube([9,85,10],center=true);
 for(y=[-36,36])translate([0,y,-1])cylinder(h=24,r=1.75);
 }}
module neck_shell(){difference(){cylinder(h=25,r1=27,r2=22);translate([0,0,-1])cylinder(h=28,r=17);}}
module rounded_head(inner=false){
 r=inner?15:18; inset=inner?3:0;
 hull() for(z=[18,52],a=[-1,1],b=[-1,1])
 translate([a*(43-r-inset),b*(55-r-inset),z]) sphere(r=r,$fn=20);
}
module head_outer(){rounded_head(false);}
module head_hollow(){rounded_head(true);}
module head_shell(front=true){intersection(){difference(){head_outer();head_hollow();
 translate([-43,0,35])rotate([0,90,0])cylinder(h=24,r=8,center=true);
}
  if(front)translate([-60,-70,-2])cube([59,140,90]);
  else translate([1,-70,-2])cube([65,140,90]);}}
// Visor is a solid fascia plate. Light rings are decorative, no purchased light hardware assumed.
module visor(){difference(){hull()for(y=[-37,37],z=[-18,18])translate([0,y,z])sphere(r=9,$fn=20);
 rotate([0,90,0])cylinder(h=24,r=7.5,center=true);}}
module annulus(ro,ri,thick=2.3){difference(){cylinder(h=thick,r=ro,center=true);cylinder(h=thick+1,r=ri,center=true);}}
module eye_ring(){rotate([0,90,0])annulus(12,8.4,2.4);}
module lens_ring(){rotate([0,90,0])annulus(10,7.2,2.5);}
module camera_proxy(){color([.08,.13,.18])rotate([0,90,0])cylinder(h=6,r=6.6,center=true);}
module grille(){difference(){plate(50,17,3,7);for(x=[-18:9:18])translate([x,0,-1])cylinder(h=6,r=2.4);}}
module cliff_sensor_fit_pod(){ // fitting placeholder, NOT a tested sensor
 difference(){plate(33,26,5,5);for(x=[-10,10])translate([x,0,-1])cylinder(h=8,r=2.1);}
}
module estop_guard(){ // printed ring only; real switch must independently isolate motor supply
 difference(){cylinder(h=7,r=15);translate([0,0,-1])cylinder(h=9,r=11);}
}
// Purchased component proxies: not manufacturing geometry.
module drive_wheel(){rotate([90,0,0]){color([.11,.14,.19])difference(){cylinder(h=27,r=tireD/2,center=true);cylinder(h=29,r=13,center=true);}color([.3,.37,.41])difference(){cylinder(h=29,r=25,center=true);cylinder(h=31,r=5,center=true);}for(a=[0:60:300])color([.65,.72,.75])rotate([0,0,a])translate([16,0,0])cube([13,4,30],center=true);}}
module omni_wheel(){rotate([90,0,0]){
 color([.16,.20,.24])difference(){cylinder(h=16,r=omniD/2-8,center=true);cylinder(h=18,r=15,center=true);}
 for(a=[0:30:330])rotate([0,0,a])translate([omniD/2-6,0,0])color([.17,.20,.23])rotate([90,0,0])cylinder(h=17,r=7,center=true,$fn=12);
 color([.45,.53,.57])difference(){cylinder(h=18,r=17,center=true);cylinder(h=20,r=5,center=true);}
 }}
module motor_proxy(){rotate([90,0,0]){color([.33,.37,.40])cylinder(h=53,r=18.5,center=true);color([.24,.27,.29])translate([0,0,32])cylinder(h=11,r=14,center=true);}}
module battery_proxy(){color([.13,.2,.27])translate([0,0,35.5])cube([76,57,71],center=true);}
module pi_proxy(){color([.11,.44,.27])cube([85,56,2],center=true);}
module visual_assembly(ex=0){
 // chassis and split shell moved apart for exploded view only
 color([.22,.46,.64])translate([0,0,ex*.08]){tub_front();tub_rear();}
 color([.33,.41,.47])for(y=[-65,65])translate([0,y,20+ex*.12])splice_plate();
 // Battery low and centered near the driven axle; tray is open for straps.
 color([.25,.34,.4])translate([28,0,21+ex*.18])battery_tray();
 if(show_electronics){translate([28,0,25+ex*.2])battery_proxy();translate([-49,0,90+ex*.45])pi_proxy();}
 color([.45,.55,.61])translate([-49,0,82+ex*.30])electronics_shelf();
 // motor fit-check pads; purchased brackets must be separately mounted to metal reinforcements.
 color([.17,.31,.4])for(side=[-1,1])translate([rearX,side*89,47+ex*.24])rotate([90,0,0])motor_test_mount();
 color([.27,.48,.62])for(side=[-1,1])translate([frontX,side*89,37+ex*.24])omni_test_mount();
 color([.25,.36,.4])for(side=[-1,1])translate([-96,side*42,11+ex*.08])cliff_sensor_fit_pod();
 color([.86,.90,.92]){
 translate([0,0,ex*.5])body_section(true);translate([0,0,ex*.5])body_section(false);
 translate([-49,0,124+ex*.86])neck_shell();
 translate([-48,0,153+ex*1.15])head_shell(true);
 translate([-48,0,153+ex*1.15])head_shell(false);
 }
 color([.15,.2,.25])translate([73,0,123+ex*.5])estop_guard();
 color([.12,.19,.26])translate([-94,0,187+ex*1.16])visor();
 color([.1,.78,1])for(y=[-32,32])translate([-103,y,188+ex*1.16])eye_ring();
 color([.58,.78,.87])translate([-103,0,188+ex*1.16])lens_ring();
 translate([-104,0,188+ex*1.16])camera_proxy();
 // Rear-wheel motor housings; axle orientation along Y
 for(side=[-1,1]){
 translate([rearX,side*wheelY,rearZ])drive_wheel();
 translate([rearX,side*87,rearZ])motor_proxy();
 translate([frontX,side*wheelY,frontZ])omni_wheel();
 }
 // Rear service badge and forward speaker grille: cosmetic only
 color([.13,.25,.31])translate([-110,0,59+ex*.5])rotate([0,90,0])grille();
}
if(part=="assembly")visual_assembly(0);
else if(part=="exploded")visual_assembly(explode>0?explode:42);
else if(part=="chassis_front")tub_front();
else if(part=="chassis_rear")tub_rear();
else if(part=="shell_front")body_section(true);
else if(part=="shell_rear")body_section(false);
else if(part=="head_front")head_shell(true);
else if(part=="head_rear")head_shell(false);
else if(part=="head_visor")visor();
else if(part=="eye_ring")eye_ring();
else if(part=="camera_ring")lens_ring();
else if(part=="neck")neck_shell();
else if(part=="electronics_shelf")electronics_shelf();
else if(part=="battery_tray")battery_tray();
else if(part=="motor_fit_check")motor_test_mount();
else if(part=="omni_fit_check")omni_test_mount();
else if(part=="splice_plate")splice_plate();
else if(part=="speaker_grille")grille();
else if(part=="cliff_sensor_fit_pod")cliff_sensor_fit_pod();
else if(part=="estop_guard")estop_guard();
else if(part=="drive_wheel_proxy")drive_wheel();
else if(part=="omni_wheel_proxy")omni_wheel();
else if(part=="motor_proxy")motor_proxy();

else if(part=="battery_proxy")battery_proxy();
else if(part=="pi_proxy")pi_proxy();
else if(part=="camera_proxy")camera_proxy();
