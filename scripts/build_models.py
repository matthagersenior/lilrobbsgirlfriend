#!/usr/bin/env python3
"""Build actual Revision G CAD-derived glTF scenes and a printable-part archive.

All meshes come from OpenSCAD STL exports of cad/robot_revG.scad.
Placement and exploded offsets follow Revision G visual_assembly() with
additional visual-only separation. This is NOT a fit/safety validation.
"""
from __future__ import annotations
import argparse
import json
import math
import pathlib
import subprocess
import tempfile
import zipfile

import numpy as np
import trimesh

ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE = ROOT / "cad" / "robot_revG.scad"

# part name, display name, color RGBA
PARTS = {
    "chassis_front": ("Front chassis tray", [52, 121, 165, 255]),
    "chassis_rear": ("Rear chassis tray", [49, 111, 154, 255]),
    "shell_front": ("Front body shell", [223, 235, 246, 255]),
    "shell_rear": ("Rear body shell", [214, 230, 242, 255]),
    "head_front": ("Front head shell", [245, 246, 242, 255]),
    "head_rear": ("Rear head shell", [223, 236, 245, 255]),
    "head_visor": ("Face visor", [29, 50, 70, 255]),
    "eye_ring": ("Eye trim ring", [64, 216, 241, 255]),
    "camera_ring": ("Camera trim ring", [133, 199, 214, 255]),
    "camera_proxy": ("Camera dimensional proxy", [48, 68, 82, 255]),
    "neck": ("Neck assembly", [219, 234, 241, 255]),
    "electronics_shelf": ("Electronics shelf", [121, 147, 164, 255]),
    "battery_tray": ("Battery tray", [94, 118, 129, 255]),
    "motor_fit_check": ("Motor mount fit check", [56, 98, 121, 255]),
    "omni_fit_check": ("Omni mount fit check", [70, 131, 161, 255]),
    "splice_plate": ("Chassis splice plate", [112, 136, 151, 255]),
    "cliff_sensor_fit_pod": ("Cliff sensor fit check", [66, 107, 125, 255]),
    "estop_guard": ("Emergency stop trim guard", [45, 64, 81, 255]),
    "drive_wheel_proxy": ("Rear driven wheel proxy", [59, 72, 87, 255]),
    "omni_wheel_proxy": ("Front omni-wheel proxy", [86, 103, 117, 255]),
    "motor_proxy": ("Motor dimensional proxy", [112, 125, 136, 255]),
    "battery_proxy": ("Battery dimensional proxy", [44, 74, 87, 255]),
    "pi_proxy": ("Pi board dimensional proxy", [41, 145, 96, 255]),
    "speaker_grille": ("Speaker grille", [43, 82, 98, 255]),
}

# ID, CAD part, XYZ position (mm), Euler XYZ degrees, exploded displacement (mm)
NODES = [
    ("chassis_front", "chassis_front", [0, 0, 0], [0, 0, 0], [-37, 0, -80]),
    ("chassis_rear", "chassis_rear", [0, 0, 0], [0, 0, 0], [40, 0, -80]),
    ("shell_front", "shell_front", [0, 0, 0], [0, 0, 0], [-54, 0, 92]),
    ("shell_rear", "shell_rear", [0, 0, 0], [0, 0, 0], [62, 0, 92]),
    ("head_front", "head_front", [-48, 0, 153], [0, 0, 0], [-58, 0, 165]),
    ("head_rear", "head_rear", [-48, 0, 153], [0, 0, 0], [57, 0, 165]),
    ("head_visor", "head_visor", [-94, 0, 187], [0, 0, 0], [-112, 0, 166]),
    ("eye_left", "eye_ring", [-103, -32, 188], [0, 0, 0], [-126, -40, 180]),
    ("eye_right", "eye_ring", [-103, 32, 188], [0, 0, 0], [-126, 40, 180]),
    ("camera_ring", "camera_ring", [-103, 0, 188], [0, 0, 0], [-144, 0, 200]),
    ("camera_proxy", "camera_proxy", [-104, 0, 188], [0, 0, 0], [-170, 0, 220]),
    ("neck", "neck", [-49, 0, 124], [0, 0, 0], [0, 0, 95]),
    ("electronics_shelf", "electronics_shelf", [-49, 0, 82], [0, 0, 0], [-35, 0, 50]),
    ("battery_tray", "battery_tray", [28, 0, 21], [0, 0, 0], [25, 0, 55]),
    ("battery_proxy", "battery_proxy", [28, 0, 25], [0, 0, 0], [42, 0, 95]),
    ("pi_proxy", "pi_proxy", [-49, 0, 90], [0, 0, 0], [-40, 0, 106]),
    ("splice_left", "splice_plate", [0, -65, 20], [0, 0, 0], [0, -70, -25]),
    ("splice_right", "splice_plate", [0, 65, 20], [0, 0, 0], [0, 70, -25]),
    ("motor_mount_left", "motor_fit_check", [49, -89, 47], [90, 0, 0], [15, -92, -26]),
    ("motor_mount_right", "motor_fit_check", [49, 89, 47], [90, 0, 0], [15, 92, -26]),
    ("omni_mount_left", "omni_fit_check", [-79, -89, 37], [90, 0, 0], [-15, -90, -28]),
    ("omni_mount_right", "omni_fit_check", [-79, 89, 37], [90, 0, 0], [-15, 90, -28]),
    ("cliff_sensor_left", "cliff_sensor_fit_pod", [-96, -42, 11], [0, 0, 0], [-38, -20, -30]),
    ("cliff_sensor_right", "cliff_sensor_fit_pod", [-96, 42, 11], [0, 0, 0], [-38, 20, -30]),
    ("estop_guard", "estop_guard", [73, 0, 123], [0, 0, 0], [35, 0, 120]),
    ("drive_wheel_left", "drive_wheel_proxy", [49, -114, 52.5], [0, 0, 0], [30, -106, 0]),
    ("drive_wheel_right", "drive_wheel_proxy", [49, 114, 52.5], [0, 0, 0], [30, 106, 0]),
    ("omni_wheel_left", "omni_wheel_proxy", [-79, -114, 60], [0, 0, 0], [-30, -104, 0]),
    ("omni_wheel_right", "omni_wheel_proxy", [-79, 114, 60], [0, 0, 0], [-30, 104, 0]),
    ("motor_left", "motor_proxy", [49, -87, 52.5], [0, 0, 0], [30, -76, 0]),
    ("motor_right", "motor_proxy", [49, 87, 52.5], [0, 0, 0], [30, 76, 0]),
    ("speaker_grille", "speaker_grille", [-110, 0, 59], [0, 90, 0], [-60, 0, 38]),
]


