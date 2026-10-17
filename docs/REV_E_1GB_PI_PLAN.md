# LilRobbsGirlfriend — Revision E, 1GB Raspberry Pi 5 cost-down candidate

Saved 2026-10-17. **Revision C best-case untouched:** branch `baseline/rev-c-best-case`. **Revision D cost-down comparison untouched:** `docs/REV_D_VALUE_ENGINEERING.md`.

## Decision

**Use Raspberry Pi 5 1GB as the default *prototype candidate*.** Same Pi 5 form factor, 40-pin header, wireless functions, CSI camera connectivity and CPU as Pi 5 2GB, but less memory. Keep the same physical mounting hardware and accessible electronics tray for a later **board replacement** with a larger-RAM Pi 5. **RAM cannot be upgraded separately on this board.** Do not design PCB/motor controller into RAM-specific assumptions.

### Verified Pi pricing / ordering

- [CanaKit Raspberry Pi 5 1GB board only](https://www.canakit.com/raspberry-pi-5-1gb.html) — $45, page reports In Stock at last check.
- [PiShop US Raspberry Pi 5/1GB](https://www.pishop.us/product/raspberry-pi-5-1gb/) — $45, page showed Notify Me at last check (may not be in stock).
- [Official Raspberry Pi pricing update, 2026-10-01](https://www.raspberrypi.com/news/price-increases-for-2gb-raspberry-pi-4-and-raspberry-pi-5/) — 1GB price unchanged; 2GB Pi 5 is $77.50.
- **Price saving against original Revision C 2GB allowance: $32.50**, not counting differing taxes/shipping.

## Adjusted cost worksheet: medium wheel candidate

| Scenario | Previous | 1GB Pi version | Extra savings |
|---|---:|---:|---:|
| Baseline Rev C *reference only* | $732.63 | $700.13 if Pi replaced, but baseline remains unchanged | $32.50 |
| Rev D1 low-disruption | $691.68 | **$659.18** | $32.50 |
| Rev D2 lower-priced four motors (unverified) | $611.40 | **$578.90** | $32.50 |
| Rev D3 lower-priced motors + 83mm wheels (unverified) | $579.54 | **$547.04** | $32.50 |

The 1GB *default prototype choice* is the D1 / D2 / D3 configuration, while Rev C stays as the higher-spec preservation snapshot. D2/D3 motor and wheel substitutions are not approved until physical fit and stall-current/torque/temperature are measured. **All prices exclude tax, shipping, power-protection and wiring completion, fasteners, handle reinforcement and any additional safety sensors.**

## Memory-aware software design; testing required

- Raspberry Pi OS Lite (64-bit), no GUI and no browser running on the Pi; companion app runs on Robb's phone.
- Keep high-level conversation and language processing on the remote API where connectivity permits; **do not run a full LLM onboard** on the 1GB Pi. No motor PWM from cloud/chatbot.
- Implement voice/wake-word locally with lightweight services where memory supports it. Consider phone-assisted speech capture if onboard transcription is too large.
- Lightweight frame capture and target-tracking prototypes: low-resolution camera frames, one vision operation at a time. Object recognition accuracy and tracking speed depend on model and frame rate, **not guaranteed**.
- Run motor safety, e-stop and watchdog on the separate ESP32 regardless of Pi memory or network quality.
- Stream/display low-resolution video first; defer persistent sentry recording to future external storage.
- Profile RAM, swap activity, thermal behavior, CPU time and camera stability during *simultaneous* voice + camera + navigation scenarios before asserting this board supports full autonomy.
- If memory pressure causes degraded stop responsiveness, dropped perception frames, unsafe navigation delays or repeated crashes, disable autonomy and/or switch to more RAM; fail safe locally.
- The Pi 5 board can be swapped to a larger RAM variant later without a new chassis, assuming the mounting layout and power provisions remain compatible.

## Status

**Documentation and prices updated; not hardware verified; no 1GB Pi purchased.** No claim of a completed hardware-safe robot, tested 1GB live perception, or finished assembly.
