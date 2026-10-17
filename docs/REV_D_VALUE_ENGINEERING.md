# LilRobbsGirlfriend — Revision D: value engineering (NOT a replacement for Rev C)

**Date:** 2026-10-17. All USD figures are published item prices checked on that date, not a delivered checkout total. **Do not purchase the candidate drivetrain until compatibility tests pass.** Original full-featured baseline is preserved on GitHub branch `baseline/rev-c-best-case`, commit `5a53e3aa99057ca76732d30e0378487651129c91`. Original medium wheel total: **$732.63** (listed items only); with all three wheel sets: **$807.61**.

## Design rules
- Retain same approximate 12-inch PLA shell, Bambu P1S printed design, low-mounted removable protected battery, accessible one-handed lift design (not yet tested), and removable drivetrain modules for small / medium / larger purchased wheels.
- Retain low-speed zero-radius turns, with differential left/right drive under an ESP32 independent watchdog. Do **not** use LLM output for direct motor PWM.
- Retain camera, pan/tilt, microphone/speaker, three ranging sensors and physical E-stop. Never claim floor edge/stairs/pet safety without verified redundant sensors.
- Keep hardware interfaces modular: motor brackets and hex wheel hubs remain replaceable; changing wheel diameter changes torque, motor speed, turning scrub, center of gravity and clearance.
- Use PLA for prototype; do not leave it in hot sunlight or hot vehicle.
- Continue integration in simulator until real hardware safe tests pass. Do not assume exact 3D fit from STL visualization.

## Three quoted subtotals, medium configuration
| Option | Listed component subtotal | Difference from original | Assumptions |
|---|---:|---:|---|
| Revision C (unchanged) | $732.63 | — | 4 Pololu 37D, 96mm wheels, Feather V2, separate 128GB USB |
| Revision D1 low-disruption | $691.68 | -$40.95 | ESP32 Feather V2 -> Adafruit ESP32-C3-DevKitM-01; defer optional 128GB USB video storage until sentry recording phase. Keep 4 Pololu motors and 96mm wheels. |
| Revision D2 *motor research candidate* | $611.40 | -$121.23 | D1 plus 4 Aslong GB37-3530B-12-111 brushed gearmotors, each $18.88 versus $38.95 Pololu. **NOT VERIFIED as performance equivalent**. |
| Revision D3 *motor + medium wheel research candidate* | $579.54 | -$153.09 | D2 plus 4-pack 83mm (3.26-inch) 12mm-hex wheels $24.09 instead of 96mm $55.95 set. Wheel size is about 83mm, *not 90 or 96mm*. New fit/clearance and traction checks required. |

**Neither D2 nor D3 is an approved shopping cart:** both need mechanical/electrical measurements and repeatable torque/current/turn tests. All totals omit shipping/tax, fuses, connectors, DC-rated switch, motor protection/overcurrent, wheel mounting hardware, and reinforcement.

## Precisely sourced price changes