def matrix(position, degrees):
    rx, ry, rz = [math.radians(x) for x in degrees]
    transform = trimesh.transformations.euler_matrix(rx, ry, rz, "sxyz")
    transform[:3, 3] = position
    return transform


def build(output: pathlib.Path):
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="robot-cad-") as temp:
        temp = pathlib.Path(temp)
        meshes = {}
        for part, (_, color) in PARTS.items():
            target = temp / f"{part}.stl"
            proc = subprocess.run(
                ["openscad", "-o", str(target), "-D", f'part="{part}"', str(SOURCE)],
                capture_output=True, text=True, timeout=180, check=False,
            )
            if proc.returncode != 0 or not target.exists() or target.stat().st_size < 100:
                raise RuntimeError(f"OpenSCAD export failed for {part}: {proc.stderr[-1200:]}")
            mesh = trimesh.load_mesh(target, process=False)
            if not isinstance(mesh, trimesh.Trimesh) or len(mesh.faces) == 0:
                raise RuntimeError(f"No exportable CAD triangles in {part}")
            mesh.visual.vertex_colors = np.tile(np.array(color, dtype=np.uint8), (len(mesh.vertices), 1))
            meshes[part] = mesh

        manifest = {"source": "cad/robot_revG.scad", "units": "millimeters",
                    "status": "Design geometry and purchased-part proxies; not safety/fit verified",
                    "parts": []}
        for exploded, name in [(False, "robot_revG.glb"), (True, "robot_revG_exploded.glb")]:
            scene = trimesh.Scene()
            for node_id, part, pos, degrees, offset in NODES:
                x = np.array(pos, dtype=float)
                if exploded:
                    x += np.array(offset, dtype=float)
                scene.add_geometry(meshes[part].copy(), geom_name="geo_" + node_id,
                                   node_name=node_id, transform=matrix(x, degrees))
                if not exploded:
                    manifest["parts"].append({
                        "id": node_id, "name": PARTS[part][0], "source_part": part,
                        "position": pos, "explode_offset": offset
                    })
            target = output / name
            scene.export(str(target), file_type="glb")
            loaded = trimesh.load(str(target), force="scene", process=False)
            if len(loaded.geometry) != len(NODES):
                raise RuntimeError(f"GLB validation failed: {name}: {len(loaded.geometry)} meshes")
            print(f"{name}: {target.stat().st_size:,} bytes / {len(loaded.geometry)} scene meshes")

        (output / "parts.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
        with zipfile.ZipFile(output / "robot_revG_STL_parts.zip", "w",
                             compression=zipfile.ZIP_DEFLATED, compresslevel=8) as z:
            for part in PARTS:
                z.write(temp / f"{part}.stl", f"{part}.stl")
            z.write(SOURCE, "robot_revG.scad")
        print("Exported", len(PARTS), "unique CAD parts and", len(NODES), "assembly nodes")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default=str(ROOT / "_site" / "models"))
    args = parser.parse_args()
    build(pathlib.Path(args.output))
