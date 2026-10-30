import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";

const $ = id => document.getElementById(id);
const holder = $("viewerCanvas");
const status = $("loadStatus");
const slider = $("explode");
const pct = $("explodeValue");
const scene = new THREE.Scene();
scene.background = new THREE.Color("#0b1622");
scene.fog = new THREE.Fog("#0b1622", 10, 23);
const camera = new THREE.PerspectiveCamera(43, 1, 0.01, 100);
const homeCamera = new THREE.Vector3(-4.3, 3.4, 5.2);
const homeTarget = new THREE.Vector3(0, 1.15, 0);
camera.position.copy(homeCamera);
const renderer = new THREE.WebGLRenderer({antialias: true, powerPreference: "low-power", alpha: false});
renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 1.8));
renderer.outputColorSpace = THREE.SRGBColorSpace;
holder.appendChild(renderer.domElement);
const controls = new OrbitControls(camera, renderer.domElement);
controls.target.copy(homeTarget);
controls.enableDamping = true;
controls.dampingFactor = 0.06;
controls.minDistance = 1.7;
controls.maxDistance = 15;
controls.maxPolarAngle = Math.PI * 0.91;
const hemi = new THREE.HemisphereLight(0xe2f5ff, 0x324254, 3.3);
scene.add(hemi);
const key = new THREE.DirectionalLight(0xffffff, 3.0);
key.position.set(-3, 7, 5);
scene.add(key);
const fill = new THREE.DirectionalLight(0x6ecfff, 1.5);
fill.position.set(4, 3, -4);
scene.add(fill);
const grid = new THREE.GridHelper(15, 30, 0x436879, 0x284153);
grid.position.y = -0.015;
scene.add(grid);
const turntable = new THREE.Group();
scene.add(turntable);

let manifest = null;
let root = null;
let nodes = new Map();
let basePositions = new Map();
let baseMaterials = new Map();
let selected = "";
let explode = 0;
let rotating = false;
let shellSeeThrough = false;

function resize() {
  const w = Math.max(240, holder.clientWidth);
  const h = Math.max(280, holder.clientHeight);
  renderer.setSize(w, h, false);
  camera.aspect = w / h;
  camera.updateProjectionMatrix();
}
new ResizeObserver(resize).observe(holder);
resize();

