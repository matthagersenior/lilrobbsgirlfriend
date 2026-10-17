# Implementation order

1. **Now:** Simulator, one-handed UI, deterministic intent examples, stop-first behavior, CI tests.
2. **Next:** Device capability registry, authenticated pairing, user roles, persistent settings, secure local API, real joystick mapping.
3. **Then:** Offline wake word and command recognition, NLU with validated action schema and conversational context.
4. **Then:** On-device detection and tracking, target-loss handling, bounded following with real obstacle sensors.
5. **Then:** Sentry events, encrypted recording and authenticated remote viewing.
6. **Finally:** Tested route navigation, docking, advanced patrols and device integrations.

Hardware acceptance gates: independent E-stop, watchdog, wheel slip/stall tests, speed/clearance tests, one-handed lift assessment, cane clearance, indoor/outdoor lighting, pet-safe distances, charging and battery safety. Camera-only obstacle detection is not sufficient for safe navigation. No autonomous physical movement before these gates pass.
