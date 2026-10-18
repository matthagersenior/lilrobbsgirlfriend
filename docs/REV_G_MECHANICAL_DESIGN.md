# Revision G — lean four-wheel / two-motor mechanical prototype

**Updated 2026-10-18. Status: geometry prototype, NOT purchase-ready or physically validated.**

New parametric source: [cad/robot_revG.scad](../cad/robot_revG.scad). The ChatGPT conversation also contains a ZIP with the source, STL print-fit-checks, GLB, 3D viewer and rendered images; the binaries have not been checked into GitHub.

## Geometry and engineering direction

- Preserve Rev F's friendly white/blue rounded shell and split head. Forward is **-X**. Rear driven wheel centers **X=+49, Y=±114 mm**, front passive omni-wheel centers **X=-79, Y=±114 mm**.
- Exactly **two independently controlled 12V brushed geared motors**, one per side, and **two passive front omni-wheels**. Two motors can rotate the chassis around the driven axle if the passive wheel supports tolerate sideways roller motion. Zero-radius turning around the *chassis center* is not claimed; the front body sweeps a clearance path.
- Candidate **85 mm rear drive wheels** and **100 mm front omni-wheels**. Axle center heights differ by 7.5 mm to maintain nominal **10 mm underside clearance** on ideal smooth floor. Validate real floor contact, tilting, carpet performance, and stability.
- Approximate overall conceptual envelope: **248 mm L × 255 mm W including tire overhang × 223 mm H**. Actual part geometry is in SCAD.
- Two front/rear screwed tub halves and two splice strips, split body shell, removable Pi shelf and tray, cosmetic head with center Camera Module 3 bore and printed decorative eye rings, servo/neck space.
- Pack candidate: **Bioenno BLF-12045W 12V 4.5Ah**, nominal advertised 76 × 57 × 71 mm. Tray includes allowance, strap channels and proposed mounting bores. **Warning:** manufacturer's product page quotes 9A continuous / 18A pulse whereas manufacturer's FAQ describes a 7A control board: verify exact battery's actual ratings and dimensions before purchase. The tray has **not** been physically fit tested.
- **Raspberry Pi 5 1GB**, 32GB microSD, Raspberry Pi OS Lite; separate ESP32 with independent local motor watchdog and E-stop interlock. Normal conversation comes from GPT/OpenAI API via a secure relay, not an onboard chat LLM. Other models/services for speech, vision and navigation. See [ChatGPT companion architecture](REV_G_CHATGPT_COMPANION_ARCHITECTURE.md).
- Keep motor mounts, battery restraint, electronics shelf, shell, and replacement wheel modules accessible for future 4-motor revision.

## Printed geometry status

**18 distinct printed STL part designs, 23 pieces at planned quantities** exported from the new SCAD; each was checked in trimesh as watertight and smaller than the Bambu P1S 256 mm print boundary *individually*. Slicing, orientation, mechanical fit and structural performance are NOT verified.

Models exported through OpenSCAD `part="..."`:
`chassis_front`, `chassis_rear`, `shell_front`, `shell_rear`, `head_front`, `head_rear`, `head_visor`, `eye_ring` (×2), `camera_ring`, `neck`, `electronics_shelf`, `battery_tray`, `motor_fit_check` (×2), `omni_fit_check` (×2), `splice_plate` (×2), `speaker_grille`, `cliff_sensor_fit_pod` (×2), `estop_guard`.

`assembly`, `exploded`, `drive_wheel_proxy`, `omni_wheel_proxy`, `motor_proxy`, `battery_proxy`, `pi_proxy`, `camera_proxy` are *visualization or purchased-component proxies*, **not printed parts**. Structural motor brackets, metal wheel axles and bearings still need proper engineering.

## Remaining prerequisites

1. Test a single selected affordable encoder gearmotor for torque, stall/running current, thermal limits, hub fit and metal bracket hole pattern.
2. Choose real omni-wheel load-bearing axle/bearing and attachment hardware; validate front wheel scrub during rotation.
3. Validate center of mass, battery restraint and safe Pi voltage regulation; fused drive supply, DC-rated latching emergency stop and communication-loss stop.
4. Add/verify cliff and contact detection, wiring harness, heat dissipation, head pivot/servo fit, actual enclosure fasteners and structural carrying method.
5. Slice/test-print prototype parts with 0.4mm nozzle, measure dimensions and adjust before committing to a full print.
6. Integrate GPT API conversational services with authenticated backend, spend limits and a separate opt-in memory; keep deterministic mobility controllers and offline stop.

**Research budget:** ~$456.70 for previously researched priced components; incomplete, not a final checkout quote. Missing motor mounts, front axle structures, safety hardware, wiring/fasteners, plastic, tax/shipping, and recurring GPT API fees. Original Rev C and Rev F remain as upgrade references, not overwritten.
