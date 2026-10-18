# Current build decision — Revision G lean companion prototype

**Updated 2026-10-18.** The user's latest direction supersedes the 2026-10-17 Raspberry Pi 5 2GB decision for the *first prototype only*.

- **Raspberry Pi 5 1GB**, Raspberry Pi OS Lite, **32GB microSD**; no optional 128GB USB drive in the first prototype. The Pi 5 2GB is an easy later board-swap upgrade, not required for the initial design. Rev E describes 1GB caveats; benchmark actual simultaneous services before assuming performance.
- **Four-wheel chassis with two independently driven motors** (one left, one right) and **two passive low-scrub front wheels**. Design for upgrade to four driven wheels; actual zero-radius turning requires suitable passive wheel geometry and friction tests. New motor, wheel and bracket parts are research candidates, not approved purchases.
- **ChatGPT/OpenAI GPT is the sole normal user-facing conversational intelligence.** Use a secure backend/API integration, not the consumer ChatGPT app or automatic sharing of personal ChatGPT Memory. Other services/models may handle audio transcription, speech synthesis, wake word, vision, sensor interpretation and navigation. See [Rev G conversational AI architecture](REV_G_CHATGPT_COMPANION_ARCHITECTURE.md).
- ESP32 independent safety/watchdog and motor control, camera and audio, protective power wiring, DC-rated physical E-stop, obstacle/cliff detection, 3D-printed replaceable body modules.
- Smaller LiFePO4 battery under consideration. Select only after validating measured currents and load; chargers and regulators must match the actual cells and Pi/motor demands.
- **Illustrative quoted priced-component target:** ~$456.70 using the previously discussed candidate parts and 4.5Ah battery. It excludes unpriced passive-wheel mounts, adapters, brackets, printed plastic, wiring, fuses, connectors, proper safety hardware, shipping and taxes; **not a complete purchasing total**. Verify market price, availability and mechanical fit again before ordering.
- The original full-spec **Rev C best-case** baseline remains unchanged on [baseline/rev-c-best-case](https://github.com/matthagersenior/lilrobbsgirlfriend/tree/baseline/rev-c-best-case). Rev D alternatives, Rev E 1GB research and Rev F printable CAD remain historical references, not assumed interchangeable with Revision G.
- Implementation and physical testing have **not** yet occurred. Do not describe the robot as purchased, assembled, autonomous, safely navigable, or with a functioning ChatGPT connection.

Design principle: keep the friendly Rev F upper shell as much as physically possible, make the drivetrain, battery cradle and electronics accessible and replaceable, and let the first prototype be small and affordable without compromising safety.

**Current mechanical CAD:** [Revision G OpenSCAD source](../cad/robot_revG.scad) and [Revision G mechanical design, dimensions and unresolved safety/fit work](REV_G_MECHANICAL_DESIGN.md). The first complete set of STL fit-check exports, color GLB and 3D touch viewer are downloadable from the associated ChatGPT conversation, not published as GitHub binary assets.