function updatePresetButtons() {
  $("assemble").setAttribute("aria-pressed", String(explode === 0));
  $("explodeBtn").setAttribute("aria-pressed", String(explode === 1));
}
function setExplosion(value) {
  explode = THREE.MathUtils.clamp(Number(value), 0, 1);
  slider.value = String(Math.round(explode * 100));
  pct.textContent = Math.round(explode * 100) + "%";
  if (manifest) {
    for (const part of manifest.parts) {
      const node = nodes.get(part.id);
      const base = basePositions.get(part.id);
      if (!node || !base) continue;
      const offset = part.explode_offset;
      node.position.set(base.x + offset[0] * explode,
                        base.y + offset[1] * explode,
                        base.z + offset[2] * explode);
    }
  }
  updatePresetButtons();
}
function applyAppearance() {
  for (const [name, node] of nodes) {
    const original = baseMaterials.get(name);
    if (!original) continue;
    const mats = Array.isArray(node.material) ? node.material : [node.material];
    for (let i = 0; i < mats.length; i++) {
      const m = mats[i];
      if (!m) continue;
      const isShell = name.startsWith("shell_") || name.startsWith("head_");
      m.transparent = isShell && shellSeeThrough;
      m.opacity = isShell && shellSeeThrough ? 0.24 : 1;
      m.depthWrite = !(isShell && shellSeeThrough);
      m.emissive?.set(name === selected ? 0x54bda9 : 0x000000);
      if (m.emissiveIntensity !== undefined) m.emissiveIntensity = name === selected ? 0.55 : 0;
      m.needsUpdate = true;
    }
  }
}
function focusPart(id) {
  selected = id;
  document.querySelectorAll(".partbtn").forEach(button =>
    button.setAttribute("aria-pressed", String(button.dataset.part === id)));
  applyAppearance();
  const part = nodes.get(id);
  if (part) {
    part.updateWorldMatrix(true, false);
    const world = new THREE.Vector3();
    part.getWorldPosition(world);
    controls.target.lerp(world, 0.85);
    controls.update();
  }
}
function listParts() {
  const list = $("partList");
  list.replaceChildren();
  manifest.parts.forEach(part => {
    const button = document.createElement("button");
    button.className = "partbtn";
    button.type = "button";
    button.textContent = part.name + " · " + part.id.replaceAll("_", " ");
    button.dataset.part = part.id;
    button.setAttribute("aria-pressed", "false");
    button.addEventListener("click", () => focusPart(part.id));
    list.appendChild(button);
  });
  $("partCount").textContent = "(" + manifest.parts.length + " placed components)";
}
function resetView() {
  turntable.rotation.y = 0;
  camera.position.copy(homeCamera);
  controls.target.copy(homeTarget);
  controls.update();
}
$("assemble").addEventListener("click", () => setExplosion(0));
$("explodeBtn").addEventListener("click", () => setExplosion(1));
slider.addEventListener("input", () => setExplosion(Number(slider.value) / 100));
$("autorotate").addEventListener("change", e => {rotating = e.target.checked;});
$("xray").addEventListener("change", e => {shellSeeThrough = e.target.checked; applyAppearance();});
$("resetCamera").addEventListener("click", resetView);
$("clearSelection").addEventListener("click", () => {
  selected = "";
  document.querySelectorAll(".partbtn").forEach(b => b.setAttribute("aria-pressed", "false"));
  applyAppearance();
  resetView();
});
let last = performance.now();
function animate(t) {
  requestAnimationFrame(animate);
  const dt = Math.min((t - last) / 1000, 0.07);
  last = t;
  if (rotating && !window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    turntable.rotation.y += dt * 0.25;
  }
  controls.update();
  renderer.render(scene, camera);
}
requestAnimationFrame(animate);

async function load() {
  try {
    const response = await fetch("models/parts.json", {cache:"no-cache"});
    if (!response.ok) throw new Error("Parts manifest returned HTTP " + response.status);
    manifest = await response.json();
    const gltf = await new GLTFLoader().loadAsync("models/robot_revG.glb");
    root = gltf.scene;
    root.rotation.x = -Math.PI / 2; // OpenSCAD Z-up to Three.js Y-up
    root.scale.setScalar(0.01); // CAD millimeters to viewer coordinates
    turntable.add(root);
    root.traverse(obj => {
      if (!obj.isMesh) return;
      if (!manifest.parts.some(p => p.id === obj.name)) return;
      nodes.set(obj.name, obj);
      basePositions.set(obj.name, obj.position.clone());
      obj.material = Array.isArray(obj.material)
        ? obj.material.map(m => m.clone()) : obj.material.clone();
      baseMaterials.set(obj.name, obj.material);
      obj.castShadow = false;
    });
    if (nodes.size !== manifest.parts.length) {
      console.warn("GLB part-name mismatch", nodes.size, manifest.parts.length);
      throw new Error("CAD part mapping incomplete (" + nodes.size + "/" + manifest.parts.length + ")");
    }
    listParts();
    shellSeeThrough = $("xray").checked;
    setExplosion(new URLSearchParams(location.search).get("mode") === "exploded" ? 1 : 0);
    applyAppearance();
    status.textContent = manifest.parts.length + " CAD pieces loaded · Rev G conceptual geometry";
  } catch (error) {
    status.textContent = "Unable to load 3D model: " + error.message +
      ". Check the published build or download the CAD source.";
    $("partList").textContent = "Model files are not available here yet.";
    console.error(error);
  }
}
load();
