// LilRobbsGirlfriend Rev A printable prototype (mm)
part="front"; // front, rear, lid, head_front, head_back
$fn=32;
module roundrect(x,y,h,r=10){hull()for(i=[-1,1],j=[-1,1])translate([i*(x/2-r),j*(y/2-r),0])cylinder(h=h,r=r);}
module tub(){difference(){roundrect(150,228,30,13);translate([0,0,3])roundrect(144,222,31,10);}for(y=[-70,70])translate([0,y,0])difference(){cube([24,20,4],center=true);cylinder(h=8,r=2,center=true);}}
module lid(){difference(){roundrect(146,218,3,12);for(x=[-52,52],y=[-84,84])translate([x,y,-1])cylinder(h=6,r=2.2);}}
module head_half(front=true){difference(){roundrect(108,94,74,16);translate([0,0,3])roundrect(102,88,74,13);if(front)translate([0,-48,47])rotate([90,0,0])cylinder(h=14,r=11,center=true);}}
if(part=="front"||part=="rear")tub();else if(part=="lid")lid();else if(part=="head_front")intersection(){head_half(true);translate([-55,-48,-1])cube([110,48,78]);}else if(part=="head_back")intersection(){head_half(false);translate([-55,0,-1])cube([110,48,78]);}
