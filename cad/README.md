# Printable-first workflow
Revision A printable STL mockups have been generated and checked for successful OpenSCAD export. Each design iteration must produce **actual STL/3MF files** and a phone-viewable preview, not only illustrations.

Use `cad/companion_revA.scad` and choose `part` from `front`, `rear`, `lid`, `head_front`, `head_back`. Export via OpenSCAD. STL models are appearance/fit prototypes and **do not yet have validated hardware mounts or reinforced load paths**. All five parts fit the 256mm P1S bed by design. Keep purchased RC wheels and motors as separate components. The head halves are intentionally hollow; printed head is not a working camera mount. Do not install a battery or drive motors in this unvalidated shell.

For subsequent revisions: retain versioned CAD, generate STLs, test manifoldness/dimensions, inspect in slicer, update viewer to match actual printable geometry, and only then mark a revision printable.

## Revision G — current concept (2026-10-18)

[robot_revG.scad](robot_revG.scad) is now the latest source CAD. It models four wheels (two independently driven rear wheels and two passive front omni-wheels), revised split shell and camera-head modules, a removable Pi 5 1GB electronics shelf and a small LiFePO4 battery tray. The earlier Rev F design remains as an upgrade reference.

The latest design exported **18 distinct printable prototypes, 23 parts at quantity**, all individually watertight and under 256mm bounding dimensions. Individual OpenSCAD STL exports were attached to the ChatGPT conversation alongside an offline interactive 3D viewer and GLB. This does **not** verify slicing, mechanical fits, safe mounting, load paths, motors or autonomous operation. Read [engineering constraints and build prerequisites](../docs/REV_G_MECHANICAL_DESIGN.md) before printing or purchasing.
