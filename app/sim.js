const out=document.querySelector("#status");
let mode="standby", target=null, motion="stopped", camera="center";
const render=()=>out.textContent=JSON.stringify({mode,target,motion,camera,connection:"simulator only"},null,2);
const stop=()=>{mode="stopped";motion="stopped";target=null;render()};
document.querySelector("#stop").onclick=stop;
document.querySelectorAll("[data-action]").forEach(b=>b.onclick=()=>{
 const a=b.dataset.action;mode=a;motion="stopped";
 target=["follow","watch"].includes(a)?document.querySelector("#target").value:null;
 const d=Number(document.querySelector("#distance").value);
 if(["follow","watch"].includes(a)&&!(d>=.5&&d<=5)){stop();out.textContent="Invalid distance. Stopped.";return}
 render();
});
document.querySelectorAll("[data-drive]").forEach(b=>{
 const down=e=>{e.preventDefault();mode="manual";target=null;motion=b.dataset.drive;render()};
 const up=e=>{e.preventDefault();motion="stopped";render()};
 b.addEventListener("pointerdown",down);
 ["pointerup","pointercancel","lostpointercapture","pointerleave"].forEach(event=>b.addEventListener(event,up));
});
window.addEventListener("blur",()=>{motion="stopped";render()});
document.querySelectorAll("[data-camera]").forEach(b=>b.onclick=()=>{camera=b.dataset.camera;render()});
render();