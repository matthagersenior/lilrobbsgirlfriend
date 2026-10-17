# LilRobbsGirlfriend

Local-first, accessible robotics companion platform for Little Robb and future devices.

## Status
Software-only prototype. No motors, cameras, microphones, or real-world autonomy have been deployed or verified. Simulation is intentionally separate from hardware.

## Quick start
```bash
python -m unittest discover -s tests -v
python -m http.server 8000
```
Open `http://localhost:8000/app/` for the one-handed-friendly controller UI. It simulates commands in the browser; it does **not** connect to a robot.

## Architecture
- `core/`: typed, bounded commands and deterministic behavior state machine; safe-stop wins.
- `app/`: installable-ready web UI foundation with manual drive, watch, follow, stop, camera controls.
- `firmware/`: ESP32 safety contract; hardware firmware pending component selection.
- `docs/`: hardware and staged integration plan.

## Safety contract
Motors must remain disabled until a hardware ESP32 controller enforces an independent watchdog, physical emergency stop, obstacle limits, and speed caps. A phone or cloud STOP command alone is insufficient. On command timeout, target loss, disconnect, or mode change, motor output must go to zero. Voice and LLM output cannot directly drive motor pins. Following and pet tracking are experimental and require controlled testing.
