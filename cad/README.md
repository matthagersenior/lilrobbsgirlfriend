# Printable mechanical prototype (revision A)

These parts are **fit/appearance mockups**, not final motor/battery enclosures. They are sized to fit a Bambu P1S and can be opened in OpenSCAD. Export each selected part to STL with F6 → File → Export → STL. Print PLA at 0.20 mm layers, 3 walls, 15–20% infill for appearance trials. Do not use the printed handle to lift a loaded robot until reinforced and load-tested.

## Preview
Open `cad/companion.scad` in the free OpenSCAD desktop application. Set `part="assembly"` to see the complete concept. Set `part` to `front`, `rear`, `head`, or `lid` for individual printable parts. Wheels are **visual placeholders** only; purchase rubber RC wheels and matching motor hubs.

## Assembly sequence
1. Print front/rear chassis trays and head mockup; check fit without electronics.
2. Select four compatible RC wheels, geared motors, motor brackets, driver, Raspberry Pi, ESP32, camera, protected battery, and charger; measure each item.
3. Revise motor holes, shaft height, battery cradle, and camera mount to measured components **before** final print.
4. Bolt front/rear trays together using metal splice plates; mount motors and wheels.
5. Mount battery low and centered, add fuse/switch and protected power distribution. Keep motor supply wiring separate from Pi supply.
6. Install ESP32 motor controller with independent hardware watchdog and physical E-stop. Bench-test with wheels suspended.
7. Install Raspberry Pi, camera and microphone/speaker; configure the companion service and secure local network.
8. Verify stop-on-disconnect, obstacle interlock and speed limits before floor trials; then indoor slow-speed tests.

No battery wiring schematic is final until the exact battery, motor stall current, and motor driver are selected. Never charge loose lithium cells without a suitable protected charger/BMS.
