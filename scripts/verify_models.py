#!/usr/bin/env python3
"""Verify generated Revision G 3D website artifacts before publishing."""
import argparse
import json
import pathlib
import zipfile
import trimesh

def main(site: pathlib.Path):
    required = [
        "index.html", "viewer.html", "simulator.html", "assets/lab.css",
        "assets/viewer.js", "assets/simulator.js", "models/parts.json",
        "models/robot_revG.glb", "models/robot_revG_exploded.glb",
        "models/robot_revG_STL_parts.zip",
    ]
    for file in required:
        path = site / file
        assert path.is_file() and path.stat().st_size > 200, f"Missing or empty {file}"
        print(file, path.stat().st_size, "bytes")

    manifest = json.loads((site / "models/parts.json").read_text())
    parts = manifest["parts"]
    assert len(parts) >= 30, "Expected a detailed multi-part assembly"
    ids = [part["id"] for part in parts]
    assert len(ids) == len(set(ids)), "Duplicate part ID"
    assert any("shell" in id for id in ids)
    assert any("wheel" in id for id in ids)
    assert any("camera" in id for id in ids)

    scenes = {}
    for name in ("robot_revG.glb", "robot_revG_exploded.glb"):
        scene = trimesh.load(str(site / "models" / name), force="scene")
        assert len(scene.geometry) == len(parts), f"GLB node/part mismatch: {name}"
        names = set(scene.graph.nodes_geometry)
        assert set(ids).issubset(names), f"GLB node names missing: {set(ids)-names}"
        scenes[name] = scene
        print(name, "parts:", len(scene.geometry), "bounds:", scene.bounds)

    assembled = scenes["robot_revG.glb"].bounds
    exploded = scenes["robot_revG_exploded.glb"].bounds
    assert (exploded[1] - exploded[0]).max() > (assembled[1] - assembled[0]).max() * 1.2, "Exploded GLB did not separate pieces"

    with zipfile.ZipFile(site / "models/robot_revG_STL_parts.zip") as archive:
        names = archive.namelist()
        assert "robot_revG.scad" in names
        unique = {p["source_part"] for p in parts}
        assert all(f"{part}.stl" in names for part in unique)
        assert archive.testzip() is None

    home = (site / "index.html").read_text()
    viewer = (site / "viewer.html").read_text()
    sim = (site / "simulator.html").read_text()
    assert "viewer.html" in home and "simulator.html" in home, "Home missing simulator/3D links"
    assert "models/robot_revG.glb" in viewer and "explode" in viewer
    assert "data-drive" in sim and 'id="estop"' in sim
    print("VERIFIED: CAD assembly, exploded GLB, STL archive, links and simulator entrypoints")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--site", required=True)
    args = parser.parse_args()
    main(pathlib.Path(args.site))
