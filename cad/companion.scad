// LilRobbsGirlfriend - printable PLA form-factor prototype, millimeters
// Preview: part="assembly"; export STL: part="front" / "rear" / "head" / "lid"
part="assembly";
$fn=48;
length=304; width=232; wall=3; tray_height=28;
module rounded_box(x,y,z,r=10){hull(){for(a=[-1,1],b=[-1,1])translate([a*(x/2-r),b*(y/2-r),0])cylinder(h=z,r=r);}}
module tray(xlen){difference(){rounded_box(xlen,width,tray_height,14);translate([0,0,wall])rounded_box(xlen-2*wall,width-2*wall,tray_height,11);}}
module front(){translate([-length/4,0,0])tray(length/2);}
module rear(){translate([length/4,0,0])tray(length/2);}
module head(){difference(){rounded_box(108,96,76,18);translate([0,0,wall])rounded_box(102,90,76,16);translate([0,-49,44])rotate([90,0,0])cylinder(h=12,r=12,center=true);}}
module lid(){difference(){rounded_box(150,190,3,16);for(x=[-50,50],y=[-65,65])translate([x,y,-1])cylinder(h=5,r=2.4);}}
module wheel(x,y){translate([x,y,40])rotate([90,0,0])color("black")difference(){cylinder(h=25,r=49,center=true);cylinder(h=27,r=13,center=true);}}
if(part=="front")front();
else if(part=="rear")rear();
else if(part=="head")head();
else if(part=="lid")lid();
else if(part=="assembly"){
color("orange")front();color("orange")rear();
for(x=[-106,106],y=[-126,126])wheel(x,y);
translate([0,0,38])color("lightgray")lid();
translate([0,0,70])color("steelblue")head();
}
