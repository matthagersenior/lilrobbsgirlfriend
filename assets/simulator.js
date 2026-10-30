"use strict";
(() => {
  const $ = id => document.getElementById(id);
  const canvas = $("simCanvas"), ctx = canvas.getContext("2d");
  if (!ctx) { $("simStatus").textContent = "Canvas unavailable in this browser."; return; }
  const W = canvas.width, H = canvas.height;
  const bounds = {left:28, right:W-28, top:28, bottom:H-28};
  const rectangles = [
    {x:245,y:68,w:30,h:196,label:"Partition"},
    {x:545,y:235,w:160,h:26,label:"Couch"},
    {x:332,y:305,w:112,h:82,label:"Table"},
    {x:530,y:60,w:30,h:132,label:"Partition"},
  ];
  const circles = [
    {x:181,y:191,r:30,label:"Chair"},
    {x:630,y:409,r:32,label:"Plant"},
  ];
  const danger = {x:697,y:55,w:67,h:100,label:"Drop zone"};
  const R = 19;
  const keys = new Set(), touch = new Set();
  const rover = {x:120,y:390,a:-Math.PI/2,v:0,w:0,battery:100};
  let mode = "manual", estopped = false, goal = null, status = "";
  let maxSpeed = 0.5, showSensors = true, last = performance.now(), lastUI = 0;
  const clamp = (v,a,b) => Math.max(a,Math.min(b,v));
  const signedAngle = x => Math.atan2(Math.sin(x),Math.cos(x));
  const circleRect = (x,y,r,rect) => {
    const px=clamp(x,rect.x,rect.x+rect.w),py=clamp(y,rect.y,rect.y+rect.h);
    return (x-px)**2+(y-py)**2 < r*r;
  };
  function hit(x,y,r=R) {
    if (x-r < bounds.left || y-r < bounds.top ||
        x+r > bounds.right || y+r > bounds.bottom) return true;
    if (rectangles.some(ob => circleRect(x,y,r,ob))) return true;
    if (circleRect(x,y,r,danger)) return true;
    return circles.some(ob => Math.hypot(x-ob.x,y-ob.y) < ob.r+r);
  }
  function raycast(angle,maxDist=138) {
    for (let d=R+4;d<maxDist;d+=4) {
      if (hit(rover.x+Math.cos(angle)*d,rover.y+Math.sin(angle)*d,2)) return d;
    }
    return maxDist;
  }
  function readInput(dir) { return keys.has(dir) || touch.has(dir); }
  function moveDrive() {
    const throttle=Number(readInput("forward"))-Number(readInput("reverse"));
    const steer=Number(readInput("right"))-Number(readInput("left"));
    return {throttle,steer};
  }
  function setStatus(next) {
    if (status === next) return;
    status = next; $("simStatus").textContent = next;
  }
  function selectMode(value) {
    mode = value;
    goal = null;
    rover.v = 0; rover.w = 0;
    $("manual").setAttribute("aria-pressed",String(mode==="manual"));
    $("waypoint").setAttribute("aria-pressed",String(mode==="waypoint"));
    $("manual").classList.toggle("primary",mode==="manual");
    $("waypoint").classList.toggle("primary",mode==="waypoint");
    $("modeLabel").textContent = (mode==="manual"?"MANUAL":"WAYPOINT") + " · VIRTUAL ONLY";
    setStatus(estopped?"Virtual E-stop latched":mode==="manual"?"Ready · Manual drive":"Waypoint mode · Tap open floor");
  }
  function reset() {
    Object.assign(rover,{x:120,y:390,a:-Math.PI/2,v:0,w:0,battery:100});
    goal=null;estopped=false;touch.clear();keys.clear();
    $("estop").setAttribute("aria-pressed","false");
    document.querySelectorAll("[data-drive]").forEach(b=>b.classList.remove("holding"));
    selectMode("manual");
  }
  function latchStop() {
    estopped = true; rover.v = 0; rover.w = 0; goal=null;
    touch.clear();keys.clear();
    document.querySelectorAll("[data-drive]").forEach(b=>b.classList.remove("holding"));
    $("estop").setAttribute("aria-pressed","true");
    setStatus("Virtual E-stop latched · Reset to resume");
  }
  $("manual").addEventListener("click",()=>selectMode("manual"));
  $("waypoint").addEventListener("click",()=>selectMode("waypoint"));
  $("reset").addEventListener("click",reset);
  $("estop").addEventListener("click",latchStop);
  $("speed").addEventListener("input",e=>{
    maxSpeed=Number(e.target.value)/100;
    $("speedValue").textContent=e.target.value+"%";
  });
  $("sensors").addEventListener("change",e=>showSensors=e.target.checked);
  const keyMapping = {
    ArrowUp:"forward",w:"forward",W:"forward",
    ArrowDown:"reverse",s:"reverse",S:"reverse",
    ArrowLeft:"left",a:"left",A:"left",
    ArrowRight:"right",d:"right",D:"right",
  };
  document.addEventListener("keydown",event=>{
    if (event.target instanceof HTMLInputElement || event.target instanceof HTMLButtonElement) return;
    if (event.key===" "){event.preventDefault();latchStop();return;}
    const dir=keyMapping[event.key];if(dir){event.preventDefault();keys.add(dir);if(mode==="waypoint") selectMode("manual");}
  });
  document.addEventListener("keyup",event=>{
    const dir=keyMapping[event.key];if(dir){event.preventDefault();keys.delete(dir);}
  });
  function releaseControls(){keys.clear();touch.clear();document.querySelectorAll("[data-drive]").forEach(b=>b.classList.remove("holding"));}
  window.addEventListener("blur",releaseControls);
  document.addEventListener("visibilitychange",()=>{if(document.hidden)releaseControls();});
  document.querySelectorAll("[data-drive]").forEach(button=>{
    const dir=button.dataset.drive;
    button.addEventListener("pointerdown",e=>{
      if(estopped)return;
      e.preventDefault();
      button.setPointerCapture(e.pointerId);
      if(mode==="waypoint")selectMode("manual");
      touch.add(dir);button.classList.add("holding");
    });
    const end=e=>{
      touch.delete(dir);button.classList.remove("holding");
      if(button.hasPointerCapture(e.pointerId))button.releasePointerCapture(e.pointerId);
    };
    button.addEventListener("pointerup",end);
    button.addEventListener("pointercancel",end);
    button.addEventListener("lostpointercapture",()=>{touch.delete(dir);button.classList.remove("holding");});
  });
  canvas.addEventListener("pointerdown",e=>{
    if(mode!=="waypoint" || estopped)return;
    const rect=canvas.getBoundingClientRect();
    const x=(e.clientX-rect.left)*W/rect.width,y=(e.clientY-rect.top)*H/rect.height;
    if(hit(x,y,R)){setStatus("Choose an open spot away from obstacles");return;}
    goal={x,y};setStatus("Navigating to virtual waypoint");
    canvas.focus();
  });

  function step(dt) {
    let targetV=0,targetW=0;
    if(!estopped && rover.battery>0) {
      if(mode==="manual"){
        const {throttle,steer}=moveDrive();
        // Differential-drive inspired motion. In-place turns are allowed.
        targetV=throttle*maxSpeed*115;
        targetW=steer*1.8*(.6+.4*maxSpeed);
      }else if(goal){
        const dist=Math.hypot(goal.x-rover.x,goal.y-rover.y);
        const aim=Math.atan2(goal.y-rover.y,goal.x-rover.x);
        const error=signedAngle(aim-rover.a);
        if(dist<13){goal=null;setStatus("Virtual waypoint reached");}
        else{
          targetW=clamp(error*2,-1.45,1.45);
          targetV=dist>13 && Math.abs(error)<0.75 ? maxSpeed*90*clamp(dist/55,.24,1) : 0;
        }
      }
    }
    rover.v+=(targetV-rover.v)*Math.min(1,dt*5);
    rover.w+=(targetW-rover.w)*Math.min(1,dt*7);
    if(estopped || rover.battery<=0){rover.v=0;rover.w=0;}
    rover.a=signedAngle(rover.a+rover.w*dt);
    const nx=rover.x+Math.cos(rover.a)*rover.v*dt;
    const ny=rover.y+Math.sin(rover.a)*rover.v*dt;
    const headingRange=raycast(rover.a);
    const blocked=hit(nx,ny);
    if(!blocked && (! (rover.v>0 && headingRange<R+7))) {
      rover.x=nx;rover.y=ny;
      if(Math.abs(rover.v)>1 || Math.abs(rover.w)>.1){
        rover.battery=Math.max(0,rover.battery-dt*(.002+Math.abs(rover.v)*.0005+Math.abs(rover.w)*.008));
        if(mode==="manual")setStatus("Driving · Virtual simulation");
      }else if(mode==="manual")setStatus("Ready · Manual drive");
    }else{
      rover.v=0;
      if(mode==="waypoint" && goal){goal=null;setStatus("Virtual obstacle encountered · Waypoint cancelled");}
      else if(!estopped)setStatus("Blocked by virtual obstacle or boundary");
    }
  }
  const colors={floor:"#14283a",wall:"#738497",hazard:"#a14553",mint:"#7ee7d0"};
  function fillRound(x,y,w,h,r,color){
    ctx.fillStyle=color;ctx.beginPath();ctx.roundRect(x,y,w,h,r);ctx.fill();
  }
  function render() {
    ctx.fillStyle=colors.floor;ctx.fillRect(0,0,W,H);
    ctx.strokeStyle="#24445c";ctx.lineWidth=1;
    for(let x=0;x<W;x+=40){ctx.beginPath();ctx.moveTo(x,0);ctx.lineTo(x,H);ctx.stroke();}
    for(let y=0;y<H;y+=40){ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(W,y);ctx.stroke();}
    ctx.lineWidth=8;ctx.strokeStyle=colors.wall;
    ctx.strokeRect(bounds.left,bounds.top,bounds.right-bounds.left,bounds.bottom-bounds.top);
    ctx.font="bold 17px system-ui";ctx.fillStyle="#94b8c9";
    ctx.fillText("LIVING AREA",65,69);ctx.fillText("KITCHEN",585,307);
    rectangles.forEach(ob=>{fillRound(ob.x,ob.y,ob.w,ob.h,8,"#4e687e");ctx.fillStyle="#daebf2";ctx.font="12px system-ui";if(ob.w>70)ctx.fillText(ob.label,ob.x+9,ob.y+ob.h/2);});
    circles.forEach(ob=>{
      ctx.beginPath();ctx.arc(ob.x,ob.y,ob.r,0,2*Math.PI);ctx.fillStyle="#667d81";ctx.fill();
      ctx.strokeStyle="#a8c0c1";ctx.lineWidth=2;ctx.stroke();
    });
    fillRound(danger.x,danger.y,danger.w,danger.h,5,"#8c333f");
    ctx.fillStyle="#ffdadb";ctx.font="bold 12px system-ui";ctx.textAlign="center";
    ctx.fillText("EDGE",danger.x+danger.w/2,danger.y+danger.h/2);ctx.textAlign="left";
    if(goal){
      ctx.strokeStyle="#ffe098";ctx.lineWidth=2;ctx.setLineDash([7,6]);
      ctx.beginPath();ctx.moveTo(rover.x,rover.y);ctx.lineTo(goal.x,goal.y);ctx.stroke();ctx.setLineDash([]);
      ctx.beginPath();ctx.arc(goal.x,goal.y,10,0,2*Math.PI);ctx.stroke();
      ctx.beginPath();ctx.moveTo(goal.x-14,goal.y);ctx.lineTo(goal.x+14,goal.y);ctx.moveTo(goal.x,goal.y-14);ctx.lineTo(goal.x,goal.y+14);ctx.stroke();
    }
    if(showSensors){
      for(let i=-3;i<=3;i++){
        const angle=rover.a+i*Math.PI/12;
        const dist=raycast(angle,145),blocked=dist<145;
        ctx.strokeStyle=blocked?"#f4b37e66":"#7ee7d044";ctx.lineWidth=2;
        ctx.beginPath();ctx.moveTo(rover.x+Math.cos(angle)*16,rover.y+Math.sin(angle)*16);
        ctx.lineTo(rover.x+Math.cos(angle)*dist,rover.y+Math.sin(angle)*dist);ctx.stroke();
        if(blocked){ctx.beginPath();ctx.arc(rover.x+Math.cos(angle)*dist,rover.y+Math.sin(angle)*dist,3,0,2*Math.PI);ctx.fillStyle="#ffc38f";ctx.fill();}
      }
    }
    ctx.save();ctx.translate(rover.x,rover.y);ctx.rotate(rover.a);
    // Nose points forward along local +X.
    fillRound(-17,-24,34,10,4,"#253545");fillRound(-17,14,34,10,4,"#253545");
    fillRound(-18,-18,37,36,12,"#eaf3f7");
    fillRound(1,-15,16,30,8,"#64b4d2");
    fillRound(-7,-11,19,22,7,"#17374e");
    ctx.fillStyle="#9bf3e0";ctx.beginPath();ctx.arc(6,-6,3,0,2*Math.PI);ctx.arc(6,6,3,0,2*Math.PI);ctx.fill();
    ctx.strokeStyle="#ffe2ad";ctx.lineWidth=3;ctx.beginPath();ctx.moveTo(8,0);ctx.lineTo(26,0);ctx.stroke();
    ctx.restore();
    if(estopped){fillRound(292,14,214,36,8,"#ac3644");ctx.fillStyle="white";ctx.font="bold 16px system-ui";ctx.fillText("VIRTUAL E-STOP",323,38);}
  }
  function updateMetrics(){
    $("actualSpeed").textContent=(Math.abs(rover.v)/100).toFixed(2);
    $("heading").textContent=((rover.a*180/Math.PI+360)%360).toFixed(0)+"°";
    $("battery").textContent=Math.ceil(rover.battery)+"%";
    const measured=raycast(rover.a);
    $("range").textContent=measured>=138?"140+":Math.round(measured)+"";
  }
  function loop(now){
    const dt=clamp((now-last)/1000,0,.05);last=now;
    step(dt);render();
    if(now-lastUI>180){updateMetrics();lastUI=now;}
    requestAnimationFrame(loop);
  }
  reset();requestAnimationFrame(loop);
})();