| Group | Existing choice | Replacement or deferral | Price change | Source and notes |
|---|---|---|---:|---|
| ESP32 board | Adafruit Feather V2 $20.95 | [Adafruit ESP32-C3 DevKitM-01](https://www.adafruit.com/product/5337) $9.95 | -$11.00 | Manufacturer-listed, in stock when checked. BLE (not Bluetooth Classic), enough I/O to review after motor PWM, encoder, E-stop and sensors are allocated. Pi handles gamepad Bluetooth, not ESP32. |
| Sentry storage | 128GB USB flash drive $29.95 | Defer until sentry video storage needed | -$29.95 | 32GB OS microSD remains, and non-persistent camera preview/voice remains. **Does not include overnight recording capacity.** |
| Four geared motors | 4× [Pololu #4745 100RPM 37D](https://www.pololu.com/product/4745), 4×$38.95=$155.80 | 4× [Aslong GB37-3530B-12-111, 111RPM brushed w/ encoder](https://www.robotshop.com/products/aslong-motor-37mm-diameter-12v-111rpm-brushed-geared-motor-w-encoder), 4×$18.88=$75.52 | -$80.28 | Both have 6mm shafts but different casing/gearbox dimensions. Aslong page has inconsistent power/speed data; continuous rated torque and current limits are NOT verified. Existing stamped Pololu brackets cannot be assumed to fit. |
| Medium wheels (4) | [VXB 96mm 12mm hex set](https://vxb.com/products/4x-1-10-rc-off-road-wheel-tires-set-with-5-spoke-r) $55.95 | [Walmart third-party 3.26-in ≈83mm, 12mm-hex, 4pc set](https://www.walmart.com/ip/17783865191) $24.09 | -$31.86 | **Different size and terrain properties**, marketplace seller, fit and load tests needed. Not an exact medium wheel equivalent. |

### Tempting discounts deliberately not counted

- [Raspberry Pi 5 1GB](https://www.raspberrypi.com/news/1gb-raspberry-pi-5-now-available-at-45-and-memory-driven-price-rises/) official price $45 vs Pi 5 2GB $77.50 would save another $32.50, but 1GB is likely too constrained for simultaneous camera, voice processing, vision and API services. Keep 2GB until profiling proves otherwise.
- [Cytron MDD10A 10A/channel](https://www.cytron.io/p-10amp-5v-30v-dc-motor-driver-2-channels) $25.90 would save $12.60 vs the MDD20A $38.50; NOT selected until real pair-of-motors per-side peak current can be bounded and verified.
- [Bioenno 3Ah LiFePO4](https://www.bioennopower.com/products/12v-3ah-lifepo4-battery-pvc) $49.99 saves $40 against $89.99 battery; DO NOT substitute: 7A continuous/14A short peak discharge is inadequate without rigorous power redesign.
- [SEMENERG 6Ah LiFePO4](https://www.semenerg.com/products/12v-6ah-lifepo4-battery) $39.99 has 10A continuous max (20A for 5 sec); unproven seller and current limit. Not selected.
- Sensor coverage, E-stop, watchdog, compatible charger and voltage/current-safe wiring are *never* cost-cutting candidates.

## Correct product interface for lighter motors
Motor drive control: Pi -> command schema -> ESP32-C3 safety/control -> dual-channel protected brushed motor driver -> left two motors/right two motors (electrically paired per side, if current limits permit). Firmware must implement communication timeout, speed/current limits, and stop-on-disconnect; hardware latching E-stop must de-energize drives independent of Pi. Full on-device control **does not require a second LLM**.

In order to approve Aslong motor swap, obtain actual output shaft drawing, motor mounting hole pitch/bolt depth, stall/running current, gearbox max working torque, gearbox thermal/rated duty data and tolerances. Prototype mounting insert **after measurements**. Record mass of fully assembled rover, turning radius in narrow apartment corridors, motor temperature after 15 minutes, current during a zero-turn on carpet, wheel scrub and stall behavior, and grade tests.

## Actual order sequence
1. **Safe early buys:** camera, Pi 5 2GB, ESP32-C3 dev board, audio peripherals, matched protected battery/charger, sensor modules. Verify store availability before paying.
2. **Investigate before buying:** a single Aslong gearmotor sample or get manufacturer test data; validate against Pololu and the chosen 6mm-to-12mm hex hub *before buying all four*. Final motor mounting is not universal.
3. Decide final motor/wheel modules; revise STL inserts rather than shell. Complete the power and safety wiring BOM including current-protected lines and measured peak load.
4. Print the final hardware-specific adaptors, verify on bench with wheels suspended, then very slow indoor tests; do not claim outdoor autonomy until validated.

**Current recommendation:** D1 is the low-risk savings option ($691.68 listed subtotal) without weakening the drivetrain. D2/D3 are opportunities worth testing, **not guaranteed identical functionality**.
