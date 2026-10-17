# Little Robb — PLA companion rover, revision 1

## Fixed design decisions
- Print body shell, head/face, camera brackets, cable guides, removable service covers and electronics trays in existing PLA on Bambu P1S (256 × 256 × 256 mm build volume).
- **Purchase** matched RC wheels/tires, motors, motor driver, bearings/axles and fasteners. No TPU or PETG required for prototype.
- Use a **low, stable four-wheel platform**, accessible lift handle with mechanical reinforcement, rounded edges, friendly face with expressive LEDs, camera on a pan/tilt head, speaker/microphone for companion interaction.
- No decorative bumper required, but keep contact sensing, independent physical emergency stop and firmware watchdog.
- No unverified battery runtime, terrain performance, weight or budget guarantees.

## Design envelope (targets, not final CAD)
- Overall footprint ~305 mm long × 240 mm wide; split printable shell into pieces within 256 mm printer bed.
- Target lift mass ~1.8–2.3 kg, subject to weighing selected components and safe lift testing.
- Wheels: prefer ~90–110 mm diameter rubber-tired RC wheels for grass/sidewalk testing; validate wheel hub and motor shaft compatibility before ordering.
- Battery low and centered, behind removable screw-fastened access panel. Pi and ESP32 in ventilated protected electronics bay; separated high-current motor wiring.
- Head: light PLA enclosure with two status/eye LEDs, pan/tilt camera, microphone and speaker grilles; keep head mass low.
- PLA for prototype only; avoid hot-car storage/direct prolonged summer sun, and re-evaluate heat resistance before outdoor use.

## Physical assembly concept (front to rear)
Front: low contact switch / proximity sensing → left/right wheels + gearmotors → center battery cradle → stacked Pi/ESP32/controller trays → rear wheels/motors; head and carry handle centered over chassis. Provide cable strain relief, ventilation and a reachable E-stop.

## Procurement dependencies
1. Select wheels AND compatible motor/hub/shaft/gearbox; record dimensions, stall current and mounting pattern.
2. Select main compute board based on local vision requirement (Pi Zero 2 W is limited; Pi 5 costs more and needs thermal/power design).
3. Select motor driver rated above motor stall current and independent ESP32 watchdog path.
4. Select protected battery pack with verified charger/BMS, fuse, power switch, DC-DC converters; do not fabricate unprotected lithium packs.
5. Select camera, pan/tilt servos, microphone, speaker/amplifier, proximity/contact sensors, emergency stop, connectors.
6. Measure actual parts before final CAD; avoid printing false-fit enclosures.

## Cost worksheet — fill with live vendor quotes before purchasing
| Group | Required | Quote status |
| --- | --- | --- |
| Four rubber RC wheels/tires and compatible hubs | yes | pending |
| Four motors, brackets, bearings/shafts or complete matched chassis | yes | pending |
| Raspberry Pi compute + storage | yes | pending |
| ESP32 + rated motor driver | yes | pending |
| Protected battery, charger, fuse, regulator, switch | yes | pending |
| Camera + two servos + mounting | yes | pending |
| Mic, speaker, amplifier | yes | pending |
| Contact/proximity sensors + physical E-stop | yes | pending |
| Fasteners, wiring, connectors | yes | pending |
| PLA print material (existing stock) | yes | sunk material; track grams |
| Shipping and tax | yes | pending |

## Software/hardware interfaces
Python Pi service: validated high-level intents, camera perception, target state, companion dialogue and device API. ESP32 C++ firmware: deterministic speed-limited motor controller, sensor interlocks, physical E-stop, command watchdog. Browser/phone TypeScript UI: pairing, manual/gamepad mapping, sentry, accessibility. Until hardware validation, all movement stays simulated.

## Mechanical milestones
1. Printable mockup of head, shell and trays using measured components.
2. Fit-test hardware; weigh assembly and check one-handed lift.
3. Wire electronics on bench with wheels off ground; validate watchdog/E-stop.
4. Controlled indoor rolling trials; then carefully bounded outdoor trials.
