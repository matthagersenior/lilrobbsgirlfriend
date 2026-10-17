# ESP32 firmware boundary

Hardware not selected. **Do not connect motors to browser or LLM outputs.** Required before physical deployment: independent ESP32 command-timeout watchdog, physical latching E-stop, bumper/proximity inputs, bounded PWM, battery undervoltage handling, motor enable interlock, and documented bench tests. Disconnect and watchdog expiry must force zero PWM and disable drivers. Manual and autonomous movement must never run concurrently.
